import { serve } from "std/http/server.ts"
import { createClient } from "supabase"
import { JWT } from "google-auth-library"

serve(async (req) => {
  try {
    const { user_id, title, body, data } = await req.json()

    if (!user_id || !title || !body) {
      return new Response(JSON.stringify({ error: 'Missing required fields: user_id, title, or body' }), { status: 400 })
    }

    // 1. Initialize Supabase Client
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // 2. Get User's FCM Tokens from our table
    const { data: tokens, error: tokenError } = await supabase
      .from('fcm_tokens')
      .select('token')
      .eq('user_id', user_id)

    if (tokenError) {
      return new Response(JSON.stringify({ error: 'Database error fetching tokens', detail: tokenError }), { status: 500 })
    }

    if (!tokens || tokens.length === 0) {
      return new Response(JSON.stringify({ error: 'No FCM tokens found for this user' }), { status: 404 })
    }

    // 3. Get Google Auth Token (using the secret)
    const serviceAccountContent = Deno.env.get('FIREBASE_SERVICE_ACCOUNT')
    if (!serviceAccountContent) {
      return new Response(JSON.stringify({ error: 'FIREBASE_SERVICE_ACCOUNT secret not found in Supabase' }), { status: 500 })
    }

    const serviceAccount = JSON.parse(serviceAccountContent)
    const jwt = new JWT({
      email: serviceAccount.client_email,
      key: serviceAccount.private_key,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    
    const { token: accessToken } = await jwt.getAccessToken()

    // 4. Send to all registered devices for this user
    const results = await Promise.all(tokens.map(async (t) => {
      try {
        const fcmResponse = await fetch(
          `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              Authorization: `Bearer ${accessToken}`,
            },
            body: JSON.stringify({
              message: {
                token: t.token,
                notification: { title, body },
                data: data || {},
              },
            }),
          }
        )
        return { token: t.token, response: await fcmResponse.json() }
      } catch (e) {
        return { token: t.token, error: e.message }
      }
    }))

    // 5. Save to Notification History table
    await supabase.from('notifications').insert({
      user_id,
      title,
      body,
      type: data?.type || 'general',
      payload: data || {},
    })

    return new Response(JSON.stringify({ success: true, results }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})
