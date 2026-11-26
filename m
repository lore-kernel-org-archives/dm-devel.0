Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705352;
	b=vwT+k0M95EsYLO44rp8mWyigYdSYwyqoVyjRIKh2XAwGR052JstAJU5IRl4VgiLF3ceE
	 mGDMiv08+qra5vpfYJNsIl6rp9EDwwGckSKEouMz/empaSJl3keAW/5llvYG3dcuEtxXm
	 D6iXcaEeJxIVeooUQz+piJjRSNKHB4r9P+8D2y+0/PdnCoIWb/gpPQVSsQZjXpGBgoZdE
	 qrCZWMxqQSJenfngQ8/bMzFY1gGpFPsKrW5LIDytDHLEPysdiTamTjn0HU5ojy6TvAgSH
	 cQfzFXOeUg1wtWI5CLulWr+7EMI5O6qDpgFDl+E5obpsG/7bwNhP352YTrfWAfiwKhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705352;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type:
	 Content-Transfer-Encoding;
	bh=7rVMTgvbm53Cvs01sDlu2aGYYzzkSHltAze1ZZ/K0Sk=;
	b=ht+B+kWHupKjCX3ygK/q8pSL1U2t1FppeoGqsPaFR8JBmxCP2aM/sknwL8Y7OF0GXOPT
	 pn4NUEGuyfAPge7OyoY8E05NJ9OB/vbC8Fa2QMGmrltAi7YxjBcaLSOCNq+WlyvUVLSof
	 erGqDYCPlj0MFwOJ/79zUSluRi22+KYiLKPMIhPg2Qwo78ZXOnUQKTWjydF4W1IHaMsOM
	 a3tF13LMcmZrwN08RwhdzV+pXVyHb3B2M34gK7vANl8pc4rnjKOnHS/PQQZAevgwQ7xBz
	 KuWpEyx6ew6pfFLtG3iFH/++kIffPVU6+PnMAEOJdx7S9FsUcih5B8f+IciD4vzNmrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NEl3AxlM;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC0606A326
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 15:02:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2CC0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NEl3AxlM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795705350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7rVMTgvbm53Cvs01sDlu2aGYYzzkSHltAze1ZZ/K0Sk=;
	b=NEl3AxlMfY4Z3EDZjjz2rVaaeJ7RjsVIpM8v8+GpQA46ZO33gGwbCGYDs17of1IJwsnXTq
	fGWH0FjqtQ6AwUCtjsLauou+pk6FH4Z+hKnv8yxZSy6fZjGO8XCk3rGKP4w1QGCj2nREDO
	TQj2VI7OOgya6qwwxa3S0yYQW0AFij0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-grGMORv7P46NfWIdJzvy3w-1; Thu, 26 Nov 2026 15:02:29 +0000
X-MC-Unique: grGMORv7P46NfWIdJzvy3w-1
X-Mimecast-MFC-AGG-ID: grGMORv7P46NfWIdJzvy3w_1795705348
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3acd4b46482so28110841fa.2
        for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 07:02:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705348; x=1796310148;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7rVMTgvbm53Cvs01sDlu2aGYYzzkSHltAze1ZZ/K0Sk=;
        b=ipUNfl2QzHmv/iimqlRQy8HpRyZ+3bYswH8LbaNN8Z7JpG+q0ceTg7rVioEotyDthL
         M+WmRuonX2WyO0KL/4SZiplERQUXRBLRagdyERcyjDqXH61AiU5OuXZHJSF0wir2prhD
         9NUkOr0gV+P54pIozzeSm+izMdeuZg7NAH++irJ7QK2tOz05L+mEW4cg1qkpFXCXUcL3
         LRiChHQT0QODt9zvmZTqobBnt1MNkcrqgC2F1AhQ8SZo4EqBWtsPODieYq74SylTsIw3
         LSW9FlYMF0q8mYWcE0jvepEXCyWlF34G6ZSmdkrCqLEugqTcNmCF8LpoSBR92sTmfqff
         2sJw==
X-Forwarded-Encrypted: i=1; AL+hErHZzkPPhOHOWrKGjQ9iUSqNGeltMJQqhzIyPRupYgCFV35kGggt6iE2G5u2Z1tXJi2BjPG9I+icKQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+4cBWrvOIbj9dSteLa8KuL3HvF3xo11OZbJoqLIzJCdoB0Yv4A
	2NSd6qUcS4Z/SjrCdO6MforJXrbpL5Dioo7hFHRMH3myE0UhyarRE0niUtFOyYSZhWLV6dghMCx
	pnJe6DftV60fNI0GTKibn/o39S1cp/hgl5kFZiD7jgPJV2Zht46SdL1XtWb2m2wiciEcb9fK02m
	Rm4Dlqbs+AxzjKLAmx+YK2FjLYBdEIWTZsxw==
X-Gm-Gg: AZFdTZcVadWZ3ASBQaQcwK3W0PgkmDYjcBWY/tVUTBxJ9OLNhHq8ws4IgrGaxd3jj0Q
	2Y7qJbPc+dPiyhGxQTmysVAf6QbLKNQrRfaXFicxN1bWEeZ1Tpb7+PT+ZyZfNkG4vZNg2IQy9OR
	X8WU7Ns4DXCTXsdStYpwYXkk2L5ipn4S43nWewEoHEW/TU4ezbhLbCtrcKsXkNcO8PJkkxIoe1R
	eXmmsZ2fdf4d5ycQo7KeYxAnex3CbDo7oP214+i30n2D/Fs94w=
X-Received: by 2002:a2e:be25:0:b0:3aa:fa3e:21bd with SMTP id 38308e7fff4ca-3ae7f9f7757mr61758251fa.12.1795705347575;
        Thu, 26 Nov 2026 07:02:27 -0800 (PST)
X-Received: by 2002:a2e:be25:0:b0:3aa:fa3e:21bd with SMTP id
 38308e7fff4ca-3ae7f9f7757mr61757871fa.12.1795705347150; Thu, 26 Nov 2026
 07:02:27 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <c1cd488a-bd45-0d29-37f7-b7fabb6accf9@redhat.com>
In-Reply-To: <c1cd488a-bd45-0d29-37f7-b7fabb6accf9@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Thu, 26 Nov 2026 23:02:14 +0800
X-Gm-Features: Aa3M54oD7kmOZ7fOMs6V7c2Nr9VOAKQBhxIgNRjRNITJdrNfUgFI7hbgrBcTAjU
Message-ID: <CALjSBEsG4EVF8=tn0BTOrAca_oUpv-jmO38_wa4Ubh0+cz4y=Q@mail.gmail.com>
Subject: Re: [PATCH] dm persistent data: use the "end" value in sm_ll_find_common_free_block
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7l1xDR0w84P4Djc29u_9egIBe9r9ekmD9YmqykRy9cE_1795705348
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 5:00=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> sm_ll_find_common_free_block would ignore the argument "end". It didn't
> cause any data corruption, it just scanned more data than needed. This
> commit makes it stop at the "end" argument. In case the caller supplies
> wild value, this commit still clips it to new_ll->nr_blocks.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Assisted-by: Claude:claude-opus-5
>

Thanks. The caller's context masks this bug, causing it to scan for
more bitmaps as a side effect when the metadata or pool is full. This
may delay the out-of-space event.

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

