Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FBE264619
	for <dm-devel@lists.linux.dev>; Fri, 28 Nov 2025 06:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764310563; cv=none; b=sjWKleHHaibaXWIsLAlHuZJFgIAJGtjFhYPZRxsnrmEjjPoOv/iXqF5BVLPP8mFw/ajfTZbE37FtfE/pVOzmDjPdFkGmzt+WXoIhYS8+69TOA5sSzNVmiNtPUdE9f+yOhpUVm7v7KpNIWxvq3lKFnEuD3CzhHG7FgBMIFk6lDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764310563; c=relaxed/simple;
	bh=ffhTyij1ReNQCxTshYxvVfuBAAWHI7lGZdQHx3iN9O4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=tKn6SUnxXEAvG5TqPGayQIhg0trr9b273kTT2Bv+aU5JyBA+EHvpJCg8AypAIkKb9y5XlCGfri09u7BPKnoSc5TOFb93Awv2p4/vLbUX6yz6qMFrI0AgsjhTmffprvXyYcQRRzRvwOKBpjCbz8X03xj3T0sj3CrqKK+bSR/VcIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k3uHuvIu; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k3uHuvIu"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4777771ed1aso8369605e9.2
        for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 22:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764310559; x=1764915359; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GzOlZeoUbK5GrmA6UDcAo/pAL66N5+Wh7nDV2nIjmh4=;
        b=k3uHuvIutdL4qU0XPjswJl5cwmJ0qj2XRxeWScGWEINTqm6UxhYYku7T5+cyXfBSJz
         mrmkPrVjqvX6/TGvnjaWcQehs0yd9xbxmHkdQmsFdSjRXewQY1CmK/EDhbvlzm860P1v
         7O4C2o+edHFqHoiHIbU+ZPnk0V99+yB4MAX1kx2YXMACgt3YJThPWPE14nMUtdSBhLrH
         Dayxu+CW1/kttwTl+8G604H+kLgwJhBMySmv1qpVV7cDPc6/haUs7d/sUsFamKmf7k5J
         9acbGzMGgq4t6iUzyoxsUH7VjNqTeIbv/5nFeL58106YcPdRSxFgX+VlQmEoxyZ9F0vw
         7UoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764310559; x=1764915359;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GzOlZeoUbK5GrmA6UDcAo/pAL66N5+Wh7nDV2nIjmh4=;
        b=OGPvvFmZm93SsrZ7XDSHATXvT92Qu2ppcHvL8A8eWGOjwM50cJfM+MUBE7qMgrG9OO
         73clagHAF3TRMoZS/5+DeOZlpg5hygx9vD9S44VdW+oQAfwTnj/Px2eWCqSTi2HT8OHJ
         IJ1ZdR1e6FACGwF/VGRO/QxWHi+U2hFQJZdrG7d11QzTu1FPj4B3KCc0uvhqzru72F/F
         0pGirkVi9c7sg0ZdHsbT69juZaz69U1ToDE3YjxU+cQyt37/BUPwiHQ/qU+Oh1JDaug3
         KaXsn2w/HlJZ4bmLNgqIJ0b+f6RVmkrv507TBpYOBls492rKjWZA7nu8AJo++aJvF3DV
         hS6Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5sYbm5BMQkwvi0PVqcIFsGU5qgZ1XGayQ+W9LBsan+kDqfouQz2nuPxNHRTKhMBQhBNaHz9fr3g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxL2BZWl/XnAlWcHz7N8oZdEloLyXXk2svV4MfQGM5UMHRlGz3L
	C5MeIZoeUzWTYwQiHzmnKIE3LrY33l5ScFEuj0dGEiRGur1M3R8EXTm4QPPpeMf+Hfc=
