From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: scsi_dh: Print a warning message when ignoring
	arguments for hardwar handlers
Date: Thu, 21 Aug 2008 23:55:37 -0700
Message-ID: <1219388137.14830.112.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Instead of silently ignoring the arguments specified along with the
hardware handler, print some warning message to inform the user that the
arguments are dropped.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

Index: linux-2.6.27-rc3/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.27-rc3.orig/drivers/md/dm-mpath.c
+++ linux-2.6.27-rc3/drivers/md/dm-mpath.c
@@ -685,6 +685,10 @@ static int parse_hw_handler(struct arg_s
 		m->hw_handler_name = NULL;
 		return -EINVAL;
 	}
+
+	if (hw_argc > 1)
+		DMWARN("Ignoring arguments for hardware handler \"%s\"",
+				m->hw_handler_name);
 	consume(as, hw_argc - 1);
 
 	return 0;
