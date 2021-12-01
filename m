Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4327C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:37:34 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-ojCRpVbtOS2CJBdTCwyQmA-1; Wed, 01 Dec 2021 07:37:30 -0500
X-MC-Unique: ojCRpVbtOS2CJBdTCwyQmA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F1E01926DA3;
	Wed,  1 Dec 2021 12:37:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2297210013D6;
	Wed,  1 Dec 2021 12:37:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F08FE1809CB9;
	Wed,  1 Dec 2021 12:37:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbBLm008688 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 34AB64047279; Wed,  1 Dec 2021 12:37:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 302464047272
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92DA1811E80
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-576-l0uwhloJNWi-hGXyb90viA-1; Wed, 01 Dec 2021 07:37:07 -0500
X-MC-Unique: l0uwhloJNWi-hGXyb90viA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 86A711FD5D;
	Wed,  1 Dec 2021 12:37:06 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 46B1713FF5;
	Wed,  1 Dec 2021 12:37:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 6LNZD3Jsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:06 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:35 +0100
Message-Id: <20211201123650.16240-7-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbBLm008688
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 06/21] multipath-tools: add tests for broken
	VPD page 83
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

Add some tests for the consistency checks in the VPD.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/vpd.c | 144 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 1 deletion(-)

diff --git a/tests/vpd.c b/tests/vpd.c
index 8e730d3..a7d2092 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -9,6 +9,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <errno.h>
 #include <stdarg.h>
 #include <stddef.h>
 #include <setjmp.h>
@@ -291,7 +292,9 @@ static int create_vpd83(unsigned char *buf, size_t bufsiz, const char *id,
 	unsigned char *desc;
 	int n = 0;
 
-	memset(buf, 0, bufsiz);
+	/* Fill with large number, which will cause length overflow */
+	memset(buf, 0xed, bufsiz);
+	buf[0] = 0;
 	buf[1] = 0x83;
 
 	desc = buf + 4;
@@ -500,6 +503,27 @@ static void test_vpd_naa_ ## naa ## _ ## wlen(void **state)             \
 			    test_id, vt->wwid);				\
 }
 
+/**
+ * test_cpd_naa_NAA_badlen_BAD() - test detection of bad length fields
+ * @NAA:	Network Name Authority (2, 3, 5, 16)
+ * @BAD:        Value for designator length field
+ * @ERR:        Expected error code
+ */
+#define make_test_vpd_naa_badlen(NAA, BAD, ERR)			\
+static void test_vpd_naa_##NAA##_badlen_##BAD(void **state)	\
+{								\
+	struct vpdtest *vt = *state;					\
+	int n, ret;							\
+									\
+	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id, 3, NAA, 0); \
+									\
+	vt->vpdbuf[7] = BAD;						\
+	will_return(__wrap_ioctl, n);					\
+	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, 40);			\
+	assert_int_equal(-ret, -ERR);					\
+}
+
 /**
  * test_vpd_eui_LEN_WLEN() - test code for VPD 83, EUI64
  * @LEN:	EUI64 length (8, 12, or 16)
@@ -532,6 +556,31 @@ static void test_vpd_eui_ ## len ## _ ## wlen ## _ ## sml(void **state)	\
 			    test_id, vt->wwid);				\
 }
 
+/**
+ * test_cpd_eui_LEN_badlen_BAD() - test detection of bad length fields
+ * @NAA:	correct length(8, 12, 16)
+ * @BAD:        value for designator length field
+ * @ERR:        expected error code
+ */
+#define make_test_vpd_eui_badlen(LEN, BAD, ERR)			\
+static void test_vpd_eui_badlen_##LEN##_##BAD(void **state)	\
+{								\
+	struct vpdtest *vt = *state;					\
+	int n, ret;							\
+									\
+	n = create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id, 2, 0, LEN); \
+									\
+	vt->vpdbuf[7] = BAD;						\
+	will_return(__wrap_ioctl, n);					\
+	will_return(__wrap_ioctl, vt->vpdbuf);				\
+	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, 40);			\
+	assert_int_equal(ret, ERR);					\
+	if (ERR >= 0)							\
+		assert_correct_wwid("test_vpd_eui_badlen_"#LEN"_"#BAD,	\
+			    2 * BAD + 1, ret, '2', 0, true,		\
+			    test_id, vt->wwid);				\
+}
+
 /**
  * test_vpd80_SIZE_LEN_WLEN() - test code for VPD 80
  * @SIZE, @LEN:	see create_vpd80()
@@ -621,6 +670,17 @@ make_test_vpd_eui(8, 17, 0);
 make_test_vpd_eui(8, 16, 0);
 make_test_vpd_eui(8, 10, 0);
 
+make_test_vpd_eui_badlen(8, 8, 17);
+/* Invalid entry, length overflow */
+make_test_vpd_eui_badlen(8, 12, -EOVERFLOW);
+make_test_vpd_eui_badlen(8, 9, -EOVERFLOW);
+/* invalid entry, no length overflow, but no full next entry */
+make_test_vpd_eui_badlen(8, 7, -EINVAL);
+make_test_vpd_eui_badlen(8, 5, -EINVAL);
+/* invalid entry, length of next one readable but too long */
+make_test_vpd_eui_badlen(8, 4, -EOVERFLOW);
+make_test_vpd_eui_badlen(8, 0, -EOVERFLOW);
+
 /* 96 bit, WWID size: 26 */
 make_test_vpd_eui(12, 32, 0);
 make_test_vpd_eui(12, 26, 0);
