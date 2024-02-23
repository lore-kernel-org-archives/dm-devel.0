Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E47E13B799
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709931; cv=none; b=lKh4wH+Ti0Btvos8UzdXLcVDdoDyIhd3YFOe2kkkg9j/2VEBQ4+Pad/ILpaKvr0kXz1e0Ax9jepQkL3VYnankeJfjASW9/aUsyO1NOl/G8sxBSSAA6iy/geght78O27l9TN+amM/AEvGgfV6sV0t/JW6D0iWusKqImT7rFP26Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709931; c=relaxed/simple;
	bh=Z/tdiaswOuMsSTRlFl5mttaDTcPlAJAfMp9lCRul4/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0WrpRdYYaAznvD7YMvGpz49sXyi9Nn9Wst5kd5quqOPYN7uQJk96i3IyXXd0zvONX28OG1YzMhKpK5lhcmtvp0FXNevCQYasCrmK8V6v7krkEwhqg1FppVBJE5UQ18d4PIgCLeLj2ZI1mRzrLRkYX6wfKq1TXMW5McozAeN8aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-68fb74416ccso2207856d6.1
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 09:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708709928; x=1709314728;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCNe9P9R3KM2Wz7dyxOARVXFpXUPwCv2nJ79gu715Oo=;
        b=bCy9lAAi/1jc6hBetnB8rTJrga4XTuU6BPNmPaTOGtWRWGuH80BddwD/FUuutjajFN
         tN8LxgUyaZQY5CEsRznW76A0BfKhstbkSAuDNGVxVHYsemasNiVPCBQLdSnzRp6ezT5H
         iH6THDHwj9IaPmV+KkSFTepgvx9cODUN6l7N+4VJ2FQLtIXbGiIwl4bWy13Xc5JqXBbj
         AZZMBBcCrA8NmCVkZRjySVxwGka5NydC2b/TqknKkwCoGCH/1W93slp+EQ6USb4lWxBZ
         8ynlU3Ucgtj03Rn19Ym0MT97PecdBxyRH01On4vn1wDK73U3qtjvETOvE5K9pYQup4y4
         pNhA==
X-Forwarded-Encrypted: i=1; AJvYcCUOSLUnWrvWPamClAkJeB6wxsbfeUM2KUjGIwZggPaMIQaaioV/ut97Z44RgOTyTbuWREQqwS6aZujLwSjaGPX437FUkgRW2I0=
X-Gm-Message-State: AOJu0YxI0yVbKcRo9/sn+eGYOTkTCTOqKhEg/z9LSmVtoiH158Lpbi31
	EVykwhXojkKglorIuUqYO8d+2JtzjVE0abRJyGvzs9E0BiR+c7xf6Sv/5jXBiw==
X-Google-Smtp-Source: AGHT+IGF+Ro5/2nuXSC4XxQgxIIQm9FF6ynywuJ5yuC7Xd0v9EMLQoNBpeBIKcvB3nktkuYP8GeMBg==
X-Received: by 2002:a0c:b699:0:b0:68f:d215:2e16 with SMTP id u25-20020a0cb699000000b0068fd2152e16mr416761qvd.43.1708709928288;
        Fri, 23 Feb 2024 09:38:48 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ng9-20020a0562143bc900b0068f455083fbsm8119452qvb.63.2024.02.23.09.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 09:38:47 -0800 (PST)
Date: Fri, 23 Feb 2024 12:38:46 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <ZdjYJrKCLBF8Gw8D@redhat.com>
References: <20240223161247.3998821-1-hch@lst.de>
 <ZdjXsm9jwQlKpM87@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdjXsm9jwQlKpM87@redhat.com>

On Fri, Feb 23 2024 at 12:36P -0500,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Fri, Feb 23 2024 at 11:12P -0500,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Hi all,
> > 
> > this series adds new helpers for the atomic queue limit update
> > functionality and then switches dm and md over to it.  The dm switch is
> > pretty trivial as it was basically implementing the model by hand
> > already, md is a bit more work.
> > 
> > I've run the mdadm testsuite, and it has the same (rather large) number
> > of failures as the baseline.  I've still not managed to get the dm
> > testuite running unfortunately, but it survives xfstests which exercises
> > quite a few dm targets and blktests.
> 
> Which DM testsuite are you trying?  There is the old ruby-based
> "device-mapper-test-suite", and a newer one written in python which
> should hopefully be less hassle to setup and run, see:
> https://github.com/jthornber/dmtest-python

Also, you can use the lvm2 source code's testsuite to get really solid
DM test coverge (particularly for changes in this patchset which is
dealing with setting limits at device creation).

Mike
