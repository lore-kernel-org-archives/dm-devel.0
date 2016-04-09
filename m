From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: fix tio leak if clone_bio fails
Date: Sat, 9 Apr 2016 12:48:18 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1604091245100.3564@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm: fix tio leak if clone_bio fails

The patch c80914e81ec5b08fec0bae531e3445268c8820f4 ("dm: return error if 
bio_integrity_clone() fails in clone_bio()") changed the function 
clone_bio so that it can return an error. However, when the error happens, 
the structure dm_target_io is not freed. This patch fixes the code so that 
structure is freed.

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1662,8 +1662,10 @@ static int __clone_and_map_data_bio(stru
 		tio = alloc_tio(ci, ti, target_bio_nr);
 		tio->len_ptr = len;
 		r = clone_bio(tio, bio, sector, *len);
-		if (r < 0)
+		if (r < 0) {
+			free_tio(ci->md, tio);
 			break;
+		}
 		__map_bio(tio);
 	}
 
