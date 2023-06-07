Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEA6BC7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 05:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686116170;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YIo8sxgF4QcGlzKepINnumUkDwczMSeqJiY+M8zlhlI=;
	b=CwJoLDosXkIZLIRA+x65iTgjbwIipVWNOlw6IqHDWdFEH4IkBfyDcMF+U8sg3nqeeoP3pf
	cWtoyF8qlAlxxTIjNXrZJwky4/SzjXLymiumkmsOXeLNo+P+hB0J5G1Z21sbatfIXwNUqh
	0pT//zPc2A9ZP1jxvZwdvAvAzaPx6IA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-yLa6Hh85Mx-tticMCUTJMQ-1; Wed, 07 Jun 2023 01:36:07 -0400
X-MC-Unique: yLa6Hh85Mx-tticMCUTJMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3D57858EEB;
	Wed,  7 Jun 2023 05:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D01D6C16046;
	Wed,  7 Jun 2023 05:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 908E519459F1;
	Wed,  7 Jun 2023 05:36:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 967E719465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 05:36:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 79FC31121315; Wed,  7 Jun 2023 05:36:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 733FF1121314
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 05:36:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57D02101A52C
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 05:36:04 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-eIu0q3DYMMeByEUj3RpAcQ-1; Wed, 07 Jun 2023 01:36:02 -0400
X-MC-Unique: eIu0q3DYMMeByEUj3RpAcQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id DD0A963AA3;
 Wed,  7 Jun 2023 05:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35C1C433EF;
 Wed,  7 Jun 2023 05:36:00 +0000 (UTC)
Date: Tue, 6 Jun 2023 22:35:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <20230607053558.GC941@sol.localdomain>
References: <20230524165717.14062-1-chang.seok.bae@intel.com>
 <20230603152227.12335-1-chang.seok.bae@intel.com>
 <20230603152227.12335-13-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230603152227.12335-13-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v8 12/12] crypto: x86/aes-kl - Implement the
 AES-XTS algorithm
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
Cc: x86@kernel.org, herbert@gondor.apana.org.au,
 "David S. Miller" <davem@davemloft.net>, ardb@kernel.org,
 dave.hansen@linux.intel.com, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org, charishma1.gairuboyina@intel.com,
 mingo@kernel.org, lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 Ingo Molnar <mingo@redhat.com>, bp@alien8.de, linux-crypto@vger.kernel.org,
 luto@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com,
 tglx@linutronix.de, nhuck@google.com, gmazyland@gmail.com, elliott@hpe.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jun 03, 2023 at 08:22:27AM -0700, Chang S. Bae wrote:
> == Key Handle Restriction ==
> 
> A key handle may be encoded with some restrictions.

It's unclear what this means.  Please avoid passive tense and the word "may"
like this.  I think you mean something like "The AES-KL instruction set supports
selecting key usage restrictions at key handle creation time."

> Restrict every handle only available in kernel mode via setkey().

I think you mean something like "Restrict all key handles created by the kernel
to kernel mode use only."

Can you also mention why you are doing this?  I suppose it might as well be
done, but I'm not seeing how it would actually matter.

What other sorts of key usage restrictions does AES-KL support?  Are any other
ones useful here?

> Subsequently the key handle could be corrupted or fail with handle
> restrictions. Then, encrypt()/decrypt() returns -EINVAL.

Aren't these scenarios actually impossible?  At least without memory corruption.

> == Userspace Exposition ==
> 
> Some hardware implementations may have some performance penalties.

Likewise, please avoid vague statements like this.  This makes it unclear
whether this is something that happens in the real world or whether it's just
theoretical.  You indeed have actual benchmark results that show that AES-KL is
much slower than AES-NI on current CPUs, right?

> But, for disk encryption, storage bandwidth may be the bottleneck before
> encryption bandwidth.

Again, please try to be less vague.  E.g. "With a slow storage device, storage
bandwidth is the bottleneck, even if disk encryption is enabled..."

> Thus, advertise it with a unique name 'xts-aes-aeskl' in /proc/crypto while
> not replacing AES-NI under the generic name 'xts(aes)' with a lower priority.

The above sentence seems to say that xts-aes-aeskl does *not* have a lower
priority than xts-aes-aesni.  But actually it does.

> Then, the performance is unlikely better than 64-bit which has already a gap
> vs. AES-NI.

I don't understand what this sentence is trying to say.

> diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
> index 9bbfd01cfa2f..658adfd7aebf 100644
> --- a/arch/x86/crypto/Kconfig
> +++ b/arch/x86/crypto/Kconfig
> @@ -2,6 +2,11 @@
>  
>  menu "Accelerated Cryptographic Algorithms for CPU (x86)"
>  
> +config AS_HAS_KEYLOCKER
> +	def_bool $(as-instr,encodekey256 %eax$(comma)%eax)
> +	help
> +	  Supported by binutils >= 2.36 and LLVM integrated assembler >= V12

It looks like arch/x86/Kconfig.assembler would be a better place for this.

> diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
> new file mode 100644
> index 000000000000..61addc61dd4e
> --- /dev/null
> +++ b/arch/x86/crypto/aeskl-intel_asm.S
> @@ -0,0 +1,552 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Implement AES algorithm using AES Key Locker instructions.
> + *
> + * Most code is based from the AES-NI implementation, aesni-intel_asm.S
> + *
> + */
> +
> +#include <linux/linkage.h>
> +#include <linux/cfi_types.h>
> +#include <asm/errno.h>
> +#include <asm/inst.h>
> +#include <asm/frame.h>
> +#include "aes-helper_asm.S"
> +
> +.text
> +
> +#define STATE1	%xmm0
> +#define STATE2	%xmm1
> +#define STATE3	%xmm2
> +#define STATE4	%xmm3
> +#define STATE5	%xmm4
> +#define STATE6	%xmm5
> +#define STATE7	%xmm6
> +#define STATE8	%xmm7
> +#define STATE	STATE1
> +
> +#define IV	%xmm9
> +#define KEY	%xmm10
> +#define INC	%xmm13
> +
> +#define IN1	%xmm8
> +#define IN	IN1

