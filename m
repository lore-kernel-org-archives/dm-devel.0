Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795453795;
	b=R9teR8IIbeoM8u2bGpvRVdhMdIZ1fc4ZOiP4+3Mjmcxm2eoOE/hZbvg7fUPcLqtwAPSU
	 By2I5JnH2Uleu8siM7QwCQBTuK1/Z5YQ3n54ANAXU7oZd4qpCyNt52gWw25BaSVRAoW+7
	 TpG315V7vumGodOgP5O8KgHVLDChdqy8gd4I0qzaTaTiMOFrW4zFBNfzbDcmZQGROO2JQ
	 r0xcyf6MWdBpjWJLEoS55dgawvl9wg70JFVq2WUTyMA0t+T2CYUXBwOQok1y008Rzl/sj
	 PJ4ifm43A57I5epJWQqTGsjTNpM0n9zPp2JhgBCIauOPA4/1QhjdYz5OQ3pY2+xt9DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795453795;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=TwwEqr3OnjXukgfvtpJZLmewy9+Abiehlm3ScQM1z60=;
	b=zdekht8DkvxXKaU9+nREGY/Lr9wMBd3a6wvVTFYdH0jIt48PIlijM2qsN1ektQEQSlds
	 VmAeUbym2L8ZlxmAwzmIXyuXI9vLCRMCI5lGu23Sqqw42QlnnsJ244QhVQDV7j9qMr5Xi
	 b/J5Zdgy0U7LjS/FzMBgsZ0ZzPLBTm1sAPwbDQx4YwmC6RLTWncAamS46b11S4M+rCTwQ
	 pHgGCGezp56ZUY2ImJP6anaj83mOGeLdh2rTzkY+aFLdhEtyEcoQN4CJScg+WW9YuIScR
	 gtvqLTsCqUTPeY8AxBKEoCVn5wYaJnD0jreMumH+FH8qqSm3bvsJCkwT0ZMQ3xFeU6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AKXnUcsq;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FB1606A31F
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 17:09:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59FB1606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AKXnUcsq
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-49a357e48a2so260889f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 09:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795453794; x=1796058594; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TwwEqr3OnjXukgfvtpJZLmewy9+Abiehlm3ScQM1z60=;
        b=AKXnUcsqMxvEcoocbZ+4kJRnjfGD6IW3vi5i6tT68uyM3H28/wR0WdmRH1MpVQKb/J
         bv10ysz2LDGqpbs5ULk0iFEslq5ZJjfQzeMxpyCm44qVjoF0ziMCBkUe8Wjr8HTAWl4V
         /m/LESISqf9k3PIzvkCJv9pTOvAZf0r3LJZPx6OOElmDTeUfVGoESAVX321ryKlTMe79
         vIbfiLtKcnirSpVHTt16mkmQwI+nGRPw/uo7Xpk1/3ROA+Nzr2Yy3ZuMIZsLzLe8JVtR
         +eTjgtaxHBDZk2ZdOuVRjYhKVbXKZ3mjjTdaJWYwK5FwZzHmye88LvVgr9EbGDSTyn8i
         iqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795453794; x=1796058594;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TwwEqr3OnjXukgfvtpJZLmewy9+Abiehlm3ScQM1z60=;
        b=BzVI09E9idSl2ToQxTvHA6zK8UjZNuBCBljNv47j+tC1js//Te0+EMhqLEDmIsazbQ
         OsOacGc/kXzuiU6eHk+SuwGiaz7zfNcFWtcbhW+p6FQ6K6s2CumL14vki+7+6sodpE2P
         ldlFwqbb+fquiNWW2HrtSqmG0K+CiquctvM7dPjpfWK4m6jBin3RgpNitJ3gsTE2goEC
         lAXSySoLMAjXRWW8+S38y9CBkWvrpypmh090H4wWB8X4/Aya6P3p2LS69SQQiXJ2PoWj
         HaNy/OE6EBMSfxo+aWJZKNS4mVL1VNNUT0KWXK8p9RAXvHHH5MFzMo5d7dnaC5B6VyMY
         m79g==
