Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B76CD68F6
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 07:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696921383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YwD7Lg51s5NGu+jaZB7KtOBjKZjcl58gUnDLmJnKvq0=;
	b=MjKnDTA+XXCC1vxRh0CwySfIDDiOaBqsCCZ5kqw51KuzOkywFIrgyhfCo0fnpFzsualj9P
	b756nXc8OeKO8lRmHH8pp4UPfONrqW4G3tCGNSgnK8D+UP4A4HANLTns/vNArqIY0VgyY9
	j0GnHM27aogtV1UnN7cPuks2vvITrPE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-M8j9DfvUN4Ojh4pOtyWGxQ-1; Tue, 10 Oct 2023 03:02:59 -0400
X-MC-Unique: M8j9DfvUN4Ojh4pOtyWGxQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1EF61C04B5D;
	Tue, 10 Oct 2023 07:02:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D210947AD4A;
	Tue, 10 Oct 2023 07:02:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ADEC419466EA;
	Tue, 10 Oct 2023 07:02:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7FC1719465A0
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Oct 2023 15:14:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 626FF401038; Mon,  9 Oct 2023 15:14:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B10C40104E
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:14:37 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 380261875059
 for <dm-devel@redhat.com>; Mon,  9 Oct 2023 15:14:37 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-6KvnVc22Oyi2Pzwec15g1w-5; Mon, 09 Oct 2023 11:14:20 -0400
X-MC-Unique: 6KvnVc22Oyi2Pzwec15g1w-5
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="369232099"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="369232099"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 09 Oct 2023 08:13:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="869287975"
X-IronPort-AV: E=Sophos;i="6.03,210,1694761200"; d="scan'208";a="869287975"
Received: from newjersey.igk.intel.com ([10.102.20.203])
 by fmsmga002.fm.intel.com with ESMTP; 09 Oct 2023 08:13:14 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yury Norov <yury.norov@gmail.com>
Date: Mon,  9 Oct 2023 17:10:16 +0200
Message-ID: <20231009151026.66145-5-aleksander.lobakin@intel.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Tue, 10 Oct 2023 07:02:51 +0000
Subject: [dm-devel] [PATCH 04/14] linkmode: convert linkmode_{test, set,
 clear, mod}_bit() to macros
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since commit b03fc1173c0c ("bitops: let optimize out non-atomic bitops
on compile-time constants"), the non-atomic bitops are macros which can
be expanded by the compilers into compile-time expressions, which will
result in better optimized object code. Unfortunately, turned out that
passing `volatile` to those macros discards any possibility of
optimization, as the compilers then don't even try to look whether
the passed bitmap is known at compilation time. In addition to that,
the mentioned linkmode helpers are marked with `inline`, not
`__always_inline`, meaning that it's not guaranteed some compiler won't
uninline them for no reason, which will also effectively prevent them
from being optimized (it's a well-known thing the compilers sometimes
uninline `2 + 2`).
Convert linkmode_*_bit() from inlines to macros. Their calling
convention are 1:1 with the corresponding bitops, so that it's not even
needed to enumerate and map the arguments, only the names. No changes in
vmlinux' object code (compiled by LLVM for x86_64) whatsoever, but that
doesn't necessarily means the change is meaningless.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 include/linux/linkmode.h | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index 15e0e0209da4..f231e2edbfa5 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -38,10 +38,10 @@ static inline int linkmode_andnot(unsigned long *dst, const unsigned long *src1,
 	return bitmap_andnot(dst, src1, src2,  __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static inline void linkmode_set_bit(int nr, volatile unsigned long *addr)
-{
-	__set_bit(nr, addr);
-}
+#define linkmode_test_bit	test_bit
+#define linkmode_set_bit	__set_bit
+#define linkmode_clear_bit	__clear_bit
+#define linkmode_mod_bit	__assign_bit
 
 static inline void linkmode_set_bit_array(const int *array, int array_size,
 					  unsigned long *addr)
@@ -52,25 +52,6 @@ static inline void linkmode_set_bit_array(const int *array, int array_size,
 		linkmode_set_bit(array[i], addr);
 }
 
-static inline void linkmode_clear_bit(int nr, volatile unsigned long *addr)
-{
-	__clear_bit(nr, addr);
-}
-
-static inline void linkmode_mod_bit(int nr, volatile unsigned long *addr,
-				    int set)
-{
-	if (set)
-		linkmode_set_bit(nr, addr);
-	else
-		linkmode_clear_bit(nr, addr);
-}
-
-static inline int linkmode_test_bit(int nr, const volatile unsigned long *addr)
-{
-	return test_bit(nr, addr);
-}
-
 static inline int linkmode_equal(const unsigned long *src1,
 				 const unsigned long *src2)
 {
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