Why do both IN1 and IN exist?  Shouldn't there just be IN?

> +
> +#define AREG	%rax

Shouldn't %rax just be hardcoded?

> +#define HANDLEP	%rdi

This should be called CTX, to match the function prototypes.

> +#define UKEYP	OUTP

This should be called IN_KEY, to match the function prototypes.

> +#define GF128MUL_MASK %xmm11
> +
> +/*
> + * int __aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsigned int key_len)
> + */
> +SYM_FUNC_START(__aeskl_setkey)
> +	FRAME_BEGIN
> +	movl %edx, 480(HANDLEP)
> +	movdqu (UKEYP), STATE1
> +	mov $1, %eax
> +	cmp $16, %dl
> +	je .Lsetkey_128
> +
> +	movdqu 0x10(UKEYP), STATE2
> +	encodekey256 %eax, %eax
> +	movdqu STATE4, 0x30(HANDLEP)
> +	jmp .Lsetkey_end
> +.Lsetkey_128:
> +	encodekey128 %eax, %eax
> +
> +.Lsetkey_end:
> +	movdqu STATE1, (HANDLEP)
> +	movdqu STATE2, 0x10(HANDLEP)
> +	movdqu STATE3, 0x20(HANDLEP)

The moves to the ctx should use movdqa, since it is aligned.

> +
> +	xor AREG, AREG
> +	FRAME_END
> +	RET
> +SYM_FUNC_END(__aeskl_setkey)

This function always returns 0, so it really should return void.

> +/*
> + * int __aeskl_enc(const void *ctx, u8 *dst, const u8 *src)
> + */
> +SYM_FUNC_START(__aeskl_enc)
> +	FRAME_BEGIN
> +	movdqu (INP), STATE
> +	movl 480(HANDLEP), KLEN
> +
> +	cmp $16, KLEN
> +	je .Lenc_128
> +	aesenc256kl (HANDLEP), STATE
> +	jz .Lenc_err
> +	jmp .Lenc_noerr
> +.Lenc_128:
> +	aesenc128kl (HANDLEP), STATE
> +	jz .Lenc_err
> +
> +.Lenc_noerr:
> +	xor AREG, AREG
> +	jmp .Lenc_end
> +.Lenc_err:
> +	mov $(-EINVAL), AREG
> +.Lenc_end:
> +	movdqu STATE, (OUTP)
> +	FRAME_END
> +	RET
> +SYM_FUNC_END(__aeskl_enc)

In the common case (successful AES-256 encryption) this is executing 'jmp'
twice.  I think the code should be rearranged to eliminate these jmps.

> +/*
> + * int __aeskl_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
> + *			   const u8 *src, unsigned int len, le128 *iv)
> + */
> +SYM_FUNC_START(__aeskl_xts_encrypt)

__aeskl_xts_encrypt() and __aeskl_xts_decrypt() are very similar.  To reduce
code duplication, can you consider generating them from a macro that takes an
argument that indicates whether it is encrypt or decrypt?

> +static int aeskl_setkey(struct crypto_tfm *tfm, void *raw_ctx, const u8 *in_key,
> +			unsigned int keylen)
> +{
> +	struct crypto_aes_ctx *ctx = (struct crypto_aes_ctx *)raw_ctx;
> +	int err;
> +
> +	if (!crypto_simd_usable())
> +		return -EBUSY;
> +
> +	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
> +	    keylen != AES_KEYSIZE_256)
> +		return -EINVAL;
> +
> +	kernel_fpu_begin();
> +	if (unlikely(keylen == AES_KEYSIZE_192)) {
> +		pr_warn_once("AES-KL does not support 192-bit key. Use AES-NI.\n");
> +		err = aesni_set_key(ctx, in_key, keylen);
> +	} else {
> +		if (!valid_keylocker())
> +			err = -ENODEV;
> +		else
> +			err = __aeskl_setkey(ctx, in_key, keylen);
> +	}
> +	kernel_fpu_end();
> +
> +	return err;
> +}
[...]
> +			.cra_ctxsize		= XTS_AES_CTX_SIZE,
[...]

Something that your AES-KL code does that's a bit ugly is that it abuses
'struct crypto_aes_ctx' to store a Keylocker key handle instead
of the actual AES key schedule which the struct is supposed to be for.

The proper way to represent that would be to make the tfm context for
xts-aes-aeskl be a union of crypto_aes_ctx and a Keylocker specific context.

If you don't do that and instead keep the proposed workaround, then please add a
comment somewhere that very clearly explains how the struct is being used.
Above aeskl_setkey() or above .cra_ctxsize might be a good place.

> diff --git a/arch/x86/crypto/aesni-intel_glue.h b/arch/x86/crypto/aesni-intel_glue.h
> new file mode 100644
> index 000000000000..5b1919f49efe
> --- /dev/null
> +++ b/arch/x86/crypto/aesni-intel_glue.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/*
> + * Support for Intel AES-NI instructions. This file contains function
> + * prototypes to be referenced for other AES implementations
> + */

It would be helpful if this comment was more concrete, like "These are AES-NI
functions that are used by the AES-KL code as a fallback when it is given a
192-bit key.  Key Locker does not support 192-bit keys."

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