X-Forwarded-Encrypted: i=1; AL+hErE6gggdW3xr/QnnQrJ5L1rv0gSMyF5WNcQjkdX48D1Qugk+X3Gq+ZwWFAB25q8q+KDM2F1yxQIHjQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z/biWyIRyz4PRhKlS/6tUh+bj6e02w9H4jCYAjn8pWRXkDsjrQo
	cp4tl5axbJdmW/C11rWOBKlW9AZ8pFT2PgOuM1XlqNV/OYDCfo8xQdo=
X-Gm-Gg: AZFdTZf3hIXGGi/kZkv1fhghQqSiPQMb91lWPFv7PXN6gWB9p3aVpjUtC7Zh+ZsFSEi
	WDs8/bisNNHaoRwdnAAuROU+zXHGkvr9WrjREVXDhpiU0ucrqGAxPtybqY1zlnhu/YksopYWt99
	rHWLDOdhiYh9uQKzDSfp41NdFHrdSZCyr7WYG8g8IF2xM3i/24eYftetwOYPLi9d+ci9xy/nBpv
	Nt8sYaFZiMtXTRLGoY4pdyg6fgrlTel9sGf3L9s6QKO5eGShTx+Qx9plewnUx8oTT+UHmaHsr8n
	n76GTnlz6GpFFYY/8lAGOOrC8yPkDksQw/Pez5OwfbiboA0AlwOR9KF3C37FrbZFSWwumA9uM8O
	JWGRuAmPEDCfmOJTfOTq8TpK2Z8ytQlvMVzRRf9tA8Jd7W/o/hEoZnFh6u+IrEJye3buIoMPjSB
	hJVONM2tMS1aJIG+uZTu2dWJmCNX3T8K/FowkYPh51YKhK0xG3l6Dc3zEh4kvSOTC1aPQOTKXeD
	G1VcbCLKTUERbH6/V0HupC9IZAPEEu1n1r6cdIjHQOxF9wcZuwVWiyjArgG2wEnrLCvYOSY6tfJ
	NnzHvFctzMY4N3Gmy0gXOqs0J+vnYaXylJE9DtE+5JI9yULq9flNCfz33V2cP7HJW57B
X-Received: by 2002:a5d:5d81:0:b0:4a3:1468:c483 with SMTP id ffacd0b85a97d-4abb4b85a38mr24156844f8f.4.1795453793485;
        Mon, 23 Nov 2026 09:09:53 -0800 (PST)
Received: from localhost (86.red-88-28-10.dynamicip.rima-tde.net. [88.28.10.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110ba3sm19036291f8f.35.2026.11.23.09.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 09:09:52 -0800 (PST)
Message-ID: <64b6d939-f527-417c-b5f8-c804e02846fe@gmail.com>
Date: Mon, 23 Nov 2026 18:09:51 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH RESEND 03/13] multipath-tools: hwtable: add FUJITSU
 ETERNUS VX710/VX740
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
 <20261113125549.504780-4-xose.vazquez@gmail.com>
 <16d621bce8b1e5f027f07a8b235be0d1f6f05796.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <16d621bce8b1e5f027f07a8b235be0d1f6f05796.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/23/26 4:00 PM, Martin Wilck wrote:

> On Fri, 2026-11-13 at 13:55 +0100, Xose Vazquez Perez wrote:

>> +	{
>> +		// ETERNUS VX700 series
>> +		.vendor        = "FUJITSU",
>> +		.product       = "ETERNUS_VX700",
>> +		.pgpolicy      = MULTIBUS,
>> +		.no_path_retry = 120,
>> +	},
> 
> I see this in the manual (my Japanese being a bit rusty), but are you
> certain that the VX700 has no ALUA support? If it does, it's at least
> misleading to set pgpolicy to MULTIBUS here, as this will be overridden
> by ALUA auto-detection.
The Fujitsu manuals specify an active-active setup with
"path_grouping_policy multibus", and the "multipath -ll"
example shows all paths active in a single group:

page  8: https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/p3am-3912.pdf
page 35: https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/p3am-6362.pdf

I did not see ALUA support mentioned in the docs.
