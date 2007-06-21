From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc4-mm2 PATCH 5/11]
	dm-raid1-report-fault-status.patch
Date: Thu, 21 Jun 2007 13:04:24 -0500
Message-ID: <1182449064.13518.10.camel@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Minor change to header.

Suggestion was made to update the version number with this patch.  I
have a version-bump patch at the end of this series.

 brassow

This patch adds extra information to the mirror status output, so that
it can be determined which device(s) have failed.  An 'A' for alive and
'D' for dead are printed in the status line for each mirror device.  This
allows userspace to properly reconfigure the mirror set.

Index: linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
@@ -1482,17 +1482,22 @@ static int mirror_status(struct dm_targe
 {
 	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	char buffer[ms->nr_mirrors + 1];
 
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
-		for (m = 0; m < ms->nr_mirrors; m++)
+		for (m = 0; m < ms->nr_mirrors; m++) {
 			DMEMIT("%s ", ms->mirror[m].dev->name);
+			buffer[m] = atomic_read(&(ms->mirror[m].error_count)) ?
+				'D' : 'A';
+		}
+		buffer[m] = '\0';
 
-		DMEMIT("%llu/%llu 0 ",
+		DMEMIT("%llu/%llu 1 %s ",
 			(unsigned long long)ms->rh.log->type->
 				get_sync_count(ms->rh.log),
-			(unsigned long long)ms->nr_regions);
+		       (unsigned long long)ms->nr_regions, buffer);
 
 		sz += ms->rh.log->type->status(ms->rh.log, type, result+sz, maxlen-sz);
 
