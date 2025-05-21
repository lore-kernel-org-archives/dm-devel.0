Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8F22CBC6
	for <dm-devel@lists.linux.dev>; Wed, 21 May 2025 18:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747853852; cv=none; b=C5iS95wLZ9y/DhO55ZNkE/7E78SvwKVurKIyGAdJdjqNae7x3tbrRQOhMr6lqciIl3g49y+LSo5TagfjW2xybdspws8NxGEPq2LjxGucXPwLPkFRpyHsgKvDuZSmK55CuKXCIcAJtZLkniQjrYL9ySaYZ3zzEtYVAkhwG2pmjgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747853852; c=relaxed/simple;
	bh=k2elYg8hDgZT2hWIWlT2Vld7InAVkC2ziHcimQmJalY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rUlcGLTpBWuKFNaN32nEJ8cWOt8NaphV9ostIlyqTPCiy+i3yL5n5WwLL2kzx96MHQhLEO52ZQobm2bff6EtIGBl+qS+9aemfEklsejnSCQvEb/kL12PCzYlbFMhFr4tdiNKEKqNaYmqzaQX4AYCqjlmz7lvGwMbCFINFGlj8bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HRa6LXm+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HRa6LXm+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747853850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zZX3oSNR/OiJ1Y9Pq6xf64GYTpDGG51TH1sjZ6Ombb8=;
	b=HRa6LXm+H53C8xKLnsICndAz1NrlsQRQFxcqwniwNzsuWauvGEoahcC/pspUUOmiBahyY5
	3+IvH9kzPnFLKf9vqn6Wc8cOsam8MFAPr/s/DgJiHzVrGrK4zQADZjGi77Aw1kQLpuTxv9
	mYcMcdlmHrBtoJUxJvCa4nYD/+6JQec=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-XxeoT9h9OZ-PDUN6kHYlfA-1; Wed, 21 May 2025 14:57:29 -0400
X-MC-Unique: XxeoT9h9OZ-PDUN6kHYlfA-1
X-Mimecast-MFC-AGG-ID: XxeoT9h9OZ-PDUN6kHYlfA_1747853848
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5e2a31f75so2233826985a.1
        for <dm-devel@lists.linux.dev>; Wed, 21 May 2025 11:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747853848; x=1748458648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZX3oSNR/OiJ1Y9Pq6xf64GYTpDGG51TH1sjZ6Ombb8=;
        b=J0/V0N1IXx21D6z+HR8pu3u3nl0eMktezBInA3tn6yOMiEBl+XEZX+H9+NSu2F+l1X
         SkPiHFdhJvE/F0gnXGSYcRfxPsRFu6/x2OZznJmprA8hxlH6OilAU5i6HL8nzhY0PN3a
         fLB2U+yOAWCtPpMrHGWsL2qUO+XJsBzu8+g/orJsjX2By28ump1rIG/4RhZWwAkVS6Bf
         Mk6hAvkT9RR9Fakpute4KMQCu723lBsjfxgf/1l0kLBJ8mEATGNPfgs/suHfK4QgNexA
         GP4GrsPRo7uTWC0fQACDPBpGjR9xQZQiHOuhoPUYX/pVa+uJjGKV2TGcVTBmZOMU17l8
         jb6Q==
X-Gm-Message-State: AOJu0YzRqL/o/hw+Dnz+kzhYZgp0squNJDONHFb16cKb+d3zFJdetL9r
	9V0CfDslgsbW3EfOLiyJk9JcPRJjkjuiSZ96cNgCOq5u+2Qoo37yfikUrC4gZYyLjqaHhcHslqq
	loRkVZbHMUJPK+kvlxk7EuOH3dNYfaVI9mdxMXv/QxNtax/PlzENiR/j/QA4C
X-Gm-Gg: ASbGncuHSa7ttIeu1vrX5vR60HI4PJpQGaYmU4d1IWV7ra1mlAWL+o+9GJa+EFjlPdv
	z2HakqOWYT7qYlKDInuDeEepUTpESl3Xwc/5IeuAQaLxNKTiWwh+Pfgf9Qhhoqes0jNGiFXN24i
	ohWZq4xdED1x5lhD8mGEUiQizZeTXW+UdD2Uo6+jHjMVk9FMJ+MiJefTmhEPRjiUl7P/MJ1xfoB
	8VwOCEPSUoaHTXfWtO421+BagzJmJXEsOZ8d2L1D/7oVDmVMoRZJ4UdPwsNVnY+04nNhkHP0Yb4
	W3+32veRt3mq1pJVNaHJBfP/dHFVuc7KEjOJdanIeFB3bXi58cHQR46Qrtg=
X-Received: by 2002:a05:620a:3194:b0:7c5:4cb7:ac97 with SMTP id af79cd13be357-7cd47efff63mr3121621985a.1.1747853848077;
        Wed, 21 May 2025 11:57:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnvoFRahZcZi6WjpnTrtmy9zuSJztpTCLgI9ec8JwApSBatPo0Ayv6017ChDQEfE2ZP9lO6g==
X-Received: by 2002:a05:620a:3194:b0:7c5:4cb7:ac97 with SMTP id af79cd13be357-7cd47efff63mr3121619885a.1.1747853847768;
        Wed, 21 May 2025 11:57:27 -0700 (PDT)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467dae90sm912153585a.46.2025.05.21.11.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 11:57:27 -0700 (PDT)
Message-ID: <9501613e-e8e5-4734-aa2f-ca3a3e4ca990@redhat.com>
Date: Wed, 21 May 2025 14:57:26 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Potential heapify performance issue in dm-vdo
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 jserv@ccns.ncku.edu.tw
References: <aC3riPZ6GV/dlr7Y@visitorckw-System-Product-Name>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <aC3riPZ6GV/dlr7Y@visitorckw-System-Product-Name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: orqVa1ahcp_Y9glbSw_5QdpjA2I3D2skCM5UPGVQ7_o_1747853848
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5/21/25 11:04 AM, Kuan-Wei Chiu wrote:
> Hi Matthew,
> 
> Recently noticed that the current heapify method in min_heap.h may
> degrade performance when the heap contains many compare-equal elements,
> compared to the previous version.
> 
> In detail, the new heapify reduces the number of comparisons by about
> 50% when all elements are distinct. However, when all elements are
> equal, the comparison count can degrade from O(1) to O(log n).
> 
> I don't have enough domain knowledge of dm-vdo, so I'd like to ask
> whether it uses heaps with many compare-equal elements. If so, I'll
> work on fixing the issue.
> 
> Regards,
> Kuan-Wei

Hi Kuan-Wei,

dm-vdo uses heapify for two different operations, but in both cases we 
define heap elements that can never be equal to each other. So I think 
this is not an issue for dm-vdo. (We have not noticed any issues with 
this in our regular testing, either.)

Matt

