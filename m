From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 00/12] fixes for kpartx -d
Date: Wed, 17 May 2017 12:06:11 -0500
Message-ID: <20170517170610.GQ22856@octiron.msp.redhat.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 15, 2017 at 05:37:10PM +0200, Martin Wilck wrote:

ACK for the set

-Ben

> Working on a bug report about kpartx not properly removing
> partitions for loop devices, I realized a number of glitches
> and improperly handled corner cases in the kpartx code for
> deleting partitions. Some mappings are not deleted although
> they should be, and others are deleted although that is clearly
> wrong.
> 
> This patch series fixes the issues I found. The series starts
> with a test program demonstrating the problems. The program
> succeeds only after all patches of this series are applied.
> 
> Here is my summary of what I think how kpartx should behave:
> 
>   1) kpartx should delete all mappings it created beforehand.
>   2) kpartx should handle partitions on dm devices and other devices
>      (e.g. loop devices) equally well.
>   3) kpartx should only delete "partitions", which are single-target
>      linear mappings into a block device. Other maps should not be touched.
>   4) kpartx should only delete mappings it created itself beforehand.
>      In particular, it shouldn't delete LVM LVs, even if they are fully
>      contained in the block device at hand and thus look like partitions
>      in the first place. (For historical compatibility reasons, allow
>      such mappings to be deleted with the -f/--force flag).
>   5) DM map names may be changed, thus kpartx shouldn't rely on them to
>      check whether a mapping is a partition of a particular device. It is
>      legal for a partition of /dev/loop0 to be named "loop0".
> 
> One patch has an obvious libdevmapper equivalent and is therefore
> included (08/12) although this series is otherwise focused only on kpartx.
> Patch 04/12 would also have a libdevmapper equivalent, but I haven't
> included it because it would conflict with Ben's previously posted
> patch "libmultipath: fix partition detection".
> 
> The patches are based on Christophe's tree; Christophe, if you prefer,
> I can rebase them on top of Ben's late submissions.
> 
> Feedback is welcome.
> 
> Changes wrt v1:
> - Test program (01/12): improved cleanup, and used "kpartx -s" rather than waiting.
> - At Ben's suggestion, removed "no_partitions" support rather than fixing it.
> - Previous 04/12 split into two patches (04+05/12), improving and separating
>   out the part that would similarly apply to libmultipath (see above).
> - New UUID format in patch 09/12 since the previous one wasn't well-received;
>   the "-kpartx-" part was superfluous, as partition UUIDs start with "part%s-" anyway.
> - Added the trivial fix 12/12.
> 
> Martin Wilck (12):
>   kpartx: test-kpartx: new unit test program
>   kpartx: remove "no_partitions" support
>   kpartx: remove is_loop_device
>   kpartx: relax and improve UUID check in dm_compare_uuid
>   kpartx: dm_remove_partmaps: support non-dm devices
>   kpartx: dm_devn: return error for non-existent device
>   kpartx: don't treat multi-linear mappings as partitions
>   libmultipath: don't treat multi-linear mappings as partitions
>   kpartx: use partition UUID for non-DM devices
>   kpartx: use absolute path for regular files
>   kpartx: find_loop_by_file: use sysfs
>   kpartx: include sys/sysmacros.h
> 
>  kpartx/devmapper.c       |  80 ++++++---------
>  kpartx/devmapper.h       |   2 +-
>  kpartx/kpartx.c          |  50 ++++++++--
>  kpartx/lopart.c          |  75 ++++++--------
>  kpartx/lopart.h          |   1 -
>  kpartx/sysmacros.h       |   9 --
>  kpartx/test-kpartx       | 254 +++++++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/devmapper.c |  15 +--
>  8 files changed, 371 insertions(+), 115 deletions(-)
>  delete mode 100644 kpartx/sysmacros.h
>  create mode 100755 kpartx/test-kpartx
> 
> -- 
> 2.12.2
