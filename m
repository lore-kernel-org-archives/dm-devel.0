From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] multipath: lower the log level for rdac TAS
	messages
Date: Fri, 6 Apr 2012 21:49:19 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B04CDAF@SACEXCMBX03-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch lowers the log level for rdac TAS related messages.
These calls are expected to fail in cluster configurations due to reservations.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- multipath-tools/libmultipath/checkers/rdac.c.orig	2012-04-06 16:16:37.000000000 -0500
+++ multipath-tools/libmultipath/checkers/rdac.c	2012-04-06 16:17:00.000000000 -0500
@@ -118,7 +118,7 @@ int libcheck_init (struct checker * c)
 	set = 1;
 out:
 	if (set == 0)
-		condlog(0, "rdac checker failed to set TAS bit");
+		condlog(3, "rdac checker failed to set TAS bit");
 	return 0;
 }
 
