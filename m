Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0266EC77B73
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684948242;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hzpbv5yIdOBB1RZb1B95a+M9SaAUKva6Sq9fFW0iPjA=;
	b=ZAQlcmbAeZ5c4voteMBXVuF34HJDp0Qojqre7kUqnfkV6lIkOVEj3V31hU2+A3aGgz6kfj
	OpUGr8NNjq4Tdln3kTWW/ro+DQpNhYtHay4D38GMPXa/FDPH6sSCFdAJE8KCvtxL3bRLjm
	gXvB6g3HdieKopG5cvF4cGTHwb5a1NU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-bSeO32ITNKeFIuwxFLesTw-1; Wed, 24 May 2023 13:10:38 -0400
X-MC-Unique: bSeO32ITNKeFIuwxFLesTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F0BB38117F6;
	Wed, 24 May 2023 17:10:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A1382166B25;
	Wed, 24 May 2023 17:10:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4527719465A8;
	Wed, 24 May 2023 17:10:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AF1BC19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 17:10:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A1496492B0E; Wed, 24 May 2023 17:10:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98FF5492B0B
 for <dm-devel@redhat.com>; Wed, 24 May 2023 17:10:27 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFC25811E78
 for <dm-devel@redhat.com>; Wed, 24 May 2023 17:10:26 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-itNdlfV4PveDA37Gc8yp7w-2; Wed, 24 May 2023 13:10:22 -0400
X-MC-Unique: itNdlfV4PveDA37Gc8yp7w-2
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="338206710"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; d="scan'208";a="338206710"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 24 May 2023 10:09:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="704427344"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; d="scan'208";a="704427344"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by orsmga002.jf.intel.com with ESMTP; 24 May 2023 10:09:52 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Wed, 24 May 2023 09:57:09 -0700
Message-Id: <20230524165717.14062-5-chang.seok.bae@intel.com>
In-Reply-To: <20230524165717.14062-1-chang.seok.bae@intel.com>
References: <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230524165717.14062-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v7 04/12] x86/asm: Add a wrapper function for the
 LOADIWKEY instruction
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au, ardb@kernel.org,
 chang.seok.bae@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, mingo@kernel.org, ebiggers@kernel.org,
 lalithambika.krishnakumar@intel.com, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, bp@alien8.de, charishma1.gairuboyina@intel.com,
 luto@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com,
 tglx@linutronix.de, nhuck@google.com,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, gmazyland@gmail.com,
 elliott@hpe.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Key Locker introduces a CPU-internal wrapping key to encode a user key
to a key handle. Then a key handle is referenced instead of the plain
text key.

LOADIWKEY loads a wrapping key in the software-inaccessible CPU state.
It operates only in kernel mode.

The kernel will use this to load a new key at boot time. Establish a
wrapper to prepare for this use. Also, define struct iwkey to pass the
key value to it.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v6:
* Massage the changelog -- clarify the reason and the changes a bit.

Changes from v5:
* Fix a typo: kernel_cpu_begin() -> kernel_fpu_begin()

Changes from RFC v2:
* Separate out the code as a new patch.
* Improve the usability with the new struct as an argument. (Dan
  Williams)

Note, Dan wondered if:
  WARN_ON(!irq_fpu_usable());
would be appropriate in the load_xmm_iwkey() function.
---
 arch/x86/include/asm/keylocker.h     | 25 ++++++++++++++++++++++
 arch/x86/include/asm/special_insns.h | 32 ++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)
 create mode 100644 arch/x86/include/asm/keylocker.h

diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
new file mode 100644
index 000000000000..9b3bec452b31
--- /dev/null
+++ b/arch/x86/include/asm/keylocker.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_KEYLOCKER_H
+#define _ASM_KEYLOCKER_H
+
+#ifndef __ASSEMBLY__
+
+#include <asm/fpu/types.h>
+
+/**
+ * struct iwkey - A temporary wrapping key storage.
+ * @integrity_key:	A 128-bit key to check that key handles have not
+ *			been tampered with.
+ * @encryption_key:	A 256-bit encryption key used in
+ *			wrapping/unwrapping a clear text key.
+ *
+ * This storage should be flushed immediately after loaded.
+ */
+struct iwkey {
+	struct reg_128_bit integrity_key;
+	struct reg_128_bit encryption_key[2];
+};
+
+#endif /*__ASSEMBLY__ */
+#endif /* _ASM_KEYLOCKER_H */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index de48d1389936..dd2d8b40fce3 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -9,6 +9,7 @@
 #include <asm/processor-flags.h>
 #include <linux/irqflags.h>
 #include <linux/jump_label.h>
+#include <asm/keylocker.h>
 
 /*
  * The compiler should not reorder volatile asm statements with respect to each
@@ -283,6 +284,37 @@ static __always_inline void tile_release(void)
 	asm volatile(".byte 0xc4, 0xe2, 0x78, 0x49, 0xc0");
 }
 
+/**
+ * load_xmm_iwkey - Load a CPU-internal wrapping key
+ * @key:	A struct iwkey pointer.
+ *
+ * Load @key to XMMs then do LOADIWKEY. After this, flush XMM
+ * registers. Caller is responsible for kernel_fpu_begin().
+ */
+static inline void load_xmm_iwkey(struct iwkey *key)
+{
+	struct reg_128_bit zeros = { 0 };
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %1, %%xmm1; movdqu %2, %%xmm2;"
+		      :: "m"(key->integrity_key), "m"(key->encryption_key[0]),
+			 "m"(key->encryption_key[1]));
+
+	/*
+	 * LOADIWKEY %xmm1,%xmm2
+	 *
+	 * EAX and XMM0 are implicit operands. Load a key value
+	 * from XMM0-2 to a software-invisible CPU state. With zero
+	 * in EAX, CPU does not do hardware randomization and the key
+	 * backup is allowed.
+	 *
+	 * This instruction is supported by binutils >= 2.36.
+	 */
+	asm volatile (".byte 0xf3,0x0f,0x38,0xdc,0xd1" :: "a"(0));
+
+	asm volatile ("movdqu %0, %%xmm0; movdqu %0, %%xmm1; movdqu %0, %%xmm2;"
+		      :: "m"(zeros));
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_SPECIAL_INSNS_H */
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

