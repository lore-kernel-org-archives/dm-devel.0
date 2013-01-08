From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/42] Update 'no_path_retry' correctly for
	failed paths
Date: Tue,  8 Jan 2013 14:54:05 +0100
Message-ID: <1357653259-62650-28-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The bug is triggered if path failed event is received by multipathd after all
paths have been already marked as failed. Surprisingly enough, it seems to
happen quite often; colleague of mine who tested this hit this bug every time.

Here is event sequence that explains this bug. I left some messages for
clarity; full log is available on request. We have completed initialization and
set feature queue_if_no_path for map CX_201 by virtue of using no_path_retry >
0.

Aug 31 10:49:09 | CX_201: devmap event #18
Aug 31 10:49:09 | CX_201: discover
Aug 31 10:49:09 | CX_201: rr_weight = 1 (internal default)
Aug 31 10:49:09 | CX_201: pgfailback = -2 (controller setting)
Aug 31 10:49:09 | CX_201: no_path_retry = 2 (controller setting)
Aug 31 10:49:09 | pg_timeout = NONE (internal default)
Aug 31 10:49:09 | 65:192: mark as failed
Aug 31 10:49:09 | CX_201: remaining active paths: 3
Aug 31 10:49:09 | 8:192: mark as failed
Aug 31 10:49:09 | CX_201: remaining active paths: 2
Aug 31 10:49:09 | CX_201: devmap event #19
Aug 31 10:49:09 | CX_201: discover
Aug 31 10:49:09 | CX_201: rr_weight = 1 (internal default)
Aug 31 10:49:09 | CX_201: pgfailback = -2 (controller setting)
Aug 31 10:49:09 | CX_201: no_path_retry = 2 (controller setting)
Aug 31 10:49:09 | pg_timeout = NONE (internal default)

Two paths failed by driver, multipahd marked them as failed.

Aug 31 10:49:09 | checker failed path 66:0 in map CX_201
Aug 31 10:49:09 | CX_201: remaining active paths: 1

Checker failed third path

Aug 31 10:49:09 | checker failed path 8:96 in map CX_201
Aug 31 10:49:09 | CX_201: Entering recovery mode: max_retries=2
Aug 31 10:49:09 | CX_201: remaining active paths: 0

Checker failed last path; multipathd entered retry loop.

Aug 31 10:49:10 | CX_201: devmap event #20

We got late event about failed path

Aug 31 10:49:10 | CX_201: discover

Start discovery. Call update_multipath -> setup_multipath ->
update_multipath_strings -> update_multipath_tablle -> disassemble_map.

Now disassemble_map tries to set no_path_retry value from kernel. This
obviously is not going to work as kernel is able remembering only Boolean
(queue/fail), while no_path_retry is arbitrary integer. So no_path_retry is set
to NO_PATH_RETRY_QUEUE from kernel.

Aug 31 10:49:10 | CX_201: rr_weight = 1 (internal default)
Aug 31 10:49:10 | CX_201: pgfailback = -2 (controller setting)

At this point we call set_no_path_retry:

set_no_path_retry(struct multipath *mpp)
{
        mpp->retry_tick = 0;
        mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
        if (mpp->nr_active > 0)
                select_no_path_retry(mpp);

So

1) retry_tick is reset
2) nr_active = 0 (no active path)
3) we do not set no_path_retry from config file because nr_active == 0 => left
with NO_PATH_RETRY_QUEUE.

Aug 31 10:49:10 | pg_timeout = NONE (internal default)

From now on there is no state changes, so map is hung forever.

Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs_vec.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 384afb7..7073915 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -306,8 +306,7 @@ set_no_path_retry(struct multipath *mpp)
 {
 	mpp->retry_tick = 0;
 	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
-	if (mpp->nr_active > 0)
-		select_no_path_retry(mpp);
+	select_no_path_retry(mpp);
 
 	switch (mpp->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
-- 
1.7.4.2
