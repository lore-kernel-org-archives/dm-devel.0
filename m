From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Print a warning message when hardware handler
	parameters are ignored
Date: Wed, 05 Nov 2008 19:57:16 -0800
Message-ID: <1225943836.14830.1096.camel@chandra-ubuntu>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Currently dm ignores the parameters provided to hardware handlers
without providing any notifications to the user.

This patch just prints a warning message so that the user knows that
the arguments are ignored.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.27-rc3/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.27-rc3.orig/drivers/md/dm-mpath.c
+++ linux-2.6.27-rc3/drivers/md/dm-mpath.c
@@ -708,6 +708,10 @@ static int parse_hw_handler(struct arg_s
 		m->hw_handler_name = NULL;
 		return -EINVAL;
 	}
+
+	if (hw_argc > 1)
+		DMWARN("Ignoring user specified arguments for hardware handler \"%s\"",
+				m->hw_handler_name);
 	consume(as, hw_argc - 1);
 
 	return 0;
