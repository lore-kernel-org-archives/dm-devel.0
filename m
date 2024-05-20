Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F003A29A
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 22:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716242596; cv=none; b=aThfGU0izx9FOq7IbDOs+jUWawpSE4wXhHSLW2A1u/tnUnyrgfBS+3yO7hhEVbojp9kilpuumOdSPbArflwLsfXYIINsj5wOfFWF1RlS1xWJVdk7b1L8odHMvq1AqCGOCUNfxkksYY+X/WTZmheJwZ8Qbj471uWyhkkoO0fNjhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716242596; c=relaxed/simple;
	bh=UVljutfoWopCdRjUsE3nyQBe0vyYLt1LjMCS4mpMGr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQEnIzXfdlTCq72h+UgjmVPn5L8rGn4d692q8Uwiz+DrLZPMrXK1DhfSxlaC2rtf1rwTmqyNekWlTyUNSjf02at5YuETW5Iw/phQsBBKCNnIts7qq1e9zY56+3OeE1A196mt5m5ihdT6/fWRLL5B3l24B7HSNO/0PoaRbRy4SAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-43df23e034cso29149591cf.0
        for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 15:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716242594; x=1716847394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuxhBJ4qisQVuZrq+vvIeMKpTLFAeiOz1b8+2ahYk6E=;
        b=DLBOtuygwAA98TNQ0BL0jdkJjCdYNsc+oO9qvfYoMUdNwBywfMUA+F1JJ+1QWFrNFE
         BMIKL4fdAgS7UebjI1wE0bbPX+BNT3JEjM0apRUUlCleAY6HjzFwh0HO9rkSKdIKyBZf
         O3l3K7KPi/I8a+qZu3PrXQYVuQ1x+URIkPKjAhNdj0HYi+ig32rOLdTsg/VRzsbltLRU
         mDjsUJ99whpzH+mo0BlpE9r6C6rG0KTKs1aNUjBxPL5FroQj8DiT2DHTyS5QmTqH4bMP
         eR/3QRycFfDkuuql8OM6tpji2EiZkqBmoO0kXOU/8Y9W6B4Nxq4Ids677HtArVdZJw2m
         Ch8w==
X-Gm-Message-State: AOJu0YzJhPBntQpYKH3ifJYYgNyILMdA5ujScndYpo9UVCZyTYDbW45K
	RNzKYH5X+KV+QgiY6Zr59MMLVCXNfIJvWqq+TYOLntIhxhO2kmdlvVq7Ny0Gxfw=
X-Google-Smtp-Source: AGHT+IHkgbqiVU0lW4qUTrQXwo9y7zvN2ZZUxBT9G8J+CnypXz8b/pWVZjl3dkIURNrt2XouM39MlQ==
X-Received: by 2002:a05:622a:60f:b0:43a:357c:322a with SMTP id d75a77b69052e-43f7a303ce0mr149884241cf.34.1716242594272;
        Mon, 20 May 2024 15:03:14 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43f7a8dae94sm37851681cf.33.2024.05.20.15.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 May 2024 15:03:13 -0700 (PDT)
Date: Mon, 20 May 2024 18:03:11 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>
Cc: dm-devel@lists.linux.dev, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, regressions@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: dm: use queue_limits_set
Message-ID: <ZkvIn73jAqz94LjI@kernel.org>
References: <20240518022646.GA450709@mit.edu>
 <ZkmIpCRaZE0237OH@kernel.org>
 <ZkmRKPfPeX3c138f@kernel.org>
 <20240520150653.GA32461@lst.de>
 <ZktuojMrQWH9MQJO@kernel.org>
 <20240520154425.GB1104@lst.de>
 <ZktyTYKySaauFcQT@kernel.org>
 <ZkuFuqo3dNw8bOA2@kernel.org>
 <20240520201237.GA6235@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520201237.GA6235@lst.de>

On Mon, May 20, 2024 at 10:12:37PM +0200, Christoph Hellwig wrote:
> On Mon, May 20, 2024 at 01:17:46PM -0400, Mike Snitzer wrote:
> > Doubt there was anything in fstests setting max discard user limit
> > (max_user_discard_sectors) in Ted's case. blk_set_stacking_limits()
> > sets max_user_discard_sectors to UINT_MAX, so given the use of
> > min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors) I
> > suspect blk_stack_limits() stacks up max_discard_sectors to match the
> > underlying storage's max_hw_discard_sectors.
> > 
> > And max_hw_discard_sectors exceeds BIO_PRISON_MAX_RANGE, resulting in
> > dm_cell_key_has_valid_range() triggering on:
> > WARN_ON_ONCE(key->block_end - key->block_begin > BIO_PRISON_MAX_RANGE)
> 
> Oh, that makes more sense.
> 
> I think you just want to set the max_hw_discard_sectors limit before
> stacking in the lower device limits so that they can only lower it.
> 
> (and in the long run we should just stop stacking the limits except
> for request based dm which really needs it)

This is what I staged, I cannot send a patch out right now.. 

Ted if you need the patch in email (rather than from linux-dm.git) I
can send it later tonight.  Please see:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.10&id=825d8bbd2f32cb229c3b6653bd454832c3c20acb