X-Gm-Gg: ASbGncvvHCCogFtixQfIJP8mN956TemoR1d9jVIaX0HQ1ukvJ66fy6v0QNgfSkO9rNZ
	b/1mjrDnGN0RnuZ/594VKx5A9nbzZRTkbaWkmk1B4mav0EnEpuwRVBZBffJFf+BfI4OiHt4q1lR
	o3A/gv51NdxUAmYBPvIICNk+5PUuGwGP6+9AoKs9F+KsfwSZjtApv6ZyxkuOFdM0vbK79DSJX7L
	XOQvASDPvpnfRW1pCTuiv+rjQobYj1E+d74Z60X/PTZZKSAVDz/cEaxxvVUkjyu8jJ3NQp/3P7Z
	PBRFGMiRyASSGCCN02zU1R+Yr/s6Ta8rmkufuzqZnnQ9NAE8T/oJTlfXiMDNBHUeOADHCkZnr+h
	x+e06DEVAGdLtYNHOtdDfeMeE9jJsAnWO+q/VEPCeo74I/qjaE4NRAqcv8ShoIlFOeCsmSpYwZu
	N/0JdiikbMGyUCm/f7
X-Google-Smtp-Source: AGHT+IFdIuL1+ag2sXfLUM/g00Zb6LkyXzXLVWwOpnWTkJoN0WxuvEW4Ox+Z1MnircVKNp0kAljDVQ==
X-Received: by 2002:a05:600c:1c85:b0:471:9da:524c with SMTP id 5b1f17b1804b1-477c016eab5mr306888745e9.12.1764310558915;
        Thu, 27 Nov 2025 22:15:58 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-479040d81e4sm88057735e9.3.2025.11.27.22.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 22:15:58 -0800 (PST)
Date: Fri, 28 Nov 2025 09:15:54 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Keith Busch <kbusch@meta.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
	ebiggers@kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 3/3] dm-crypt: dynamic scatterlist for many segments
Message-ID: <202511281018.FNOzcP4r-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124170903.3931792-4-kbusch@meta.com>

Hi Keith,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-remove-stacking-default-dma_alignment/20251125-051340
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
patch link:    https://lore.kernel.org/r/20251124170903.3931792-4-kbusch%40meta.com
patch subject: [PATCHv2 3/3] dm-crypt: dynamic scatterlist for many segments
config: i386-randconfig-141-20251127 (https://download.01.org/0day-ci/archive/20251128/202511281018.FNOzcP4r-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202511281018.FNOzcP4r-lkp@intel.com/

New smatch warnings:
drivers/md/dm-crypt.c:1510 crypt_convert_block_skcipher() warn: was || intended here instead of &&?

vim +1510 drivers/md/dm-crypt.c

8f0009a225171c Milan Broz        2017-03-16  1499  	skcipher_request_set_crypt(req, sg_in, sg_out, cc->sector_size, iv);
3a7f6c990ad04e Milan Broz        2008-02-08  1500  
3a7f6c990ad04e Milan Broz        2008-02-08  1501  	if (bio_data_dir(ctx->bio_in) == WRITE)
bbdb23b5d69521 Herbert Xu        2016-01-24  1502  		r = crypto_skcipher_encrypt(req);
3a7f6c990ad04e Milan Broz        2008-02-08  1503  	else
bbdb23b5d69521 Herbert Xu        2016-01-24  1504  		r = crypto_skcipher_decrypt(req);
3a7f6c990ad04e Milan Broz        2008-02-08  1505  
2dc5327d3acb33 Milan Broz        2011-01-13  1506  	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
ef43aa38063a6b Milan Broz        2017-01-04  1507  		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
ef43aa38063a6b Milan Broz        2017-01-04  1508  
02664d2ac0d3cf Keith Busch       2025-11-24  1509  out:
02664d2ac0d3cf Keith Busch       2025-11-24 @1510  	if (r == -EINPROGRESS && r == -EBUSY) {
                                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Presumably || was intended as the warning suggests since it can't be
both.

02664d2ac0d3cf Keith Busch       2025-11-24  1511  		kfree(dmreq->__sg_in);
02664d2ac0d3cf Keith Busch       2025-11-24  1512  		kfree(dmreq->__sg_out);
02664d2ac0d3cf Keith Busch       2025-11-24  1513  		dmreq->__sg_in = NULL;
02664d2ac0d3cf Keith Busch       2025-11-24  1514  		dmreq->__sg_out = NULL;
02664d2ac0d3cf Keith Busch       2025-11-24  1515  	}
3a7f6c990ad04e Milan Broz        2008-02-08  1516  	return r;
01482b7671d014 Milan Broz        2008-02-08  1517  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

