Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8F8C77B7C
	for <dm-devel@archiver.kernel.org>; Sat,  6 May 2023 00:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683331321;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HgWD5Z01V4GjS6d0bTl1vSxDrE4QVPJnnNO1d0uod6g=;
	b=CJgGf+EKfspKE8eB88LIWeTjrzTxqEvZT/cYitbrDnDEb+fflIO4or/VhOvADLoZRSdQuw
	P6ZIUQuf/lwSgBJOv7sxyIC/EKcWtwopEl9NCcBS74G/JIxgrQhUZVhU1fncGrg773jY6r
	vJVNQ8cXBOhfi+CXrQcFDaW4IA+L7jc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-KZ3YlSBgPQ65C3KqyoWL-g-1; Fri, 05 May 2023 20:01:58 -0400
X-MC-Unique: KZ3YlSBgPQ65C3KqyoWL-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C46F85A588;
	Sat,  6 May 2023 00:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3A45140C2063;
	Sat,  6 May 2023 00:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E1FD1946A48;
	Sat,  6 May 2023 00:01:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 397F11946A43
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 May 2023 00:01:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 298011121339; Sat,  6 May 2023 00:01:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22B301121331
 for <dm-devel@redhat.com>; Sat,  6 May 2023 00:01:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08E481006849
 for <dm-devel@redhat.com>; Sat,  6 May 2023 00:01:55 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-SjrWwrldNDmx-t-vkzj1Aw-1; Fri, 05 May 2023 20:01:51 -0400
X-MC-Unique: SjrWwrldNDmx-t-vkzj1Aw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 04D7D615DD;
 Sat,  6 May 2023 00:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4BEC433D2;
 Sat,  6 May 2023 00:01:48 +0000 (UTC)
Date: Sat, 6 May 2023 00:01:47 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
Message-ID: <ZFWY6/VelArVYy1F@gmail.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
 <20230410225936.8940-12-chang.seok.bae@intel.com>
MIME-Version: 1.0
In-Reply-To: <20230410225936.8940-12-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v6 11/12] crypto: x86/aes-kl - Support AES
 algorithm using Key Locker instructions
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
Cc: Tom Rix <trix@redhat.com>, dave.hansen@linux.intel.com,
 lalithambika.krishnakumar@intel.com, dm-devel@redhat.com,
 "H. Peter Anvin" <hpa@zytor.com>, ardb@kernel.org, herbert@gondor.apana.org.au,
 x86@kernel.org, mingo@kernel.org, Ingo Molnar <mingo@redhat.com>, bp@suse.de,
 gmazyland@gmail.com, Nathan Chancellor <nathan@kernel.org>,
 Borislav Petkov <bp@alien8.de>, luto@kernel.org, dan.j.williams@intel.com,
 charishma1.gairuboyina@intel.com, Nick Desaulniers <ndesaulniers@google.com>,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, linux-crypto@vger.kernel.org,
 bernie.keany@intel.com, "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 10, 2023 at 03:59:35PM -0700, Chang S. Bae wrote:
> [PATCH v6 11/12] crypto: x86/aes-kl - Support AES algorithm using Key Locker instructions

Thanks for dropping the unnecessary modes of operation (CBC, ECB, CTR).  It
simplified the patchset quite a bit!

Now that only AES-XTS is included, can you please also merge this patch with the
following patch?  As-is, this patch is misleading since it doesn't actually add
"support" for anything at all.  It actually just adds an unfinished AES-XTS
implementation, which patch 12 then finishes.  I assume that the current
patchset organization is left over from when you were trying to support multiple
modes of operation.  IMO, it would be much easier to review if patches 11-12
were merged into one patch that adds the new AES-XTS implementation.

> For disk encryption, storage bandwidth may be the bottleneck
> before encryption bandwidth, but the potential performance difference is
> why AES-KL is advertised as a distinct cipher in /proc/crypto rather than
> the kernel transparently replacing AES-NI usage with AES-KL.

This does not correctly describe what is going on.  Actually, this patchset
registers the AES-KL XTS algorithm with the usual name "xts(aes)".  So, it can
potentially be used by any AES-XTS user.  It seems that you're actually relying
on the algorithm priorities to prioritize AES-NI, as you've assigned priority
200 to AES-KL, whereas AES-NI has priority 401.  Is that what you intend, and if
so can you please update your explanation to properly explain this?

The alternative would be to use a unique algorithm name, such as
"keylocker-xts(aes)".  I'm not sure that would be better, given that the
algorithms are compatible.  However, that actually would seem to match the
explanation you gave more closely, so perhaps that's what you actually intended?

> diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
[...]
> +#ifdef __x86_64__
> +#define AREG	%rax
> +#define HANDLEP	%rdi
> +#define OUTP	%rsi
> +#define KLEN	%r9d
> +#define INP	%rdx
> +#define T1	%r10
> +#define LEN	%rcx
> +#define IVP	%r8
> +#else
> +#define AREG	%eax
> +#define HANDLEP	%edi
> +#define OUTP	AREG
> +#define KLEN	%ebx
> +#define INP	%edx
> +#define T1	%ecx
> +#define LEN	%esi
> +#define IVP	%ebp
> +#endif

I strongly recommend skipping the 32-bit support, as it's unlikely to be worth
the effort.

And actually, aeskl-intel_glue.c only registers the algorithm for 64-bit
anyway...  So the 32-bit code paths are untested dead code.

> +static inline int aeskl_enc(const void *ctx, u8 *out, const u8 *in)
> +{
> +	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
> +		return -EINVAL;
> +	else if (!valid_keylocker())
> +		return -ENODEV;
> +	else if (_aeskl_enc(ctx, out, in))
> +		return -EINVAL;
> +	else
> +		return 0;
> +}
> +
> +static inline int aeskl_dec(const void *ctx, u8 *out, const u8 *in)
> +{
> +	if (unlikely(keylength(ctx) == AES_KEYSIZE_192))
> +		return -EINVAL;
> +	else if (!valid_keylocker())
> +		return -ENODEV;
> +	else if (_aeskl_dec(ctx, out, in))
> +		return -EINVAL;
> +	else
> +		return 0;
> +}

I don't think the above two functions should exist.  keylength() and
valid_keylocker() should be checked before calling xts_crypt_common(), and the
assembly functions should just return the correct error code (-EINVAL,
apparently) instead of an unspecified nonzero value.  That would leave nothing
for a wrapper function to do.

Note: if you take this suggestion, the assembly functions would need to use
SYM_TYPED_FUNC_START instead of SYM_FUNC_START.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

