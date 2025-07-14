Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE69B248869
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 23:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752537529; cv=none; b=S9RBYeGpdNkd9WOOAuw9OMWiOysvxe90NHbkkxD+9UJoj3Y1YcIY6iWl6kmwL33QbAPuHQeTZGA+qaA7gAUkUuJGikiMf7FJdrbY9zwkzaNFlXfB4q8/yNQfOcYw1GonrixtlbbpboUnkRyZYh0DTkRYV8ZUMrJTHCGvBGHPRaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752537529; c=relaxed/simple;
	bh=wyNznoKhJPzBpps0P3eH/mjBHnJXLyAjNFEdAR1ch2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kwc9fPJXRx7OeaHUaITwnQlkVZ0NoB1OM4G1gfwjCv+dwCOwW/RrlGHiJzd1uTG6xRNDR0ttNPRlVoc6VFTX/uMbBCopPW3IVEY9l939nJ8gjl7AtD0Rs5NFPqYzuYg7P9Anm/67yKxj1ypQ6XFIFwSxcFtHLCSOz8ebgMPh2RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMUrStFJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMUrStFJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752537526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XFHkkkUss5JwFnv8W5cQ4tbVdnVJDNuS4+t47VQvGiQ=;
	b=VMUrStFJbYLOty/qviMBvJMYx3M3wfDcWXg/l8Zwc3TCTDnvrE0uPLNb+QlPro/Y5zFwOo
	EVW5qRLEFKuZ/+xn+Zzgzhae51RV+/Tf8YaAoQ5sJeFwn8o0IBmnE68JLjWGTLenongxR4
	d6R2ONIixlqjA56dqitC0l3TPqQv2VE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-yRA4A1MWM1aeH5c-eExBTw-1; Mon, 14 Jul 2025 19:58:45 -0400
X-MC-Unique: yRA4A1MWM1aeH5c-eExBTw-1
X-Mimecast-MFC-AGG-ID: yRA4A1MWM1aeH5c-eExBTw_1752537525
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6fab979413fso87606976d6.2
        for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 16:58:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752537525; x=1753142325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XFHkkkUss5JwFnv8W5cQ4tbVdnVJDNuS4+t47VQvGiQ=;
        b=cSywUqfmIe4qqtTo1aA96/pRpleyKKaYY7iBwAM1YXzHOFyWguFp+lwCk/0yKyvCXk
         zYvMP3FkpkucJx5EdFArlbEUay3emVjvakvj1fHma4SzQ3pCXRO/zx/qEedXiF+uM895
         8w/BGninosMxD+cA2V/18PqMgU44voId10wjUA56cy9e+NbO5HUT36Vnc4BoFDOkja3+
         cpL/0ncdCVpiSeyNl735nfN6TnsxMW35Jq4O2DNnMik9ab9DPuGWS0zHRVkwTz0OoWsp
         gJp2DmxShqAAiJnmPjRl4pf4SfuKisZuqj19uhoE+FyudZg4XBT6y+zFnNa16NGSmWaI
         Hkqg==
X-Gm-Message-State: AOJu0Yyd2+Ac3D1lfS3IP6brK8saXDCQX2PHc/rjMre6bOxrLttrlflA
	maaOc2hRjeMnQJ/qsaALH+NTDlTJwkR/nbECrLmO/gDlkChxXL0okth6hK9rL0whGJOHXXnMnGS
	jCB8AJsp7moAvboWmMtp8vpmkj7mX3T95op05pVI+RNhtljy6TL5tBfzLfzq+
X-Gm-Gg: ASbGnctV2q+mvraaVVPa1mJUZJbqz2pOkQNXazCp2BDQW1ad6tTNCzjs8Jwlb6nU0Gb
	AEyb0FblBbxjSq/AEDFXNwYUOX201e37nCQRJ9p2uaicQy8I4Gz7hm9toCTRMWOVQf7+uXr9u3g
	qrHX57dXe23e9xrnOiHydJq8D+G4yX+niNZaIOBlsYEzH6CfsZevOIZOYLcMj4G857Ius0Trg4M
	40x4JgzEnimrCVKxqKUbc5JMC8tpqu1MyXRw1SEQU/H461Q4ROZrd9lXQOLOLm4Mx5CWG2v8AG6
	HoHL3RfZfm7+gjbZAp4HGDaCTo65Kth53wqGMCJ3sc41B4ATHM3CEH4fQO2PERoiJsrCU8jBp44
	blUbz1do0aVg=
X-Received: by 2002:a05:6214:cae:b0:704:881d:3102 with SMTP id 6a1803df08f44-704a359715emr196556316d6.12.1752537524491;
        Mon, 14 Jul 2025 16:58:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3rDonvvz61ptZSSrUxkyVcuBWZovP7KyZ4TVoOo4uwkWajHlvicczIRePCbuzrPO/L3eraQ==
X-Received: by 2002:a05:6214:cae:b0:704:881d:3102 with SMTP id 6a1803df08f44-704a359715emr196556066d6.12.1752537523968;
        Mon, 14 Jul 2025 16:58:43 -0700 (PDT)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7049799e8a9sm52151036d6.10.2025.07.14.16.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 16:58:43 -0700 (PDT)
Message-ID: <e8a0f6d3-b830-448a-a86d-2c37840a4104@redhat.com>
Date: Mon, 14 Jul 2025 19:58:42 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vdo: omit need_resched() before cond_resched()
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
References: <a9f43714-17a3-041d-fae4-bdbb79311f3b@redhat.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <a9f43714-17a3-041d-fae4-bdbb79311f3b@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7E2KMO5PY96ssAd2r7DsGojRhe2FwLXwzOt8eYYuBVg_1752537525
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/14/25 12:27 PM, Mikulas Patocka wrote:
> There's no need to call need_resched() because cond_resched() will do
> nothing if need_resched() returns false.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Reviewed-by: Matthew Sakai <msakai@redhat.com>

> ---
>   drivers/md/dm-vdo/funnel-workqueue.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-vdo/funnel-workqueue.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-vdo/funnel-workqueue.c	2024-03-30 20:07:03.000000000 +0100
> +++ linux-2.6/drivers/md/dm-vdo/funnel-workqueue.c	2025-07-14 18:17:59.000000000 +0200
> @@ -252,8 +252,7 @@ static void service_work_queue(struct si
>   		 * This speeds up some performance tests; that "other work" might include other VDO
>   		 * threads.
>   		 */
> -		if (need_resched())
> -			cond_resched();
> +		cond_resched();
>   	}
>   
>   	run_finish_hook(queue);
> 

