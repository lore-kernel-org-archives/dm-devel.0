Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DDACC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jan 2022 08:09:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-mONLgj5jOZWMg4kv3JLBng-1; Thu, 13 Jan 2022 03:09:08 -0500
X-MC-Unique: mONLgj5jOZWMg4kv3JLBng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E73A11006AAE;
	Thu, 13 Jan 2022 08:09:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C48D61F2F1;
	Thu, 13 Jan 2022 08:09:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8F6EC1806D1C;
	Thu, 13 Jan 2022 08:09:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20CLKjTA016089 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 Jan 2022 16:20:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D8BE8C15E73; Wed, 12 Jan 2022 21:20:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D455EC15E6F
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B724685A5BA
	for <dm-devel@redhat.com>; Wed, 12 Jan 2022 21:20:45 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-82-p5BJ6yYuP9KBnLX3-pGC1w-7; Wed, 12 Jan 2022 16:20:44 -0500
X-MC-Unique: p5BJ6yYuP9KBnLX3-pGC1w-7
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="244060330"
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="244060330"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	12 Jan 2022 13:20:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,284,1635231600"; d="scan'208";a="529378294"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
	by orsmga008.jf.intel.com with ESMTP; 12 Jan 2022 13:20:42 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
	herbert@gondor.apana.org.au, ebiggers@kernel.org, ardb@kernel.org,
	x86@kernel.org, luto@kernel.org, tglx@linutronix.de, bp@suse.de,
	dave.hansen@linux.intel.com, mingo@kernel.org
Date: Wed, 12 Jan 2022 13:12:57 -0800
Message-Id: <20220112211258.21115-12-chang.seok.bae@intel.com>
In-Reply-To: <20220112211258.21115-1-chang.seok.bae@intel.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 13 Jan 2022 03:08:37 -0500
Cc: ravi.v.shankar@intel.com, chang.seok.bae@intel.com,
	linux-kernel@vger.kernel.org, kumar.n.dwarakanath@intel.com,
	dan.j.williams@intel.com, charishma1.gairuboyina@intel.com
Subject: [dm-devel] [PATCH v5 11/12] crypto: x86/aes-kl - Support AES
	algorithm using Key Locker instructions
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Key Locker is a CPU feature to reduce key exfiltration opportunities while
maintaining a programming interface similar to AES-NI. It converts the AES
key into an encoded form, called the 'key handle'.

The key handle is a wrapped version of the clear-text key where the
wrapping key has limited exposure. Once converted via setkey(), all
subsequent data encryption using new AES instructions ('AES-KL') uses this
key handle, reducing the exposure of private key material in memory.

AES-KL is analogous to that of AES-NI. Most assembly code is translated
from the AES-NI code. They are operational in both 32-bit and 64-bit modes
like AES-NI. However, users need to be aware of the following differences:

== Key Handle ==

AES-KL may fail with an invalid key handle. It could be corrupted or fail
with handle restriction. A key handle may be encoded with some
restrictions. The implementation restricts every handle only available
in kernel mode via setkey().

=== AES Compliance ===

Key Locker is not AES compliant in that it lacks support for 192-bit keys.
However, per the expectations of Linux crypto-cipher implementations the
software cipher implementation must support all the AES compliant
key-sizes. The AES-KL cipher implementation achieves this constraint by
logging a warning and falling back to AES-NI. In other words the 192-bit
key-size limitation for what can be converted into a Key Locker key-handle
is only documented, not enforced. This along with the below performance and
failure mode implications is an end-user consideration for selecting AES-KL
vs AES-NI.

== API Limitation ==

The setkey() function transforms an AES key to a handle. An extended key is
a usual outcome of setkey() in other AES cipher implementations. For this
reason, a setkey() failure does not fall back to the other. So, AES-KL will
be exposed via synchronous interfaces only.

== Wrapping-key Restore Failure ==

The setkey() failure is also possible with the wrapping-key restore
failure. In an event of hardware failure, the wrapping key is lost from
deep sleep states. Then, setkey() will fail with the ENODEV error. And the
suspended data transforming task may resume but will fail due to the
wrapping key change.

