From: Shiva Krishna <Shiva.Krishna@nimblestorage.com>
Subject: [PATCH v3]multipath-tools: prevent unnecessary reinstate
 of stand-by paths with implicit tags mode and no active array paths
Date: Sat, 27 Feb 2016 20:44:22 +0000
Message-ID: <D2F74AA5.88BF%Shiva.Krishna@nimblestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-ID: <ACA5D19E667AEE4191EB63D2655BAACB@nimblestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

multipathd treats "stand-by" path as active(ghost) and reinstate path.This
causes I/O hang issues and lots of "change" udev events in cases where only
stand-by paths are present in multipath map and target supports only
implicit tpgs mode(active/passive arrays)

This can happen during system boot where only stand-by paths are discovered
first and continuous retry of I/O's by dm-multipath and change(failed)
events are hogging multipathd and slowing down the entire boot process with
large number of volumes mapped (~100s).

Selecting path checkers other than tur is not a solution as well, as they
will continuously throw messages saying paths are failed for stand-by
state.

This patch will prevent re-instate of stand-by paths in this situation and
thus prevent unnecessary i/o with failed events during boot or when active
array goes down temporarily.

With this, for targets supporting only alua and implicit tpgs mode,
stand-by paths are not reinstated by path checker unless there is an active
path in the map.

Detailed steps to hit the I/O hang issue even with no_path_retry:
devices {
    device {
        vendor               "Nimble"
        product              "Server"
        path_grouping_policy group_by_prio
        prio                 alua
        hardware_handler     "1 alua"
        path_checker         tur
        failback             immediate
        fast_io_fail_tmo     10
        no_path_retry        30
        path_selector        "round-robin 0"
    }
}

1. Delete all active paths.

