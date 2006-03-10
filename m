From: David Wysochanski <davidw@netapp.com>
Subject: [PATCH] update defaults for netapp targets
Date: Fri, 10 Mar 2006 11:22:43 -0500
Message-ID: <4411A7D3.2030306@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090102060600080505030207"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------090102060600080505030207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Should apply to latest git tree.



--------------090102060600080505030207
Content-Type: text/x-patch;
 name="update-netapp-target-defaults.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="update-netapp-target-defaults.patch"

--- libmultipath/hwtable.c	2006-03-02 11:29:20.000000000 -0500
+++ libmultipath/hwtable.c.new	2006-03-10 11:22:38.180997000 -0500
@@ -330,10 +330,10 @@ static struct hwentry default_hw[] = {
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
+		.minio         = 64
 		.checker_name  = READSECTOR0,
 	},
 	/*

--------------090102060600080505030207
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090102060600080505030207--
