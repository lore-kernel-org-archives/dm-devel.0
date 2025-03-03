Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6594B215058
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741022304; cv=none; b=sNuyXWkE26iPzKE4znkpdtoYDlGCq/rV8IbEhq59oVb8WBZ+4MdHezhiewt245e63iEutfUaUGV8xZF6QSZVe/hRGTWpORnb6Ay0MvFvUE0pYZABEdQNP+fjxaF6EWBjVLmr9d2ZKuY9MXrRmfODGe1mUgKPCfhnl7u+weGpHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741022304; c=relaxed/simple;
	bh=tEbl9Z0LHEelJx/aBMH20V1zwfdMngeOka83kgkcoHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=kNryejJPy3JWhkj248s1NHwmrLVDCmp+/sSVohFh97RzRodgnw/75KzS6aptD2TqYjlKcAyM7yz+mxCsYu74zx3JvIn5a3+xyGU6BEXCoG6aWwmfDEVkrBAIhrWLgRVao/dbGAoZ7wivvJLbktOFhc5Fxo3dSe32eIMQ73/rMQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I8Vo0Rs7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I8Vo0Rs7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741022301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9zzxoP24nmh82oHSaWc5helnKokGr310kh8VjOMYcbk=;
	b=I8Vo0Rs7WNT6gMpTTFgQilAKJNR8BWeuG+e1q96tQvo+ikrzwx7Lt8mPHYvZ178zw5Wu6m
	rqXo9rExeaMv60JHOfJctX5GXtMT/vLL+Th6SUeGpb3OIqyHSHhz3JHZ8kakkHZpET2Wa3
	tWuBwJO1lAzLtomTrRplPYu7XteQ1f8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-mwWBLGVHMFSgHOnuXsTYlA-1; Mon, 03 Mar 2025 12:18:20 -0500
X-MC-Unique: mwWBLGVHMFSgHOnuXsTYlA-1
X-Mimecast-MFC-AGG-ID: mwWBLGVHMFSgHOnuXsTYlA_1741022299
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-390e62ef5f6so1701442f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 03 Mar 2025 09:18:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741022298; x=1741627098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zzxoP24nmh82oHSaWc5helnKokGr310kh8VjOMYcbk=;
        b=joAbkG2z3sDIZi9T2SL43pRM4pAG2hYEkAM1SnM27mhhoI8OTahvYtyAXKussY5xAw
         8RJqbt05qoR2FR/vChfycs5LCS923h/4/OyecrczG5bd6WloAJ1urxPQ/dK93sy9XoYN
         7QFaAdTJugRIQgM+D/soiiQV+tt+otU9doBQsEVqDe6Gz7cAZnWJUQMcUGiKdlS+CxIO
         gNuhOzc/wGpYrFDuFmiPyQTPw10Lrzl9CnLWVZTSY9AJFmrTcEMm+D0F/i1pgeOcIn88
         1m0Ejo6lk8wQjQakExb2lrnMSo3ChsQX/rcY7N+bbOVcBLAwireSuX6m44DafZ6DgNqo
         E20Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkfq3agiKfbFEiHnz8X/FXp8PVohKNYomxNvAgsKKELkEbzNVpPN5C8LQWkniOcz+1muXn1YHFjw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyiqVzhHSAP3QMc+38fX2H+9FDsqdUKrmitYCeVqymoJXXq7vG4
	BHXbl2khksPK1RfEO8M2xjQJ7/B4ycl16kGY0WgWwIa2rLYH285wdbOc/fvEYHp5Me7NqSvPNol
	UHVaHOXLmkzKKlfeKf/xXuakCKO88VinC8iVGhpRX/ANpklQFwqTTNSNc
X-Gm-Gg: ASbGnctqBLpKyGOkANTxFnISBORvD4VrInJfsZ9Y8oOLUhX5Act3aAKSHSO7DFq0eyc
	YgxLfLloZy2QuofGWGePyO692zU0qf/rcHfuLJT5HEHGRRGQhjqU/p2l/nTENm9F2hR7fl8S+tu
	+xZSHsHY+VtmIhOeMLAGsb1po2Jk2xeE4btRYzNPRXBd3AXeGjeslF6kyG0t89lOpPryfdUrsRB
	CJpx8jeqe9kIbuTLTjNmxMl6O6oaSg7e/f8GjZVwW/yDe6c43M7RCBQVhH6uSCodLMMFMLfKkkG
	UDMIm3IYfb9g/Q4HCDNJMd8MRByPoGM3Ri194w==
X-Received: by 2002:a05:6000:1ac6:b0:391:13f7:92ad with SMTP id ffacd0b85a97d-39113f7954fmr1323066f8f.27.1741022298582;
        Mon, 03 Mar 2025 09:18:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5d/hEIDGqC62p/7+/rM5orGav0jyhJDcMmBAMbJkNL7PGTfOYy0B6v19rbsYDULNx/C1wLg==
X-Received: by 2002:a05:6000:1ac6:b0:391:13f7:92ad with SMTP id ffacd0b85a97d-39113f7954fmr1323045f8f.27.1741022298295;
        Mon, 03 Mar 2025 09:18:18 -0800 (PST)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47a6a78sm14792252f8f.23.2025.03.03.09.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 09:18:17 -0800 (PST)
Date: Mon, 3 Mar 2025 17:18:16 +0000
From: "Bryn M. Reeves" <breeves@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z8XkWA_aWDNQ-giK@redhat.com>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
 <Z8Xe9bJQYs9TiUrO@redhat.com>
 <0690d480-1bb9-a586-6b3b-976b9bf2ec1d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0690d480-1bb9-a586-6b3b-976b9bf2ec1d@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZQpA2IgKUbGLdZUCyWG2rjLbKt6aaM6PXfa03Mpu5iY_1741022299
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2025 at 06:06:36PM +0100, Mikulas Patocka wrote:
> The dm-loop driver does the same thing as swapfile activation - so I 
> presume that if swapfile activation is correct, then dm-loop is also 
> correct.
> 
> The S_SWAPFILE flag prevents the kernel from truncating, extending or 
> deleting the file - it just returns "Text file busy".

Right: that was the idea, and it was lifted wholesale from swapfile.c.

In my testing it seemed reliable, but we had reports from users of
very occasional memory or file corruption iirc that we were never
able to pin down and resolve.

One user in the UK was running it in production for a couple of years on
multiple systems - in that time they had a handful of crashes that we
were never able to make much sense of. 

Regards,
Bryn.

