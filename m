Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6673AC11
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G7XFaX6N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524317;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wljrgkzshiDWdcVqDZ4fRXusgukNdzfUXirX9tkFq+E=;
	b=G7XFaX6NAAwiInGlvKZMdfVAcjCBH4lB05jmI8Sm8lJcpfwWDIWWSGi/Mej9GmSQz7RGpX
	YJUdHrCWpliFUc3DoTq1JHSVDFR+YChzOIbVo8qVLQBsg4toBbKcicbs1dM7V83Vu+7Fe1
	OUkeLQuEdh73fI+Qsrj1KGs8Mf2ci6I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-o01RLJGxMlO0qNlLdOsenQ-1; Tue, 17 Oct 2023 02:31:55 -0400
X-MC-Unique: o01RLJGxMlO0qNlLdOsenQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19B131029F40
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 127CC1C060AE
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCD3C19466F0
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C72F01946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 Oct 2023 16:55:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FD46C15BBC; Mon, 16 Oct 2023 16:55:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98A8DC15BB8
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 16:55:22 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 688BB85828C
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 16:55:22 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-3pfeuz6vO5mdnD7CcKOTLw-4; Mon, 16 Oct 2023 12:55:14 -0400
X-MC-Unique: 3pfeuz6vO5mdnD7CcKOTLw-4
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364937362"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; d="scan'208";a="364937362"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 16 Oct 2023 09:55:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826084575"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; d="scan'208";a="826084575"
Received: from newjersey.igk.intel.com ([10.102.20.203])
 by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 09:55:09 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH v2 13/13] lib/bitmap: add tests for IP tunnel flags conversion
 helpers
Date: Mon, 16 Oct 2023 18:52:47 +0200
Message-ID: <20231016165247.14212-14-aleksander.lobakin@intel.com>
In-Reply-To: <20231016165247.14212-1-aleksander.lobakin@intel.com>
References: <20231016165247.14212-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 17 Oct 2023 06:31:30 +0000
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Now that there are helpers for converting IP tunnel flags between the
old __be16 format and the bitmap format, make sure they work as expected
by adding a couple of tests to the bitmap testing suite. The helpers are
all inline, so no dependencies on the related CONFIG_* (or a standalone
module) are needed.

Cover three possible cases:

1. No bits past BIT(15) are set, VTI/SIT bits are not set. This
   conversion is almost a direct assignment.
2. No bits past BIT(15) are set, but VTI/SIT bit is set. During the
   conversion, it must be transformed into BIT(16) in the bitmap,
   but still compatible with the __be16 format.
3. The bitmap has bits past BIT(15) set (not the VTI/SIT one). The
   result will be truncated.
   Note that currently __IP_TUNNEL_FLAG_NUM is 17 (incl. special),
   which means that the result of this case is currently
   semi-false-positive. When BIT(17) is finally here, it will be
   adjusted accordingly.

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 lib/test_bitmap.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/lib/test_bitmap.c b/lib/test_bitmap.c
index a005fcd70ed7..2981277ed8d4 100644
--- a/lib/test_bitmap.c
+++ b/lib/test_bitmap.c
@@ -14,6 +14,8 @@
 #include <linux/string.h>
 #include <linux/uaccess.h>
 
+#include <net/ip_tunnels.h>
+
 #include "../tools/testing/selftests/kselftest_module.h"
 
 #define EXP1_IN_BITS	(sizeof(exp1) * 8)
@@ -1387,6 +1389,108 @@ static void __init test_bitmap_write_perf(void)
 
 #undef TEST_BIT_LEN
 
