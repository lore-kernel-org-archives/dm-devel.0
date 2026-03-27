Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7F82C08AB
	for <dm-devel@lists.linux.dev>; Fri, 27 Mar 2026 03:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774582905; cv=none; b=L+DGUZSsZ2TioP6nq4MYE6H07bnTtyyuDlDstfRP9JzxptmTGuutRjOYsNzpg5WHzQ37GU53V+nPcvz/BVxVY9ghb5qa202oBkIJ5uyEHwSaGl6m8yo87lx9JuSUvjYNQjS3EDkBcoLyGC2RM590YpBpwKQVgvTZJ8IRjxLFD78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774582905; c=relaxed/simple;
	bh=qo8jvwi12PTBndJgwus5CYFprC5hv/McXtXlEpcI8yk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=CfAKNztYpkTCOk1+xfDk3o4sx8k4GgDE+jBQ5E5ZV5qQDQyBdkBdHqFhO+rCz4wx0tuIVHcHF1fe3P2ItCFRRixzLMXoJ2o8WwnW+eQPbbXavIVoWPAFedUxaIaopwApIr7rPHfhaBuYVRTqlYAQKvB895IOgtghitznTD1tBVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAlqBCES; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAlqBCES"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774582903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xZKEuUe2T/zmVXIQcRtS2bf8FKNJLlcDvgeBK2kY5lA=;
	b=iAlqBCESJhvFrvZ1xayBCh/pZ7qMoBRN2CeHERpS1Pe/vG83tb/mgcg+Br6hyvfEiIMRqg
	HcDHCt77S9IJ+fpYlWgAvE1U1Inu/uhF0AoEgNMIbOakBal/zoGUVanR7KZpQEddF4h8v0
	eOGDwh1qte1MYs5jAj3NoTkPoYgZsSU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-ADkylCkSOk-3pdezg2_fSw-1; Thu,
 26 Mar 2026 23:41:39 -0400
X-MC-Unique: ADkylCkSOk-3pdezg2_fSw-1
X-Mimecast-MFC-AGG-ID: ADkylCkSOk-3pdezg2_fSw_1774582898
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 80944195609D;
	Fri, 27 Mar 2026 03:41:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2086019560B1;
	Fri, 27 Mar 2026 03:41:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62R3faMp1157694
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 23:41:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62R3fa5r1157693;
	Thu, 26 Mar 2026 23:41:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH] libmultipath: Handle SCSI-2 style vpd page 0x83 descriptors
Date: Thu, 26 Mar 2026 23:41:36 -0400
Message-ID: <20260327034136.1157685-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y6hSByqM4IxC8pcsVoyVmWqEqwTd1sEbleG41BRkKNY_1774582898
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Some older SCSI devices return a SCSI-2 style vpd page 0x83, instead of
a SPC-2/3 format one. The SCSI-2 page 83 format returns an IEEE WWN in
binary encoded hexi-decimal in the 16 bytes following the initial
4-byte page 83 reply header.

Check the 7th byte of the vpd page 83 buffer to determine whether this
is a SCSI-2 or SPC-2/3 confomant one. Byte 7 is the 3rd byte of first
Identification descriptor in a SPC-2/3 confromant vpd page 83. This is a
reserved field, and is guaranteed to be 0. If it is not zero, then it is
likely the 3rd byte of a SCSI-2 Identifier (The first 3 bytes of the ID
are the Organizationally Unique Identifier). Both the sg_inq and scsi_id
commands handle vpd page 83 this way. To make sure that the WWID which
multipath reads directly from the device matches, it should handle this
format as well.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 13 +++++++++
 tests/vpd.c              | 58 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0efb8213..057ff45f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1208,6 +1208,18 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 	if (out_len <= 1)
 		return 0;
 
