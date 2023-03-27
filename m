Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEAEC77B62
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679923531;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LBYsJsFgNdiTMVw//U7ITIlOh2nEm+P8rYLhnaBK+lY=;
	b=Dsi81z+Aq4iDXQvS9/F2YPPTu9DQnZRHc6F7Iq8i1Mbq0rt7+mJjLl+9AifoYRAPAt8rBc
	BJ9cXbzdaCTmFL/fC1rnMpvDih11gZhEhkZEiTbSbHqXZsNsbjofK3Trl8xY2Fql+HKB1M
	njGNuJrbPDz/loTMu8kxpD5d8EX7eYc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-FEYRm7rJPd6LmpbdEiJNFA-1; Mon, 27 Mar 2023 09:25:28 -0400
X-MC-Unique: FEYRm7rJPd6LmpbdEiJNFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 986FF101A531;
	Mon, 27 Mar 2023 13:25:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84C852166B26;
	Mon, 27 Mar 2023 13:25:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4CE441946A5A;
	Mon, 27 Mar 2023 13:25:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63D0119465B9
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 13:25:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 497C343FBE; Mon, 27 Mar 2023 13:25:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 421193542A
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:25:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 234FF38173CB
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:25:19 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-EyA-7DKyOPyvzSA12kkXaw-1; Mon,
 27 Mar 2023 09:25:15 -0400
X-MC-Unique: EyA-7DKyOPyvzSA12kkXaw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 5C9D821ECF;
 Mon, 27 Mar 2023 13:25:14 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0AF76138ED;
 Mon, 27 Mar 2023 13:25:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id mEz3ADqZIWTobgAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 27 Mar 2023 13:25:14 +0000
From: mwilck@suse.com
To: Douglas Gilbert <dgilbert@interlog.com>,
	Hannes Reinecke <hare@suse.de>
Date: Mon, 27 Mar 2023 15:24:58 +0200
Message-Id: <20230327132459.29531-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 2/3] 58-scsi-sg3_symlink.rules: don't create
 extra by-id symlinks by default
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The current code will set device symlinks for every identifier obtained
from VPD pages 0x83 and 0x80. This is seldom useful. Device IDs shouldn't
be used for identifying file systems or high-level objects such as LVs;
it is much more useful to identify these by their respective UUIDs.
Those subsystems that need device IDs, such as LVM, multipath, dm-crypt
etc, just need one identifier. For these use cases, a single symlink
is sufficient, and it should be the most reliable one as selected by
the ID_SERIAL logic in 55-scsi-sg3_id.rules.

On the other hand, especially on large configurations, unreliable and
ambiguous device identifiers can cause trouble when many devices claim
the same symlink. udev's attempts to determine the highest-priority
contender for a given symlink may be very resource-intensive and slow,
especially during boot, when lots of uevents for similar devices have
to be processed in parallel. This can cause udev workers to be killed,
and in the worst case, boot failure.

Avoid these issues by not creating possibly ambiguous /dev/disk/by-id
symlinks any more by default. Users can modify the configuration by
setting the types of symlinks to create in the environment variable
.SCSI_SYMLINK_SRC, which can be a combination of the letters T, L, V, S:

 T: T10 vendor ID ("1...") from VPD 0x83
 L: NAA local ("33...") from VPD 0x83
 V: vendor-specific ("0...") from VPD 0x83
 S: vendor/model/serial number ("S...") from VPD 0x80

In practice, modifying this should only be necessary if legacy devices
that don't provide any reliable identifiers are used as targets for
dm-crypt or LVM.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 scripts/58-scsi-sg3_symlink.rules | 50 +++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/scripts/58-scsi-sg3_symlink.rules b/scripts/58-scsi-sg3_symlink.rules
index fe6b000..99fdc23 100644
--- a/scripts/58-scsi-sg3_symlink.rules
+++ b/scripts/58-scsi-sg3_symlink.rules
@@ -5,10 +5,36 @@ ACTION=="remove", GOTO="sg3_utils_symlink_end"
 SUBSYSTEM!="block", GOTO="sg3_utils_symlink_end"
 ENV{UDEV_DISABLE_PERSISTENT_STORAGE_RULES_FLAG}=="1", GOTO="sg3_utils_symlink_end"
 
