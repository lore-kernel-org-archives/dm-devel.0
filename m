Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795598367;
	b=ZV4PEc63QiCDQlEmxAj1XjCFI4HM/GK8nt8vv78GAPyqHI/4OVV50h+s3Vr2Aod5jA3s
	 LukDaySiMuTw9ALClb3zziGPUBb4gGCqhGz82axfXzowkDZr044qM+ffC19aWI6lofnh7
	 c7r1n6koacWvuk1qAo8hgkJYOVr6BXYBSuEE7EV25xp5CJeUil3vWKEZQp9+DKnM0JjRB
	 1oFHj3SzAq52rbgzTFvsJShfw69fElHa1DrUqIbFY11jeNJYC6NlQG+RRf3aGepSii97r
	 J6k9+QIZFM3NsqVLVRR90xhshoYeZoGq096NMjsKe7IgJKVbLioGcGUuBUH/qJJBO1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795598367;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HM/80FJuhfrnMxC/IfbUvOR9owLp0+IkW3x6Etq4fS4=;
	b=pKYOaO1Dkp8TLJ7lV3x+EMF5cWUEYlasRiUS0cx3Xz0MCwU16JVIiXjEWS5HEYCoblmY
	 nQoEYrL7u90dfWe9RReEMC7slLGLE17msBObJjgUgjfRvAZ9FzNZiIfxMVuS51y3Llb/T
	 ZzAOybgPtDbZFaJ2m5WN5ImdklKGdwXzm/bvwrWlBojEM4HdNy/yNtL5TRE1uJKNNNdbB
	 YE8BqyKoyTt2OJ4bDc8qemkNZC1CPtm2OCChaVKQ0XrFiqA+ZkK4XCw/xO+uGkEuXbU0J
	 NvxerlJVx5dhpWd7+6Uh54M0PSINwS4IbVSx5wBLk/+mN+1waSbNcToBcwlMwbPrEdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mmfIoIRQ;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1431D606A695
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 09:19:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1431D606A695
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mmfIoIRQ
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso52418665e9.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 01:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795598363; x=1796203163; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HM/80FJuhfrnMxC/IfbUvOR9owLp0+IkW3x6Etq4fS4=;
        b=mmfIoIRQKjlw3uPfcQYAAibRLtMM6umHnKY58AvEUTClUI8spjyTJ2h1JQfIaLVsG7
         d3p/LY1C9e9H0QmyU0+NKpUzb0E+tZ7tw9z1wTIYKetEGLR/08U/9JqDOEFQi+kuWQFA
         rkIQddQioJDHhj3AbbTfQoDv/7kLyNQpLUJJoBzX3hGdMYBWjsTkjE8Y/L4QFuR/XSYT
         LOWwInu5WNLZPZE9l8JXtgFIuIWrEWrWZHfqq1QznHCg+Qh1whRywgxYNgR+e+uRnPjW
         nEKxQ3kchpnpPBrlXXJDN1uV3j+fNcqdYYeIEfjWJWV7e+KN3k587OK9u0v+ZkPzWnZJ
         Pc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795598363; x=1796203163;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HM/80FJuhfrnMxC/IfbUvOR9owLp0+IkW3x6Etq4fS4=;
        b=GMEkpSs2p9UwlTDFZaO+eF1mh+B5gKw6lOnAXBLWDD7oh4omeJ5eJq9sdbrbG2+rQJ
         t9go7SxV2vHcS5GnQ27u/oanBM07EFAr7QsYQ2R0lby/cuCoCOCzYFo9a0ct+vR1kea1
         bGFSsZpmUaZRD0/+VkIBuGfQxdvafVO85FZin0KS4UtHKZehYmmQYEg2E0jV7qDJfWU3
         WhrErhiIE2aQuOm7hwxSVbCsWfbBl6v9HpL+QaHvzEkzwx+9TUu1g0FWxyOUCeptbesO
         2ccfEaXbfaQvZS7v2aNyb4pS8eVhXLojnY0q4IgHwcOhToJCTZBNZVdYbZBg824FVxQy
         xkCA==
X-Forwarded-Encrypted: i=1; AL+hErFoG4aX95zw5nf45B52zU5qpq9nAe5ut036BsjdzdZVgB6muiuT1FG1b+i22Wkyhxg6hVN3OoWfew==@lists.linux.dev
X-Gm-Message-State: APuU4Z/K+6HQGGLyLRl6m04JC1rlR9vkm3cCDYNkmo4co+uBgK23MQpW
	bB915gItwHcdHIoBUd1F+BY7+dyyrxsikXLYQwEdNcQu0uIyiE99SABZ
