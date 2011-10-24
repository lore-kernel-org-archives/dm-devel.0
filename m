From: bmarzins@sourceware.org
Subject: multipath-tools/kpartx gpt.c
Date: 24 Oct 2011 13:37:18 -0000
Message-ID: <20111024133718.30188.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2011-10-24 13:37:18

Modified files:
	kpartx         : gpt.c 

Log message:
	Fix for bz #719575.  Validate size of GPT partitions.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/gpt.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.2.1

--- multipath-tools/kpartx/gpt.c	2006/10/13 23:28:47	1.3
+++ multipath-tools/kpartx/gpt.c	2011/10/24 13:37:18	1.3.2.1
@@ -358,6 +358,15 @@
 		return 0;
 	}
 
+	/* Check that sizeof_partition_entry has the correct value */
+	if (__le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
+		// printf("GUID partition entry size check failed.\n");
+		free(*gpt);
+		*gpt = NULL;
+		return 0;
+	}
+
+
 	if (!(*ptes = alloc_read_gpt_entries(fd, *gpt))) {
 		free(*gpt);
 		*gpt = NULL;