+	/*
+	 * Not a valid SPC-2/3 vpd page 83. Assume it's a SCSI-2 style
+	 * descriptor.
+	 */
+	if (in[6] != 0) {
+		len = 0;
+		vpd_type = 0x3;
+		vpd_len = in_len - 4;
+		vpd = in + 4;
+		goto decode;
+	}
+
 	d = in + 4;
 	while (d <= in + in_len - 4) {
 		bool invalid = false;
@@ -1323,6 +1335,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 	vpd_type = vpd[1] & 0xf;
 	vpd_len = vpd[3];
 	vpd += 4;
+decode:
 	/* untaint vpd_len for coverity */
 	if (vpd_len > WWID_SIZE) {
 		condlog(1, "%s: suspicious designator length %zu truncated to %u",
diff --git a/tests/vpd.c b/tests/vpd.c
index f9e22cd8..b0217948 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -331,6 +331,28 @@ static int create_vpd83(unsigned char *buf, size_t bufsiz, const char *id,
 	return n + 4;
 }
 
+/**
+ * create_pre_spc3_vpd83() - create pre-SPC3 "device identification" VPD page
+ *
+ * @buf, @bufsiz: see above.
+ * @id:		input ID (third byte must be non-zero)
+ *
+ * Create a pre-SPC3 "device identification" VPD page. See comments in
+ * sg3_utils/src/sg_inq.c for details
+ *
+ * Return:	VPD page length.
+ */
+static int create_pre_spc3_vpd83(unsigned char *buf, size_t bufsize,
+				 const char *id)
+{
+	memset(buf, 0, bufsize);
+	buf[1] = 0x83;
+
+	hex2bin(buf + 4, id, 16, 32);
+	put_unaligned_be16(16, buf + 2);
+	return 20;
+}
+
 /**
  * assert_correct_wwid() - test that a retrieved WWID matches expectations
  * @test:	test name
@@ -479,6 +501,30 @@ static void test_vpd_str_ ## typ ## _ ## len ## _ ## wlen(void **state) \
 			    test_id, vt->wwid);				\
 }
 
+/**
+ * test_vpd_prespc3_WLEN() - test code for pre-SPC3 VPD 83
+ * @WLEN:	WWID buffer size
+ */
+#define make_test_vpd_prespc3(wlen)					\
+static void test_vpd_prespc3_ ## wlen(void **state)			\
+{									\
+	struct vpdtest *vt = *state;					\
+	int n, ret;							\
+	int exp_len;							\
+									\
+	/* returned size is always uneven */				\
+	exp_len = wlen > 33 ? 33 :					\
+		wlen % 2 == 0 ? wlen - 1 : wlen - 2;			\
+									\
+	n = create_pre_spc3_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf),	\
+				  test_id);				\
+	wrap_will_return(WRAP_IOCTL, n); 				\
+	wrap_will_return(WRAP_IOCTL, vt->vpdbuf);			\
+	ret = get_vpd_sgio(10, 0x83, 0, vt->wwid, wlen);		\
+	assert_correct_wwid("test_vpd_prespc3_" #wlen, exp_len, ret,	\
+			    '3', 0, true, test_id, vt->wwid);		\
+}
+
 /**
  * test_vpd_naa_NAA_WLEN() - test code for VPD 83 NAA designation
  * @NAA:	Network Name Authority (2, 3, 5, or 6)
@@ -814,6 +860,13 @@ make_test_vpd_str(18, 20, 17)
 make_test_vpd_str(18, 20, 16)
 make_test_vpd_str(18, 20, 15)
 
+/* PRE-SPC3, WWID size: 34 */
+make_test_vpd_prespc3(40)
+make_test_vpd_prespc3(34)
+make_test_vpd_prespc3(33)
+make_test_vpd_prespc3(32)
+make_test_vpd_prespc3(20)
+
 static int test_vpd(void)
 {
 	const struct CMUnitTest tests[] = {
@@ -945,6 +998,11 @@ static int test_vpd(void)
 		cmocka_unit_test(test_vpd_str_18_20_17),
 		cmocka_unit_test(test_vpd_str_18_20_16),
 		cmocka_unit_test(test_vpd_str_18_20_15),
+		cmocka_unit_test(test_vpd_prespc3_40),
+		cmocka_unit_test(test_vpd_prespc3_34),
+		cmocka_unit_test(test_vpd_prespc3_33),
+		cmocka_unit_test(test_vpd_prespc3_32),
+		cmocka_unit_test(test_vpd_prespc3_20),
 	};
 	return cmocka_run_group_tests(tests, setup, teardown);
 }
-- 
2.53.0

