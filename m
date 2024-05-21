Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE741442E3
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716305388; cv=none; b=mYYLvlFCkq0Z3r4vSEnpujvXif9dcWzcVRemBIidR+mjp2rB1Spj4D1n7qo/UqdcZVJQSN+mQjo/d5OrmgHCv+/iO8+dzCcp5IqsRtnv8Q/4r65tU3nzLReGIKSe6eIh6d4KlRdxBWPMKc+IRZK1Deor2wuG8vmHQ518ZPVVDAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716305388; c=relaxed/simple;
	bh=UvH4ktnL1tc7jDTG/u5fqTldApC2eZfE4ZdoJUo2544=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5KU+pOu5PKejT6AnZ+szpbqhPHTONj/KW/mElbU6bUHBbP+d1hohq5XjmngUn1pI7GxIPVIPVP2/pdJ+b0w2zVaQbqyvE8GYmc8ymyDmL62t+G0BF2d9sX1t30oofcM9fw667+6sqnaJg3pJiLwDLqfhERFD0oHuFdDJIwwNDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-79305314956so20975485a.3
        for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 08:29:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716305385; x=1716910185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3+XPV7zuv4ms1R7vIYpXPZzY3GXErYi4LFqsxLAG47I=;
        b=TkX44yAOp3rx5oeI7Bib6SI4Jp3tjvbn8gG5orUKBSc59xd9eA9dFPXVo6A2xuUI1e
         wtlNIEHDaOjop+kOuT1TjJONHWDn2tKecaNtrrhhdhPWXQDX6esNMAsIBzfjwtG0utJl
         LdZ+qjaTH/Z9mBByfjMoPjuVWEMbNWhh7Pam9+m8HvZcOOlMaDI4cFoJ/ClBpbHYJsaD
         NjS8KNYpVozORCKlccNbnt0GNrJtzvc4A7MjycCOY017U3MaI4qDei0f/tdst6SHfKwn
         0LXMWWW6VUF/71td1vzHt43ltKG+zwwVgU0T3ryydb2neXUGAVCchPr1AS6F8Osjy8S6
         lrAQ==
X-Gm-Message-State: AOJu0YzKXHp1j3kSL3ga03dW25ZLUJi39+86hHSpoec62izERsksb7rU
	UPsRKoLFsRdfC1NeDzLO+aXTGc+C6k+qQrGEFUCadv3x2uJQ0MKYoZXv3Rs1ScI=
X-Google-Smtp-Source: AGHT+IF8uzIllLEK1FILZCyeg/sSMiPh8GED2VV5AYcL1qdc3iolbJlLULo4eghby1CQfxaYqUkGog==
X-Received: by 2002:a05:620a:244a:b0:790:797d:2c4a with SMTP id af79cd13be357-792c75763e2mr3967911485a.14.1716305385299;
        Tue, 21 May 2024 08:29:45 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2fc789sm1291554285a.93.2024.05.21.08.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 08:29:44 -0700 (PDT)
Date: Tue, 21 May 2024 11:29:43 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>
Cc: dm-devel@lists.linux.dev, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, regressions@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: dm: use queue_limits_set
Message-ID: <Zky951XVqcqI48P3@kernel.org>
References: <ZkmIpCRaZE0237OH@kernel.org>
 <ZkmRKPfPeX3c138f@kernel.org>
 <20240520150653.GA32461@lst.de>
 <ZktuojMrQWH9MQJO@kernel.org>
 <20240520154425.GB1104@lst.de>
 <ZktyTYKySaauFcQT@kernel.org>
 <ZkuFuqo3dNw8bOA2@kernel.org>
 <20240520201237.GA6235@lst.de>
 <ZkvIn73jAqz94LjI@kernel.org>
 <ZkvuqNXaNOMe6Gfj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkvuqNXaNOMe6Gfj@kernel.org>

On Mon, May 20, 2024 at 08:45:28PM -0400, Mike Snitzer wrote:
> On Mon, May 20, 2024 at 06:03:11PM -0400, Mike Snitzer wrote:
> > On Mon, May 20, 2024 at 10:12:37PM +0200, Christoph Hellwig wrote:
> > > On Mon, May 20, 2024 at 01:17:46PM -0400, Mike Snitzer wrote:
> > > > Doubt there was anything in fstests setting max discard user limit
> > > > (max_user_discard_sectors) in Ted's case. blk_set_stacking_limits()
> > > > sets max_user_discard_sectors to UINT_MAX, so given the use of
> > > > min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors) I
> > > > suspect blk_stack_limits() stacks up max_discard_sectors to match the
> > > > underlying storage's max_hw_discard_sectors.
> > > > 
> > > > And max_hw_discard_sectors exceeds BIO_PRISON_MAX_RANGE, resulting in
> > > > dm_cell_key_has_valid_range() triggering on:
> > > > WARN_ON_ONCE(key->block_end - key->block_begin > BIO_PRISON_MAX_RANGE)
> > > 
> > > Oh, that makes more sense.
> > > 
> > > I think you just want to set the max_hw_discard_sectors limit before
> > > stacking in the lower device limits so that they can only lower it.
> > > 
> > > (and in the long run we should just stop stacking the limits except
> > > for request based dm which really needs it)
> > 
> > This is what I staged, I cannot send a patch out right now.. 
> > 
> > Ted if you need the patch in email (rather than from linux-dm.git) I
> > can send it later tonight.  Please see:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.10&id=825d8bbd2f32cb229c3b6653bd454832c3c20acb
> 
> From: Mike Snitzer <snitzer@kernel.org>
> Date: Mon, 20 May 2024 13:34:06 -0400
> Subject: [PATCH] dm: always manage discard support in terms of max_hw_discard_sectors
> 
> Commit 4f563a64732d ("block: add a max_user_discard_sectors queue
> limit") changed block core to set max_discard_sectors to:
>  min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors)
> 
> Since commit 1c0e720228ad ("dm: use queue_limits_set") it was reported
> dm-thinp was failing in a few fstests (generic/347 and generic/405)
> with the first WARN_ON_ONCE in dm_cell_key_has_valid_range() being
> reported, e.g.:
> WARNING: CPU: 1 PID: 30 at drivers/md/dm-bio-prison-v1.c:128 dm_cell_key_has_valid_range+0x3d/0x50
> 
> blk_set_stacking_limits() sets max_user_discard_sectors to UINT_MAX,
> so given how block core now sets max_discard_sectors (detailed above)
> it follows that blk_stack_limits() stacks up the underlying device's
> max_hw_discard_sectors and max_discard_sectors is set to match it. If
> max_hw_discard_sectors exceeds dm's BIO_PRISON_MAX_RANGE, then
> dm_cell_key_has_valid_range() will trigger the warning with:
> WARN_ON_ONCE(key->block_end - key->block_begin > BIO_PRISON_MAX_RANGE)
> 
> Aside from this warning, the discard will fail.  Fix this and other DM
> issues by governing discard support in terms of max_hw_discard_sectors
> instead of max_discard_sectors.
> 
> Reported-by: Theodore Ts'o <tytso@mit.edu>
> Fixes: 1c0e720228ad ("dm: use queue_limits_set")
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

With this patch applied, I verified xfstests generic/347 and
generic/405 no longer trigger the dm_cell_key_has_valid_range
WARN_ON_ONCE.  I'm sending the fix to Linus now.
