Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E8F145350
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 15:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709048202; cv=none; b=r+sjuMQ+0YcOCSdQvi9L0/zB6uyf+hyLuWO+5WFT9kYY36mz33xIoWb2zJ/d6BLP52BhjqrDPrlUJaLzraSSapKiKHLNP+7J1UlOpb7RKmafzwfU5Jz8jS2rBJRxL/io53XazwRU3ncFqOJP3Kj90NdA+VUrmx4tYo7czoY88KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709048202; c=relaxed/simple;
	bh=5uF36SkL6j3rjU+v75xcUHnjNsRFkrV5u2gpq2J7cJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOs6ypB7fiL3KDpHxTms6F4zmpzgEHooJtf9m+OGLBbTyB7iTPLL2iHA6uhCxTHtSAUurxdGTeVndFUvdoUKgPTVqZMXDynp2lWaSo/isT/T/3jfAoI27kbW+G0oqdvJ4ciRxctZsCBHIGgbHceiRqJRjNVcdQl+C+ybOFwknoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-69012259657so4044036d6.0
        for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 07:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709048200; x=1709653000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m2sGMg+51MVkfuFuHYE8WK5guxAx9KsEPslVkAQ6ODY=;
        b=g1HuIQfWLrvlPnbIYHpwSZg9nG/MyWGUU9FD/9T7aqt5jhMPGyE3hRS7WzbnkWA3cg
         SJliftIyafdv/x7sJ+2g6Pzrc3Uh4PU/NaGksSCHEvdQ/c4mLWqktzcQvpvIYtvPByMJ
         PDHcaAnYQ6/ow56rX7nGKasxnYw8ffDFeGcu/MoEOnvMtDIXFFz8ljIZPdhx6F2lsGhH
         iSR+190AUdYFF/doG754I4T7PAYuAe5VXnOgYURu/RgxSCQpi/yyk0XZYwOr31/Vm4dv
         r4vRBMdyMPF4Nyl4bv/w4nak5ZvzoDbydJ96J2QucygiCXIVpuaMXyNfYdVejTgxtlDn
         78kQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3nVwKi6jOyT+UhchKIPVGBAIAAgX23mE7Nb4beSySP1vwWW7ZY/CWE8p7imoSIk1838HHZfoUJjh9goOD5arpJ1eVtko6wqA=
X-Gm-Message-State: AOJu0Ywx8JIWO5uAz8jqL27Blrt0QXiZXbB/Cd+hDl2dJ9IMyhD0yBtb
	1naDkV1mbAx9ABEXynji4e0vRYfII50wGl6h0wvSmAoRBF4ll0QA5q/ZsKmRlA==
X-Google-Smtp-Source: AGHT+IHefBd/DYeC9kDGOWZX34cDpyMowKjJqRD0RsTiq7qAUMMzIzL+c6tRbAmqftYr+t9pPcOiRw==
X-Received: by 2002:a0c:f00f:0:b0:68f:6df2:3b60 with SMTP id z15-20020a0cf00f000000b0068f6df23b60mr2351854qvk.20.1709048200270;
        Tue, 27 Feb 2024 07:36:40 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id og17-20020a056214429100b0068fe3170b0esm4259658qvb.11.2024.02.27.07.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 07:36:39 -0800 (PST)
Date: Tue, 27 Feb 2024 10:36:37 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, lvm-devel@lists.linux.dev
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <Zd4BhQ66dC_d7Mn0@redhat.com>
References: <20240223161247.3998821-1-hch@lst.de>
 <ZdjXsm9jwQlKpM87@redhat.com>
 <ZdjYJrKCLBF8Gw8D@redhat.com>
 <20240227151016.GC14335@lst.de>
 <Zd38193LQCpF3-D0@redhat.com>
 <20240227151734.GA14628@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227151734.GA14628@lst.de>

On Tue, Feb 27 2024 at 10:17P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Feb 27, 2024 at 10:16:39AM -0500, Mike Snitzer wrote:
> > That's the mainline issue a bunch of MD (and dm-raid) oriented
> > engineers are working hard to fix, they've been discussing on
> > linux-raid (with many iterations of proposed patches).
> > 
> > It regressed due to 6.8 MD changes (maybe earlier).
> 
> 
> Do you know if there is a way to skip specific tests to get a useful
> baseline value (and to complete the run?)

I only know to sprinkle 'skip' code around to explicitly force the
test to get skipped (e.g. in test/shell/, adding 'skip' at the top of
each test as needed).

But I've cc'd the lvm-devel mailing list in case there is an easier
way.
