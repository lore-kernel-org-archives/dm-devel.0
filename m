Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D71B6D08
	for <dm-devel@lists.linux.dev>; Wed,  5 Aug 2026 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785890285; cv=none; b=Ma8NfvFXAZVC2RsiEDn3fPfOVNR9heHBtLo/kkeSj0TF/XaZuzmC1umRS4SFc6SaUWfh4D/YvQ8FAaUDLUrVBJAp4/wBleyYXIXLN9/DaJwzuUSUNsRR8zF/+Ju2alvPolLBFeS5d64S/03JhPEN4Ahw9E3YirbYofKLscmflCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785890285; c=relaxed/simple;
	bh=6WqxOwvRODMPS+mVjvMMhwG2W9CP//QhLJ9wj24lR2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BtOEM+fNr8nbg9R2AOgCXi6MEmn/EtHnIRNccUd7VfPv+b4e88MYSIqmbcMpn4KuiyZKRwjltmtINWZHGzGYWQ19oNk/rGtVp5IL762GEO2zLcVEkmwKeeCSpSnup131M1QIm+YjKXHgVM6GS7p0UeaaDJPAuj9mnJEJqbdUzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mi7eRKjU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mi7eRKjU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785890283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3bMRUKPMAbpvvFE6T6OHBpDN/lFKrzTrz1UKeAGpowM=;
	b=Mi7eRKjUzkCNPzGhY1/px/zuNhGLcYb34CCEUte+Xj68oq2BiXcDaMv/cdljxRa+nX9HCc
	koYyeECir4qZptN+rkJfNCNZUO8xig8EPh8v15XMLlOz3VQkbbyfOGji29Jg9wVBQACABG
	EISGF45sLPHt5lZnfT5NhGsdKbQwnKE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-saESknG0PPauHQpCcuayeA-1; Tue, 04 Aug 2026 20:37:56 -0400
X-MC-Unique: saESknG0PPauHQpCcuayeA-1
X-Mimecast-MFC-AGG-ID: saESknG0PPauHQpCcuayeA_1785890276
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8f45dde7595so4057926d6.3
        for <dm-devel@lists.linux.dev>; Tue, 04 Aug 2026 17:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785890276; x=1786495076;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3bMRUKPMAbpvvFE6T6OHBpDN/lFKrzTrz1UKeAGpowM=;
        b=UTUwsoMpTRhMmU+3h6rp3tGPXOH3pBwISnDvtzLFFEUmcnIKXWYMFQNvVLBMO84cYx
         +vXQalyfExyGa7IdagrAHyuGCQwTEuy3+9zCaL6yVDPXW8UpQr4VtWH59p3e4sjVw0tx
         G1E7Zt3BKKLCIWsq0dnaOqijD8ahYspEDhDx8h+25no5eGWR9sa1fTHC6HyTwpmPprzj
         Wik8FVhPsnNScq+iMmKJR2RrTMHV2S49eoDuBFzZ0z+LAgXiIOQDvQJEOLSJ3LEvk96V
         1PhvZ9Sptc4OwD+XQTNDV1xf3/2xUynx6lprSwSfmGDahE9OOLhKgwvJHNf8cMeq//CH
         qXGg==
X-Forwarded-Encrypted: i=1; AHgh+RrR6hm1s80gOtlDl6oNi8HzoCs95Idx0pgd93QSARezk50oS4EOxZpxaXQp55yx8bO3PY2iQeATlg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyKwTyh3HaL+aXJr7jfNouTdMglbvY1ywDt8yuXvhtj/AHcjf1H
	DOX/BHpRvCj8iH2+RFmgMvdzd2r58hzTdbm93+vTcKno1kI8d3GBCrTkmSovYmJCrOF/y9LsvfM
	inWUEwZtK2et+I/GM1BgBZR1jjjIDAL55HEbzolvi3uv7VJpgPdGqYRTdHAIj
X-Gm-Gg: AR+sD11twXThm7GUAw0dx1VOpRzE9HOT016QAT7yHlrxo0vAwCwZkFLd0ctW3k5nWuy
	KvtxPbqo8A05VSAEqhKA1QYn9Yk4OeDENn5MJPbzezrWeWbl3LrhFGg9fHBYtv5kebCtP/70Csx
	McHyVSndCZe5DsvVTmla+0hku4miXimQyc1kc+kvNqo7NSHkBiUYqWxdVQhvjRkFOMoXf4alUL4
	RNQODZSkS2inTQVxFbzDxHaK4+l4L95b9Pi37tlfZN3T8y/4Mckpr/EFOp8ONVKKCZ4Xqs5V5mF
	9Acm3lSJCW1QukQ02E6GCZF9Zaawz/+7kAYZ1ofOgM99TGXAMYUSSzKj1dOfBJMzaZQFjSeerZy
	EIF6WQ6cBoWjsrZJK/17gaMJ2VZwUpi3+v214urTC0wJpKhKH
X-Received: by 2002:ad4:5e8c:0:b0:8ed:6c66:d11d with SMTP id 6a1803df08f44-9088137452bmr30503736d6.26.1785890275649;
        Tue, 04 Aug 2026 17:37:55 -0700 (PDT)
X-Received: by 2002:ad4:5e8c:0:b0:8ed:6c66:d11d with SMTP id 6a1803df08f44-9088137452bmr30503406d6.26.1785890275168;
        Tue, 04 Aug 2026 17:37:55 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:b400:d348:ae32:97a6:8a0d? ([2600:4040:530f:b400:d348:ae32:97a6:8a0d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9088008e9aasm13982146d6.28.2026.08.04.17.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 17:37:54 -0700 (PDT)
Message-ID: <0255e828-bc7c-46ec-ba72-847e56b44b15@redhat.com>
Date: Tue, 4 Aug 2026 20:37:53 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] vdo: add zstd compression support
To: June Park <june@pythonplayer123.dev>, dm-devel@lists.linux.dev
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
 <178a5039-1817-4e13-8937-12eee8b26cc6@redhat.com>
 <012e81d2-dd6e-4977-b385-d7ac890be2a2@pythonplayer123.dev>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <012e81d2-dd6e-4977-b385-d7ac890be2a2@pythonplayer123.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Nyge8rC6OdJ-VMf9byBEi2Hsbj8NbjDQiysQUZIMUUc_1785890276
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi June,

Sorry for the delay in responding. I've been away from the office and 
I'm currently digging out of the backlog of stuff that's piled up, but I 
hope to be able to make a real reply to this soon.

Matt

On 7/27/26 9:43 AM, June Park wrote:
> Hello! Thank you for the thoughtful comments.
> 
>> I have to ask, what is the motivation for this change? Do you have a workload that shows some kind of improvement from this proposal?
> 
> My initial testing in QEMU, storing files from the kernel source tree, showed noticeable improvements in compression ratio (around 2.4 to 3.5), even though vdo uses small block sizes. However, I did notice that certain types of data (such as long synthetic streams of repeating bytes) showed far less improvement with zstd, at the expense of more CPU cycles. I had concluded that it could outperform LZ4 in some workloads in terms of compression ratio, for more CPU, a trade-off that could be made on a case-by-case basis.
> 
> The discussion you linked to proposes the ability to swap the algorithm without reformatting. My current implementation tries to reduce breaking changes as much as possible, so I had decided on storing the compression algorithm directly in the volume geometry, instead of for every block. This has the downside of requiring reformatting, but since the focus of vdo is deduplication, I don't think the large amounts of additional machinery needed to support live changes is justified.
> 
> June
> 

