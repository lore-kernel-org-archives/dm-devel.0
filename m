From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] lock snapshot when asking for status
Date: Thu, 8 Oct 2009 22:47:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0910082245560.6442@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch locks the snapshot when returning status --- it fixes a race 
when it would return invalid number of free chunks if someone 
simultaneously modifies it.

Mikulas

Hold the lock when processing the status.

On 32-bit computers with 64-bit chunk size, writes to the fields in the
exception store are not atomic and some invalid intermediate value can
be returned as the number of use chunks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.31-fast-new/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.31-fast-new.orig/drivers/md/dm-snap.c	2009-10-09 04:00:28.000000000 +0200
+++ linux-2.6.31-fast-new/drivers/md/dm-snap.c	2009-10-09 04:26:36.000000000 +0200
@@ -1170,6 +1170,8 @@ static int snapshot_status(struct dm_tar
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
 
+	down_write(&snap->lock);
+
 	switch (type) {
 	case STATUSTYPE_INFO:
 		if (!snap->valid)
@@ -1201,6 +1203,8 @@ static int snapshot_status(struct dm_tar
 		break;
 	}
 
+	up_write(&snap->lock);
+
 	return 0;
 }
 
