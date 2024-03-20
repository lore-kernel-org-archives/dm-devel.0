Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79085C43
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 21:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710971782; cv=none; b=Imj1BkEOt1Px4s3pj/6Xl68ARDNDrERg0iDPSmgVih+/nN+L54WRKCkibq+Gw6PyozAd1Mv27gcnDKZCoWhhf6LmuXsadEqK2N8lgjts0Ozdhjra9I70p3Xow8p6Vt7FzY+MrDjUEcgpWwhUsQLwuzsJLYsw2E6upFRSf2JKYHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710971782; c=relaxed/simple;
	bh=3Y9zpf1wfvY5KLBzI213sJGWxjZ+o1dGQveIv1ywB5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=eZSECV07zQOyycN5nZB69MJS/KO5/+vhkaCDPLvzt3yknCONm5hpFmmDw7rbEkTAVXNWIqY+gP0Kc/baShnYfIoC88zsLdC2FdSEqx5SHW9vgvjmmXPZmbRbAX/MDtj4e8E1oX7pQMLWWpTAIxmq/1tX9VgKAribGCecxODsghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=efficientek.com; spf=pass smtp.mailfrom=efficientek.com; dkim=pass (2048-bit key) header.d=efficientek-com.20230601.gappssmtp.com header.i=@efficientek-com.20230601.gappssmtp.com header.b=B7FheXcn; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=efficientek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficientek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficientek-com.20230601.gappssmtp.com header.i=@efficientek-com.20230601.gappssmtp.com header.b="B7FheXcn"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2220a3b3871so175697fac.2
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 14:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=efficientek-com.20230601.gappssmtp.com; s=20230601; t=1710971779; x=1711576579; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:reply-to:message-id:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NwLRl82njW9qOCI08DiI0Mi6Z9GVC805nkZi5Fy+J9U=;
        b=B7FheXcnKRSQltsgwss/xy4ULIj7AGTXncr0tR87jORu1rdANbvvmgLfQ1d24GV9rr
         693i0H5Ccu7ldNJ7lT4ECRHkfvlq3Yv7pwRyCseK90yHQBmOVqp3qw1lXucz81oFPoZm
         /7eaykz8OSZgqAqltgPe9/Ci/n5eiIBVuVSABxHseCjFVz/IbQsQ3Oj5Ry2g8ztHci2m
         hCw9/nkTslWDX2GvFmJAT2dRHdyQKUE8vIEOSd2sfcbIXLW8ucdQmYmmj9/CGsaRvk9N
         CqRyA5Dc/oNkOQisPm6jbLhljtIX3Use04Hj8HcEhtnuRTtHFtuWs9JaBVUg80tnYzUD
         Hmaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710971779; x=1711576579;
        h=content-transfer-encoding:mime-version:reply-to:message-id:subject
         :cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwLRl82njW9qOCI08DiI0Mi6Z9GVC805nkZi5Fy+J9U=;
        b=JTt3kmMN7bhnrwof09jsM8cygvHO0SwWr8qu3X9yotJkurmyXUpMj9+eCGyLTLofsP
         5DwYHXj9Ajhuc51h8bkm5XG2nq+nt54PQ+ZgPdsvsdUCjkIRduRX7c0MZgd7pJCZcxXP
         z4SFN9nJP1p/NI7EBHh5SVFsY2wzmOnfzeSQHOE95Vcy6Ku3do6iEekDNABApSrERu6U
         LFrY5FJEWj37KJSwhMD4KQJgVcvroX+5bDnvlSx6X93o47qj9mhyV59fa4VRS/dLDyHx
         /MBy7+rbs3GMbO9j1tl35wVmj64Q6yA5Mi5JOUuaCd4htPP2VT++BLDKYZ4TetXRa3Y0
         Gv1Q==
X-Gm-Message-State: AOJu0Yyd2fgMFdgauYSjb4bLZDEQthl0Br2rlNlT5G1q/NshCcR6J7JV
	wb4fGRa7oCVEZ+UDQ/1u0r9GtcNxmBROQCPdK8HH7MsuSLxuFTdhTjIKZu944JCqHLtH3vsLXq0
	=
X-Google-Smtp-Source: AGHT+IERVnHDyCRKMbKQ1CvMqRQ1iTEgmI48bTHDG/oAkD5At/lDqY2l5505tlZOZPPXI9jhbAQZAQ==
X-Received: by 2002:a05:6870:6195:b0:220:99bf:c26d with SMTP id a21-20020a056870619500b0022099bfc26dmr397339oah.9.1710971779086;
        Wed, 20 Mar 2024 14:56:19 -0700 (PDT)
Received: from crass-HP-ZBook-15-G2 ([204.13.164.84])
        by smtp.gmail.com with ESMTPSA id lb3-20020a056a004f0300b006e664031f10sm12270964pfb.51.2024.03.20.14.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 14:56:18 -0700 (PDT)
Date: Wed, 20 Mar 2024 16:56:09 -0500
From: Glenn Washburn <development@efficientek.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Cannot create dm-linear or dm-crypt mapping on scsi or mmc block
 device if mapping already exists on partition of device
Message-ID: <20240320165339.1c6b4d39@crass-HP-ZBook-15-G2>
Reply-To: development@efficientek.com
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Saludos,

I've hit some unexpected behavior that is not intuitive and might be
considered a bug. A dm-linear or dm-crypt (possibly others) mapping is
attempted to be created on a scsi or mmc block device (again, possibly
others) when there already exists a mapping on a sub block device, the
mapping creation will fail with EBUSY.  Here's a concrete example:

# dmsetup create --concise "dm-test,,,ro,0 8 linear /dev/sda1 0"
# dmsetup create --concise "dm-test2,,,ro,0 4 linear /dev/sda1 2"
# dmsetup create --concise "dm-test3,,,ro,0 4 linear /dev/sda 2"
[  968.046906] device-mapper: table: 252:2: linear: Device lookup failed (-EBUSY)
[  968.047305] device-mapper: ioctl: error adding target to table
device-mapper: reload ioctl on dm-test3 (252:2) failed: Device or resource busy
Command failed.
# dmsetup create --concise "dm-test4,,,ro,0 4 linear ${DEV}2 8"
# dmsetup table --show
dm-test: 0 8 linear 8:1 0
dm-test2: 0 4 linear 8:1 2
dm-test4: 0 4 linear 8:2 8

The second command shows that dm-linear has no issues with creating an
overlapping mapping on the same device. It makes little sense that the
third command fails where the second and fourth succeed. Further testing
shows that if there is an existing linear mapping on the full block device,
then mappings fail to be created on any partition block devices. This has
been tested on scsi and mmc devices. It is also true for the dm-crypt
target and mixing dm-linear and dm-crypt mappings. I've tested on Ubuntu's
6.8.1 test kernel. I doubt this is affected by any Ubuntu patching, but
perhaps someone could confirm this on a vanilla kernel.

I noticed this because I tried to create a dm-linear mapping of a scsi
device to capture sectors not contained in a partition, but it failed
because I already had a dm-crypt mapping on a partition of the device.

Any ideas what's going on? Are there good reasons for this behavior that
I'm unaware of? I've done some searching but haven't found it having been
reported anywhere. If this has been discussed, please point me in that
direction.

Glenn
