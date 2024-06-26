Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C641891AF
	for <dm-devel@lists.linux.dev>; Wed, 26 Jun 2024 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719414895; cv=none; b=WQBG8NG9aZIL4ewP4TyWKjUPplRIkvTL0dO9DxSURi1NqtxEUsN8L1GtPCvuxKkQhFirRgldutICehHOBpFOVddhjFEq4cJg+Cs5tIFv7s27XwLbOwlJR05lY3pYXqQ5zJIP1RCYa0KwGtKzq1zVXUq+rUwIPh5emDIzanf2djM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719414895; c=relaxed/simple;
	bh=bTL6Y2DEulOBxwrx74oiHr0lCWdB9/T+TOfCR6Xx908=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=eAfenZfkEvk2IJuZmzw/nddY6EYkb3EDRifGZAK/x+6astvdyLtBwlO+C5Hp5QJGOI1VmthbhfNJNi+qugx1HDcSipZi+rzX/aqQD+icCkk4yUt/WHnZ9Nz7h4fv6OPcV0QmaI+c9a8p4KuMH5Zw3/E4hjL9Wt4nvQhp4OyqrSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MWWuadX2; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MWWuadX2"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7068ca5a807so182506b3a.3
        for <dm-devel@lists.linux.dev>; Wed, 26 Jun 2024 08:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719414893; x=1720019693; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ejiLOCPjQYH7ACXd016xEl0yCudpyXAA5MF+cxuWv6M=;
        b=MWWuadX2rKimVd2LHRWgFxs+FYTQB+oGvxo/uTr4K4v/wBhSRkeDQKz2DG6JZBhWk+
         JicVahVks3RtNvpKMeqvNxXup4bsogLl3sXhhzcSJO9G8wuTR0/dqciWMcQD4bi4b4lN
         +V2KEEGIYNJ9lt+KWi8CTt/PWMdHucacRD5UlZuoV7cRsfiqSnoqfRFlI4U2KJRUzEAP
         vctOx2qMdvvMd/TAM6HRhrxUsZ/1bp8NbLPSW6T0j70ylb9LKxRFd+/hgVgTFa8Q2qhw
         sV+/xovZlW3VKZaZgJqMwGS94EYulnRtj7Cix1g1IEbTwIeFIKaPCKDPWkKfmwwY7xOV
         Q2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719414893; x=1720019693;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejiLOCPjQYH7ACXd016xEl0yCudpyXAA5MF+cxuWv6M=;
        b=PDA3exEy/0/9gqoRL2vsIUo5bWJFe4Kstg33G6ipJM4lIy8zr7z/cTYa8po7mKhNez
         xZ5B2wmf3JTfAxprCUn+Z9+nxZbmUOxBQuUN98apxvihrpfW74HbR3JmTkfLd4tiRlWL
         JAVqrRtpwIxiJi4sphngeCnx9eRacUr3nzLl+AsTsCFmhJr+X8AW20uaICgeWml3W0Ht
         bRElQcTv9ermAsdNUdO1boE5oOc5Wux+k9FhSvvUy270e+sYfxa12fJqQ1wZdCJY3i3a
         153tjJbsXvtzIJ72SWkZtQlWcJRNLe6zzEoAFB59q7UZyDQFw3Ui+RjqEsVkDBIbUK6T
         p/vQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqQh5cKnji8RxzxmvMGn/2abCel3WDmdrChAs8xlF70nJVXJPjbGTUakN5jWpwwvXazgyQIvLK4dXtOJLBri6AW1KcFSA9nro=
X-Gm-Message-State: AOJu0YyS8bXP0Jy8XHoN/We3YZC+bQJrG/a4UIsXkJAWFHkVWgmT4ND7
	ivG3YIwVsiRPyjr9aNSERPUYEuRviPTCbYylu0SzJJPelUv2ST66kAHGO6oztD8=
X-Google-Smtp-Source: AGHT+IFmzeqdqLg5SiV0tu6djto+9EcNyF5jowS1AcAqpWmkqpnRMXJ/vbnzGjN2TKNNd7d+87nUFA==
X-Received: by 2002:a05:6a00:6085:b0:705:d60f:e64e with SMTP id d2e1a72fcca58-70667e2b1cfmr12723111b3a.1.1719414893526;
        Wed, 26 Jun 2024 08:14:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7066c2ebd85sm8184326b3a.93.2024.06.26.08.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 08:14:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@kernel.org>, 
 Milan Broz <gmazyland@gmail.com>, Anuj gupta <anuj1072538@gmail.com>, 
 Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-nvme@lists.infradead.org
In-Reply-To: <719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com>
References: <719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com>
Subject: Re: (subset) [PATCH 0/2 v4] dm-crypt support for per-sector NVMe
 metadata
Message-Id: <171941489217.836289.13164322028417269597.b4-ty@kernel.dk>
Date: Wed, 26 Jun 2024 09:14:52 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Mon, 27 May 2024 17:39:14 +0200, Mikulas Patocka wrote:
> Here I'm resending the dm-crypt support for per-sector NVMe metadata. I
> made some changes to the first patch as suggested by Christoph Hellwig.
> 
> The first patch fixes a bug when splitting a bio with attached metadata.
> The second patch enables dm-crypt to use NVMe metadata for authenticated
> encryption. dm-crypt can run directly on NVMe without using dm-integrity.
> 
> [...]

Applied, thanks!

[1/2] block: change rq_integrity_vec to respect the iterator
      commit: cf546dd289e0f6d2594c25e2fb4e19ee67c6d988

Best regards,
-- 
Jens Axboe