-# Select which identifier to use per default
+# Enable or disable possibly ambiguous SCSI device symlinks under /dev/disk/by-id
+#
+# .SCSI_SYMLINK_SRC can be any combination of the letter "TLVS":
+#   T: T10 vendor ID ("1...") from VPD 0x83
+#   L: NAA local ("33...") from VPD 0x83
+#   V: vendor-specific ("0...") from VPD 0x83
+#   S: vendor/model/serial number ("S...") from VPD 0x80
+# Symlinks will be created for every letter included in .SCSI_SYMLINK_SRC.
+# Symlinks for NAA (except "local") and EUI-64 IDs (see below) are always created.
+#
+# NOTE: The default rules in 60-persistent-storage.rules create a symlink
+# "ENV{ID_BUS}-ENV{ID_SERIAL}" symlink anyway, where ID_BUS is "scsi", "ata", "usb", or "cciss".
+# ID_SERIAL is set in 55-scsi-sg3_id.rules from the least ambiguous device identifier.
+# The symlinks created by this file are created *in addition* to the default symlink.
+#
+# This only needs to be changed if some subsystem, like dm-crypt or LVM, depends on the
+# additional symlinks being present for device identification.
+#
+# To configure the behavior, add an early rule (e.g. /etc/udev/rules.d/00-scsi-serial.rules)
+# like this:
+# ACTION!="remove", KERNEL=="sd*|sr*|st*|nst*|cciss*", ENV{.SCSI_SYMLINK_SRC}="TS"
+#
+# By default, no possibly ambiguous additional symlinks will be created.
+ENV{.SCSI_SYMLINK_SRC}!="?*", ENV{.SCSI_SYMLINK_SRC}=""
+
 # 0: vpd page 0x80 identifier
-ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}"
-ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*S*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}"
+ENV{.SCSI_SYMLINK_SRC}=="*S*", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-S$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_SERIAL}-part%n"
 # NAA identifier (prefix 3)
 # 1: IEEE Registered Extended first
 ENV{SCSI_IDENT_LUN_NAA_REGEXT}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_REGEXT}"
@@ -26,13 +52,19 @@ ENV{SCSI_IDENT_LUN_EUI64}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id
 ENV{SCSI_IDENT_LUN_NAME}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-8$env{SCSI_IDENT_LUN_NAME}"
 ENV{SCSI_IDENT_LUN_NAME}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-8$env{SCSI_IDENT_LUN_NAME}-part%n"
 # 6: T10 Vendor identifier (prefix 1)
-ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}"
-ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*T*", ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}"
+ENV{.SCSI_SYMLINK_SRC}=="*T*", ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-1$env{SCSI_IDENT_LUN_T10}-part%n"
 # 7: IEEE Locally assigned
-ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}"
-ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*L*", ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}"
+ENV{.SCSI_SYMLINK_SRC}=="*L*", ENV{SCSI_IDENT_LUN_NAA_LOCAL}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-3$env{SCSI_IDENT_LUN_NAA_LOCAL}-part%n"
 # 8: Vendor-specific identifier (prefix 0)
-ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="disk", SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}"
-ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="partition", SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}-part%n"
+ENV{.SCSI_SYMLINK_SRC}=="*V*", ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="disk", \
+    SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}"
+ENV{.SCSI_SYMLINK_SRC}=="*V*", ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{DEVTYPE}=="partition", \
+    SYMLINK+="disk/by-id/scsi-0$env{SCSI_VENDOR}_$env{SCSI_MODEL}_$env{SCSI_IDENT_LUN_VENDOR}-part%n"
 
 LABEL="sg3_utils_symlink_end"
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

