From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: [PATCH] libmultipath/twable.c: Add default config for
 Sun StorageTek 2500 and 2530
Date: Wed, 26 Aug 2009 18:45:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908261844200.21130@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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


Signed-off-by: Charlie Brady <charlieb@budge.apana.org.au>

--- libmultipath/hwtable.c.orig	2009-08-26 18:30:55.000000000 -0400
+++ libmultipath/hwtable.c	2009-08-26 18:31:52.000000000 -0400
@@ -878,10 +878,10 @@
  		.checker_name  = RDAC,
  		.prio_name     = PRIO_RDAC,
  	},
-	/* SUN/LSI 2510, 2540 */
+	/* SUN/LSI 2500, 2510, 2530, 2540 */
  	{
  		.vendor        = "SUN",
-		.product       = "LCSM100_[IF]",
+		.product       = "LCSM100_[IEFS]",
  		.getuid        = DEFAULT_GETUID,
  		.features      = DEFAULT_FEATURES,
  		.hwhandler     = "1 rdac",
