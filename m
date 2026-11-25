Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597778;
	b=xgwulRH59JEf5kc3LW4xJy2vhltW0qETglmwxx0l1845AJnJYrhBLNaRRCNBfmsKxTzK
	 Awj3LAFiKch4MijXIPUF2t9SNB3aPRRVzI2yuMVtyYs1g5gtMHDz0lZENoRBU+WOHgofe
	 EpNdz/KMx4tIAow4YpxXwIOKrXiA6VQd+IN01FxCcfGkgGQzS9e9Fwe6VciGzkLGh9G4E
	 oJtkr6TVjYofo1nv5c1qxr8kuaR8ddata2rbVeGZODw8ewEN7JzZTXFXgNKOJ6x7beQuR
	 +PTs7S61IjgLFEH9i/eJqAjD601Y5aOAVrQ9J0peAoGqOuMkSRBMSC32VU9CJHrj+cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597778;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qm/FI2mE1ewe632JTFSK32XwvOS0GNyWzPRE758QoDs=;
	b=MSx0L+h7YQ7J1c4Ur10umVoZ8IFuUSg/i4dmD7bwpiJYwh31Qyvtc2UJOsZ68VkazuSR
	 TWIIUhoElZ3IQv0WNSiDtQKVBFdfC3V4cLV5hFTDacIXJteNOAk9HJIVQBw/hbKrqqlYE
	 MYvMvYX6gSm/udLhB41li/ud6UvAK5URUXnGtTVleAjlwhmpBGjmRWEGa6/nZJujP6VP7
	 jeIiSjUfYa2Goh0ez5aPCgVWvzGR87FbEl1IyE6gAhqcQB7qFXsnKkNmH6RYwrVmnxhQm
	 mznrkeRUcskT1dcUUGFAVx2IL0wS2o37/A/2cN0xYlZVNRr03dJGerA77HOZIU4HSSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mi1d0ALa;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23109606A32A
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 09:09:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23109606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mi1d0ALa
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so50252915e9.2
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 01:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795597776; x=1796202576; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qm/FI2mE1ewe632JTFSK32XwvOS0GNyWzPRE758QoDs=;
        b=Mi1d0ALa9LRcFZGq/KCvGwQ/Krt690DUOEeGnYKbSFNQfAKCnu8wQOk6DuFCG4jMgs
         QV4fjyb5PbPlP1FM2WzRneKYL/iphAFkVekWMLIEFV/JaXG1vL6aO4WdwaYyGAbJqUKK
         i7D7BnwIkStZ1SUwujdNqpVvaZGRtkoNOwcVkPqE2B5PWKyPCDXcgOyLix12tlzlfyLb
         ODOP0AmMLg/cbyhqJPyckXg+dlzYkMGpW5AxCfCWHntgRrMM2K2AVDwaMcHeAQAJv4Jn
         NyAbDewJzFmbZOu8HYg2DqLSILp4LeKJlCGAPvEj0qcFhroAnNGLGwITo6ar+NTzoUqn
         SV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795597776; x=1796202576;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qm/FI2mE1ewe632JTFSK32XwvOS0GNyWzPRE758QoDs=;
        b=JqR6baPe7VTsqmI6wnvFxUs+xzpJgF++Pjtu1KyAzDXN1FtrRSynW1KCzyxEzPTPnE
         vO74V6iWHHJ/NThP+UpXx+GbRfFqSywbVFZqQKo9g7sxfpeUTsngX1FvYUjYWmCdmajB
         wkJezqVQMrrsp76U2ANmSCZV0aMvCKNgBpHhtat6fM/EQv6WFdJccbvYU3FkbgLxgdx8
         EPlISza9JcsC6oDWIcZkxacjwtTMiuDRqW2+AL6u4SKjWeBx0XKj25Xzy6PU8u5PZCiF
         H4a8tQkU8KNag+wsfcOCj15b9GB58uNAYkkKepTyH3BXePWwq6DzML4bma66qOXwhUYJ
         IPIQ==
X-Forwarded-Encrypted: i=1; AL+hErHpI9Kg/vm9WqHUrSjgjUfGdSIGnwTESOTCShMFj38yiuRYQU58Gz6VubNFCDC/Ek7+rLGXBcty1g==@lists.linux.dev
X-Gm-Message-State: APuU4Z/+0kqixLJ43AexEhkuCLZvOsYXlbVq1iau4+wPY/x5PS7/QXPm
	LFwG6u6AqSda7WAY1MXfiFrFaUwizdtWXgWPcv8MjVLs0xew/B3kYhUp