X-Gm-Gg: AZFdTZek1qoUdoS8YMm9uMVDA/Vla44D8fXyF87lW3yMSdVF8MB+Dcp4O+haT92Oeup
	xXhK77onHwapPQhfSKNh/F31wkZza1zrH9CBO3Z2zjObif08CNvEvKEglgvDlOSxhZuCFcUOian
	l4xqZPmJmPcCdNMJ59gUIOo9Fv/tVAiqPyPkliq39Qvb2+991fk3EX7GHpiz9U3k8BgEozXJ/NT
	eNDB3fhSTuWmA0YyTdp5eIUjB/IoCCb/rVjPRXtpAoBvpOBiFgO303NqRf6wTTyIC+VzVs3m32E
	I3uOgZUPd3O/fkVnrkOW0q9DXOmU4DJFQSQ4B4Flb25dF5bnywm3PQTeNArXeq7cBVb2yKX9k2H
	3BkRDa4RJF5aXxdtXjeVJR8rO4sPSMQjZkyarx2PdGrMV6Oy9ibsawrwyC48oNdJGExzLDLKdGi
	DKvOAG6PIt7u1OdTdvFWsLiRz2+JSlkacK8K01KlLJt9fuBKZaTQz1zoZSmPDTEaN1ixjUnHd5i
	P2zh5wWl33aOw2N8a6N8OQEx9RgSxeGugX3V9pDFJUN8PbhlgPMm9oawKy+K0KbaV2+SMGH/1lo
	D1nhTL+5D43wz14yFrPNQAAhI40Jf0CbPbTxVT+xp7eVnTD/F+OTMV3PYkyJnK5xTA==
X-Received: by 2002:a05:600d:8449:b0:4bb:8e95:8ce1 with SMTP id 5b1f17b1804b1-4bb8e958ce4mr235915585e9.23.1795598363338;
        Wed, 25 Nov 2026 01:19:23 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884b39b6sm461330575e9.12.2026.11.25.01.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 01:19:23 -0800 (PST)
Date: Wed, 25 Nov 2026 09:19:21 +0000
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
Subject: Re: [PATCH v2 2/9] lib/asn1_encoder: Add
 asn1_encode_integer_bytes()
Message-ID: <20261125091921.4bf40279@pumpkin>
In-Reply-To: <20261124194043.1651679-3-jarkko@kernel.org>
References: <20261124194043.1651679-1-jarkko@kernel.org>
	<20261124194043.1651679-3-jarkko@kernel.org>
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

On Tue, 24 Nov 2026 21:40:36 +0200
Jarkko Sakkinen <jarkko@kernel.org> wrote:

> Add a helper encoding a positive integer from a byte array in big-endian
> format.

Interesting...
You allow for integer values longer than 127 bytes but don't allow for the
much more common likelyhood of the encoding being 'implicit'.

David

> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  include/linux/asn1_encoder.h |  3 ++
>  lib/asn1_encoder.c           | 56 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/include/linux/asn1_encoder.h b/include/linux/asn1_encoder.h
> index d17484dffb74..e206bd425854 100644
> --- a/include/linux/asn1_encoder.h
> +++ b/include/linux/asn1_encoder.h
> @@ -12,6 +12,9 @@ unsigned char *
>  asn1_encode_integer(unsigned char *data, const unsigned char *end_data,
>  		    s64 integer);
>  unsigned char *
> +asn1_encode_integer_bytes(unsigned char *data, const unsigned char *end_data,
> +			  const unsigned char *integer, u32 integer_len);
> +unsigned char *
>  asn1_encode_oid(unsigned char *data, const unsigned char *end_data,
>  		u32 oid[], int oid_len);
>  unsigned char *
> diff --git a/lib/asn1_encoder.c b/lib/asn1_encoder.c
> index 92f35aae13b1..8fea70dc0846 100644
> --- a/lib/asn1_encoder.c
> +++ b/lib/asn1_encoder.c
> @@ -10,6 +10,8 @@
>  #include <linux/string.h>
>  #include <linux/module.h>
>  
> +static int asn1_encode_length(unsigned char **data, int *data_len, int len);
> +
>  /**
>   * asn1_encode_integer() - encode positive integer to ASN.1
>   * @data:	pointer to the pointer to the data
> @@ -85,6 +87,60 @@ asn1_encode_integer(unsigned char *data, const unsigned char *end_data,
>  }
>  EXPORT_SYMBOL_GPL(asn1_encode_integer);
>  
> +/**
> + * asn1_encode_integer_bytes() - encode positive integer bytes to ASN.1
> + * @data:		pointer to the pointer to the data
> + * @end_data:		end of data pointer, points one beyond last usable byte in @data
> + * @bytes:		integer bytes
> + * @bytes_len:		amount of bytes
> + *
> + * Encode a positive integer from a byte array in big-endian format. Strip
> + * leading zeros.
> + */
> +unsigned char *
> +asn1_encode_integer_bytes(unsigned char *data, const unsigned char *end_data,
> +			  const unsigned char *bytes, u32 bytes_len)
> +{
> +	int data_len = end_data - data;
> +	bool add_pad;
> +	int ret;
> +
> +	if (IS_ERR(data))
> +		return data;
> +
> +	if (!bytes || !bytes_len)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Strip leading zeros: */
> +	while (bytes_len > 1 && bytes[0] == 0) {
> +		bytes++;
> +		bytes_len--;
> +	}
> +
> +	add_pad = bytes[0] & 0x80;
> +
> +	if (data_len < 2)
> +		return ERR_PTR(-EINVAL);
> +
> +	*(data++) = _tag(UNIV, PRIM, INT);
> +	data_len--;
> +
> +	ret = asn1_encode_length(&data, &data_len, bytes_len + add_pad);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	if (data_len < bytes_len + add_pad)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (add_pad)
> +		*(data++) = 0;
> +
> +	memcpy(data, bytes, bytes_len);
> +	data += bytes_len;
> +	return data;
> +}
> +EXPORT_SYMBOL_GPL(asn1_encode_integer_bytes);
> +
>  /* calculate the base 128 digit values setting the top bit of the first octet */
>  static int asn1_encode_oid_digit(unsigned char **_data, int *data_len, u32 oid)
>  {

