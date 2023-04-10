Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A88DC7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 06:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681195467;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NJY2m89r1E1XCbTyPfAFvrQF64tPM+u/e1BCWouRQRc=;
	b=eapwn9Wi2fy3AYlf86M3WivPdD5tkN8zAswxgKNO04zztpNtMfUMOYjmSKfBXD4CKEs4OO
	JZekT+E00nQow1Bn5ks4Anprb+o/TeT2sTYGUAdp0TnHSqOpF8pUkk2T0G2IlsjiO26hSw
	kx6scN1kPU4KbDCGvzv/0BWFkZ9y4tQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-OMIyzDFvP_OSXmWCTBVloA-1; Tue, 11 Apr 2023 02:44:24 -0400
X-MC-Unique: OMIyzDFvP_OSXmWCTBVloA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0F7185C080;
	Tue, 11 Apr 2023 06:44:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA577202701E;
	Tue, 11 Apr 2023 06:44:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4557B19472D6;
	Tue, 11 Apr 2023 06:44:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 35C211946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Apr 2023 23:12:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2648A14171BF; Mon, 10 Apr 2023 23:12:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E70514171B7
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 23:12:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F35AF811E7C
 for <dm-devel@redhat.com>; Mon, 10 Apr 2023 23:12:50 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-AZ10c6u9MemPlRAZKrZUYw-2; Mon, 10 Apr 2023 19:12:47 -0400
X-MC-Unique: AZ10c6u9MemPlRAZKrZUYw-2
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="340962617"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; d="scan'208";a="340962617"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
 by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 10 Apr 2023 16:11:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="757608024"
X-IronPort-AV: E=Sophos;i="5.98,335,1673942400"; d="scan'208";a="757608024"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
 by fmsmga004.fm.intel.com with ESMTP; 10 Apr 2023 16:11:42 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dm-devel@redhat.com
Date: Mon, 10 Apr 2023 15:59:36 -0700
Message-Id: <20230410225936.8940-13-chang.seok.bae@intel.com>
In-Reply-To: <20230410225936.8940-1-chang.seok.bae@intel.com>
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20230410225936.8940-1-chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 11 Apr 2023 06:44:09 +0000
Subject: [dm-devel] [PATCH v6 12/12] crypto: x86/aes-kl - Support XTS mode
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
 chang.seok.bae@intel.com, dave.hansen@linux.intel.com,
 dan.j.williams@intel.com, mingo@kernel.org, ebiggers@kernel.org,
 lalithambika.krishnakumar@intel.com, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, luto@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, bernie.keany@intel.com, tglx@linutronix.de,
 bp@suse.de, gmazyland@gmail.com, charishma1.gairuboyina@intel.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: intel.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Implement XTS mode using AES-KL. Export the methods with a lower priority
than AES-NI to avoid from selected by default.

The assembly code clobbers more than eight 128-bit registers to make use of
performant wide instructions that process eight 128-bit blocks at once.
But that many 128-bit registers are not available in 32-bit mode, so
support 64-bit mode only.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
Changes from v5:
* Replace the ret instruction with RET as rebased on the upstream -- commit
  f94909ceb1ed ("x86: Prepare asm files for straight-line-speculation").

Changes from RFC v2:
* Separate out the code as a new patch.
---
 arch/x86/crypto/aeskl-intel_asm.S  | 449 +++++++++++++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c | 107 ++++++-
 2 files changed, 553 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/aeskl-intel_asm.S b/arch/x86/crypto/aeskl-intel_asm.S
index 17c7b306a766..05134327bcb2 100644
--- a/arch/x86/crypto/aeskl-intel_asm.S
+++ b/arch/x86/crypto/aeskl-intel_asm.S
@@ -182,3 +182,452 @@ SYM_FUNC_START(_aeskl_dec)
 	RET
 SYM_FUNC_END(_aeskl_dec)
 