X-Gm-Gg: AZFdTZcB92+NUmNBzX8pKs32HO6VkuzDD/HonqrUN6bInai0kwu00sa0JTQoaCHsvcv
	kkzRfCVQeeZRTkHdz1rGkP8D3/Hu1O+OhmFw4ZM2LiteIcMXk3Ex1HjlB5KOk5pBKcl5OIX3NEY
	MBlc8XtjorJh4PjEIbkuefrD3Xpw0CGR++OHXoh2+MnEEZeyxluMrkBgPyOwFTVktEYB1U3Bxs6
	ZcLDxEZv0HVJqbs6UiTeZcsqQR0EyppvDi+DyWoz7qemms2DiuP0xtmWkrp7q9PJs25GKgTSmAc
	3Rcv9x/T9iJUOu23gh1kcIxwuqbSlrNCS4vKB7vH5t6YlKyL3Ctq8tRoJPji1yaQtylDL0Cecaq
	pXmkMQxLlhmb1+6iBbN5OA0bOUt+OeX6yGpzd/Gy6KWzF11OH9UlRALgiI10tZk4Yxf78UOrIvS
	ir1LXLB/yfaSc0UMYiy1T87rbXwG/oA58+ZLjT6LSG07bQW6vCIFHJEah41PLw8TYH6IgUS5JUO
	RgwPgxcs81zd1lDL74pL5iebDdctoZVnxTRvWw7IWyrXPVGB8/oLpEQlMoe5R/kXUl9PTbIP8hY
	EVCEM9Is3kJB7PF9g3c+WpOg3pMaTgANb9qioZUkADbWdGBacE9pqYr92hqdn+hmDw==
X-Received: by 2002:a05:600c:3509:b0:4bb:76f6:d23a with SMTP id 5b1f17b1804b1-4bb88814d16mr374824975e9.21.1795597776397;
        Wed, 25 Nov 2026 01:09:36 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm558503985e9.12.2026.11.25.01.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:09:36 -0800 (PST)
Date: Wed, 25 Nov 2026 09:09:30 +0000
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
 <James.Bottomley@HansenPartnership.com>, James Morris <jmorris@namei.org>,
 James Prestwood <prestwoj@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Peter Huewe
 <peterhuewe@gmx.de>, Randy Dunlap <rdunlap@infradead.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, Shuah Khan <skhan@linuxfoundation.org>, Sumit
 Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 1/9] KEYS: trusted: Allow ASN.1 TPM2 sealed data
 shorter than MIN_KEY_SIZE
Message-ID: <20261125090930.698d8f1b@pumpkin>
In-Reply-To: <20261124194043.1651679-2-jarkko@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-2-jarkko@kernel.org>
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

On Tue, 24 Nov 2026 21:40:35 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> tpm2_unseal_cmd() rejects unsealed payloads shorter than MIN_KEY_SIZE (32
> bytes) with -EFAULT even when loading an ASN.1 TPMKey (OID_TPMSealedData,
> 2.23.133.10.1.5) blob.
> 
> While kernel-generated trusted keys ("new <keylen>") and legacy old_format
> blobs are at least 32 bytes long, external TPM2 tools allow sealing any
> non-empty payload up to 128 bytes.
> 
> Keep MIN_KEY_SIZE for legacy old_format blobs and accept 1..MAX_KEY_SIZE
> bytes for ASN.1 TPMKey sealed blobs.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  security/keys/trusted-keys/trusted_tpm2.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
> index 30188a0ec676..d7336f25b514 100644
> --- a/security/keys/trusted-keys/trusted_tpm2.c
> +++ b/security/keys/trusted-keys/trusted_tpm2.c
> @@ -559,9 +559,11 @@ static int tpm2_unseal_cmd(struct tpm_chip *chip,
>  	rc = tpm_buf_check_hmac_response(chip, buf, rc);
>  
>  	if (!rc) {
> +		u16 min_len = payload->old_format ? MIN_KEY_SIZE : 1;

There is no point using u16, just use unsigned int.

The same goes for data_len.

David

> +
>  		data_len = be16_to_cpup(
>  			(__be16 *)&buf->data[TPM_HEADER_SIZE + 4]);
> -		if (data_len < MIN_KEY_SIZE ||  data_len > MAX_KEY_SIZE)
> +		if (data_len < min_len || data_len > MAX_KEY_SIZE)
>  			return -EFAULT;
>  
>  		if (tpm_buf_length(buf) < TPM_HEADER_SIZE + 6 + data_len)

