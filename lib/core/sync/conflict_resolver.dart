/// Conflict resolution helper used by SyncService and RealtimeService.
/// Encapsulates last-write-wins by `updatedAt` with deterministic
/// tie-break by `lastWriterDeviceId` (lexicographic).
bool shouldUpdateLocal(int? localUpdatedAt, String? localDeviceId, int remoteUpdatedAt, String? remoteDeviceId) {
  if (localUpdatedAt == null) return true;
  if (remoteUpdatedAt > localUpdatedAt) return true;
  if (remoteUpdatedAt < localUpdatedAt) return false;

  // Tie: compare device ids lexicographically (null-safe)
  return (remoteDeviceId ?? '').compareTo(localDeviceId ?? '') > 0;
}