+#ifdef __x86_64__
+
+/*
+ * XTS implementation
+ */
+
+/*
+ * _aeskl_gf128mul_x_ble: 	internal ABI
+ *	Multiply in GF(2^128) for XTS IVs
+ * input:
+ *	IV:	current IV
+ *	GF128MUL_MASK == mask with 0x87 and 0x01
+ * output:
+ *	IV:	next IV
+ * changed:
+ *	CTR:	== temporary value
+ */
+#define _aeskl_gf128mul_x_ble() \
+	pshufd $0x13, IV, KEY; \
+	paddq IV, IV; \
+	psrad $31, KEY; \
+	pand GF128MUL_MASK, KEY; \
+	pxor KEY, IV;
+
+/*
+ * int _aeskl_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
+ */
+SYM_FUNC_START(_aeskl_xts_encrypt)
+	FRAME_BEGIN
+	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(HANDLEP), KLEN
+
+.Lxts_enc8:
+	sub $128, LEN
+	jl .Lxts_enc1_pre
+
+	movdqa IV, STATE1
+	movdqu (INP), INC
+	pxor INC, STATE1
+	movdqu IV, (OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
+	movdqu IV, 0x10(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
+	movdqu IV, 0x20(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
+	movdqu IV, 0x30(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE5
+	movdqu 0x40(INP), INC
+	pxor INC, STATE5
+	movdqu IV, 0x40(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE6
+	movdqu 0x50(INP), INC
+	pxor INC, STATE6
+	movdqu IV, 0x50(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE7
+	movdqu 0x60(INP), INC
+	pxor INC, STATE7
+	movdqu IV, 0x60(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE8
+	movdqu 0x70(INP), INC
+	pxor INC, STATE8
+	movdqu IV, 0x70(OUTP)
+
+	cmp $16, KLEN
+	je .Lxts_enc8_128
+	aesencwide256kl (%rdi)
+	jz .Lxts_enc_ret_err
+	jmp .Lxts_enc8_end
+.Lxts_enc8_128:
+	aesencwide128kl (%rdi)
+	jz .Lxts_enc_ret_err
+
+.Lxts_enc8_end:
+	movdqu 0x00(OUTP), INC
+	pxor INC, STATE1
+	movdqu STATE1, 0x00(OUTP)
+
+	movdqu 0x10(OUTP), INC
+	pxor INC, STATE2
+	movdqu STATE2, 0x10(OUTP)
+
+	movdqu 0x20(OUTP), INC
+	pxor INC, STATE3
+	movdqu STATE3, 0x20(OUTP)
+
+	movdqu 0x30(OUTP), INC
+	pxor INC, STATE4
+	movdqu STATE4, 0x30(OUTP)
+
+	movdqu 0x40(OUTP), INC
+	pxor INC, STATE5
+	movdqu STATE5, 0x40(OUTP)
+
+	movdqu 0x50(OUTP), INC
+	pxor INC, STATE6
+	movdqu STATE6, 0x50(OUTP)
+
+	movdqu 0x60(OUTP), INC
+	pxor INC, STATE7
+	movdqu STATE7, 0x60(OUTP)
+
+	movdqu 0x70(OUTP), INC
+	pxor INC, STATE8
+	movdqu STATE8, 0x70(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+
+	add $128, INP
+	add $128, OUTP
+	test LEN, LEN
+	jnz .Lxts_enc8
+
+.Lxts_enc_ret_iv:
+	movups IV, (IVP)
+.Lxts_enc_ret_noerr:
+	xor AREG, AREG
+	jmp .Lxts_enc_ret
+.Lxts_enc_ret_err:
+	mov $1, AREG
+.Lxts_enc_ret:
+	FRAME_END
+	RET
+
+.Lxts_enc1_pre:
+	add $128, LEN
+	jz .Lxts_enc_ret_iv
+	sub $16, LEN
+	jl .Lxts_enc_cts4
+
+.Lxts_enc1:
+	movdqu (INP), STATE1
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_enc1_128
+	aesenc256kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+	jmp .Lxts_enc1_end
+.Lxts_enc1_128:
+	aesenc128kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+
+.Lxts_enc1_end:
+	pxor IV, STATE1
+	_aeskl_gf128mul_x_ble()
+
+	test LEN, LEN
+	jz .Lxts_enc1_out
+
+	add $16, INP
+	sub $16, LEN
+	jl .Lxts_enc_cts1
+
+	movdqu STATE1, (OUTP)
+	add $16, OUTP
+	jmp .Lxts_enc1
+
+.Lxts_enc1_out:
+	movdqu STATE1, (OUTP)
+	jmp .Lxts_enc_ret_iv
+
+.Lxts_enc_cts4:
+	movdqu STATE8, STATE1
+	sub $16, OUTP
+
+.Lxts_enc_cts1:
+	lea .Lcts_permute_table(%rip), T1
+	add LEN, INP		/* rewind input pointer */
+	add $16, LEN		/* # bytes in final block */
+	movups (INP), IN1
+
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	add OUTP, LEN
+
+	movups (T1), STATE2
+	movaps STATE1, STATE3
+	pshufb STATE2, STATE1
+	movups STATE1, (LEN)
+
+	movups (IVP), STATE1
+	pshufb STATE1, IN1
+	pblendvb STATE3, IN1
+	movaps IN1, STATE1
+
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_enc1_cts_128
+	aesenc256kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+	jmp .Lxts_enc1_cts_end
+.Lxts_enc1_cts_128:
+	aesenc128kl (HANDLEP), STATE1
+	jz .Lxts_enc_ret_err
+
+.Lxts_enc1_cts_end:
+	pxor IV, STATE1
+	movups STATE1, (OUTP)
+	jmp .Lxts_enc_ret_noerr
+SYM_FUNC_END(_aeskl_xts_encrypt)
+
+/*
+ * int _aeskl_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			  const u8 *src, unsigned int len, le128 *iv)
+ */
+SYM_FUNC_START(_aeskl_xts_decrypt)
+	FRAME_BEGIN
+	movdqa .Lgf128mul_x_ble_mask(%rip), GF128MUL_MASK
+	movups (IVP), IV
+
+	mov 480(HANDLEP), KLEN
+
+	test $15, LEN
+	jz .Lxts_dec8
+	sub $16, LEN
+
+.Lxts_dec8:
+	sub $128, LEN
+	jl .Lxts_dec1_pre
+
+	movdqa IV, STATE1
+	movdqu (INP), INC
+	pxor INC, STATE1
+	movdqu IV, (OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE2
+	movdqu 0x10(INP), INC
+	pxor INC, STATE2
+	movdqu IV, 0x10(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE3
+	movdqu 0x20(INP), INC
+	pxor INC, STATE3
+	movdqu IV, 0x20(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE4
+	movdqu 0x30(INP), INC
+	pxor INC, STATE4
+	movdqu IV, 0x30(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE5
+	movdqu 0x40(INP), INC
+	pxor INC, STATE5
+	movdqu IV, 0x40(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE6
+	movdqu 0x50(INP), INC
+	pxor INC, STATE6
+	movdqu IV, 0x50(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE7
+	movdqu 0x60(INP), INC
+	pxor INC, STATE7
+	movdqu IV, 0x60(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+	movdqa IV, STATE8
+	movdqu 0x70(INP), INC
+	pxor INC, STATE8
+	movdqu IV, 0x70(OUTP)
+
+	cmp $16, KLEN
+	je .Lxts_dec8_128
+	aesdecwide256kl (%rdi)
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec8_end
+.Lxts_dec8_128:
+	aesdecwide128kl (%rdi)
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec8_end:
+	movdqu 0x00(OUTP), INC
+	pxor INC, STATE1
+	movdqu STATE1, 0x00(OUTP)
+
+	movdqu 0x10(OUTP), INC
+	pxor INC, STATE2
+	movdqu STATE2, 0x10(OUTP)
+
+	movdqu 0x20(OUTP), INC
+	pxor INC, STATE3
+	movdqu STATE3, 0x20(OUTP)
+
+	movdqu 0x30(OUTP), INC
+	pxor INC, STATE4
+	movdqu STATE4, 0x30(OUTP)
+
+	movdqu 0x40(OUTP), INC
+	pxor INC, STATE5
+	movdqu STATE5, 0x40(OUTP)
+
+	movdqu 0x50(OUTP), INC
+	pxor INC, STATE6
+	movdqu STATE6, 0x50(OUTP)
+
+	movdqu 0x60(OUTP), INC
+	pxor INC, STATE7
+	movdqu STATE7, 0x60(OUTP)
+
+	movdqu 0x70(OUTP), INC
+	pxor INC, STATE8
+	movdqu STATE8, 0x70(OUTP)
+
+	_aeskl_gf128mul_x_ble()
+
+	add $128, INP
+	add $128, OUTP
+	test LEN, LEN
+	jnz .Lxts_dec8
+
+.Lxts_dec_ret_iv:
+	movups IV, (IVP)
+.Lxts_dec_ret_noerr:
+	xor AREG, AREG
+	jmp .Lxts_dec_ret
+.Lxts_dec_ret_err:
+	mov $1, AREG
+.Lxts_dec_ret:
+	FRAME_END
+	RET
+
+.Lxts_dec1_pre:
+	add $128, LEN
+	jz .Lxts_dec_ret_iv
+
+.Lxts_dec1:
+	movdqu (INP), STATE1
+
+	add $16, INP
+	sub $16, LEN
+	jl .Lxts_dec_cts1
+
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_dec1_128
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec1_end
+.Lxts_dec1_128:
+	aesdec128kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec1_end:
+	pxor IV, STATE1
+	_aeskl_gf128mul_x_ble()
+
+	test LEN, LEN
+	jz .Lxts_dec1_out
+
+	movdqu STATE1, (OUTP)
+	add $16, OUTP
+	jmp .Lxts_dec1
+
+.Lxts_dec1_out:
+	movdqu STATE1, (OUTP)
+	jmp .Lxts_dec_ret_iv
+
+.Lxts_dec_cts1:
+	movdqa IV, STATE5
+	_aeskl_gf128mul_x_ble()
+
+	pxor IV, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_dec1_cts_pre_128
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec1_cts_pre_end
+.Lxts_dec1_cts_pre_128:
+	aesdec128kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec1_cts_pre_end:
+	pxor IV, STATE1
+
+	lea .Lcts_permute_table(%rip), T1
+	add LEN, INP		/* rewind input pointer */
+	add $16, LEN		/* # bytes in final block */
+	movups (INP), IN1
+
+	mov T1, IVP
+	add $32, IVP
+	add LEN, T1
+	sub LEN, IVP
+	add OUTP, LEN
+
+	movups (T1), STATE2
+	movaps STATE1, STATE3
+	pshufb STATE2, STATE1
+	movups STATE1, (LEN)
+
+	movups (IVP), STATE1
+	pshufb STATE1, IN1
+	pblendvb STATE3, IN1
+	movaps IN1, STATE1
+
+	pxor STATE5, STATE1
+
+	cmp $16, KLEN
+	je .Lxts_dec1_cts_128
+	aesdec256kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+	jmp .Lxts_dec1_cts_end
+.Lxts_dec1_cts_128:
+	aesdec128kl (HANDLEP), STATE1
+	jz .Lxts_dec_ret_err
+
+.Lxts_dec1_cts_end:
+	pxor STATE5, STATE1
+
+	movups STATE1, (OUTP)
+	jmp .Lxts_dec_ret_noerr
+
+SYM_FUNC_END(_aeskl_xts_decrypt)
+
+#endif
diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
index 0062baaaf7b2..6616a2fc6f04 100644
--- a/arch/x86/crypto/aeskl-intel_glue.c
+++ b/arch/x86/crypto/aeskl-intel_glue.c
@@ -27,8 +27,15 @@ asmlinkage int aeskl_setkey(struct crypto_aes_ctx *ctx, const u8 *in_key, unsign
 asmlinkage int _aeskl_enc(const void *ctx, u8 *out, const u8 *in);
 asmlinkage int _aeskl_dec(const void *ctx, u8 *out, const u8 *in);
 
-static int __maybe_unused aeskl_setkey_common(struct crypto_tfm *tfm, void *raw_ctx,
-					      const u8 *in_key, unsigned int key_len)
+#ifdef CONFIG_X86_64
+asmlinkage int _aeskl_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				  unsigned int len, u8 *iv);
+asmlinkage int _aeskl_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				  unsigned int len, u8 *iv);
+#endif
+
+static int aeskl_setkey_common(struct crypto_tfm *tfm, void *raw_ctx, const u8 *in_key,
+			       unsigned int key_len)
 {
 	struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
 	int err;
@@ -86,11 +93,99 @@ static inline int aeskl_dec(const void *ctx, u8 *out, const u8 *in)
 		return 0;
 }
 
+#ifdef CONFIG_X86_64
+
+static inline int aeskl_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				    unsigned int len, u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_xts_encrypt(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static inline int aeskl_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in,
+				    unsigned int len, u8 *iv)
+{
+	if (unlikely(ctx->key_length == AES_KEYSIZE_192))
+		return -EINVAL;
+	else if (!valid_keylocker())
+		return -ENODEV;
+	else if (_aeskl_xts_decrypt(ctx, out, in, len, iv))
+		return -EINVAL;
+	else
+		return 0;
+}
+
+static int aeskl_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	return xts_setkey_common(tfm, key, keylen, aeskl_setkey_common);
+}
+
+static int xts_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return xts_crypt_common(req, aeskl_xts_encrypt, aeskl_enc);
+	else
+		return xts_crypt_common(req, aesni_xts_encrypt, aesni_enc);
+}
+
+static int xts_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (likely(keylength(crypto_skcipher_ctx(tfm)) != AES_KEYSIZE_192))
+		return xts_crypt_common(req, aeskl_xts_decrypt, aeskl_enc);
+	else
+		return xts_crypt_common(req, aesni_xts_decrypt, aesni_enc);
+}
+
+#endif /* CONFIG_X86_64 */
+
+static struct skcipher_alg aeskl_skciphers[] = {
+	{
+#ifdef CONFIG_X86_64
+		.base = {
+			.cra_name		= "__xts(aes)",
+			.cra_driver_name	= "__xts-aes-aeskl",
+			.cra_priority		= 200,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= XTS_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.walksize	= 2 * AES_BLOCK_SIZE,
+		.setkey		= aeskl_xts_setkey,
+		.encrypt	= xts_encrypt,
+		.decrypt	= xts_decrypt,
+#endif
+	}
+};
+
+static struct simd_skcipher_alg *aeskl_simd_skciphers[ARRAY_SIZE(aeskl_skciphers)];
+
 static int __init aeskl_init(void)
 {
+	u32 eax, ebx, ecx, edx;
+	int err;
+
 	if (!valid_keylocker())
 		return -ENODEV;
 
+	cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
+	if (!(ebx & KEYLOCKER_CPUID_EBX_WIDE))
+		return -ENODEV;
+
 	/*
 	 * AES-KL itself does not depend on AES-NI. But AES-KL does not
 	 * support 192-bit keys. To make itself AES-compliant, it falls
@@ -99,12 +194,18 @@ static int __init aeskl_init(void)
 	if (!boot_cpu_has(X86_FEATURE_AES))
 		return -ENODEV;
 
+	err = simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+					     aeskl_simd_skciphers);
+	if (err)
+		return err;
+
 	return 0;
 }
 
 static void __exit aeskl_exit(void)
 {
-	return;
+	simd_unregister_skciphers(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+				  aeskl_simd_skciphers);
 }
 
 late_initcall(aeskl_init);
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

