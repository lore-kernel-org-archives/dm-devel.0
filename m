Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C67C77B6D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679923532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yg/vMSuaw5sv67eUgRpCAakITTLheqO3HQuXsqLREHE=;
	b=DMkItdGnq1Mpm5FwGopW1Ef1kdMO5jcuuRxFfM7LeVy4tYEk73tHxqX4ya7QWVGXE9e2/B
	C9iFYc6cSLHhmJ8YjlY50QWPWuLFdltzJnJh/C3lP1OBdVSILKPBetfZS1DI1Z8rODiBzc
	RUGSei33ChTgQWWjt4erS4baNxEh/cc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-iyhBJRF7N0igSqfDixqt_Q-1; Mon, 27 Mar 2023 09:25:28 -0400
X-MC-Unique: iyhBJRF7N0igSqfDixqt_Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A465857FB5;
	Mon, 27 Mar 2023 13:25:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41630492C3E;
	Mon, 27 Mar 2023 13:25:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25BEE1946594;
	Mon, 27 Mar 2023 13:25:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 09886194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 13:25:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F200B492C3E; Mon, 27 Mar 2023 13:25:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EAEEF492B01
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:25:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0E3310119EB
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:25:18 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-jNuicCUkNJy7AYBceHBSsg-1; Mon,
 27 Mar 2023 09:25:15 -0400
X-MC-Unique: jNuicCUkNJy7AYBceHBSsg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 073F421F48;
 Mon, 27 Mar 2023 13:25:14 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9FD6613329;
 Mon, 27 Mar 2023 13:25:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id oD8UJTmZIWTobgAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 27 Mar 2023 13:25:13 +0000
From: mwilck@suse.com
To: Douglas Gilbert <dgilbert@interlog.com>,
	Hannes Reinecke <hare@suse.de>
Date: Mon, 27 Mar 2023 15:24:57 +0200
Message-Id: <20230327132459.29531-2-mwilck@suse.com>
In-Reply-To: <20230327132459.29531-1-mwilck@suse.com>
References: <20230327132459.29531-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/3] 55-scsi-sg3_id.rules: don't set unreliable
 device ID by default
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Franck Bui <fbui@suse.de>,
 dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Some of the methods to determine the SCSI device ID are known to be
unreliable and, and possibly cause dm-multipath to falsely detect
a multipath setup and cause data corruption. These methods will
only be used if the known reliable device IDs (like NAA registered)
are unavailable.

Don't apply these methods by default. Make the methods to use configurable
instead. Configuration is done by setting the udev property
".SCSI_ID_SERIAL_SRC" to any combination of the letters T, L, V, S:

  T: T10 vendor ID ("1...")
  L: NAA local ("33...")
  V: vendor-specific ("0...")
  S: vendor/model/serial number ("S...")

The ordering of the letters in .SCSI_ID_SERIAL_SRC doesn't matter,
the precedence is always T, L, V, S.

Regardless of using these properties for ID_SERIAL, we can infer that
if any of these properties is set, it's correct to set ID_BUS="scsi".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 scripts/55-scsi-sg3_id.rules | 53 +++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/scripts/55-scsi-sg3_id.rules b/scripts/55-scsi-sg3_id.rules
index 453210b..33b2ad3 100644
--- a/scripts/55-scsi-sg3_id.rules
+++ b/scripts/55-scsi-sg3_id.rules
@@ -99,11 +99,56 @@ ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA_REG}=="?*", ENV{ID_BUS}="scsi", ENV
 ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA_EXT}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA_EXT}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA_EXT}"
 ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_EUI64}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="2$env{SCSI_IDENT_LUN_EUI64}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_EUI64}"
 ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAME}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="8$env{SCSI_IDENT_LUN_NAME}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAME}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="1$env{SCSI_IDENT_LUN_T10}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_T10}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA_LOCAL}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA_LOCAL}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_VENDOR}"
-ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{ID_BUS}="scsi", ENV{ID_SERIAL}="S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_SERIAL}"
 
 # Compat ID_SCSI_SERIAL setting
 ENV{ID_SCSI_SERIAL}!="?*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{ID_SCSI_SERIAL}="$env{SCSI_IDENT_SERIAL}"
+
+# Enable or disable possibly ambiguous SCSI device ID sources for setting ID_SERIAL
+#
+# .SCSI_ID_SERIAL_SRC can be any combination of the characters "TLVS":
+#   T: T10 vendor ID ("1...") from VPD 0x83
+#   L: NAA local ("33...") from VPD 0x83
+#   V: vendor-specific ("0...") from VPD 0x83
+#   S: vendor/model/serial number ("S...") from VPD 0x80
+# The ordering of the letters doesn't matter, the precedence is always T, L, V, S
+# NAA (except "local") and EUI-64 IDs (see below), as well as ATA IDs, always take precedence over
+# the sources configured here.
+#
+# This only needs to be changed if there are legacy SCSI devices that don't provide any reliable
+# device identifiers, and some subsystem like multipath requires that ID_SERIAL is set.
+# Be aware that multipath actually needs unique identifiers, though.
+# Using ambiguous identifiers for ID_SERIAL can cause data corruption with multipath.
+#
+# To configure this, add an early rule (e.g. /etc/udev/rules.d/00-scsi-serial.rules) e.g. like this:
+# ACTION!="remove", KERNEL=="sd*|sr*|st*|nst*|cciss*", ENV{.SCSI_ID_SERIAL_SRC}="TLVS"
+#
+# By default, only T10 vendor ID is allowed.
+ENV{.SCSI_ID_SERIAL_SRC}!="?*", ENV{.SCSI_ID_SERIAL_SRC}="T"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*T*", \
+    ENV{ID_SERIAL}="1$env{SCSI_IDENT_LUN_T10}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_T10}"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*L*", \
+    ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA_LOCAL}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA_LOCAL}"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*V*", \
+    ENV{ID_SERIAL}="0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_VENDOR}"
+
+ENV{ID_SERIAL}=="?*", GOTO="sg3_utils_id_end"
+ENV{SCSI_IDENT_SERIAL}=="?*", ENV{ID_BUS}="scsi"
+ENV{SCSI_IDENT_SERIAL}=="?*", ENV{.SCSI_ID_SERIAL_SRC}=="*S*", \
+    ENV{ID_SERIAL}="S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}", \
+    ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_SERIAL}"
+
 LABEL="sg3_utils_id_end"
+ENV{ID_SERIAL}!="?*", ENV{DEVTYPE}=="disk", \
+    PROGRAM="/bin/logger -t 55-scsi-sg3_id.rules -p daemon.warning \"WARNING: SCSI device %k has no device ID, consider changing .SCSI_ID_SERIAL_SRC in 00-scsi-sg3_config.rules\""
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