@@ -628,12 +688,38 @@ make_test_vpd_eui(12, 25, 0);
 make_test_vpd_eui(12, 20, 0);
 make_test_vpd_eui(12, 10, 0);
 
+make_test_vpd_eui_badlen(12, 12, 25);
+make_test_vpd_eui_badlen(12, 16, -EOVERFLOW);
+make_test_vpd_eui_badlen(12, 13, -EOVERFLOW);
+/* invalid entry, no length overflow, but no full next entry */
+make_test_vpd_eui_badlen(12, 11, -EINVAL);
+make_test_vpd_eui_badlen(12, 9, -EINVAL);
+/* non-fatal - valid 8-byte descriptor */
+make_test_vpd_eui_badlen(12, 8, 17);
+/* invalid entry, length of next one readable but too long */
+make_test_vpd_eui_badlen(12, 7, -EOVERFLOW);
+make_test_vpd_eui_badlen(12, 0, -EOVERFLOW);
+
 /* 128 bit, WWID size: 34 */
 make_test_vpd_eui(16, 40, 0);
 make_test_vpd_eui(16, 34, 0);
 make_test_vpd_eui(16, 33, 0);
 make_test_vpd_eui(16, 20, 0);
 
+make_test_vpd_eui_badlen(16, 16, 33);
+make_test_vpd_eui_badlen(16, 17, -EOVERFLOW);
+make_test_vpd_eui_badlen(16, 15, -EINVAL);
+make_test_vpd_eui_badlen(16, 13, -EINVAL);
+/* non-fatal - valid 12-byte descriptor */
+make_test_vpd_eui_badlen(16, 12, 25);
+/* invalid entry, length of next one readable but too long */
+make_test_vpd_eui_badlen(16, 11, -EOVERFLOW);
+/* non-fatal - valid 8-byte descriptor */
+make_test_vpd_eui_badlen(16, 8, 17);
+/* invalid entry, length of next one readable but too long */
+make_test_vpd_eui_badlen(16, 7, -EOVERFLOW);
+make_test_vpd_eui_badlen(16, 0, -EOVERFLOW);
+
 /* NAA IEEE registered extended (36), WWID size: 34 */
 make_test_vpd_naa(6, 40);
 make_test_vpd_naa(6, 34);
@@ -641,12 +727,33 @@ make_test_vpd_naa(6, 33);
 make_test_vpd_naa(6, 32);
 make_test_vpd_naa(6, 20);
 
+/* NAA IEEE registered extended with bad designator length */
+make_test_vpd_naa_badlen(6, 16, 33);
+/* offset overflow */
+make_test_vpd_naa_badlen(6, 17, -EOVERFLOW);
+/* invalid entry, no length overflow, but no full next entry */
+make_test_vpd_naa_badlen(6, 15, -EINVAL);
+/* invalid entry, length of next one readable but too long */
+make_test_vpd_naa_badlen(6, 8, -EOVERFLOW);
+make_test_vpd_naa_badlen(6, 0, -EOVERFLOW);
+
 /* NAA IEEE registered (35), WWID size: 18 */
 make_test_vpd_naa(5, 20);
 make_test_vpd_naa(5, 18);
 make_test_vpd_naa(5, 17);
 make_test_vpd_naa(5, 16);
 
+/* NAA IEEE registered with bad designator length */
+make_test_vpd_naa_badlen(5, 8, 17);
+/* offset overflow */
+make_test_vpd_naa_badlen(5, 16, -EOVERFLOW);
+make_test_vpd_naa_badlen(5, 9, -EOVERFLOW);
+/* invalid entry, no length overflow, but no full next entry */
+make_test_vpd_naa_badlen(5, 7, -EINVAL);
+/* invalid entry, length of next one readable but too long */
+make_test_vpd_naa_badlen(5, 4, -EOVERFLOW);
+make_test_vpd_naa_badlen(5, 0, -EOVERFLOW);
+
 /* NAA local (33), WWID size: 18 */
 make_test_vpd_naa(3, 20);
 make_test_vpd_naa(3, 18);