== Performance ==

This feature comes with some performance penalties vs AES-NI. The
cryptsetup benchmark indicates Key Locker raw throughput can be  ~5x slower
than AES-NI. For disk encryption, storage bandwidth may be the bottleneck
before encryption bandwidth, but the potential performance difference is
why AES-KL is advertised as a distinct cipher in /proc/crypto rather than
the kernel transparently replacing AES-NI usage with AES-KL.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: x86@kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v3:
* Exclude non-AES-KL objects. (Eric Biggers)
* Simplify the assembler dependency check. (Peter Zijlstra)
* Trim the Kconfig help text. (Dan Williams)
* Fix a defined-but-not-used warning.

Changes from RFC v2:
* Move out each mode support in new patches.
* Update the changelog to describe the limitation and the tradeoff
  clearly. (Andy Lutomirski)

Changes from RFC v1:
* Rebased on the refactored code. (Ard Biesheuvel)
* Dropped exporting the single block interface. (Ard Biesheuvel)
* Fixed the fallback and error handling paths. (Ard Biesheuvel)
* Revised the module description. (Dave Hansen and Peter Zijlsta)
* Made the build depend on the binutils version to support new
  instructions. (Borislav Petkov and Peter Zijlstra)
* Updated the changelog accordingly.
Link: https://lore.kernel.org/lkml/CAMj1kXGa4f21eH0mdxd1pQsZMUjUr1Btq+Dgw-gC=O-yYft7xw@mail.gmail.com/
---
 arch/x86/crypto/Makefile           |   3 +
 arch/x86/crypto/aeskl-intel_asm.S  | 184 +++++++++++++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c | 115 ++++++++++++++++++
 crypto/Kconfig                     |  36 ++++++
 4 files changed, 338 insertions(+)
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ef6c0b9f69c6..3a64779af974 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -50,6 +50,9 @@ obj-$(CONFIG_CRYPTO_AES_NI_INTEL) += aesni-intel.o
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o aes-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 
+obj-$(CONFIG_CRYPTO_AES_KL) += aeskl-intel.o
+aeskl-intel-y := aeskl-intel_asm.o aeskl-intel_glue.o
+
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
 sha1-ssse3-$(CONFIG_AS_SHA1_NI) += sha1_ni_asm.o
diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
new file mode 100644
index 000000000000..d56ec8dd6644
--- /dev/null
+++ b/arch/x86/crypto/aeskl-intel_asm.S
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Implement AES algorithm using Intel AES Key Locker instructions.
+ *
+ * Most code is based from the AES-NI implementation, aesni-intel_asm.S
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+#include <asm/frame.h>
+#include "aes-intel_asm.S"
+
+.text
+
+#define STATE1	%xmm0
+#define STATE2	%xmm1
+#define STATE3	%xmm2
+#define STATE4	%xmm3
+#define STATE5	%xmm4
+#define STATE6	%xmm5
+#define STATE7	%xmm6
+#define STATE8	%xmm7
+#define STATE	STATE1
+
+#define IV	%xmm9
+#define KEY	%xmm10
+#define BSWAP_MASK %xmm11
+#define CTR	%xmm12
+#define INC	%xmm13
+
+#ifdef __x86_64__
+#define IN1	%xmm8
+#define IN2	%xmm9
+#define IN3	%xmm10
+#define IN4	%xmm11
+#define IN5	%xmm12
+#define IN6	%xmm13
+#define IN7	%xmm14
+#define IN8	%xmm15
+#define IN	IN1
+#define TCTR_LOW %r11
+#else
+#define IN	%xmm1
+#endif
+
+#ifdef __x86_64__
+#define AREG	%rax
+#define HANDLEP	%rdi
+#define OUTP	%rsi
+#define KLEN	%r9d
+#define INP	%rdx
+#define T1	%r10
+#define LEN	%rcx
+#define IVP	%r8
+#else
+#define AREG	%eax
+#define HANDLEP	%edi
+#define OUTP	AREG
+#define KLEN	%ebx
+#define INP	%edx
+#define T1	%ecx
+#define LEN	%esi
+#define IVP	%ebp
+#endif
+
+#define UKEYP	OUTP
+#define GF128MUL_MASK %xmm11
+
+/*
+ * int aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_len)
+ */
+SYM_FUNC_START(aeskl_setkey)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	push HANDLEP
+	movl (FRAME_OFFSET+8)(%esp),  HANDLEP	# ctx
+	movl (FRAME_OFFSET+12)(%esp), UKEYP	# in_key
+	movl (FRAME_OFFSET+16)(%esp), %edx	# key_len
+#endif
+	movl %edx, 480(HANDLEP)
+	movdqu (UKEYP), STATE1
+	mov $1, %eax
+	cmp $16, %dl
+	je .Lsetkey_128
+
+	movdqu 0x10(UKEYP), STATE2
+	encodekey256 %eax, %eax
+	movdqu STATE4, 0x30(HANDLEP)
+	jmp .Lsetkey_end
+.Lsetkey_128:
+	encodekey128 %eax, %eax
+
+.Lsetkey_end:
+	movdqu STATE1, (HANDLEP)
+	movdqu STATE2, 0x10(HANDLEP)
+	movdqu STATE3, 0x20(HANDLEP)
+
+	xor AREG, AREG
+#ifndef __x86_64__
+	popl HANDLEP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(aeskl_setkey)
+
+/*
+ * int _aeskl_enc(const void *ctx, u8 *dst, const u8 *src)
+ */
+SYM_FUNC_START(_aeskl_enc)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+12)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+16)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+20)(%esp), INP	# src
+#endif
+	movdqu (INP), STATE
+	movl 480(HANDLEP), KLEN
+
+	cmp $16, KLEN
+	je .Lenc_128
+	aesenc256kl (HANDLEP), STATE
+	jz .Lenc_err
+	jmp .Lenc_noerr
+.Lenc_128:
+	aesenc128kl (HANDLEP), STATE
+	jz .Lenc_err
+
+.Lenc_noerr:
+	xor AREG, AREG
+	jmp .Lenc_end
+.Lenc_err:
+	mov $1, AREG
+.Lenc_end:
+	movdqu STATE, (OUTP)
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(_aeskl_enc)
+
+/*
+ * int _aeskl_dec(const void *ctx, u8 *dst, const u8 *src)
+ */
+SYM_FUNC_START(_aeskl_dec)
+	FRAME_BEGIN
+#ifndef __x86_64__
+	pushl HANDLEP
+	pushl KLEN
+	movl (FRAME_OFFSET+12)(%esp), HANDLEP	# ctx
+	movl (FRAME_OFFSET+16)(%esp), OUTP	# dst
+	movl (FRAME_OFFSET+20)(%esp), INP	# src
+#endif
+	movdqu (INP), STATE
+	mov 480(HANDLEP), KLEN
+
+	cmp $16, KLEN
+	je .Ldec_128
+	aesdec256kl (HANDLEP), STATE
+	jz .Ldec_err
+	jmp .Ldec_noerr
+.Ldec_128:
+	aesdec128kl (HANDLEP), STATE
+	jz .Ldec_err
+
+.Ldec_noerr:
+	xor AREG, AREG
+	jmp .Ldec_end
+.Ldec_err:
+	mov $1, AREG
+.Ldec_end:
+	movdqu STATE, (OUTP)
+#ifndef __x86_64__
+	popl KLEN
+	popl HANDLEP
+#endif
+	FRAME_END
+	ret
+SYM_FUNC_END(_aeskl_dec)
+
diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
new file mode 100644
index 000000000000..0062baaaf7b2
--- /dev/null
+++ b/arch/x86/crypto/aeskl-intel_glue.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Support for AES Key Locker instructions. This file contains glue
+ * code and the real AES implementation is in aeskl-intel_asm.S.
+ *
+ * Most code is based on AES-NI glue code, aesni-intel_glue.c
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/xts.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/internal/simd.h>
+#include <asm/simd.h>
+#include <asm/cpu_device_id.h>
+#include <asm/fpu/api.h>
+#include <asm/keylocker.h>
+
+#include "aes-intel_glue.h"
+#include "aesni-intel_glue.h"
+
+asmlinkage int aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_len);
+
+asmlinkage int _aeskl_enc(const void *ctx, u8 *out, const u8 *in);
+asmlinkage int _aeskl_dec(const void *ctx, u8 *out, const u8 *in);
+
+static int __maybe_unused aeskl_setkey_common(struct crypto_tfm *tfm, void *raw_ctx,
+					      const u8 *in_key, unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
+	int err;
+
+	if (!crypto_simd_usable())
+		return -EBUSY;
+
+	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
+	    key_len != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	kernel_fpu_begin();
+	if (unlikely(key_len == AES_KEYSIZE_192)) {
+		pr_warn_once("AES-KL does not support 192-bit key. Use AES-NI.\n");
+		err = aesni_set_key(ctx, in_key, key_len);
+	} else {
+		if (!valid_keylocker())
+			err = -ENODEV;
+		else
+			err = aeskl_setkey(ctx, in_key, key_len);
+	}
+	kernel_fpu_end();
+
+	return err;
+}
+
+static inline u32 keylength(const void *raw_ctx)
+{
+	struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
+
+	return ctx->key_length;
+}
+
+static inline int aeskl_enc(const void *ctx, u8 *out, const u8 *in)
+{
+	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_enc(ctx, out, in))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static inline int aeskl_dec(const void *ctx, u8 *out, const u8 *in)
+{
+	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_dec(ctx, out, in))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int __init aeskl_init(void)
+{
+	if (!valid_keylocker())
+		return -ENODEV;
+
+	/*
+	 * AES-KL itself does not depend on AES-NI. But AES-KL does not
+	 * support 192-bit keys. To make itself AES-compliant, it falls
+	 * back to AES-NI.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_AES))
+		return -ENODEV;
+
+	return 0;
+}
+
+static void __exit aeskl_exit(void)
+{
+	return;
+}
+
+late_initcall(aeskl_init);
+module_exit(aeskl_exit);
+
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, AES Key Locker implementation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("aes");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 285f82647d2b..b8b5d0353f58 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1113,6 +1113,42 @@ config CRYPTO_AES_NI_INTEL
 	  ECB, CBC, LRW, XTS. The 64 bit version has additional
 	  acceleration for CTR.
 
+config AS_HAS_KEYLOCKER
+	def_bool $(as-instr,encodekey256 %eax$(comma)%eax)
+	help
+	  Supported by binutils >= 2.36 and LLVM integrated assembler >= V12
+
+config CRYPTO_AES_KL
+	tristate "AES cipher algorithms (AES-KL)"
+	depends on AS_HAS_KEYLOCKER
+	depends on CRYPTO_AES_NI_INTEL
+	select X86_KEYLOCKER
+
+	help
+	  Key Locker provides AES SIMD instructions (AES-KL) for secure
+	  data encryption and decryption. While this new instruction
+	  set is analogous to AES-NI, AES-KL supports to encode an AES
+	  key to an encoded form ('key handle') and uses it to transform
+	  data instead of accessing the AES key.
+
+	  The setkey() transforms an AES key to a key handle, then the AES
+	  key is no longer needed for data transformation. A user may
+	  displace their keys from possible exposition.
+
+	  This key encryption is done by the CPU-internal wrapping key.
+	  This wrapping key support is provided with X86_KEYLOCKER.
+
+	  AES-KL supports 128-/256-bit keys only. While giving a 192-bit
+	  key does not return an error, as the AES-NI driver is chosen to
+	  process it, the claimed security property is not available with
+	  that.
+
+	  Bare metal disk encryption is the preferred use case. Key Locker
+	  usage requires explicit opt-in at setup time. So select it if
+	  unsure.
+
+	  See Documentation/x86/keylocker.rst for more details.
+
 config CRYPTO_AES_SPARC64
 	tristate "AES cipher algorithms (SPARC64)"
 	depends on SPARC64
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

