Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D8195FF0
	for <dm-devel@lists.linux.dev>; Tue, 10 Sep 2024 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725996590; cv=none; b=SEzuKM3dnPwB25/8reJ16joYP360QUeNU6qaxx4Ddq4WVKqr4Z2DAcXXIXa91b3gSgKlks0dC3j+DIYFt2hC5CZpsjLHkMcchsoj4GiXmq2M0cyp7lTu/d1q3vLed8XSgOtfIiMbCwZYdRzmoocW96cvlrctrCOsTh6HAOXeqoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725996590; c=relaxed/simple;
	bh=zrWzVDTbwoZ36Fq8r2pqBUOr/YVhP/nQKVd2pjfRto8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0YfxilgGk1mijsYZ5uzhHNxYnLfz9oS5qsrgePrEVTH2K3PFT45Iu5y27ibmyLbYuw85CwBDCT2eDkAHZkKKapRmdFyq+vFqAWD0QwDGr5UX21HILhuvzuopWCFxNhBrD1Owpt2q5eYyrNE9XeMBYkvvxRTqrDaCEg+LevgfcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jxFoPRKF; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jxFoPRKF"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42cb2191107so24712655e9.1
        for <dm-devel@lists.linux.dev>; Tue, 10 Sep 2024 12:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725996586; x=1726601386; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=74xKJ54lv/8s3jPtFBrmEDDeV1HNO3ZP6zqx4/HVpbU=;
        b=jxFoPRKFvWrLservdYOQPZAdhm+BVdXITbIZG4phCQ7gyKERHobTzCP2Gyf0GbRYnA
         MM0j5OVbPiGHHStJMSmVXLmh6ag8tewb4Cyoj22PKm68k7mG+GSQFgOlhwF9n9F/z82p
         nRAey043lvsJg2kCu0nYVRnz/YqDfj6nhuBRgsCz0B5nYTf8pknCh+4i/Xq/pUWLfCmi
         FcwxZiOLW07/V8NO7GGbJaK0V2/I/TsUF+BTYwPNNpxvf20xDxeLWeetT0d60OCdZsdC
         XVy9zL8GzL7q9p4IfiDZSmeOP7DQ0ue1i9goqBRITWzvm8z3852u7LZE5YrgwSxDOtu2
         07SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725996586; x=1726601386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74xKJ54lv/8s3jPtFBrmEDDeV1HNO3ZP6zqx4/HVpbU=;
        b=uLuZq+YQmdTirbgg23ya76BolVhXAidBXU6w0hG/6mO/s8okGMACQRlOuhtv6ntYYC
         8GUWXctBDIgl6dq0jAeX7DIDIrjCpEXUc/n/B+TkflzVh/bizBhRuY9dbMN18SfvKe2W
         iJ++lgUA15RBqImuxiHOd6Z7aYS5zySIhZOamD693T07v44btFfqKahSZ9Tq0RF8cPgV
         Gbi6WFDvZ0NvgxExPDZ6xgWoecgbyw6xFoBarIS3dFe8K/ZQqZJ1lok81fMrvxXtVvXC
         J8XafL/2dL7URHJRlz8VzNYt9qzx7LtcnBQTFWWtsrmY1JkU9X4jzrTkcF0LQsIZr8K6
         48/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWl13NIUqjE7fyXXvAngPvASAmvZA//g/I9YBAdHg2EIfGL3Az54njcXKDTqlncPpzIST7+3g2ZCA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqmjsXG5eoXDK/6nc04HQ2/0dQ9X3D7ZaqV23ihPGaaCV36yto
	tvnS0H5dJYWo8EbrgSckD227wNl5Tucv/YOJCBOKt+dYumsd95WfOTkXd3LzeXQ=
X-Google-Smtp-Source: AGHT+IHcwxH4lQaumeSORspB9q6XbiPImR0VCNKtbYPCZI7jzOvi+Tz8sm4XgEXli0IqpFD5pny+dw==
X-Received: by 2002:a05:600c:1550:b0:427:abed:3602 with SMTP id 5b1f17b1804b1-42cad87efd3mr94036065e9.24.1725996586420;
        Tue, 10 Sep 2024 12:29:46 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb449aesm120799955e9.25.2024.09.10.12.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 12:29:46 -0700 (PDT)
Date: Tue, 10 Sep 2024 22:29:41 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] dm-integrity: check mac_size against HASH_MAX_DIGESTSIZE
 in sb_mac()
Message-ID: <54d895ab-3735-47c9-8418-2310eb11dd8d@stanley.mountain>
References: <20240910175259.28620-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910175259.28620-1-ebiggers@kernel.org>

On Tue, Sep 10, 2024 at 10:52:59AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> sb_mac() verifies that the superblock + MAC don't exceed 512 bytes.
> Because the superblock is currently 64 bytes, this really verifies
> mac_size <= 448.  This confuses smatch into thinking that mac_size may
> be as large as 448, which is inconsistent with the later code that
> assumes the MAC fits in a buffer of size HASH_MAX_DIGESTSIZE (64).
> 
> In fact mac_size <= HASH_MAX_DIGESTSIZE is guaranteed by the crypto API,
> as that is the whole point of HASH_MAX_DIGESTSIZE.  But, let's be
> defensive and explicitly check for this.  This suppresses the false
> positive smatch warning.  It does not fix an actual bug.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202409061401.44rtN1bh-lkp@intel.com/
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

This works.  Another option would be to just delete the SECTOR_SIZE check, but
this is obviously more conservative.  ;)

regards,
dan carpenter