@@ -741,24 +848,59 @@ static int test_vpd(void)
 		cmocka_unit_test(test_vpd_eui_8_17_0),
 		cmocka_unit_test(test_vpd_eui_8_16_0),
 		cmocka_unit_test(test_vpd_eui_8_10_0),
+		cmocka_unit_test(test_vpd_eui_badlen_8_8),
+		cmocka_unit_test(test_vpd_eui_badlen_8_12),
+		cmocka_unit_test(test_vpd_eui_badlen_8_9),
+		cmocka_unit_test(test_vpd_eui_badlen_8_7),
+		cmocka_unit_test(test_vpd_eui_badlen_8_5),
+		cmocka_unit_test(test_vpd_eui_badlen_8_4),
+		cmocka_unit_test(test_vpd_eui_badlen_8_0),
 		cmocka_unit_test(test_vpd_eui_12_32_0),
 		cmocka_unit_test(test_vpd_eui_12_26_0),
 		cmocka_unit_test(test_vpd_eui_12_25_0),
 		cmocka_unit_test(test_vpd_eui_12_20_0),
 		cmocka_unit_test(test_vpd_eui_12_10_0),
+		cmocka_unit_test(test_vpd_eui_badlen_12_12),
+		cmocka_unit_test(test_vpd_eui_badlen_12_16),
+		cmocka_unit_test(test_vpd_eui_badlen_12_13),
+		cmocka_unit_test(test_vpd_eui_badlen_12_11),
+		cmocka_unit_test(test_vpd_eui_badlen_12_9),
+		cmocka_unit_test(test_vpd_eui_badlen_12_8),
+		cmocka_unit_test(test_vpd_eui_badlen_12_7),
+		cmocka_unit_test(test_vpd_eui_badlen_12_0),
 		cmocka_unit_test(test_vpd_eui_16_40_0),
 		cmocka_unit_test(test_vpd_eui_16_34_0),
 		cmocka_unit_test(test_vpd_eui_16_33_0),
 		cmocka_unit_test(test_vpd_eui_16_20_0),
+		cmocka_unit_test(test_vpd_eui_badlen_16_16),
+		cmocka_unit_test(test_vpd_eui_badlen_16_17),
+		cmocka_unit_test(test_vpd_eui_badlen_16_15),
+		cmocka_unit_test(test_vpd_eui_badlen_16_13),
+		cmocka_unit_test(test_vpd_eui_badlen_16_12),
+		cmocka_unit_test(test_vpd_eui_badlen_16_11),
+		cmocka_unit_test(test_vpd_eui_badlen_16_8),
+		cmocka_unit_test(test_vpd_eui_badlen_16_7),
+		cmocka_unit_test(test_vpd_eui_badlen_16_0),
 		cmocka_unit_test(test_vpd_naa_6_40),
 		cmocka_unit_test(test_vpd_naa_6_34),
 		cmocka_unit_test(test_vpd_naa_6_33),
 		cmocka_unit_test(test_vpd_naa_6_32),
 		cmocka_unit_test(test_vpd_naa_6_20),
+		cmocka_unit_test(test_vpd_naa_6_badlen_16),
+		cmocka_unit_test(test_vpd_naa_6_badlen_15),
+		cmocka_unit_test(test_vpd_naa_6_badlen_8),
+		cmocka_unit_test(test_vpd_naa_6_badlen_17),
+		cmocka_unit_test(test_vpd_naa_6_badlen_0),
 		cmocka_unit_test(test_vpd_naa_5_20),
 		cmocka_unit_test(test_vpd_naa_5_18),
 		cmocka_unit_test(test_vpd_naa_5_17),
 		cmocka_unit_test(test_vpd_naa_5_16),
+		cmocka_unit_test(test_vpd_naa_5_badlen_8),
+		cmocka_unit_test(test_vpd_naa_5_badlen_7),
+		cmocka_unit_test(test_vpd_naa_5_badlen_4),
+		cmocka_unit_test(test_vpd_naa_5_badlen_16),
+		cmocka_unit_test(test_vpd_naa_5_badlen_9),
+		cmocka_unit_test(test_vpd_naa_5_badlen_0),
 		cmocka_unit_test(test_vpd_naa_3_20),
 		cmocka_unit_test(test_vpd_naa_3_18),
 		cmocka_unit_test(test_vpd_naa_3_17),
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

