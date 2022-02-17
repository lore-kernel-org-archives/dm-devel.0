Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB629C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 19:55:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-T3SpyD_ZOO2yzVItJuo3-w-1; Thu, 17 Feb 2022 14:55:52 -0500
X-MC-Unique: T3SpyD_ZOO2yzVItJuo3-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB6D0801AC5;
	Thu, 17 Feb 2022 19:55:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE4EF4BC7B;
	Thu, 17 Feb 2022 19:55:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97CC51809CAB;
	Thu, 17 Feb 2022 19:55:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HJth6r005155 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 14:55:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B5B3576F0; Thu, 17 Feb 2022 19:55:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEEFD53AA
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 637091C05EBA
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:39 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-607-P-DZ0Z1MMQKyb5tlHDrKOw-1; Thu, 17 Feb 2022 14:55:37 -0500
X-MC-Unique: P-DZ0Z1MMQKyb5tlHDrKOw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91FFC1F3A2;
	Thu, 17 Feb 2022 19:55:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5369013476;
	Thu, 17 Feb 2022 19:55:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id yPEGEjioDmLBVgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 17 Feb 2022 19:55:36 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Feb 2022 20:55:30 +0100
Message-Id: <20220217195533.4251-2-mwilck@suse.com>
In-Reply-To: <20220217195533.4251-1-mwilck@suse.com>
References: <20220217195533.4251-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21HJth6r005155
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/4] libmultipath: enable linear ordering of
	bus/proto tuple
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

We categorized protocols by bus/proto_id, while we only differentiate
protocol IDs for SCSI. Allow transforming this into a linear sequence
of bus/protocol IDs by having non-SCSI first, and follwing up with
the different SCSI protocols.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 10 ++++++++++
 libmultipath/structs.h | 13 +++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 17f4baf..5849bf1 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -753,3 +753,13 @@ out:
 
 	return 0;
 }
+
+unsigned int bus_protocol_id(const struct path *pp) {
+	if (!pp || pp->bus < 0 || pp->bus > SYSFS_BUS_SCSI)
+		return SYSFS_BUS_UNDEF;
+	if (pp->bus != SYSFS_BUS_SCSI)
+		return pp->bus;
+	if (pp->sg_id.proto_id < 0 || pp->sg_id.proto_id > SCSI_PROTOCOL_UNSPEC)
+		return SYSFS_BUS_UNDEF;
+	return SYSFS_BUS_SCSI + pp->sg_id.proto_id;
+}
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 205cf64..d94f93a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -57,12 +57,13 @@ enum failback_mode {
 	FAILBACK_FOLLOWOVER
 };
 
+/* SYSFS_BUS_SCSI should be last, see bus_protocol_id() */
 enum sysfs_buses {
 	SYSFS_BUS_UNDEF,
-	SYSFS_BUS_SCSI,
 	SYSFS_BUS_CCW,
 	SYSFS_BUS_CCISS,
 	SYSFS_BUS_NVME,
+	SYSFS_BUS_SCSI,
 };
 
 enum pathstates {
@@ -181,9 +182,17 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_ADT = 7,	/* Media Changers */
 	SCSI_PROTOCOL_ATA = 8,
 	SCSI_PROTOCOL_USB = 9,  /* USB Attached SCSI (UAS), and others */
-	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
+	SCSI_PROTOCOL_UNSPEC = 0xa, /* No specific protocol */
 };
 
+/*
+ * Linear ordering of bus/protocol
+ * This assumes that SYSFS_BUS_SCSI is last in enum sysfs_buses
+ * SCSI is the only bus type for which we distinguish protocols.
+ */
+#define LAST_BUS_PROTOCOL_ID (SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC)
+unsigned int bus_protocol_id(const struct path *pp);
+
 #define SCSI_INVALID_LUN ~0ULL
 
 enum no_undef_states {
-- 
2.35.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