mpathal (2e0176ad6309077166c9ce90033bfa248_1) dm-2 Nimble,Server
size=20G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 8:0:5:1 sdg 8:96  active ghost running
  `- 8:0:6:1 sdh 8:112 active ghost running

2. Issue I/O on mpath with zero active paths.

dd if=/dev/mapper/mpathal of=/dev/null bs=512 count=1 iflag=direct &

Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: sdg - tur checker
reports path is in standby state
Nov 23 15:10:36 hitdev-rhel67 multipathd: 8:96: reinstated
Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: queue_if_no_path enabled
Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: Recovered to normal mode
Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: remaining active paths:1
Nov 23 15:10:36 hitdev-rhel67 kernel: sd 8:0:5:1: alua: port group 02
state S non-preferred supports tolusna
Nov 23 15:10:36 hitdev-rhel67 kernel: device-mapper: multipath: Failing
path 8:96.
Nov 23 15:10:36 hitdev-rhel67 multipathd: 8:96: mark as failed
Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: Entering recovery mode:
max_retries=20
Nov 23 15:10:36 hitdev-rhel67 multipathd: mpathal: remaining active paths:
0

3. Monitor udev events every 5 seconds.

# udevadm monitor
monitor will print the received events for:
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[1448320131.061837] change   /devices/virtual/block/dm-2 (block)
KERNEL[1448320131.064802] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320131.082838] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320131.102134] change   /devices/virtual/block/dm-2 (block)
KERNEL[1448320135.551737] change   /devices/virtual/block/dm-2 (block)
KERNEL[1448320135.552701] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320135.571634] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320135.591017] change   /devices/virtual/block/dm-2 (block)
KERNEL[1448320136.553368] change   /devices/virtual/block/dm-2 (block)
KERNEL[1448320136.554298] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320136.572733] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320136.592089] change   /devices/virtual/block/dm-2 (block)
KERNEL[1448320140.555389] change   /devices/virtual/block/dm-2 (block)
KERNEL[1448320140.556369] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320140.574944] change   /devices/virtual/block/dm-2 (block)
UDEV  [1448320140.594076] change   /devices/virtual/block/dm-2 (block)

Signed-off-by: ShivaKrishna Merla <shiva.krishna@nimblestorage.com>
--- 
libmultipath/propsel.c |   13 ++++++++++++-
libmultipath/structs.h |    1 +
multipathd/main.c      |   19 ++++++++++++++++---
3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f64d5e4..890d4b1 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -373,9 +373,11 @@ detect_prio(struct path * pp)
{
	int ret;
	struct prio *p = &pp->prio;
+	int tpgs = 0;
-	if (get_target_port_group_support(pp->fd) <= 0)
+	if ((tpgs = get_target_port_group_support(pp->fd)) <= 0)
		return;
+	pp->tpgs = tpgs;
	ret = get_target_port_group(pp->fd);
	if (ret < 0)
		return;
@@ -415,6 +417,15 @@ select_prio (struct path * pp)
	prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
	origin = "(internal default)";
out:
+	/*
+	 * fetch tpgs mode for alua, if its not already obtained
+	 */
+	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
+		int tpgs = 0;
+		if(!pp->tpgs && 
+		   (tpgs = get_target_port_group_support(pp->fd)) >= 0)
+			pp->tpgs = tpgs;
+	}
	condlog(3, "%s: prio = %s %s", pp->dev, prio_name(p), origin);
	condlog(3, "%s: prio args = \"%s\" %s", pp->dev, prio_args(p), origin);
	return 0;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 5f68a8e..ef5fb7e 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -193,6 +193,7 @@ struct path {
	int detect_prio;
	int watch_checks;
	int wait_checks;
+	int tpgs;
	char * uid_attribute;
	char * getuid;
	struct prio prio;
diff --git a/multipathd/main.c b/multipathd/main.c
index 04f6d02..b6b0053 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -62,6 +62,7 @@ static int use_watchdog;
#include <pgpolicies.h>
#include <uevent.h>
#include <log.h>
+#include "prioritizers/alua_rtpg.h"
#include "main.h"
#include "pidfile.h"
@@ -1161,6 +1162,7 @@ check_path (struct vectors * vecs, struct path * pp)
	int new_path_up = 0;
	int chkr_new_path_up = 0;
	int add_active;
+	int ignore_reinstate = 0;
	int oldchkrstate = pp->chkrstate;
	if (pp->initialized && !pp->mpp)
@@ -1235,6 +1237,16 @@ check_path (struct vectors * vecs, struct path * pp)
			pp->wait_checks = 0;
	}
+	/*
+	 * don't reinstate failed path, if its in stand-by
+	 * and if target supports only implicit tpgs mode.
+	 * this will prevent unnecessary i/o by dm on stand-by
+	 * paths if there are no other active paths in map.
+	 */
+	ignore_reinstate = (newstate == PATH_GHOST &&
+			    pp->mpp->nr_active == 0 &&
+			    pp->tpgs == TPGS_IMPLICIT) ? 1 : 0;
+
	pp->chkrstate = newstate;
	if (newstate != pp->state) {
		int oldstate = pp->state;
@@ -1297,7 +1309,7 @@ check_path (struct vectors * vecs, struct path * pp)
				pp->watch_checks--;
			add_active = 0;
		}
-		if (reinstate_path(pp, add_active)) {
+		if (!ignore_reinstate && reinstate_path(pp, add_active)) {
			condlog(3, "%s: reload map", pp->dev);
			ev_add_path(pp, vecs);
			pp->tick = 1;
@@ -1316,8 +1328,9 @@ check_path (struct vectors * vecs, struct path * pp)
			enable_group(pp);
	}
	else if (newstate == PATH_UP || newstate == PATH_GHOST) {
-		if (pp->dmstate == PSTATE_FAILED ||
-		    pp->dmstate == PSTATE_UNDEF) {
+		if ((pp->dmstate == PSTATE_FAILED ||
+		    pp->dmstate == PSTATE_UNDEF) &&
+		    !ignore_reinstate) {
			/* Clear IO errors */
			if (reinstate_path(pp, 0)) {
				condlog(3, "%s: reload map", pp->dev);
--
