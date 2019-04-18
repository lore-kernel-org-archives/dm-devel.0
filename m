From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [patch V2 00/29] stacktrace: Consolidate stack trace usage
Date: Thu, 18 Apr 2019 10:41:19 +0200
Message-ID: <20190418084119.056416939@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Rapoport <rppt-23VcF4HTsmKsTnJN9+BGXg@public.gmane.org>
List-Id: dm-devel.ids

This is an update to V1:

 https://lkml.kernel.org/r/20190410102754.387743324-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org

Struct stack_trace is a sinkhole for input and output parameters which is
largely pointless for most usage sites. In fact if embedded into other data
structures it creates indirections and extra storage overhead for no
benefit.

Looking at all usage sites makes it clear that they just require an
interface which is based on a storage array. That array is either on stack,
global or embedded into some other data structure.

Some of the stack depot usage sites are outright wrong, but fortunately the
wrongness just causes more stack being used for nothing and does not have
functional impact.

Fix this up by:

  1) Providing plain storage array based interfaces for stacktrace and
     stackdepot.

  2) Cleaning up the mess at the callsites including some related
     cleanups.

  3) Removing the struct stack_trace based interfaces

  This is not yet changing the struct stack_trace interfaces at the
  architecture level, but it removes the exposure to the usage sites.

The last two patches are extending the cleanup to the architecture level by
replacing the various save_stack_trace.* architecture interfaces with a
more unified arch_stack_walk() interface. x86 is converted, but I have
worked through all architectures already and it removes lots of duplicated
code and allows consolidation across the board. The rest of the
architecture patches are not included in this posting as I want to get
feedback on the approach itself. The diffstat of cleaning up the remaining
architectures is currently on top of the current lot is:

   47 files changed, 402 insertions(+), 1196 deletions(-)

Once this has settled, the core interfaces can be improved by adding
features, which allow to get rid of the imprecise 'skip number of entries'
approach which tries to remove the stack tracer and the callsites themself
from the trace. That's error prone due to inlining and other issues. Having
e.g. a _RET_IP_ based filter allows to do that far more reliable.

The series is based on:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core/stacktrace

which contains the removal of the inconsistent and pointless ULONG_MAX
termination of stacktraces.

It's also available from git:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git WIP.core/stacktrace

   up to:  131038eb3e2f ("x86/stacktrace: Use common infrastructure")

Changes vs. V1:

   - Applied the ULONG_MAX termination cleanup in tip

   - Addressed the review comments

   - Fixed up the last users of struct stack_trace outside the stacktrace
     core and architecture code (livepatch, tracing)

   - Added the new arch_stack_walk() model and converted x86 to it

Thanks,

	tglx

---
 arch/x86/Kconfig                              |    1 
 arch/x86/kernel/stacktrace.c                  |  116 +--------
 drivers/gpu/drm/drm_mm.c                      |   22 -
 drivers/gpu/drm/i915/i915_vma.c               |   11 
 drivers/gpu/drm/i915/intel_runtime_pm.c       |   21 -
 drivers/md/dm-bufio.c                         |   15 -
 drivers/md/persistent-data/dm-block-manager.c |   19 -
 fs/btrfs/ref-verify.c                         |   15 -
 fs/proc/base.c                                |   14 -
 include/linux/ftrace.h                        |   18 -
 include/linux/lockdep.h                       |    9 
 include/linux/stackdepot.h                    |    8 
 include/linux/stacktrace.h                    |   80 +++++-
 kernel/backtracetest.c                        |   11 
 kernel/dma/debug.c                            |   13 -
 kernel/latencytop.c                           |   17 -
 kernel/livepatch/transition.c                 |   22 -
 kernel/locking/lockdep.c                      |   81 ++----
 kernel/stacktrace.c                           |  323 ++++++++++++++++++++++++--
 kernel/trace/trace.c                          |  105 +++-----
 kernel/trace/trace.h                          |    8 
 kernel/trace/trace_events_hist.c              |   12 
 kernel/trace/trace_stack.c                    |   76 ++----
 lib/Kconfig                                   |    4 
 lib/fault-inject.c                            |   12 
 lib/stackdepot.c                              |   50 ++--
 mm/kasan/common.c                             |   30 --
 mm/kasan/report.c                             |    7 
 mm/kmemleak.c                                 |   24 -
 mm/page_owner.c                               |   79 ++----
 mm/slub.c                                     |   12 
 31 files changed, 664 insertions(+), 571 deletions(-)
