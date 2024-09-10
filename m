Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2830F1A4F31
	for <dm-devel@lists.linux.dev>; Tue, 10 Sep 2024 18:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725993702; cv=none; b=dUGnunwDpN30oJqvs3xsAEzuzTCVIern+LGZ+qkzL0ShAv2qB7lnsjnaoy63CkXMK5Xn5jcCxbYAgfV3mrvzr/a55NLKkzzgbXI2bQ+UHRT1DRmSGexT6Pryp4Thvwe8XgTCZ7qnh26W/ociMcIdhsqVZZ/i7od8vRRC4HNZzXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725993702; c=relaxed/simple;
	bh=BWmo7iSKtODxk30hoO0cSTCVls5lhJji1P4AIkMyan0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEubI5LEq8uM2OarrFO+Iw2LEcwRZAAQz6MT6uiDVMK0oB165hqrBs9Afo3LSofivcOMB8rTZ2nMmYXDn4KPwDQUSgftwBwOT8VFTd6JxUoSkXGO50w+R2btewGNZhuanGZpMucbdZUujVf8QwRKK8JcRIFnQB+6/dEoPzEGr3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZIcZ6Kz8; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZIcZ6Kz8"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42cafda818aso33768915e9.2
        for <dm-devel@lists.linux.dev>; Tue, 10 Sep 2024 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725993698; x=1726598498; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9PL5Tl2Mwr8imabb3mrABTELpbfGgfF2GcjdAezlDk=;
        b=ZIcZ6Kz8wErA7MBFgirU6vC5KfUMr0zi1a3lpLGc8z939pEXgOQCweCC0AdF4M5tjG
         d8MNieDotvYzW6XhA4vHUdRhXvsMTzbE6WtQJqbHAzVr9wXfPL9QGtJDohnIz22phklv
         jFlgQ4rIgFEw8gw4nj+Ja156ok762VVerSzd36oir6JKUn8Tb8q2NL6lEB/96Ma0qu+/
         JKEKl8bdYcz+yrh8cde7Tl3zjsHHVGj73QsliOcXRBsp2JVEaVPsgBg37J2ZtcSSlMBG
         cdMwKnWlB70wzl9w3wzCm7pmQhyqDI0tNlo35yVpikuMOaoBYpHrLLGesfZVEwoT9G2I
         hTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725993698; x=1726598498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9PL5Tl2Mwr8imabb3mrABTELpbfGgfF2GcjdAezlDk=;
        b=XEBay+dzdt8S2G7rhCES0KeKkPkw5wICF03A3H4Q6R0Xq73uI+SyDPwzqoVQLU2cuC
         I0t7RBU2v6+ITT7ytOV8fjhw46O3y9HvaJDocuWaENmILo7bCF0/R/zPA3NIzW1etMfa
         mAPNyXLqsqzdd6v9WQq6h5q9n6IBnV60ffUtVdI/SNB2BdNq8jFhpgSDjnmAJVarCyez
         1G1NshL9acF9DGe2dOOmpi6gzravZtOuXBFEAuujLUkNAqaGElVUc50NOP9MvP9HSmxv
         +q7CJpxUOaZh38IIKouGpgZXv9wMzx0+Ovn4olzqcxuTrhyT15QaRFsbKKQdiwd65aaE
         rCOA==
X-Forwarded-Encrypted: i=1; AJvYcCWcpA7BIVQm8moenI5k4ygwvY2VELYdh6qL3bsCBXS/hu29I4/IYKXjJKe34mCFi0U0/xS0r8qRZA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxdzLbuEpUZn6s/Ctqd6XkPHRQtKCRGReYPk/VtmCWIi0L84mS7
	a+JJL8YHG1ohHijgip3S+MwpTKNelMEcILI0/sJhIL9uHxv/9NniIRwjMxzaT0g=
X-Google-Smtp-Source: AGHT+IHtloX3WqASwCkacjxrSNiWqVc1JRchMQnG3IFI7ixq90XKVKnIRhzzHkwvO4dBvtOs4eh9Kg==
X-Received: by 2002:a5d:4c8b:0:b0:373:b87:55d8 with SMTP id ffacd0b85a97d-378895c549amr8702023f8f.3.1725993698324;
        Tue, 10 Sep 2024 11:41:38 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378956d3765sm9604350f8f.74.2024.09.10.11.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 11:41:38 -0700 (PDT)
