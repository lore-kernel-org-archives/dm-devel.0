Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69DA12C523
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 17:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709461; cv=none; b=prQo7NT2Prh3Xv0IA88CXOKC5PtLDXoH1PnrFzNuep6FFpXavQp8k4VlAfhjWyaVMhg/MqfrNWrezKownml/Og0oCD+JEY7S8umMMWlzoex0cnk8OPOYTVmMn9yohcpehEapMOEcb9WfQVjtfowEwAQidZ/KWTRRFsScC6hCScQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709461; c=relaxed/simple;
	bh=kk9USHa3Igm+4RJya8josHopx6Qb1FmJAPmqrV6cP8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BfoaO9CIx0h5iiZPUG17BeknV9x5jXBtQ+Vypg5PiBVSew7FPQ8QBhnb1Sce7M72NNeAfyFB1KkIEFPjY3KjnWQkJO4QfFWJSQkopD48cPqNLfyU3j0mKVPER0dXHPnGX/w+AWU0AgK8O0MSAYfTMKPtdHzOfcnV1FYugi61CJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-787a2a14d9cso76988985a.2
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 09:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708709458; x=1709314258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVdmESG4PxkwASoqLragfY2GZJ2QdcB8GuhgUXgWRzg=;
        b=ubtyM4mcfjP1ZLK4TdjpgMYgH0QvANLPxSUoY+XBwb+Yf+BaqBDFlJjCw4RFbM/c09
         k7BEwR9pUXki2v4ethTbVcdWtRUWBp2Q9chUk3XUG+m+iNmfKnLQ4hPR7LI1boNdgFot
         SnBIgz/3G7B0uc94SxmdG2FPDKvCuTweriSmojIrqIIosdtTCJj/I6ga9kk4Cj9SzVgR
         XHdkwsF6oQEW9zYLJFAaM7EwmUpphQoTInBp5OIxvo/xoG+4KMJuMNdZ2GueJZsCu0oR
         YNB8uPDM5nZFLNDtc21TFvN3KSLc/hHecBMwqI0Zp8rACgRoHVzSAKyrq54Pty808Ccs
         1wew==
X-Forwarded-Encrypted: i=1; AJvYcCVWQ3zdy2Kcy+ELeRTHJvnOsiMLYycxU75JtEQ5x+GIgBfWLwQpRs8RNTWme5T//w+2I0u1lHpa5TBjYZG2qUwhLOnt047sdws=
X-Gm-Message-State: AOJu0Yx3AVWbcK43DBsxyhegt6Tihi+/V2YAOoM+36um6aHdyWrCU2yy
	VcOsim+KJORB8QfV3Gk4/8xrAzVB1RS6ghzkAM/rAAHpSAt0542bJsaAPoMNDQ==
X-Google-Smtp-Source: AGHT+IEiN2DRNfZ9o9l6t4npd0H7WRs0vXB44XzHTTVVeoGiXBOzkyqAnD2/8Y1Y40PYCiOWrBICOg==
X-Received: by 2002:a0c:e113:0:b0:68f:3452:584 with SMTP id w19-20020a0ce113000000b0068f34520584mr377462qvk.59.1708709458689;
        Fri, 23 Feb 2024 09:30:58 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id nw5-20020a0562143a0500b0068d38023e35sm7035400qvb.112.2024.02.23.09.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 09:30:58 -0800 (PST)
Date: Fri, 23 Feb 2024 12:30:57 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/9] dm: use queue_limits_set
Message-ID: <ZdjWUdwrwmPT0mX1@redhat.com>
References: <20240223161247.3998821-1-hch@lst.de>
 <20240223161247.3998821-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223161247.3998821-4-hch@lst.de>

On Fri, Feb 23 2024 at 11:12P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Use queue_limits_set which validates the limits and takes care of
> updating the readahead settings instead of directly assigning them to
> the queue.  For that make sure all limits are actually updated before
> the assignment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
