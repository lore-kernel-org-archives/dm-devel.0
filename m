Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B230C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-xdo668lWOCe3B6tk6R3u7Q-1; Wed, 01 Dec 2021 07:37:34 -0500
X-MC-Unique: xdo668lWOCe3B6tk6R3u7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CB601926DC8;
	Wed,  1 Dec 2021 12:37:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8420E67842;
	Wed,  1 Dec 2021 12:37:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F7D64CA9B;
	Wed,  1 Dec 2021 12:37:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbAd6008677 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8E487C0808C; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A716C08084
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 069AB85A5BB
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-139-zHNnlIeOMbSzzdh4P7wFvg-1; Wed, 01 Dec 2021 07:37:08 -0500
X-MC-Unique: zHNnlIeOMbSzzdh4P7wFvg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 092881FD5E;
	Wed,  1 Dec 2021 12:37:07 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C891513FF5;
	Wed,  1 Dec 2021 12:37:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id oPUNL3Jsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:06 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:37 +0100
Message-Id: <20211201123650.16240-9-mwilck@suse.com>
In-Reply-To: <20211201123650.16240-1-mwilck@suse.com>
References: <20211201123650.16240-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbAd6008677
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 08/21] libmultipath (coverity): fix tainted
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
 libmultipath/prioritizers/alua_rtpg.c | 13 ++++----
 libmultipath/prioritizers/alua_spc3.h | 43 +++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 13 deletions(-)

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
index 7ba2cf4..f0a4bc4 100644
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
@@ -190,6 +191,38 @@ struct vpd83_data {
 	struct vpd83_dscr	data[0];
 } __attribute__((packed));
 
+#define VPD_BUFLEN 4096
+
+/* Returns the max byte offset in the VPD page from the start of the page */
+static inline unsigned int vpd83_max_offs(const struct vpd83_data *p)
+{
+	uint16_t len = get_unaligned_be16(p->length) + 4;
+
+	return len <= VPD_BUFLEN ? len : VPD_BUFLEN;
+}
+
+static inline bool
+vpd83_descr_fits(const struct vpd83_dscr *d, const struct vpd83_data *p)
+{
+	ptrdiff_t max_offs = vpd83_max_offs(p);
+	ptrdiff_t offs = ((const char *)d - (const char *)p);
+
+	/* make sure we can read d->length */
+	if (offs < 0 || offs > max_offs - 4)
+		return false;
+
+	offs += d->length + 4;
+	return offs <= max_offs;
+}
+
+static inline const struct vpd83_dscr *
+vpd83_next_dscr(const struct vpd83_dscr *d, const struct vpd83_data *p)
+{
+	ptrdiff_t offs = ((const char *)d - (const char *)p) + d->length + 4;
+
+	return (const struct vpd83_dscr *)((const char *)p + offs);
+}
+
 /*-----------------------------------------------------------------------------
  * This macro should be used to walk through all identification descriptors
  * defined in the code page 0x83.
@@ -199,11 +232,9 @@ struct vpd83_data {
  */
 #define FOR_EACH_VPD83_DSCR(p, d) \
 		for( \
-			d = p->data; \
-			(((char *) d) - ((char *) p)) < \
-			get_unaligned_be16(p->length); \
-			d = (struct vpd83_dscr *) \
-				((char *) d + d->length + 4) \
+			d = p->data;		  \
+			vpd83_descr_fits(d, p);	  \
+			d = vpd83_next_dscr(d, p) \
 		)
 
 /*=============================================================================
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

