From: Gerhard Wichert <Gerhard.Wichert@ts.fujitsu.com>
Subject: multipath-tools
Date: Tue, 7 Feb 2012 16:49:18 +0100
Message-ID: <201202071649.19235.Gerhard.Wichert@ts.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/fUMPPLVIj5Utv8"
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
To: christophe.varoqui@opensvc.com
Cc: "Wilck, Martin" <Martin.Wilck@ts.fujitsu.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--Boundary-00=_/fUMPPLVIj5Utv8
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Christophe,

It would be nice if You could add the Fujitsu storage devices to the HW config 
table of the multipath tools. Find attached a diff file against version 0.4.9 
with the configuration parameters for the Fujitsu devices.

Thanks,

Gerhard


diff -rup multipath-tools-0.4.9/libmultipath/hwtable.c multipath-tools-0.4.9-
fts/libmultipath/hwtable.c
--- multipath-tools-0.4.9/libmultipath/hwtable.c        2010-05-22 
14:01:58.000000000 +0200
+++ multipath-tools-0.4.9-fts/libmultipath/hwtable.c    2012-02-07 
16:17:55.000000000 +0100
@@ -352,6 +352,22 @@ static struct hwentry default_hw[] = {
                .prio_name     = DEFAULT_PRIO,
                .prio_args     = NULL,
        },
+       {
+               .vendor        = "FUJITSU",
+               .product       = "ETERNUS_DX(L|400|8000)",
+               .getuid        = DEFAULT_GETUID,
+               .features      = "1 queue_if_no_path",
+               .hwhandler     = DEFAULT_HWHANDLER,
+               .selector      = DEFAULT_SELECTOR,
+               .pgpolicy      = GROUP_BY_PRIO,
+               .pgfailback    = -FAILBACK_IMMEDIATE,
+               .rr_weight     = RR_WEIGHT_NONE,
+               .no_path_retry = 10,
+               .minio         = DEFAULT_MINIO,
+               .checker_name  = TUR,
+               .prio_name     = PRIO_ALUA,
+               .prio_args     = NULL,
+       },
        /*
         * Hitachi controller family
         *
diff -rup multipath-tools-0.4.9/multipath.conf.defaults multipath-tools-0.4.9-
fts/multipath.conf.defaults
--- multipath-tools-0.4.9/multipath.conf.defaults       2010-05-22 
14:01:58.000000000 +0200
+++ multipath-tools-0.4.9-fts/multipath.conf.defaults   2012-02-07 
16:10:21.000000000 +0100
@@ -266,6 +266,22 @@
 #              prio_args               ""
 #      }
 #      device {
+#              vendor                  "FUJITSU"
+#              product                 "ETERNUS_DX(L|400|8000)"
+#              getuid_callout          "/lib/udev/scsi_id --whitelisted --
device=/dev/%n"
+#              features                "1 queue_if_no_path"
+#              hardware_handler        "0"
+#              path_selector           "round-robin 0"
+#              path_grouping_policy    group_by_prio
+#              failback                immediate
+#              rr_weight               uniform
+#              no_path_retry           10
+#              rr_min_io               1000
+#              path_checker            tur
+#              prio                    alua
+#              prio_args               ""
+#      }
+#      device {
 #              vendor                  "(HITACHI|HP)"
 #              product                 "OPEN-.*"
 #              getuid_callout          "/lib/udev/scsi_id --whitelisted --
device=/dev/%n"
---
With best regards

Gerhard Wichert
Senior Developer
DCS R&D HW

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1, 33106 Paderborn, Germany
Tel:    +49 (5251) 525 2799
Fax:    +49 (5251) 525 32 2799
Email:	Gerhard.Wichert@ts.fujitsu.com
Web:    ts.fujitsu.com
Company Details: ts.fujitsu.com/imprint


--Boundary-00=_/fUMPPLVIj5Utv8
Content-Type: text/x-patch; charset="ISO-8859-15";
	name="multipath-tools-0.4.9-fts.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="multipath-tools-0.4.9-fts.patch"

diff -rup multipath-tools-0.4.9/libmultipath/hwtable.c multipath-tools-0.4.9-fts/libmultipath/hwtable.c
--- multipath-tools-0.4.9/libmultipath/hwtable.c	2010-05-22 14:01:58.000000000 +0200
+++ multipath-tools-0.4.9-fts/libmultipath/hwtable.c	2012-02-07 16:17:55.000000000 +0100
@@ -352,6 +352,22 @@ static struct hwentry default_hw[] = {
 		.prio_name     = DEFAULT_PRIO,
 		.prio_args     = NULL,
 	},
+	{
+		.vendor        = "FUJITSU",
+		.product       = "ETERNUS_DX(L|400|8000)",
+		.getuid        = DEFAULT_GETUID,
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 10,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
+		.prio_args     = NULL,
+	},
 	/*
 	 * Hitachi controller family
 	 *
diff -rup multipath-tools-0.4.9/multipath.conf.defaults multipath-tools-0.4.9-fts/multipath.conf.defaults
--- multipath-tools-0.4.9/multipath.conf.defaults	2010-05-22 14:01:58.000000000 +0200
+++ multipath-tools-0.4.9-fts/multipath.conf.defaults	2012-02-07 16:10:21.000000000 +0100
@@ -266,6 +266,22 @@
 #		prio_args		""
 #	}
 #	device {
+#		vendor			"FUJITSU"
+#		product			"ETERNUS_DX(L|400|8000)"
+#		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#		path_selector		"round-robin 0"
+#		path_grouping_policy	group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		10
+#		rr_min_io		1000
+#		path_checker		tur
+#		prio			alua
+#		prio_args		""
+#	}
+#	device {
 #		vendor			"(HITACHI|HP)"
 #		product			"OPEN-.*"
 #		getuid_callout		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"

--Boundary-00=_/fUMPPLVIj5Utv8
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Boundary-00=_/fUMPPLVIj5Utv8--
