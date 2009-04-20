From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 13/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 04:01:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200401280.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
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

dm-multipath-flush.patch

Flush support for dm-multipath target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-mpath.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-mpath.c	2009-04-10 06:28:46.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-mpath.c	2009-04-10 06:33:51.000000000 +0200
@@ -824,6 +824,8 @@ static int multipath_ctr(struct dm_targe
 		goto bad;
 	}
 
+	ti->num_flush_requests = 1;
+
 	return 0;
 
  bad:
