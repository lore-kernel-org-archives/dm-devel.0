Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B5D23758
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709666174; cv=none; b=UzPs6pVk1aTTXCpZDAk+FSdjyG/r5GEatc0eE5qQR8WHtdCkVzWL3CPOHpfDpNSL6dS1Mxcg/J2p0b1eQDc420KMo1uZ8COXQpcOrNvtlpcNY/sBoOBSfdYswrLHin3X341opVXPzKiWraZYwadSD14znNxCK06mvr3oPRYL7lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709666174; c=relaxed/simple;
	bh=oG8ZzpcnX77hmopTqVFecVNH8qHE11eP1MFgLsxgoyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxuiYCOXCIJg4uaR/OZ5OooT2itKXTzhH17PYxJzH71ZCRkkhB69RAxobHJzFE/3EMUyi9mOI9eKPNRJe1tauVrFDKXn8TYRikJvdJL0+FMult20XjFKPB4UW+dhs29hFlTPd9YQDqe3X5459ZQbK1rSXpIbuNiu9EFLIlC1kH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6905d51fdfbso959166d6.0
        for <dm-devel@lists.linux.dev>; Tue, 05 Mar 2024 11:16:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709666172; x=1710270972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8FIdcTmA+GbjII2/0pif/GDtFSocWhsyjRQ59DjG6JI=;
        b=jXmFO5LMJq3ThmmyaXTFevT/7trNpf0qh7MCQUe5JzViU69EtoNrxkWzijHBVh82tN
         wcrCfheTHoP9ug44Y98xUgtpCWtX7uds78REC6xWv0p8RlfzDs9/533aMz3OntftJrU4
         4fctFEPB4yKOjpvCMZ3bxzZ+3E5QVIfs3L+ZFXMOSb325Ex/6Mj7q44WZJWKRL1U3VEa
         RI1us7FTBzLUWYUxbepzmQbf66xXcsABYI5RuKAlq87yu1dkXcZydkBDJFFX7WqXbi+5
         zt6ZjgTsBQc+z2CkVuOcvXpxoJuFq35XNs+4xIgHyDYCEEMkw/pMlB/19vmLZCDAie5I
         q9eg==
X-Forwarded-Encrypted: i=1; AJvYcCWMP5iRSNnxdmQ7kKHNZOhYKbhdnJUQCoMJNKleZCjL/r2uFNRW8SnNr4HuOdjZ9vXalu/vChxUk6ELIft9wCNmOFiZ567c4mo=
X-Gm-Message-State: AOJu0YzYdlm3QxKhE37q88zkSngugw6pzFoMEmRAf4vbHy8SuEwKDJ3n
	Vul9X+ZydVL2+RvgG2GI9zYHBbFUxYuBlssP0dbA0i2CnqY/LT8ZZ2x+kVrZ9Q==
X-Google-Smtp-Source: AGHT+IEL+3tWSSmMgjjhlQqRSkh94vstTZRuMUA9188eeJ1xHRXP20UJ7IcU7d4VlKX8TvEEOREG6Q==
X-Received: by 2002:ad4:4045:0:b0:690:4e40:76f3 with SMTP id r5-20020ad44045000000b006904e4076f3mr4993697qvp.25.1709666171980;
        Tue, 05 Mar 2024 11:16:11 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ej19-20020ad45a53000000b0068f65b22b0fsm6540392qvb.82.2024.03.05.11.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 11:16:11 -0800 (PST)
Date: Tue, 5 Mar 2024 14:16:10 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Song Liu <songliubraving@meta.com>
Cc: linux-raid <linux-raid@vger.kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai1@huaweicloud.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Junxiao Bi <junxiao.bi@oracle.com>, Dan Moulding <dan@danm.net>,
	Song Liu <song@kernel.org>
Subject: Re: [GIT PULL] md-6.8 20240305
Message-ID: <Zedveg1t6VK-vNiO@redhat.com>
References: <2FCF4E06-B33B-44A8-95D7-8BA481313BB8@fb.com>
 <cbd5ed5f-f4f6-455f-aedd-98e41be70d92@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbd5ed5f-f4f6-455f-aedd-98e41be70d92@kernel.dk>

On Tue, Mar 05 2024 at  1:49P -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 3/5/24 11:47 AM, Song Liu wrote:
> > Hi Jens, 
> > 
> > Please consider pulling the following fixes for md-6.8 on top of your 
> > block-6.8 branch. This set fixes two issues:
> > 
> > 1. dmraid regression since 6.7 kernels. This issue was initially 
> >    reported in [1]. This set of fix has been reviewed and tested by
> >    md and dm folks. 
> > 
> > 2. raid5 hang since 6.7 kernel, reported in [2]. We haven't got a 
> >    better fix for this issue yet. This revert is a workaround. It has
> >    been applied to 6.7 stable kernels [3], and proved to be affective.
> >    We will look more into this issue for a better fix. 
> > 
> > We understand this is really last minute for the 6.8 release. But based 
> > on the data we have, these changes are safe and fix issues in the 6.8 
> > kernel. 
> 
> There's just no way we're doing this much at this late in the process,
> particularly when these are a) not introduced in the 6.8 cycle, and b)
> we're not even a week away from the merge window. Doing them now for 6.8
> would just further risk stability there, no matter how well it's tested,
> and it won't really reduce the time to stable anyway. Hence no, please
> add these to the 6.9 queue.

I agree.

Song, please revisit each commit's header to make sure they are
flagged for stable@ if appropriate (e.g. either add a Fixes: tag or
explicitly Cc: stable@).

Thanks,
Mike
