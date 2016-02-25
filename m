From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH]multipath-tools: prevent unnecessary
 reinstate of stand-by paths with implicit tpgs mode and no active array
 paths.
Date: Thu, 25 Feb 2016 14:49:53 -0600
Message-ID: <20160225204953.GA2915@octiron.msp.redhat.com>
References: <065E3B7B-8F7D-48D9-BCB9-DFE13F8F3923@nimblestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <065E3B7B-8F7D-48D9-BCB9-DFE13F8F3923@nimblestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shiva Krishna <Shiva.Krishna@nimblestorage.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Feb 20, 2016 at 08:23:29PM +0000, Shiva Krishna wrote:

I understand your problem, but this isn't the right patch to fix it. For
one this check

+		if (newstate != PATH_GHOST || pp->mpp->nr_active > 0 ||
+		    pp->tpgs != TPGS_IMPLICIT) {

is pretty problematic.  Every path that isn't alua or doesn't enable
detect_prio will have pp->tpgs != TPGS_IMPLICIT (because this will be
zeroed out on path creation for all paths, and TPGS_IMPLICIT == 0x1). If
you need special handling for PATH_GHOST, and you don't want to copy and
modify an existing checker, then you should probably go with a config
option to enable this on your device, perhaps ghost_is_standby.  Then
you (and anyone else who needs this) can set that in your builtin device
config, and you don't need to try to craft a complicated check to get
this right.

Also, I see how this will stop the reinstate on the check after the
kernel fails this path, but how about on the check after that?

That check that you added before reinstate only happens on the

if (newstate != pp->state) {

branch. The next time you check the path, presumably newstate will equal
pp->state and the code does

      else if (newstate == PATH_UP || newstate == PATH_GHOST) {
                if (pp->dmstate == PSTATE_FAILED ||
                    pp->dmstate == PSTATE_UNDEF) {
                        /* Clear IO errors */
                        if (reinstate_path(pp, 0)) {

Won't you simply reinstate the path here? There are other places where
the path can get reinstated as well.  Possibly a better option is to use
your config option to check the return from (or perhpas in) get_state()
and if it is PATH_GHOST, change it to a new state, say PATH_STANDBY.
Now, if you do this, you will probably need to go through and add
PATH_STANDBY to all the checks that look for PATH_DOWN or PATH_SHAKY, so
that multipath is treating PATH_STANDBY like PATH_DOWN, but with a more
helpful name.  In which case, you might just want to make the check a
macro on inline function. And as long as you're doing that, you should
add PATH_TIMEOUT to the check as well, so that it gets treated like
PATH_DOWN, because currently it doesn't, which is broken.

-Ben

> multipathd treats "stand-by" path as active(ghost) and reinstate path.This
> causes I/O hang issues and lots of "change" udev events in cases where only
> stand-by paths are present in multipath map and target supports only implicit
> tpgs mode(active/passive arrays) 
> 
> This can happen during system boot where only stand-by paths are discovered
> first and continuous retry of I/O's by dm-multipath and change(failed) events
> are hogging multipathd and slowing down the entire boot process with large
> number of volumes mapped (~100s).
> 
> Selecting path checkers other than tur is not a solution as well, as they will
> continuously throw messages saying paths are failed for stand-by state.
> 
> This patch will prevent re-instate of stand-by paths in this situation and
> thus prevent unnecessary i/o with failed events during boot or when active
> array goes down temporarily.
> 
> Detailed steps to hit the I/O hang issue even with no_path_retry:
> devices {
>     device {
>         vendor               "Nimble"
>         product              "Server"
>         path_grouping_policy group_by_prio
>         detect_prio          yes
>         hardware_handler     "1 alua"
>         path_checker         tur
>         failback             immediate
>         fast_io_fail_tmo     10
>         no_path_retry        30
>         path_selector        "round-robin 0"
>     }
> }
> 
> 1. Delete all active paths.
> 
> mpathal (2e0176ad6309077166c9ce90033bfa248_1) dm-2 Nimble,Server
> size=20G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
> `-+- policy='round-robin 0' prio=1 status=active
>   |- 8:0:5:1 sdg 8:96  active ghost running
>   `- 8:0:6:1 sdh 8:112 active ghost running
> 
> 2. Issue I/O on mpath with zero active paths.
> 
> dd if=/dev/mapper/mpathal of=/dev/null bs=512 count=1 iflag=direct &
> 
> Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: sdg - tur checker reports path is in standby state
> Nov 23 15:10:36 hitdev-rhel67 multipathd: 8:96: reinstated
> Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: queue_if_no_path enabled
> Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: Recovered to normal mode
> Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: remaining active paths: 1
> Nov 23 15:10:36 hitdev-rhel67 kernel: sd 8:0:5:1: alua: port group 02 state S non-preferred supports tolusna
> Nov 23 15:10:36 hitdev-rhel67 kernel: device-mapper: multipath: Failing path 8:96.
> Nov 23 15:10:36 hitdev-rhel67 multipathd: 8:96: mark as failed
> Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: Entering recovery mode: max_retries=20
> Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: remaining active paths: 0
> 
> 3. Monitor udev events every 5 seconds.
> 
> # udevadm monitor
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
> 
> KERNEL[1448320131.061837] change   /devices/virtual/block/dm-2 (block)
> KERNEL[1448320131.064802] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320131.082838] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320131.102134] change   /devices/virtual/block/dm-2 (block)
> KERNEL[1448320135.551737] change   /devices/virtual/block/dm-2 (block)
> KERNEL[1448320135.552701] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320135.571634] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320135.591017] change   /devices/virtual/block/dm-2 (block)
> KERNEL[1448320136.553368] change   /devices/virtual/block/dm-2 (block)
> KERNEL[1448320136.554298] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320136.572733] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320136.592089] change   /devices/virtual/block/dm-2 (block)
> KERNEL[1448320140.555389] change   /devices/virtual/block/dm-2 (block)
> KERNEL[1448320140.556369] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320140.574944] change   /devices/virtual/block/dm-2 (block)
> UDEV  [1448320140.594076] change   /devices/virtual/block/dm-2 (block)
> 
> Signed-off-by: ShivaKrishna Merla <shiva.krishna@nimblestorage.com>
> ---
>  libmultipath/propsel.c |    2 +-
>  libmultipath/structs.h |    1 +
>  multipathd/main.c      |   21 ++++++++++++++++-----
>  3 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index f64d5e4..b9e389f 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -374,7 +374,7 @@ detect_prio(struct path * pp)
>  	int ret;
>  	struct prio *p = &pp->prio;
>  
> -	if (get_target_port_group_support(pp->fd) <= 0)
> +	if ((pp->tpgs = get_target_port_group_support(pp->fd)) <= 0)
>  		return;
>  	ret = get_target_port_group(pp->fd);
>  	if (ret < 0)
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 5f68a8e..ef5fb7e 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -193,6 +193,7 @@ struct path {
>  	int detect_prio;
>  	int watch_checks;
>  	int wait_checks;
> +	int tpgs;
>  	char * uid_attribute;
>  	char * getuid;
>  	struct prio prio;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index bf3423f..7faa4bd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -62,6 +62,7 @@ static int use_watchdog;
>  #include <pgpolicies.h>
>  #include <uevent.h>
>  #include <log.h>
> +#include "prioritizers/alua_rtpg.h"
>  
>  #include "main.h"
>  #include "pidfile.h"
> @@ -1299,11 +1300,21 @@ check_path (struct vectors * vecs, struct path * pp)
>  				pp->watch_checks--;
>  			add_active = 0;
>  		}
> -		if (reinstate_path(pp, add_active)) {
> -			condlog(3, "%s: reload map", pp->dev);
> -			ev_add_path(pp, vecs);
> -			pp->tick = 1;
> -			return 0;
> +
> +		/*
> +		 * don't reinstate failed path, if its in stand-by
> +		 * and if target supports only implicit tpgs mode.
> +		 * this will prevent unnecessary i/o by dm on stand-by
> +		 * paths if there are no other active paths in map.
> +		 */
> +		if (newstate != PATH_GHOST || pp->mpp->nr_active > 0 ||
> +		    pp->tpgs != TPGS_IMPLICIT) {
> +			if (reinstate_path(pp, add_active)) {
> +				condlog(3, "%s: reload map", pp->dev);
> +				ev_add_path(pp, vecs);
> +				pp->tick = 1;
> +				return 0;
> +			}
>  		}
>  		new_path_up = 1;
> --
