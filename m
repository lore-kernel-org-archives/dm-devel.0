From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch 6 of 14] Device Mapper Mirror
Date: Tue, 07 Nov 2006 10:02:45 -0600
Message-ID: <1162915365.17899.45.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
Cc: heinzm@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

(Please note that this patch is already in 2.6.19-rc4-mm2.  The tarballs
given in the original mail take this into account.)
 brassow

Index: linux-2.6.18.1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.18.1.orig/drivers/md/dm-raid1.c	2006-11-01 14:03:43.000000000 -0600
+++ linux-2.6.18.1/drivers/md/dm-raid1.c	2006-11-01 14:16:14.000000000 -0600
@@ -1239,9 +1239,9 @@ static int mirror_status(struct dm_targe
 
 	case STATUSTYPE_TABLE:
 		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
-		DMEMIT("%d ", ms->nr_mirrors);
+		DMEMIT("%d", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
-			DMEMIT("%s %llu ", ms->mirror[m].dev->name,
+			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
 				(unsigned long long)ms->mirror[m].offset);
 	}
 
