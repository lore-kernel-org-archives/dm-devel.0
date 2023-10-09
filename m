Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484E5CD68ED
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921394;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YosvzrYn+B23hW+5zpv8rxvd8LzQLDToJ2GTKrwHMos=;
	b=MXv7Jq0ve0Wwfikke4GC0McvbY5zdUMIbmTVxfANdd+7Awt3Xa5H3s3Rg6XhTJkQJe/9ea
	fwIiPSCTfKD93Mu6pLYjQSYfPhkXR0VT/qu8loLQ+nDDheA7Gr3HgyXB8GLajgLD5W5o1x
	QJsTSJ4vcWRvYi1DvdKpjVGjVKnZaBk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-zXzUsiJgOheS7JvaI_fIWw-1; Tue, 10 Oct 2023 03:03:10 -0400
X-MC-Unique: zXzUsiJgOheS7JvaI_fIWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B61C3800BB8;
	Tue, 10 Oct 2023 07:03:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B14E15C39;
	Tue, 10 Oct 2023 07:03:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7EF451946A70;
	Tue, 10 Oct 2023 07:02:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27AA519465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 15:15:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05FAA4026FB; Mon,  9 Oct 2023 15:15:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F2D8640D1BC
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:15:14 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAFA5803497
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:15:14 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-QeyHCSJNOFCPufBiG3nRAQ-3; Mon, 09 Oct 2023 11:15:12 -0400
X-MC-Unique: QeyHCSJNOFCPufBiG3nRAQ-3
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="369232537"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="369232537"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 Oct 2023 08:13:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="869288197"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="869288197"
Received: from newjersey.igk.intel.com ([10.102.20.203])
 by fmsmga002.fm.intel.com with ESMTP; 09 Oct 2023 08:13:48 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yury Norov <yury.norov@gmail.com>
Date: Mon,  9 Oct 2023 17:10:25 +0200
Message-ID: <20231009151026.66145-14-aleksander.lobakin@intel.com>
In-Reply-To: <20231009151026.66145-1-aleksander.lobakin@intel.com>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:51 +0000
Subject: [dm-devel] [PATCH 13/14] lib/bitmap: add tests for bitmap_{get,
 set}_bits()
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

bitmap_{get,set}_value8() is now bitmap_{get,set}_bits(). The former
didn't have any dedicated tests in the bitmap test suite.
Add a pack of test cases with variable offset, width, and value to set
(for _set_bits()), randomly generated with the only limitation:
``offset % 32 + width <= 32``, to make sure the tests won't fail or
trigger kernel warnings on 32-bit platforms. For _get_bits(), compare
the return values with the expected ones, calculated and saved manually.
For _set_bit(), do several modifications of the source bitmap and then
compare against the expected resulting one, also pre-calculated.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 lib/test_bitmap.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index cbf1b9611616..6037b66fd30a 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -1161,6 +1161,82 @@ static void __init test_bitmap_print_buf(void)
 	}
 }
 
+struct getset_test {
+	u16	offset;
+	u16	width;
+	union {
+		u32	expect;
+		u32	value;
+	};
+};
+
+#define GETSET_TEST(o, w, v) {	\
+	.offset	= (o),		\
+	.width	= (w),		\
+	.value	= (v),		\
+}
+
+static const unsigned long getset_src[] __initconst = {
+	BITMAP_FROM_U64(0x4329c918b472468eULL),
+	BITMAP_FROM_U64(0xb2c20a622474a119ULL),
+	BITMAP_FROM_U64(0x3a08cb5591cea40dULL),
+	BITMAP_FROM_U64(0xc9a7550384e145f8ULL),
+};
+
+static const struct getset_test get_bits_test[] __initconst = {
+	GETSET_TEST(208, 16, 0x84e1),
+	GETSET_TEST(104, 8, 0xa),
+	GETSET_TEST(224, 32, 0xc9a75503),
+	GETSET_TEST(64, 16, 0xa119),
+	GETSET_TEST(169, 1, 0x1),
+	GETSET_TEST(144, 8, 0xce),
+	GETSET_TEST(80, 4, 0x4),
+	GETSET_TEST(24, 4, 0x4),
+};
+
+static const struct getset_test set_bits_test[] __initconst = {
+	GETSET_TEST(56, 4, 0xa),
+	GETSET_TEST(80, 16, 0xb17a),
+	GETSET_TEST(112, 8, 0x1b),
+	GETSET_TEST(0, 32, 0xe8a555f2),
+	GETSET_TEST(16, 2, 0),
+	GETSET_TEST(72, 8, 0x7d),
+	GETSET_TEST(47, 1, 0),
+	GETSET_TEST(160, 16, 0x1622),
+};
+
+static const unsigned long getset_out[] __initconst = {
+	BITMAP_FROM_U64(0x4a294918e8a455f2ULL),
+	BITMAP_FROM_U64(0xb21b0a62b17a7d19ULL),
+	BITMAP_FROM_U64(0x3a08162291cea40dULL),
+	BITMAP_FROM_U64(0xc9a7550384e145f8ULL),
+};
+
+#define GETSET_TEST_BITS	BYTES_TO_BITS(sizeof(getset_out))
+
+static void __init test_bitmap_getset_bits(void)
+{
+	DECLARE_BITMAP(out, GETSET_TEST_BITS);
+
+	for (u32 i = 0; i < ARRAY_SIZE(get_bits_test); i++) {
+		const struct getset_test *test = &get_bits_test[i];
+		u32 val;
+
+		val = bitmap_get_bits(getset_src, test->offset, test->width);
+		expect_eq_uint(test->expect, val);
+	}
+
+	bitmap_copy(out, getset_src, GETSET_TEST_BITS);
+
+	for (u32 i = 0; i < ARRAY_SIZE(set_bits_test); i++) {
+		const struct getset_test *test = &set_bits_test[i];
+
+		bitmap_set_bits(out, test->offset, test->value, test->width);
+	}
+
+	expect_eq_bitmap(getset_out, out, GETSET_TEST_BITS);
+}
+
 /*
  * FIXME: Clang breaks compile-time evaluations when KASAN and GCOV are enabled.
  * To workaround it, GCOV is force-disabled in Makefile for this configuration.
@@ -1238,6 +1314,7 @@ static void __init selftest(void)
 	test_mem_optimisations();
 	test_bitmap_cut();
 	test_bitmap_print_buf();
+	test_bitmap_getset_bits();
 	test_bitmap_const_eval();
 
 	test_find_nth_bit();
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

