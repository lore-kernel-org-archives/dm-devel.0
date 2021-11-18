Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A83AC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:19:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1B5F46141B
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1B5F46141B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-dhhuh-nTMLWxKsGeFdx3Mg-1; Thu, 18 Nov 2021 18:19:36 -0500
X-MC-Unique: dhhuh-nTMLWxKsGeFdx3Mg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7732EA40C1;
	Thu, 18 Nov 2021 23:19:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6106E4ABAA;
	Thu, 18 Nov 2021 23:19:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B6784E9E2;
	Thu, 18 Nov 2021 23:19:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINE50W005065 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1438740CFD12; Thu, 18 Nov 2021 23:14:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E92740CFD11
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9D7A857D02
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:04 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-406-PsJmrJf7OQeMBD453rn9ew-1; Thu, 18 Nov 2021 18:14:03 -0500
X-MC-Unique: PsJmrJf7OQeMBD453rn9ew-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AC61F2170E;
	Thu, 18 Nov 2021 23:14:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C82113DC0;
	Thu, 18 Nov 2021 23:14:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id UN08GDnelmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:01 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:25 +0100
Message-Id: <20211118231338.22358-9-mwilck@suse.com>
In-Reply-To: <20211118231338.22358-1-mwilck@suse.com>
References: <20211118231338.22358-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINE50W005065
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 08/21] libmultipath (coverity): fix tainted
	values in alua_rtpg.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Coverity needs tainted values limited by constant expressions.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/alua_rtpg.c | 13 ++++++------
 libmultipath/prioritizers/alua_spc3.h | 30 ++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 420a2e3..3f9c0e7 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -27,7 +27,6 @@
 #include "../structs.h"
 #include "../prio.h"
 #include "../discovery.h"
-#include "../unaligned.h"
 #include "../debug.h"
 #include "alua_rtpg.h"
 
@@ -252,12 +251,12 @@ int
 get_target_port_group(const struct path * pp, unsigned int timeout)
 {
 	unsigned char		*buf;
-	struct vpd83_data *	vpd83;
-	struct vpd83_dscr *	dscr;
+	const struct vpd83_data *	vpd83;
+	const struct vpd83_dscr *	dscr;
 	int			rc;
 	int			buflen, scsi_buflen;
 
-	buflen = 4096;
+	buflen = VPD_BUFLEN;
 	buf = (unsigned char *)malloc(buflen);
 	if (!buf) {
 		PRINT_DEBUG("malloc failed: could not allocate"
@@ -298,13 +297,13 @@ get_target_port_group(const struct path * pp, unsigned int timeout)
 	rc = -RTPG_NO_TPG_IDENTIFIER;
 	FOR_EACH_VPD83_DSCR(vpd83, dscr) {
 		if (vpd83_dscr_istype(dscr, IDTYPE_TARGET_PORT_GROUP)) {
-			struct vpd83_tpg_dscr *p;
+			const struct vpd83_tpg_dscr *p;
 			if (rc != -RTPG_NO_TPG_IDENTIFIER) {
 				PRINT_DEBUG("get_target_port_group: more "
 					    "than one TPG identifier found!");
 				continue;
 			}
-			p  = (struct vpd83_tpg_dscr *)dscr->data;
+			p  = (const struct vpd83_tpg_dscr *)dscr->data;
 			rc = get_unaligned_be16(p->tpg);
 		}
 	}
@@ -377,7 +376,7 @@ get_asymmetric_access_state(const struct path *pp, unsigned int tpg,
 	uint64_t		scsi_buflen;
 	int fd = pp->fd;
 
-	buflen = 4096;
+	buflen = VPD_BUFLEN;
 	buf = (unsigned char *)malloc(buflen);
 	if (!buf) {
 		PRINT_DEBUG ("malloc failed: could not allocate"
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index 7ba2cf4..611d67e 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -14,6 +14,7 @@
  */
 #ifndef __SPC3_H__
 #define __SPC3_H__
+#include "../unaligned.h"
 
 /*=============================================================================
  * Definitions to support the standard inquiry command as defined in SPC-3.
@@ -177,7 +178,7 @@ struct vpd83_dscr {
 } __attribute__((packed));
 
 static inline int
-vpd83_dscr_istype(struct vpd83_dscr *d, unsigned char type)
+vpd83_dscr_istype(const struct vpd83_dscr *d, unsigned char type)
 {
 	return ((d->b1 & 7) == type);
 }
@@ -190,6 +191,26 @@ struct vpd83_data {
 	struct vpd83_dscr	data[0];
 } __attribute__((packed));
 
+#define VPD_BUFLEN 4096
+
+static inline unsigned int vpd83_length(const struct vpd83_data *p)
+{
+	uint16_t len = get_unaligned_be16(p->length);
+
+	return len <= VPD_BUFLEN ? len : VPD_BUFLEN;
+}
+
+static inline const struct vpd83_dscr *
+vpd83_next_dscr(const struct vpd83_dscr *d, const struct vpd83_data *p)
+{
+	uint16_t pg_len = vpd83_length(p);
+	ptrdiff_t offs = ((const char *)d - (const char *)p) + d->length + 4;
+
+	offs = offs < 0 ? 0 : offs > pg_len ? pg_len : offs;
+	return (const struct vpd83_dscr *)((const char *)p + offs);
+}
+
+
 /*-----------------------------------------------------------------------------
  * This macro should be used to walk through all identification descriptors
  * defined in the code page 0x83.
@@ -200,10 +221,9 @@ struct vpd83_data {
 #define FOR_EACH_VPD83_DSCR(p, d) \
 		for( \
 			d = p->data; \
-			(((char *) d) - ((char *) p)) < \
-			get_unaligned_be16(p->length); \
-			d = (struct vpd83_dscr *) \
-				((char *) d + d->length + 4) \
+			(((const char *) d) - ((const char *) p)) \
+				< (ptrdiff_t)vpd83_length(p);	  \
+			d = vpd83_next_dscr(d, p) \
 		)
 
 /*=============================================================================
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

