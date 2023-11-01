Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A339C18E0D
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7789a4c01easo2849585a.0
        for <dm-devel@lists.linux.dev>; Wed, 01 Nov 2023 11:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698863290; x=1699468090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbraHScpAjzoS0M8nDOOEKlaOP4qg6lROvG1DxdhQQU=;
        b=n68xjHre16CSNOcnUyXj3nCaNKf36IPkpcpWTJVP1S18ddIiLcUqfbHYjDxenqooeG
         wM5+UZYkinpFsyaQEG7XBWWFe9x4lKtDgFC/ajFtFBBKEcJE0O1WhHwt5qrsgE48t9dw
         9Ur6ORqvqs/tRqxaNMTCqYThAc/sX3hWClA4jDeXNkXlLRJZwfOhDe1sFs5DoVcu9CiU
         Dz/M6qqjWMg3gZ23+Zajqe93rnfL2kzkUuOlkt9KQJz8sBXj7FIi5BK17ILLzNC1Kg1z
         DczO89mbw+fFSedZKkv6/1xr5IQDF3oBWArKwa7J0r5vdzEDCKCZChgr107mdbUT8vjk
         g9Fg==
X-Gm-Message-State: AOJu0YyhJK0hG0FdbNW2WEkXA91oXhQ1FudXm8SG4Fon7ZHjb91fj70d
	ySf9wCXuUE9kp8kC98GdRaje
X-Google-Smtp-Source: AGHT+IFuYhqolGh05xqnNdfZAmwuJH7T5XnlR7OKwXvDKM+T8xuftXsfTTR03//wtu+lZk4QjEuEJw==
X-Received: by 2002:a05:6214:dc7:b0:66d:2ae0:44cc with SMTP id 7-20020a0562140dc700b0066d2ae044ccmr24754552qvt.21.1698863290336;
        Wed, 01 Nov 2023 11:28:10 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a134500b0076f1d8b1c2dsm1663939qkl.12.2023.11.01.11.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 11:28:09 -0700 (PDT)
Date: Wed, 1 Nov 2023 14:28:08 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH v4 00/39] dm vdo: add the dm-vdo deduplication and
 compression DM target
Message-ID: <ZUKYuHcLu3syvvYG@redhat.com>
References: <20231026214136.1067410-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026214136.1067410-1-msakai@redhat.com>

On Thu, Oct 26 2023 at  5:40P -0400,
Matthew Sakai <msakai@redhat.com> wrote:

> The dm-vdo target provides inline deduplication, compression, zero-block
> elimination, and thin provisioning. A dm-vdo target can be backed by up to
> 256TB of storage, and can present a logical size of up to 4PB. This target
> was originally developed at Permabit Technology Corp. starting in 2009. It
> was first released in 2013 and has been used in production environments
> ever since. It was made open-source in 2017 after Permabit was acquired by
> Red Hat.
> 
> Because deduplication rates fall drastically as the block size increases, a
> vdo target has a maximum block size of 4KB. However, it can achieve
> deduplication rates of 254:1, i.e. up to 254 copies of a given 4KB block
> can reference a single 4KB of actual storage. It can achieve compression
> rates of 14:1. All zero blocks consume no storage at all.
> 
> https://github.com/dm-vdo/dm-linux contains the most recent dm-vdo updates.

I've rebased linux-dm.git's dm-vdo branch to reflect this v4 baseline
(rebased on dm-6.7).

And the dm-vdo-wip branch was rebased accordingly ontop of the dm-vdo
branch.

Mike
