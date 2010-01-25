From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: suppress debugobjects workqueue
	warning
Date: Mon, 25 Jan 2010 11:57:59 -0500
Message-ID: <20100125165759.GB20047@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

chunk_io() declares its 'struct mdata_req' on the stack and then
initializes its 'struct work_struct' member.  Annotate the
initialization of this workqueue with INIT_WORK_ON_STACK to suppress a
debugobjects warning seen when CONFIG_DEBUG_OBJECTS_WORK is enabled:

  ODEBUG: object is on stack, but not annotated
  ------------[ cut here ]------------
  WARNING: at lib/debugobjects.c:291 __debug_object_init+0x2b9/0x35c()
  ...
  Call Trace:
  [<ffffffff810485ac>] warn_slowpath_common+0x7c/0x94
  [<ffffffff810485d8>] warn_slowpath_null+0x14/0x16
  [<ffffffff811e113b>] __debug_object_init+0x2b9/0x35c
  [<ffffffff811e120b>] debug_object_init+0x14/0x16
  [<ffffffff810606c0>] __init_work+0x27/0x29
  [<ffffffffa0077306>] chunk_io+0xba/0x127 [dm_snapshot]
  ...

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 7d08879..c097d8a 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -254,7 +254,7 @@ static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw,
 	 * Issue the synchronous I/O from a different thread
 	 * to avoid generic_make_request recursion.
 	 */
-	INIT_WORK(&req.work, do_metadata);
+	INIT_WORK_ON_STACK(&req.work, do_metadata);
 	queue_work(ps->metadata_wq, &req.work);
 	flush_workqueue(ps->metadata_wq);
 
