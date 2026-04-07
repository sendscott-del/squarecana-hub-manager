import { Badge } from '@/components/ui/badge'
import { STATUS_COLORS, STATUS_LABELS } from '@/lib/constants'
import { cn } from '@/lib/utils'

export function StatusBadge({ status, className }: { status: string; className?: string }) {
  return (
    <Badge
      variant="outline"
      className={cn(STATUS_COLORS[status] || 'bg-gray-100 text-gray-700', className)}
    >
      {STATUS_LABELS[status] || status.replace(/_/g, ' ')}
    </Badge>
  )
}