Date: Tue, 10 Sep 2024 21:41:34 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: oe-kbuild@lists.linux.dev, lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: drivers/md/dm-integrity.c:521 sb_mac() error: __builtin_memcmp()
 'actual_mac' too small (64 vs 448)
Message-ID: <d09d8b14-9ea8-4802-9c37-2cd60a75b0fa@stanley.mountain>
References: <e8c80d61-2c74-4b50-ab50-2cf1291df9bc@stanley.mountain>
 <20240910172001.GD2642@sol.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910172001.GD2642@sol.localdomain>

On Tue, Sep 10, 2024 at 10:20:01AM -0700, Eric Biggers wrote:
> [+Cc dm-devel@lists.linux.dev]
> 
> On Tue, Sep 10, 2024 at 10:31:56AM +0300, Dan Carpenter wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   b831f83e40a24f07c8dcba5be408d93beedc820f
> > commit: 070bb43ab01e891db1b742d4ddd7291c7f8d7022 dm integrity: use crypto_shash_digest() in sb_mac()
> 
> This commit seems unrelated, as the alleged issue existed in the code before
> that commit too (maybe smatch just didn't notice it yet).
> 
> > date:   10 months ago
> > config: i386-randconfig-141-20240906 (https://download.01.org/0day-ci/archive/20240906/202409061401.44rtN1bh-lkp@intel.com/config)
> > compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > | Closes: https://lore.kernel.org/r/202409061401.44rtN1bh-lkp@intel.com/
> > 
> > smatch warnings:
> > drivers/md/dm-integrity.c:521 sb_mac() error: __builtin_memcmp() 'actual_mac' too small (64 vs 448)
> > 
> > vim +/actual_mac +521 drivers/md/dm-integrity.c
> > 
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  492  static int sb_mac(struct dm_integrity_c *ic, bool wr)
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  493  {
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  494  	SHASH_DESC_ON_STACK(desc, ic->journal_mac);
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  495  	int r;
> > 070bb43ab01e89 Eric Biggers      2023-10-28  496  	unsigned int mac_size = crypto_shash_digestsize(ic->journal_mac);
> > 070bb43ab01e89 Eric Biggers      2023-10-28  497  	__u8 *sb = (__u8 *)ic->sb;
> > 070bb43ab01e89 Eric Biggers      2023-10-28  498  	__u8 *mac = sb + (1 << SECTOR_SHIFT) - mac_size;
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  499  
> > 070bb43ab01e89 Eric Biggers      2023-10-28  500  	if (sizeof(struct superblock) + mac_size > 1 << SECTOR_SHIFT) {
> > 
> > This is paired with the line before and prevents the subtraction from going
> > negative.  It limits the mac_size to 0-448.  Is it reasonable to have a mac_size
> > which is > HASH_MAX_DIGESTSIZE (64)?
> 
> crypto_shash_digestsize() cannot return a value greater than HASH_MAX_DIGESTSIZE
> because the crypto API doesn't allow registering any hash algorithms with
> digests larger than that.  That's the whole point of HASH_MAX_DIGESTSIZE.
> 
> > This buffer is only 64 bytes.
> 
> Yes.
> 
> > 0ef0b4717aa684 Heinz Mauelshagen 2023-02-01  515  
> > 070bb43ab01e89 Eric Biggers      2023-10-28  516  		r = crypto_shash_digest(desc, sb, mac - sb, actual_mac);
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  517  		if (unlikely(r < 0)) {
> > 070bb43ab01e89 Eric Biggers      2023-10-28  518  			dm_integrity_io_error(ic, "crypto_shash_digest", r);
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  519  			return r;
> > 09d85f8d8909ec Mikulas Patocka   2021-01-21  520  		}
> > 070bb43ab01e89 Eric Biggers      2023-10-28 @521  		if (memcmp(mac, actual_mac, mac_size)) {
> >                                                                                 ^^^^^^^^^^
> > Read overflow.
> 
> No, because mac_size <= 64.
> 
> We might as well explicitly check that in the code to suppress the static
> analysis warning (I'll send a patch), but it's not fixing an actual bug.

Generally, we try avoid silencing warnings just for silencing them unless it
makes the code more readable.

The other way to silence this warning would be to delete the check on line 500
because if it can't be larger than 64 then it can't be larger than 448.  It's
not like SECTOR_SIZE is going to get smaller in the future.

regards,
dan carpenter

