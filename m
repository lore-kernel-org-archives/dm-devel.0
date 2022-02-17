Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A721BC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 19:55:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-qjdhm9g1NzavozCkxisU-Q-1; Thu, 17 Feb 2022 14:55:50 -0500
X-MC-Unique: qjdhm9g1NzavozCkxisU-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 941A41800D50;
	Thu, 17 Feb 2022 19:55:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0061460BD8;
	Thu, 17 Feb 2022 19:55:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1AE071809CAA;
	Thu, 17 Feb 2022 19:55:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HJtgLG005144 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 14:55:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3E89F407E244; Thu, 17 Feb 2022 19:55:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A4DB407E242
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22A8D802A5E
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 19:55:42 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-77-0ZIsTISgOJCSKKotVyqA9Q-1; Thu, 17 Feb 2022 14:55:38 -0500
X-MC-Unique: 0ZIsTISgOJCSKKotVyqA9Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DEF7C1F3AA;
	Thu, 17 Feb 2022 19:55:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A17B613476;
	Thu, 17 Feb 2022 19:55:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id gPAoJTioDmLBVgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 17 Feb 2022 19:55:36 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Feb 2022 20:55:31 +0100
Message-Id: <20220217195533.4251-3-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21HJtgLG005144
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/4] libmultipath: use bus_protocol_id() in
	snprint_path_protocol()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Simplify bus_protocol_id() by using the linear ordering.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 58 ++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 37 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 8ea8557..bf88f30 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -754,43 +754,27 @@ snprint_path_failures(struct strbuf *buff, const struct path * pp)
 int
 snprint_path_protocol(struct strbuf *buff, const struct path * pp)
 {
-	switch (pp->bus) {
-	case SYSFS_BUS_SCSI:
-		switch (pp->sg_id.proto_id) {
-		case SCSI_PROTOCOL_FCP:
-			return append_strbuf_str(buff, "scsi:fcp");
-		case SCSI_PROTOCOL_SPI:
-			return append_strbuf_str(buff, "scsi:spi");
-		case SCSI_PROTOCOL_SSA:
-			return append_strbuf_str(buff, "scsi:ssa");
-		case SCSI_PROTOCOL_SBP:
-			return append_strbuf_str(buff, "scsi:sbp");
-		case SCSI_PROTOCOL_SRP:
-			return append_strbuf_str(buff, "scsi:srp");
-		case SCSI_PROTOCOL_ISCSI:
-			return append_strbuf_str(buff, "scsi:iscsi");
-		case SCSI_PROTOCOL_SAS:
-			return append_strbuf_str(buff, "scsi:sas");
-		case SCSI_PROTOCOL_ADT:
-			return append_strbuf_str(buff, "scsi:adt");
-		case SCSI_PROTOCOL_ATA:
-			return append_strbuf_str(buff, "scsi:ata");
-		case SCSI_PROTOCOL_USB:
-			return append_strbuf_str(buff, "scsi:usb");
-		case SCSI_PROTOCOL_UNSPEC:
-		default:
-			return append_strbuf_str(buff, "scsi:unspec");
-		}
-	case SYSFS_BUS_CCW:
-		return append_strbuf_str(buff, "ccw");
-	case SYSFS_BUS_CCISS:
-		return append_strbuf_str(buff, "cciss");
-	case SYSFS_BUS_NVME:
-		return append_strbuf_str(buff, "nvme");
-	case SYSFS_BUS_UNDEF:
-	default:
-		return append_strbuf_str(buff, "undef");
-	}
+	static const char * const protocol_name[LAST_BUS_PROTOCOL_ID + 1] = {
+		[SYSFS_BUS_UNDEF] = "undef",
+		[SYSFS_BUS_CCW] = "ccw",
+		[SYSFS_BUS_CCISS] = "cciss",
+		[SYSFS_BUS_NVME] = "nvme",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_FCP] = "scsi:fcp",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SPI] = "scsi:spi",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SSA] = "scsi:ssa",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SBP] = "scsi:sbp",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SRP] = "scsi:srp",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ISCSI] = "scsi:iscsi",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SAS] = "scsi:sas",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ADT] = "scsi:adt",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ATA] = "scsi:ata",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_USB] = "scsi:usb",
+		[SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC] = "scsi:unspec",
+	};
+	const char *pn = protocol_name[bus_protocol_id(pp)];
+
+	assert(pn != NULL);
+	return append_strbuf_str(buff, pn);
 }
 
 static int
-- 
2.35.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

