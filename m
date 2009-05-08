From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] flush keventd queue in multipath destructor
Date: Fri, 8 May 2009 08:02:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0905080759570.9554@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

This fixes an upstream bug in multipath trigger_event code. I've already 
fixed similar bug in dm-raid1.

Mikulas

---

The commit fe9cf30eb8186ef267d1868dc9f12f2d0f40835a in 2.6.29-rc1 moves
dm table event submission from kmultipath queue to kernel kevent queue to
avoid a deadlock.

There is a possibility of race condition because kevent queue is not flushed
in the multipath destructor. The scenario is:
- some event happens and is queued to keventd
- keventd thread is delayed due to scheuling latency or some other work
- multipath device is destroyed
- keventd now attempts to process work_struct that is residing in already
  released memory.

The patch flushes the keventd queue in multipath constructor.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-mpath.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.30-rc4-devel/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.30-rc4-devel.orig/drivers/md/dm-mpath.c	2009-05-08 13:29:33.000000000 +0200
+++ linux-2.6.30-rc4-devel/drivers/md/dm-mpath.c	2009-05-08 13:29:44.000000000 +0200
@@ -851,6 +851,7 @@ static void multipath_dtr(struct dm_targ
 
 	flush_workqueue(kmpath_handlerd);
 	flush_workqueue(kmultipathd);
+	flush_scheduled_work();
 	free_multipath(m);
 }
 
