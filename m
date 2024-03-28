Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31054135A50
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 18:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650575; cv=none; b=qFM+CbH61ymvwBd3v93E4W3jjEcvltuqH4CdGLXt01LYlrc3GsCEHHmFNY4kK5o9ym2/SvV1N/U/KKxBKdF7FN4OE5F6xKIx4mrvXu3BJ38GHUpsXme7Wqn05KCa8f+2DlLQLR7K1bVXcunWr2T/+cf5pxC9rgalUufJ20T/BCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650575; c=relaxed/simple;
	bh=GthFzf4c2CnxlFa+euL1T99nUeV+RK/jqmB1OAtv88w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sXSQip//rUtTca2lV0pV/FelQZOAA/0Z5lY0qzrdvgew1Qt+sfsbAJsxb723Fp5Le2r7uZ5JpqjnuNv+7vDVFOFju35O+W2O4vxskI5DUhVPpThhcYqOmQdCs/cL5O0NpC190sE1FKm+ovczQNWXOGyYdEdIerlUfzEyajPd2x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1VOGjRg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1VOGjRg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711650573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=295Tz66lZ5wzxYSBeQjEsXjOn4yj5P6f+q+3yKW440Y=;
	b=S1VOGjRgA8Ytar8RGHM3NpPXwfi7vN80ygRtTN32eSQJKoc+hHp/J1ur6SO6hbphIu9FqU
	KzvxZKC4gSo/0tQvQvdDzhYIJSjHMe6ZlkZggHA0aIahoige5D5WnCA1bn/3TCdmq98Si4
	5QnSvgtod2XSBduZ53n2ZmGuvuVvaoE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-mCEGpdMsOE-YjC2-yk77nQ-1; Thu, 28 Mar 2024 14:29:29 -0400
X-MC-Unique: mCEGpdMsOE-YjC2-yk77nQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-69622e04585so18936256d6.1
        for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 11:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711650569; x=1712255369;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=295Tz66lZ5wzxYSBeQjEsXjOn4yj5P6f+q+3yKW440Y=;
        b=V+0aqWiRhKT/EGJakZvb+jDCaFpvyvYDs2hRQugxtdbD2gGBmCsHCU9KLVqZg3QQFQ
         uE78shYB74NTMw3h9M5TfE7QJKx/zj4HoY9BWYoOCVDtRIFM7WKtCAcTfd/eTQpj80mg
         hC4aECmN4w9shs1aFH3qUG8YjzOT3jHMAe58SZfLH0UTtOYooSIbv9uZMK6gSHCpGyZw
         3mNDpJI/FHMziwKLcYMetUQYolIyckR/EzsdYcZ6LnfRJdIdHULmmh/MMjC3hc8T7j6r
         EwQTyGWaff+VgnQHVbg4Akq5iAJnGp01SwiR74EelmbN7vDD29CI0eCFNexNp57Eewdh
         DXAw==
X-Forwarded-Encrypted: i=1; AJvYcCXqPXQdaAKT8XZJFQwoSBZZLBdw2MKkzC8wGOr4bYiUk+AKCMKV2dVGUmN98IsDer9em1jromp6o7eIomy2kPedQ0NKs//P5NU=
X-Gm-Message-State: AOJu0Yw74dWMx31qIroir5eEMudVN2H+IirOd/W6MCdEUkbxlIq3eWC9
	hvCA6ETdL60/Q3mLstzHKwQB9V4UkFkdNdzr/1OrI3BDAXnZn/g1AXnTruMm1ZaDFK5FLW9Fu38
	qR9yDdaXliHV65hBA4WJ3ovxfWRO11/IYqtSEvO2RNRlbn2fhIxUTt1wz
X-Received: by 2002:a0c:d64d:0:b0:696:3a75:2964 with SMTP id e13-20020a0cd64d000000b006963a752964mr57856qvj.18.1711650569463;
        Thu, 28 Mar 2024 11:29:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFe5oHWCZzfUomrQkq5TZ0+KX+12VkRPiBcXfHIdH4JazXT/nPJvHY3WgEr/AA6t75OSJCiAw==
X-Received: by 2002:a0c:d64d:0:b0:696:3a75:2964 with SMTP id e13-20020a0cd64d000000b006963a752964mr57839qvj.18.1711650569212;
        Thu, 28 Mar 2024 11:29:29 -0700 (PDT)
Received: from [192.168.1.165] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id c13-20020a056214224d00b006913aa64629sm854751qvc.22.2024.03.28.11.29.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 11:29:28 -0700 (PDT)
Message-ID: <2ae69d9f-a42c-00d7-f9eb-e93c071153ce@redhat.com>
Date: Thu, 28 Mar 2024 14:29:27 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 1/4] block: add a bio_list_merge_init helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 dm-devel@lists.linux.dev, cgroups@vger.kernel.org,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20240328084147.2954434-1-hch@lst.de>
 <20240328084147.2954434-2-hch@lst.de>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20240328084147.2954434-2-hch@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/28/24 04:41, Christoph Hellwig wrote:
> This is a simple combination of bio_list_merge + bio_list_init
> similar to list_splice_init.  While it only saves a single
> line in a callers, it makes the move all bios from one list to
> another and reinitialize the original pattern a lot more obvious
> in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/linux/bio.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 875d792bffff82..9b8a369f44bc6b 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -615,6 +615,13 @@ static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
>   	bl->tail = bl2->tail;
>   }
>   
> +static inline void bio_list_merge_init(struct bio_list *bl,
> +		struct bio_list *bl2)

Nit: The indentation in this line looks off to me.
Otherwise, for the series:

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> +{
> +	bio_list_merge(bl, bl2);
> +	bio_list_init(bl2);
> +}
> +
>   static inline void bio_list_merge_head(struct bio_list *bl,
>   				       struct bio_list *bl2)
>   {

