Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D1731281D
	for <dm-devel@lists.linux.dev>; Wed, 18 Feb 2026 20:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771446414; cv=none; b=g0EOzyqX/9T0itzUcmF/G08Yz3bUnhWnTVceKmsXroQLlW8RzRGzV7hSwzoqEekhub0c0NH//8xEk6btB0/Wz+Q/TvqCiwVaXj8e4XCkiWCfQm8PQwVihZ6dhq3/j7zSbl+ZWmYleEKxkZ83Gjh5pTyXry/OvTCVjYlmppMsEQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771446414; c=relaxed/simple;
	bh=1UY9+p+DKvRG79Ec1NsYvCayqJbzivTkIBlR/eIidno=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eC3m0f+SUGD3qDXzEndVa/0ozk9ZgTi6fZ0FCDDslWpYYpIiCEysjjvfueqssZ/nUP3ds6BTRuh93voi5A7g4WQvOeDYYbqyoP4Kp29xRqUD6cXcZ/362ZxOXfetNPXp57w1WATxQCVYdjYItKm6hyJansYQvkATjYFft3Z5BCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RSuElMQJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RSuElMQJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771446411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjnByTgk3jlx4GflNECqRqqr8EIr6wF+vuRXLFi5u5Y=;
	b=RSuElMQJbS7uYRDFOsjGjuuiBLZ3DHGZqJK43gNpn4shTDLseszZTOfprTS6hmmF2om2M8
	rUAMhfi/rzPVehRw5SrkHklFaZvqII/+vSMOnWSZNr7BnI12WNgYitPXpuKhNjLktGIvc/
	xrBD/fY4sWSkgA6SkWw56uP95pci0Es=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-Q1fvfT-KMT6gne3KaDnMfg-1; Wed, 18 Feb 2026 15:26:50 -0500
X-MC-Unique: Q1fvfT-KMT6gne3KaDnMfg-1
X-Mimecast-MFC-AGG-ID: Q1fvfT-KMT6gne3KaDnMfg_1771446409
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c70fadd9a3so190395385a.0
        for <dm-devel@lists.linux.dev>; Wed, 18 Feb 2026 12:26:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771446409; x=1772051209;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GjnByTgk3jlx4GflNECqRqqr8EIr6wF+vuRXLFi5u5Y=;
        b=R9H1TzUmtWTHmNYm7ZSEiSd+fTZKwZTXNYo8lxpU0HRX2D15MNvCXqopZyPqwvn9yA
         zdp7RwA6MZWxLpodxY8jSAaSekOffjtP+27lCZ3UbkH2D97x/CUfcm8K3cD63LJJjy0w
         7/o/gmfNwjKCeqXVT/s1tEfdnA5sxPFg+X2RitpjIeELoWN4HA6sOMLqLtXVwKirsv6e
         lAX6o08PUZqg4Js3mY/tXHRWgBSHNODxeWxY+JwcPn8yrbOqp/4b6KB9g/uIOoinhWE6
         dtXn88uNrtNbizVkE4GvHRiYhUz4wH56IIcDC3zabwG7skwW3mB2JWU66tH6PCebobub
         3fEA==
X-Gm-Message-State: AOJu0YzTqa5rdSphnjcqjNEHNo9y4QayxqB7fOVy9LcWCRsFC3MDmTrb
	unJEHLG++WRQ0yIRlnNHUaIXtb3IJVRzEABg/oISnXUkki5kcJgXEfCWqxyb2jNWll+51RJyA6E
	CwiAniDzGqiQ1m2pFPN78ZiMi4QSDP8tFEYEXBHPRG9OIXweyAlAemwvy2412lfyK/5E8EG0vBF
	V0dvb7Yjkdilc6+HoL7+N0NrYJWRhvnAgIbkO1iNRvnG/D
X-Gm-Gg: AZuq6aLK8UU8pquoPfHkRDi1ViyYlYUa7gAgYy4Jy9unWG9lyiVDvMW/uq9+/CvYf+V
	r+aTm5KKjRrOeP9Hc/vl+zFQxIvbEyWL8ny/DC+eb2FVJR76RjnbIeR4d4x8o3eoxlmArLjIzoX
	7SflvaaFqHIMGa2hz+PECDPaeFGx403b8UPyk7M2NpLGeZxbAlvBVS3CetHogp47l8+4z6VcmQp
	3OP2ZlHG1KP2fB4XHdKGbjPI47YNb3RXnflL9jrzZpDZv54hpmiqUVaWe+El2BeYTHIzEodtwa9
	4PJSOUJsDhBUF1w7X7sIgpBHqrqso/7SGKEk4GoBuba/yr7aNjYLAwdhPgxnr4o9H6bXQr28srM
	50ZjojwAxn/unN+HBZnQfZw1bIkM+2F1hSuACSZ2XIMAhyUTFb60xMRi5G6hzFfpTR1+GOg==
X-Received: by 2002:a05:620a:4481:b0:8cb:4059:a90d with SMTP id af79cd13be357-8cb4bfd5be6mr1959550885a.38.1771446409557;
        Wed, 18 Feb 2026 12:26:49 -0800 (PST)
X-Received: by 2002:a05:620a:4481:b0:8cb:4059:a90d with SMTP id af79cd13be357-8cb4bfd5be6mr1959547085a.38.1771446409132;
        Wed, 18 Feb 2026 12:26:49 -0800 (PST)
Received: from ?IPV6:2600:4040:530f:2500:540d:8da2:f197:6711? ([2600:4040:530f:2500:540d:8da2:f197:6711])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b1c8505sm1815861885a.25.2026.02.18.12.26.48
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 12:26:48 -0800 (PST)
Message-ID: <103f07b9-5f5f-41b6-8f13-540706a8e81b@redhat.com>
Date: Wed, 18 Feb 2026 15:26:47 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dm vdo indexer: validate saved zone count
To: dm-devel@lists.linux.dev
References: <cover.1770818146.git.msakai@redhat.com>
 <d5a993c1d724a5a2ae3c9a7179eedf68afa16f67.1770818146.git.msakai@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <d5a993c1d724a5a2ae3c9a7179eedf68afa16f67.1770818146.git.msakai@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PYobX04HkOo8zhDpEdRJ4BDYxV6fQgw9k6-EBbTaLH0_1771446409
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I just found a bug in this. The new check is actually too strict
and prevents some valid cases from working correctly.

Please ignore this version. I'll send an update once I'm sure I've got 
it right.

Matt

On 2/11/26 10:05 AM, Matthew Sakai wrote:
> Verify that the loaded zone count is in the valid range
> before using it as a loop iterator.
> 
> Signed-off-by: Matthew Sakai <msakai@redhat.com>
> ---
>   drivers/md/dm-vdo/indexer/index-layout.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
> index 61edf2b72427..37144249f7ba 100644
> --- a/drivers/md/dm-vdo/indexer/index-layout.c
> +++ b/drivers/md/dm-vdo/indexer/index-layout.c
> @@ -1445,6 +1445,9 @@ static int __must_check reconstruct_index_save(struct index_save_layout *isl,
>   	u64 last_block = next_block + isl->index_save.block_count;
>   
>   	isl->zone_count = table->header.region_count - 3;
> +	if (isl->zone_count > MAX_ZONES)
> +		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
> +					      "invalid zone count");
>   
>   	last_region = &table->regions[table->header.region_count - 1];
>   	if (last_region->kind == RL_KIND_EMPTY) {