+struct ip_tunnel_flags_test {
+	const u16	*src_bits;
+	const u16	*exp_bits;
+	u8		src_num;
+	u8		exp_num;
+	__be16		exp_val;
+	bool		exp_comp:1;
+};
+
+#define IP_TUNNEL_FLAGS_TEST(src, comp, eval, exp) {	\
+	.src_bits	= (src),			\
+	.src_num	= ARRAY_SIZE(src),		\
+	.exp_comp	= (comp),			\
+	.exp_val	= (eval),			\
+	.exp_bits	= (exp),			\
+	.exp_num	= ARRAY_SIZE(exp),		\
+}
+
+/* These are __be16-compatible and can be compared as is */
+static const u16 ip_tunnel_flags_1[] __initconst = {
+	IP_TUNNEL_KEY_BIT,
+	IP_TUNNEL_STRICT_BIT,
+	IP_TUNNEL_ERSPAN_OPT_BIT,
+};
+
+/*
+ * Due to the previous flags design limitation, setting either
+ * ``IP_TUNNEL_CSUM_BIT`` (on Big Endian) or ``IP_TUNNEL_DONT_FRAGMENT_BIT``
+ * (on Little) also sets VTI/ISATAP bit. In the bitmap implementation, they
+ * correspond to ``BIT(16)``, which is bigger than ``U16_MAX``, but still is
+ * backward-compatible.
+ */
+#ifdef __BIG_ENDIAN
+#define IP_TUNNEL_CONFLICT_BIT	IP_TUNNEL_CSUM_BIT
+#else
+#define IP_TUNNEL_CONFLICT_BIT	IP_TUNNEL_DONT_FRAGMENT_BIT
+#endif
+
+static const u16 ip_tunnel_flags_2_src[] __initconst = {
+	IP_TUNNEL_CONFLICT_BIT,
+};
+
+static const u16 ip_tunnel_flags_2_exp[] __initconst = {
+	IP_TUNNEL_CONFLICT_BIT,
+	IP_TUNNEL_SIT_ISATAP_BIT,
+};
+
+/* Bits 17 and higher are not compatible with __be16 flags */
+static const u16 ip_tunnel_flags_3_src[] __initconst = {
+	IP_TUNNEL_VXLAN_OPT_BIT,
+	17,
+	18,
+	20,
+};
+
+static const u16 ip_tunnel_flags_3_exp[] __initconst = {
+	IP_TUNNEL_VXLAN_OPT_BIT,
+};
+
+static const struct ip_tunnel_flags_test ip_tunnel_flags_test[] __initconst = {
+	IP_TUNNEL_FLAGS_TEST(ip_tunnel_flags_1, true,
+			     cpu_to_be16(BIT(IP_TUNNEL_KEY_BIT) |
+					 BIT(IP_TUNNEL_STRICT_BIT) |
+					 BIT(IP_TUNNEL_ERSPAN_OPT_BIT)),
+			     ip_tunnel_flags_1),
+	IP_TUNNEL_FLAGS_TEST(ip_tunnel_flags_2_src, true, VTI_ISVTI,
+			     ip_tunnel_flags_2_exp),
+	IP_TUNNEL_FLAGS_TEST(ip_tunnel_flags_3_src,
+			     /*
+			      * This must be set to ``false`` once
+			      * ``__IP_TUNNEL_FLAG_NUM`` goes above 17.
+			      */
+			     true,
+			     cpu_to_be16(BIT(IP_TUNNEL_VXLAN_OPT_BIT)),
+			     ip_tunnel_flags_3_exp),
+};
+
+static void __init test_ip_tunnel_flags(void)
+{
+	for (u32 i = 0; i < ARRAY_SIZE(ip_tunnel_flags_test); i++) {
+		typeof(*ip_tunnel_flags_test) *test = &ip_tunnel_flags_test[i];
+		IP_TUNNEL_DECLARE_FLAGS(src) = { };
+		IP_TUNNEL_DECLARE_FLAGS(exp) = { };
+		IP_TUNNEL_DECLARE_FLAGS(out);
+
+		for (u32 j = 0; j < test->src_num; j++)
+			__set_bit(test->src_bits[j], src);
+
+		for (u32 j = 0; j < test->exp_num; j++)
+			__set_bit(test->exp_bits[j], exp);
+
+		ip_tunnel_flags_from_be16(out, test->exp_val);
+
+		expect_eq_uint(test->exp_comp,
+			       ip_tunnel_flags_is_be16_compat(src));
+		expect_eq_uint((__force u16)test->exp_val,
+			       (__force u16)ip_tunnel_flags_to_be16(src));
+
+		__ipt_flag_op(expect_eq_bitmap, exp, out);
+	}
+}
+
 static void __init selftest(void)
 {
 	test_zero_clear();
@@ -1405,6 +1509,7 @@ static void __init selftest(void)
 	test_bitmap_read_write();
 	test_bitmap_read_perf();
 	test_bitmap_write_perf();
+	test_ip_tunnel_flags();
 
 	test_find_nth_bit();
 	test_for_each_set_bit();
-- 
2.41.0

