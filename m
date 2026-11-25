Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642015;
	b=QLtSVi2JKGJ74vOnhOVhabDtE06cZRpg0Pg8SaJ1SBuChw73ym25oDsvtronIa0vEnbW
	 xsAd9434BQtaexTxRin13MVOi8ihRw4n537MfgAsbVdCB8ehaZzXB2ZRAbIzumaAvmJRi
	 ra97S1qBcNplYVX2nL/hYSgh0bpbVfyvpZdao0jZZzAKYliBTpc0tk76Jv4Tj5eRMwyZU
	 TOVRYmckoNISMqR53t1+VXO/juBv0htz3/jOg7S/yo81Wn2aA4jzy0SXyscOfYPKLt6Yi
	 mWhzN4N4JDRY8ShzQZ8jer98ZPhf8hf/jTlEmyE1/z+JOkiYvtqbOppQXtiw/29SjWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642015;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=TvrU0wA9nQ8NmkHqlIbwXmklpSSQk+6g+lOk6duGUaY=;
	b=NHNvt49X5QPCLNA+fL8wiqXYlaE5PCHg78qC4NmKBgTL0PS2nM9HI70sg6FV0DZCEmCE
	 EN+0zkj6rpft8bhR99OsdojJ4y8Iiw05tbH3wFuvHZNkKtiPpsA/tAxuAP5ZumVf4+4eF
	 VtLt0Km2vLmXsOmc6tuYTrB1LRCCV++KhCHRN1n0PNnrbomFP/EcYFGbbhsLAV2LFdlpy
	 fh57AXgvxpEqWUODvY7uCo286r59N7DHzDJZK7/YBIR1KSwjNvLuCM3swFqPyv15I6hKy
	 R9GcggM+N/XN+rLEyaSzd98x5oNf900PoKCWul1zFShElRJumE6WSFzq2lVOU8jaj8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=csjkQ0oa;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39405606A337
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 21:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39405606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=csjkQ0oa
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso59291985e9.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 13:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642012; x=1796246812; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TvrU0wA9nQ8NmkHqlIbwXmklpSSQk+6g+lOk6duGUaY=;
        b=csjkQ0oaBQM5f4ur496yEc4fdbdHP0HVv6WS+Et7EUb2sR3SasjiRdtHEjk21PcQnz
         BE1bxODz5UX5M8PrEqHgADVtGmLgCdbBzKaxcpVrtY6Yq8fO373ZvclA5B1wH9kEQ/C1
         nCvAhOUHWliKBtl6Mntg0qR3SKtZTpc3nqi3W3KRkkfyWGML+gXRqRF/68Fwksh0zUn9
         qtI4b0ycZ1OKOOA2IKB/oqkNobUguSVok9GAEmRkcSdO2mm+lmqOCCh3Mp6Q5l8z8/hm
         jUDcF2OzTeL9ruJEmDIlXSXiZSWBu2loXfxKXDmwAUyRfp5omlJ2E1vFv02GaQ79NYBd
         DtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642012; x=1796246812;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TvrU0wA9nQ8NmkHqlIbwXmklpSSQk+6g+lOk6duGUaY=;
        b=Q41KOI8W7zymwXCqLi8hj3dQXZJnrrnx3inFMlrVnmaEIoDBF3n96w1dcqBdC5ciJ1
         b8Zt1/2jPhiC7b+kyLOMX2XEcoG3MC44x6G9LQ1LhOqPnaYH0rBHwYhH4TujSOPn8MUd
         0W5+I/JZhhyz9iVsxVgyRaqomJi0RngDUaKHJzZxmAVMjEk9TaCcdHUlAosfGDbAqX9q
         Knr9rqBk0aaljpHZ1NmIYeLHbZHlKCd1SaNwnaqS+c2dHY3EXYBdK7aPlezoWk+HIdY0
         JGr7DzPoMorYQBAs5hP28UOV7jCPgAn8M1uJBNoTl+E8KZkUSRo+Mj+JhZMLHI82UVKO
         N29A==
X-Forwarded-Encrypted: i=1; AL+hErGU7BF2Op7y5dcY2Dk8b8KQovgVmzwfp13BMiiPZY5bRxlVM6T/HwOEABXlDmWvCZaxlp/tbCX3cw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/e/T2kkkEnr+MQu9/suN1KlA1OaOzEVkCFIqKa7LyFqozuBQ/D
	ZkjFn6Q3fwr6yEnXBLC1JApY6br22nqp727E9EmcFHKRPkTnG2JZ8Dss
