From: Dan Carpenter <error27@gmail.com>
Subject: [patch] memory leak dm-exception-store.c
Date: Sat, 28 Nov 2009 12:31:13 +0200
Message-ID: <20091128103113.GF10640@bicker>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids


Without this change we would leak tmp_store.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/md/dm-exception-store.c	2009-11-28 07:17:35.000000000 +0200
+++ devel/drivers/md/dm-exception-store.c	2009-11-28 07:23:04.000000000 +0200
@@ -216,7 +216,8 @@ int dm_exception_store_create(struct dm_
 		type = get_type("N");
 	else {
 		ti->error = "Persistent flag is not P or N";
-		return -EINVAL;
+		r = -EINVAL;
+		goto bad_type;
 	}
 
 	if (!type) {
