Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D870615ADC
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lty7r4cT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524294;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mB9qECTdXwwkVWumwPPdVlBDqFTo2AuUsFGYPiovtRw=;
	b=Lty7r4cTVKN9G2QXARPS33K5bU3EBArC33xCvtDK5+LiryhdaDBdJXg42zIziAA4tgISEJ
	KXm06soDyAM7C22ErdhbEz+dYs/eBKGM99u/dNztN3Cz4skfmMjjuSXwhXFD83uRAYZPsf
	U53Zw0ibgt3JCXc3GW/0/ukzTP0X7J4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-692-Q-p_CsMTNfm5dtHQspvrBQ-1; Tue, 17 Oct 2023 02:31:33 -0400
X-MC-Unique: Q-p_CsMTNfm5dtHQspvrBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3953855300
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC8CE2166B27
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90C8519466EC
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:31:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77C2E1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 Oct 2023 16:54:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6744A200A7A2; Mon, 16 Oct 2023 16:54:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FDD820296DC
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 16:54:29 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30C47185A7B2
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 16:54:29 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-UaWBZ7ChNCWd9gbHq7kdmA-1; Mon, 16 Oct 2023 12:54:25 -0400
X-MC-Unique: UaWBZ7ChNCWd9gbHq7kdmA-1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364937059"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; d="scan'208";a="364937059"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 16 Oct 2023 09:54:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826083947"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; d="scan'208";a="826083947"
Received: from newjersey.igk.intel.com ([10.102.20.203])
 by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 09:54:20 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH v2 02/13] bitops: make BYTES_TO_BITS() treewide-available
Date: Mon, 16 Oct 2023 18:52:36 +0200
Message-ID: <20231016165247.14212-3-aleksander.lobakin@intel.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Avoid open-coding that simple expression each time by moving
BYTES_TO_BITS() from the probes code to <linux/bitops.h> to export
it to the rest of the kernel.
Simplify the macro while at it. `BITS_PER_LONG / sizeof(long)` always
equals to %BITS_PER_BYTE, regardless of the target architecture.
Do the same for the tools ecosystem as well (incl. its version of
bitops.h).

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 include/linux/bitops.h         | 2 ++
 kernel/trace/trace_probe.c     | 2 --
 tools/include/linux/bitops.h   | 2 ++
 tools/perf/util/probe-finder.c | 2 --
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index f7f5a783da2a..e0cd09eb91cd 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -21,6 +21,8 @@
 #define BITS_TO_U32(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
 #define BITS_TO_BYTES(nr)	__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
 
+#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_BYTE)
+
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
 extern unsigned int __sw_hweight32(unsigned int w);
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 4dc74d73fc1d..2b743c1e37db 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1053,8 +1053,6 @@ parse_probe_arg(char *arg, const struct fetch_type *type,
 	return ret;
 }
 
-#define BYTES_TO_BITS(nb)	((BITS_PER_LONG * (nb)) / sizeof(long))
-
 /* Bitfield type needs to be parsed into a fetch function */
 static int __parse_bitfield_probe_arg(const char *bf,
 				      const struct fetch_type *t,
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index f18683b95ea6..bc6600466e7b 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -20,6 +20,8 @@
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
 #define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
 
+#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_BYTE)
+
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);
 extern unsigned int __sw_hweight32(unsigned int w);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index f171360b0ef4..35f66c12ad8a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -304,8 +304,6 @@ static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
 	return ret2;
 }
 
-#define BYTES_TO_BITS(nb)	((nb) * BITS_PER_LONG / sizeof(long))
-
 static int convert_variable_type(Dwarf_Die *vr_die,
 				 struct probe_trace_arg *tvar,
 				 const char *cast, bool user_access)
-- 
2.41.0