X-Gm-Gg: AZFdTZeW//TG28wt6YHLiOoXXLCBkEXokbVzbE1Dp6LIa/eF/9yZe/lm4XwW8AQHxeR
	eFgN8MPJmcw+Y2wqQIvpPoRffAl0CfwhlFR9bgGqGyDBrUVBk03zuybi2xOKLuuOcDeGUtnB+Nn
	BJFDG/aIYUPemAHVaG3/Jefkfp+JMd6sStQVjBpxsLcCPyLHzz0wosOS++h6kzzyf4zTO9/W6Kb
	zsv5Bqp5H34OL+r28QikaMjuQz4fhNyHMiKlyfNeFauveilDBjY7ChktS3dBOir/YJc/9v7W9yA
	J4jDdwg4xvLzbNs72hfnAqWkz9NLKvvXBe8ZEO632P22IG55Oudmm4w4pVu8tMWSjNRMIxLZPbx
	eerG9RWR7yFM6CuuzR5zgl4Y/3FQsEARUGXS8njl1brLpKBC+ZBdUeCxLOqK1T7mTDyPrFUfhHp
	MWN8FWCF7BTD8SkrIz5eQ64e7s2VXeAbVldxzsiNnM3YIVG22IoBbOwwcR6HYHKTHdaK+57HY6o
	/BU3R+3yxsr85H04+aRA5zgWxjmgTR5kmvzKgGttUJyj24Vg1ktGw/vpzdXgN2nJoPwRE6S1LWp
	+Rhk2y9GT1T0qERfSq2BzLznzezEJ9icCEZ692gTxwqLFCnO1lIP07UhVbUC0ZDZqw==
X-Received: by 2002:a05:600d:82c5:b0:4a3:5aee:2c25 with SMTP id 5b1f17b1804b1-4bb88822642mr433032475e9.31.1795642012525;
        Wed, 25 Nov 2026 13:26:52 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm310815745e9.2.2026.11.25.13.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:26:52 -0800 (PST)
Date: Wed, 25 Nov 2026 21:26:50 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, Ahmad Fatoum
 <a.fatoum@pengutronix.de>, Alasdair Kergon <agk@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 David Gstir <david@sigma-star.at>, David Howells <dhowells@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, David Woodhouse
 <dwmw2@infradead.org>, Herbert Xu <herbert@gondor.apana.org.au>, Ignat
 Korchagin <ignat@linux.win>, James Bottomley
 <James.Bottomley@hansenpartnership.com>, James Morris <jmorris@namei.org>,
 James Prestwood <prestwoj@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Peter Huewe
 <peterhuewe@gmx.de>, Randy Dunlap <rdunlap@infradead.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Sumit
 Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 1/9] KEYS: trusted: Allow ASN.1 TPM2 sealed data
 shorter than MIN_KEY_SIZE
Message-ID: <20261125212650.479bea7c@pumpkin>
In-Reply-To: <awcAeLUROL0l_g3X@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-2-jarkko@kernel.org>
	<20261125090930.698d8f1b@pumpkin>
	<awcAeLUROL0l_g3X@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Nov 2026 17:36:24 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> On Wed, Nov 25, 2026 at 09:09:30AM +0000, David Laight wrote:
> > On Tue, 24 Nov 2026 21:40:35 +0200
> > Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >   
> > > tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
> > > bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
> > > 2.23.133.10.1.5) blob.
> > > 
> > > While kernel-generated trusted keys ("new <keylen>") and legacy old_format
> > > blobs are at least 32 bytes long, external TPM2 tools allow sealing any
> > > non-empty payload up to 128 bytes.
> > > 
> > > Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
> > > bytes for ASN.1 TPMKey sealed blobs.
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > ---
> > >  security/keys/trusted-keys/trusted_tpm2.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
> > > index 30188a0ec676..d7336f25b514 100644
> > > --- a/security/keys/trusted-keys/trusted_tpm2.c
> > > +++ b/security/keys/trusted-keys/trusted_tpm2.c
> > > @@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
> > >  	rc = tpm_buf_check_hmac_response(chip, buf, rc);
> > >  
> > >  	if (!rc) {
> > > +		u16 min_len = payload->old_format ? MIN_KEY_SIZE : 1;  
> > 
> > There is no point using u16, just use unsigned int.
> > 
> > The same goes for data_len.  
> 
> Hmm... or just int?

Unsigned int can generate slightly better code - especially for
array indexes.
I sort of prefer it for values that can never be negative.

David

> 
> 
> > 
> > David  
> 
> 
> Br, Jarkko

