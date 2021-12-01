Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06824C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:19 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-XOlZWoEwO_mZHrTY6KjBwg-1; Wed, 01 Dec 2021 07:37:17 -0500
X-MC-Unique: XOlZWoEwO_mZHrTY6KjBwg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB787100C661;
	Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6089510013D6;
	Wed,  1 Dec 2021 12:37:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 827A04BB7C;
	Wed,  1 Dec 2021 12:37:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1Cb9YO008662 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5B9DA401E44; Wed,  1 Dec 2021 12:37:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 584CD401E2F
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 209EB80A0AE
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:09 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-433-dhHMMATJOcS0gnOEntkSBw-1; Wed, 01 Dec 2021 07:37:07 -0500
X-MC-Unique: dhHMMATJOcS0gnOEntkSBw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 39E89212CB;
	Wed,  1 Dec 2021 12:37:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F261013FF5;
	Wed,  1 Dec 2021 12:37:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id mLA3OXFsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:05 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:34 +0100
Message-Id: <20211201123650.16240-6-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1Cb9YO008662
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 05/21] libmultipath (coverity): improve input
	checking in parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Check offsets and other obvious errors in the VPD83 data.

The original reason to do this was to fix "tained scalar"
warnings from coverity. But this doesn't suffice for coverity
without using a constant boundary (WWID_SIZE) for "len" in
parse_vpd_pg80() and for "vpd_len" in parse_vpd_pg83(), even
though the computed boundaries are tighter than the constant
ones.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 134 +++++++++++++++++++++++++--------------
 1 file changed, 88 insertions(+), 46 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 36ea7b3..977aed9 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -36,6 +36,8 @@
 #include "print.h"
 #include "strbuf.h"
 
