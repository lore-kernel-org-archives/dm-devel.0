Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9771573F02
	for <dm-devel@lists.linux.dev>; Thu, 22 Feb 2024 21:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708637093; cv=none; b=DEsuQzCVV5v71XnA99ZXvzxNvUgoy9hykepJ4Nc9awdr8kMDkww892riYb5rKsG/6EigBEF/X2YzEwTHmb5bgT1bO6z4w2YzeUEmuzVZGdMkVx1KkQ7Z2j0emnmht3lbgV27v9wsfm6S1UsP7f4HnzHOlM0aP1b3CtQpjSBeToU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708637093; c=relaxed/simple;
	bh=tXUpcTAJY+vi3vE9MWTEQBL5LoTKxp5Sis2ipx0eQX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UeTcLZlMcbdUefTxiFE27s1jd/BWe7aRZibcW2mK59Dy2lfa16xWLD6jpH5FzWB2UBOSMu9H1MnbbyqJD+bGPo8iQsxQu3K2LBghuo7sHsHmN7gjLsmKamNz8fbIEbSfeG7fUakIbTvEUPZD7MdRzZotgHlbbyAOo2X6upS83Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-68fb71fc886so1134706d6.3
        for <dm-devel@lists.linux.dev>; Thu, 22 Feb 2024 13:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708637087; x=1709241887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eq0QwZQY3YjWZ+VtYPNkWvBuXSdkd0s0ToaLbM0Gyng=;
        b=XOBdvbpCfOhJ2e/aEVFq78GSqNMT4HFGLLPq9ZaPpkwjICnIhTYu8vMHRPGwxsOU1u
         Q/4u+ipR6FmAoUzdaUHzZv4ll75AbzkjQAt4c0TdmEmwb7ARkvuy3Rv6E7Q1t3OcuDc0
         6CiSCkVP/dftRLP54sxIkyvuB1wQbTdabkdZf0YmC8l4I+Cm3K9Y+R+jfGnJu8zKvjeU
         dYQaa6jbaOQFV1S0EqYyJbn35EObqkEVPSDTEG3YPQDl2WgR8QCgfgu8oEn+G1z5eXf2
         8Sq0SzVTumHaEGSzrBmbnob9Q+xR6Iwp6k6Vsv1aCqhTMmszy5x+kcQWL5qgdMsCtVgu
         3stQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSdmo7zuYIU88IGUNE5u+ISy+dU0iStIdzolthx0nhGVAqZ8dMM9V2rLzJKuJWhYS5BUiNtsW7k8cQRKiYqFdFiBe268dAZ5w=
X-Gm-Message-State: AOJu0Yxek3hxqsBdgcOLFjYh9ebVXtDFJdD6F7x7A2JWpv9I0Q0Y4vZH
	j/pF0DT+cr46gEyjXxf6WnIke+uFtUoTkzSB6wsvtZ7mLi+Fr0ZnhIjlawos1A==
X-Google-Smtp-Source: AGHT+IGN01XI6hb44wNpdqumjqu4HGrAUjLE3qm5ShySTrAHxjvJp1IxMDc5obZgXCmLdXewj8STng==
X-Received: by 2002:a0c:f38c:0:b0:68f:2e24:615a with SMTP id i12-20020a0cf38c000000b0068f2e24615amr399836qvk.12.1708637087556;
        Thu, 22 Feb 2024 13:24:47 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id qm18-20020a056214569200b0068c88a31f1bsm1802546qvb.89.2024.02.22.13.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:24:46 -0800 (PST)
Date: Thu, 22 Feb 2024 16:24:45 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com,
	damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com,
	peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org,
	allen.lkml@gmail.com, kernel-team@meta.com,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/8] dm-verity: Convert from tasklet to BH workqueue
Message-ID: <Zde7nXVx8oFepINV@redhat.com>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-9-tj@kernel.org>
 <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com>
 <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
 <CAHk-=wjMz_1mb+WJsPhfp5VBNrM=o8f-x2=6UW2eK5n4DHff9g@mail.gmail.com>
 <ZbrgCPEolPJNfg1x@slm.duckdns.org>
 <ZbrjhJFMttj8lh3X@redhat.com>
 <ZdUBHQQEN5-9AHBe@redhat.com>
 <ZdUGFqLCpWez42Js@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdUGFqLCpWez42Js@slm.duckdns.org>

On Tue, Feb 20 2024 at  3:05P -0500,
Tejun Heo <tj@kernel.org> wrote:

> Hello, Mike.
> 
> On Tue, Feb 20, 2024 at 02:44:29PM -0500, Mike Snitzer wrote:
> > I'm not sure where things stand with the 6.9 workqueue changes to add
> > BH workqueue.  I had a look at your various branches and I'm not
> > seeing where you might have staged any conversion patches (like this
> > dm-verity one).
> 
> Yeah, the branch is for-6.9-bh-conversions in the wq tree but I haven't
> queued the DM patches yet. Wanted to make sure the perf signal from TCP
> conversion is okay first. FWIW, while Eric still has concerns, the initial
> test didn't show any appreciable regression with production memcache
> workload on our side.
> 
> > I just staged various unrelated dm-verity and dm-crypt 6.8 fixes from
> > Mikulas that I'll be sending to Linus later this week (for v6.8-rc6).
> > Those changes required rebasing 'dm-6.9' because of conflicts, here is
> > the dm-6.9 branch:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.9
> > 
> > So we'll definitely need to rebase your changes on dm-6.9 to convert
> > dm-crypt and dm-verity over to your BH workqueue.  Are you OK with
> > doing that or would you prefer I merge some 6.9 workqueue branch that
> > you have into dm-6.9? And then Mikulas and I work to make the required
> > DM target conversion changes?
> 
> Oh, if you don't mind, it'd be best if you could pull wq/for-6.9 into dm-6.9
> and do the conversions there.
> 
> Thank you.

I've rebased and made the changes available in this dm-6.9-bh-wq branch:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-6.9-bh-wq

I left them both DM conversion commits attributed to use despite the
rebase (and churn of renames I did in the dm-verity commit); hopefully
you're fine with that but if not I can split the renames out.

I successfully tested using the cryptsetup testsuite ('make check').
And I've also added these changes to linux-next, via linux-dm.git's
'for-next':
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

Mikulas, feel free to review/test and possibly add another patch for
dm-verity that only uses a single work_struct in struct dm_verity_io

Thanks,
Mike
