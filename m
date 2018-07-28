From: <gregkh@linuxfoundation.org>
Subject: Patch "scsi: scsi_dh: replace too broad "TP9" string
	with the exact models" has been added to the 4.4-stable tree
Date: Sat, 28 Jul 2018 12:27:47 +0200
Message-ID: <153277366717336@kroah.com>
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
To: alexander.levin@microsoft.com, dm-devel@redhat.com, gregkh@linuxfoundation.org, hare@suse.de, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, ng-eseries-upstream-maintainers@netapp.com, xose.vazquez@gmail.com
Cc: stable-commits@vger.kernel.org
List-Id: dm-devel.ids


This is a note to let you know that I've just added the patch titled

    scsi: scsi_dh: replace too broad "TP9" string with the exact models

to the 4.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     scsi-scsi_dh-replace-too-broad-tp9-string-with-the-exact-models.patch
and it can be found in the queue-4.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From foo@baz Sat Jul 28 12:10:33 CEST 2018
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Sat, 7 Apr 2018 00:47:23 +0200
Subject: scsi: scsi_dh: replace too broad "TP9" string with the exact models

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

[ Upstream commit 37b37d2609cb0ac267280ef27350b962d16d272e ]

SGI/TP9100 is not an RDAC array:
    ^^^
https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/hwtable.c;h=88b4700beb1d8940008020fbe4c3cd97d62f4a56;hb=HEAD#l235

This partially reverts commit 35204772ea03 ("[SCSI] scsi_dh_rdac :
Consolidate rdac strings together")

[mkp: fixed up the new entries to align with rest of struct]

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_dh.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -58,7 +58,10 @@ static const struct scsi_dh_blist scsi_d
 	{"IBM", "3526",			"rdac", },
 	{"IBM", "3542",			"rdac", },
 	{"IBM", "3552",			"rdac", },
-	{"SGI", "TP9",			"rdac", },
+	{"SGI", "TP9300",		"rdac", },
+	{"SGI", "TP9400",		"rdac", },
+	{"SGI", "TP9500",		"rdac", },
+	{"SGI", "TP9700",		"rdac", },
 	{"SGI", "IS",			"rdac", },
 	{"STK", "OPENstorage",		"rdac", },
 	{"STK", "FLEXLINE 380",		"rdac", },


Patches currently in stable-queue which might be from xose.vazquez@gmail.com are

queue-4.4/scsi-scsi_dh-replace-too-broad-tp9-string-with-the-exact-models.patch