+#define VPD_BUFLEN 4096
+
 struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE] = {
 	[VPD_VP_UNDEF]	= { 0x00, "undef" },
 	[VPD_VP_HP3PAR]	= { 0xc0, "hp3par" },
@@ -1086,6 +1088,8 @@ parse_vpd_pg80(const unsigned char *in, char *out, size_t out_len)
 	if (out_len == 0)
 		return 0;
 
+	if (len > WWID_SIZE)
+		len = WWID_SIZE;
 	/*
 	 * Strip leading and trailing whitespace
 	 */
@@ -1115,84 +1119,123 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 	const unsigned char *d;
 	const unsigned char *vpd = NULL;
 	size_t len, vpd_len, i;
-	int vpd_type, prio = -1, naa_prio;
+	int vpd_type, prio = -1;
+	int err = -ENODATA;
+
+	/* Need space at least for one digit */
+	if (out_len <= 1)
+		return 0;
 
 	d = in + 4;
-	while (d < in + in_len) {
+	while (d <= in + in_len - 4) {
+		bool invalid = false;
+		int new_prio = -1;
+
 		/* Select 'association: LUN' */
-		if ((d[1] & 0x30) != 0) {
-			d += d[3] + 4;
-			continue;
-		}
+		if ((d[1] & 0x30) == 0x30) {
+			invalid = true;
+			goto next_designator;
+		} else if ((d[1] & 0x30) != 0x00)
+			goto next_designator;
+
 		switch (d[1] & 0xf) {
+			unsigned char good_len;
 		case 0x3:
 			/* NAA: Prio 5 */
 			switch (d[4] >> 4) {
 			case 6:
 				/* IEEE Registered Extended: Prio 8 */
-				naa_prio = 8;
+				new_prio = 8;
+				good_len = 16;
 				break;
 			case 5:
 				/* IEEE Registered: Prio 7 */
-				naa_prio = 7;
+				new_prio = 7;
+				good_len = 8;
 				break;
 			case 2:
 				/* IEEE Extended: Prio 6 */
-				naa_prio = 6;
+				new_prio = 6;
+				good_len = 8;
 				break;
 			case 3:
 				/* IEEE Locally assigned: Prio 1 */
-				naa_prio = 1;
+				new_prio = 1;
+				good_len = 8;
 				break;
 			default:
 				/* Default: no priority */
-				naa_prio = -1;
+				good_len = 0xff;
 				break;
 			}
-			if (prio < naa_prio) {
-				prio = naa_prio;
-				vpd = d;
-			}
+
+			invalid = good_len == 0xff || good_len != d[3];
 			break;
 		case 0x2:
 			/* EUI-64: Prio 4 */
-			if (prio < 4) {
-				prio = 4;
-				vpd = d;
-			}
+			invalid = (d[3] != 8 && d[3] != 12 && d[3] != 16);
+			new_prio = 4;
 			break;
 		case 0x8:
 			/* SCSI Name: Prio 3 */
-			if (memcmp(d + 4, "eui.", 4) &&
-			    memcmp(d + 4, "naa.", 4) &&
-			    memcmp(d + 4, "iqn.", 4))
-				break;
-			if (prio < 3) {
-				prio = 3;
-				vpd = d;
-			}
+			invalid = (d[3] < 4 || (memcmp(d + 4, "eui.", 4) &&
+						memcmp(d + 4, "naa.", 4) &&
+						memcmp(d + 4, "iqn.", 4)));
+			new_prio = 3;
 			break;
 		case 0x1:
 			/* T-10 Vendor ID: Prio 2 */
-			if (prio < 2) {
-				prio = 2;
-				vpd = d;
-			}
+			invalid = (d[3] < 8);
+			new_prio = 2;
 			break;
+		case 0xa:
+			condlog(2, "%s: UUID identifiers not yet supported",
+				__func__);
+			break;
+		default:
+			invalid = true;
+			break;
+		}
+
+	next_designator:
+		if (d + d[3] + 4 - in > (ssize_t)in_len) {
+			condlog(2, "%s: device descriptor length overflow: %zd > %zu",
+				__func__, d + d[3] + 4 - in, in_len);
+			err = -EOVERFLOW;
+			break;
+		} else if (invalid) {
+			condlog(2, "%s: invalid device designator at offset %zd: %02x%02x%02x%02x",
+				__func__, d - in, d[0], d[1], d[2], d[3]);
+			/*
+			 * We checked above that the next offset is within limits.
+			 * Proceed, fingers crossed.
+			 */
+			err = -EINVAL;
+		} else if (new_prio > prio) {
+			vpd = d;
+			prio = new_prio;
 		}
 		d += d[3] + 4;
 	}
 
 	if (prio <= 0)
-		return -ENODATA;
-	/* Need space at least for one digit */
-	else if (out_len <= 1)
-		return 0;
+		return err;
+
+	if (d != in + in_len)
+		/* Should this be fatal? (overflow covered above) */
+		condlog(2, "%s: warning: last descriptor end %zd != VPD length %zu",
+			__func__, d - in, in_len);
 
 	len = 0;
 	vpd_type = vpd[1] & 0xf;
 	vpd_len = vpd[3];
 	vpd += 4;
+	/* untaint vpd_len for coverity */
+	if (vpd_len > WWID_SIZE) {
+		condlog(1, "%s: suspicious designator length %zu truncated to %u",
+			__func__, vpd_len, WWID_SIZE);
+		vpd_len = WWID_SIZE;
+	}
 	if (vpd_type == 0x2 || vpd_type == 0x3) {
 		size_t i;
 
@@ -1206,10 +1249,6 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 		for (i = 0; i < vpd_len; i++)
 			len += sprintf(out + len,
 				       "%02x", vpd[i]);
-	} else if (vpd_type == 0x8 && vpd_len < 4) {
-		condlog(1, "%s: VPD length %zu too small for designator type 8",
-			__func__, vpd_len);
-		return -EINVAL;
 	} else if (vpd_type == 0x8) {
 		if (!memcmp("eui.", vpd, 4))
 			out[0] =  '2';
@@ -1316,11 +1355,12 @@ parse_vpd_c0_hp3par(const unsigned char *in, size_t in_len,
 static int
 get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 {
-	int len, buff_len;
-	unsigned char buff[4096];
+	int len;
+	size_t buff_len;
+	unsigned char buff[VPD_BUFLEN];
 
-	memset(buff, 0x0, 4096);
-	if (!parent || sysfs_get_vpd(parent, pg, buff, 4096) <= 0) {
+	memset(buff, 0x0, VPD_BUFLEN);
+	if (!parent || sysfs_get_vpd(parent, pg, buff, VPD_BUFLEN) <= 0) {
 		condlog(3, "failed to read sysfs vpd pg%02x", pg);
 		return -EINVAL;
 	}
@@ -1331,8 +1371,10 @@ get_vpd_sysfs (struct udev_device *parent, int pg, char * str, int maxlen)
 		return -ENODATA;
 	}
 	buff_len = get_unaligned_be16(&buff[2]) + 4;
-	if (buff_len > 4096)
+	if (buff_len > VPD_BUFLEN) {
 		condlog(3, "vpd pg%02x page truncated", pg);
+		buff_len = VPD_BUFLEN;
+	}
 
 	if (pg == 0x80)
 		len = parse_vpd_pg80(buff, str, maxlen);
@@ -1376,7 +1418,7 @@ bool
 is_vpd_page_supported(int fd, int pg)
 {
 	int i, len;
-	unsigned char buff[4096];
+	unsigned char buff[VPD_BUFLEN];
 
 	len = fetch_vpd_page(fd, 0x00, buff, sizeof(buff));
 	if (len < 0)
@@ -1392,7 +1434,7 @@ int
 get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
 {
 	int len, buff_len;
-	unsigned char buff[4096];
+	unsigned char buff[VPD_BUFLEN];
 
 	buff_len = fetch_vpd_page(fd, pg, buff, sizeof(buff));
 	if (buff_len < 0)
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

