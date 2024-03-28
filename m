Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7147B12FF95
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 23:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711667127; cv=none; b=lBJ8FumgQ5AV3XOgkWQSvUvfyjdLbdhXZE8NYXijCP3+0pQ4qeZKDiro0AgnCDT8XpE8iMHywtl+n3bDN5dsKcnVlphMCxJAR6lgM+XJVU1OrdQnmwwB8U0Jwm/LFmhgpK5yWWwIl/m5P7erMKxSUPvxXA0PhwFkSeBd2LyD9ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711667127; c=relaxed/simple;
	bh=RR1NsxYBYOM1Y/zktRAsa3HBsBJLbkk3BP9brZN7qiU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OnWz9vFWQnTSVRP5KvE73VMWQ9XeJeE8c/fWosrJw8aqyCeTNCOT2F6FXtqt/b6ny2kIS1Gh3XUoTvx7zOIxzW7yySgB7N/CgGFRjgss8mVED9Hxvuc7cRFBj4uYIzlPs0YVXFsfsR/KWA5CSYlqlmObTrqv2swPhYhaKZlJCPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QPneIhE+; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QPneIhE+"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1dd3c6c8dbbso2197965ad.1
        for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 16:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711667126; x=1712271926; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jH6cSamYqu9y6NrHpddafX7jLWVjJSO+MIjSmesZ7SQ=;
        b=QPneIhE+wrWKWRa1Lwzk1MdYdBbBA+6G8h5r9b0bk5wxRn9jotDIPyAOZ1NOMtW/Vf
         gMaCUmpj3ku0VhFsp3Lagmh50l72c8MZf131vNU9VSNoSTa3/sk+nftUEDLHo3OGKfjT
         92TnKdsdllXQBSAJNzNDvf7XVrnTNbKHdW5hbWP/cXX3DZO8W5DBqFqF4JUfsQ2DVf8B
         WS0rQLUoXfUjDXwtZ5mrlYvv2qNLy2VgtCxiQiUy7DvNw2lccGuDpbRi0QF9oGX9Vp8J
         EDdCBlJ3lEMjTT3Un9rFTjgH9ZepaSANXJWF642bdy31LzpJs/Sd0+dXHplI6zOgrUmm
         ss+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711667126; x=1712271926;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jH6cSamYqu9y6NrHpddafX7jLWVjJSO+MIjSmesZ7SQ=;
        b=koVsf3UuHRAhRn+0k5kqwpR3+LRAzMliRVlWoRQ2Y18mgp5BhfuVMxvOyEnLoLvadO
         NaNIK6R/exmH1C0+xbu8MvJEnW3NQjrqHx3jz2pRM5kqvyuIURz/07LErV9QZgikzHuS
         uf64OKBxGJcIWEho6fiw1mVOZB7/izpYZvDpRT1vgxVpTD1momGKNLq+wwBoNhSB04Li
         +6NgIKAXPten7vzsA+fRLN5rnoFTCZ7AinK49DPaxvp9lVCK6T+IsBDNlpfzyt7nyjij
         6EdfapgYGOVeYwH2Jdc78TldRLcCB5c5906tP5KLGSjTDFHgCyiO16BeGbl0DM98WzV3
         a4HA==
X-Forwarded-Encrypted: i=1; AJvYcCUigHFoFqn3iu+DDcGJQ98LrLnkj2AnsjRXd9nWvgE3kjZeH+wSzUwfKtYPetS597nWzz7JfoRpHKJx6XAYlQ0FSmRLqEaJ72I=
X-Gm-Message-State: AOJu0Yz5v0pBXAKFPSevD/h1OpvyPHbz/RyJRg6uA+RLg6efIImS2VhZ
	+T+RdalzGrTHYeaEpSLKHKMcQ89eAnlfnBJDIbQ7Ld3WMHpcqZbEj1UeBHXVzb8=
X-Google-Smtp-Source: AGHT+IFz2PM05uHbkjHCxEwx7ITQmcuHmP+Q9onJ6IDFb8FdZ5M8mwUFVEVXNdLv1bOXS14zB6XpZg==
X-Received: by 2002:a17:90a:77cb:b0:29c:7487:43b8 with SMTP id e11-20020a17090a77cb00b0029c748743b8mr839839pjs.1.1711667125810;
        Thu, 28 Mar 2024 16:05:25 -0700 (PDT)
Received: from [127.0.0.1] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id cx18-20020a17090afd9200b0029d7e7b7b41sm4013902pjb.33.2024.03.28.16.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:05:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>, 
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
Subject: Re: (subset) [PATCH v3 00/30] Zone write plugging
Message-Id: <171166712406.796545.15002324421306835511.b4-ty@kernel.dk>
Date: Thu, 28 Mar 2024 17:05:24 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 28 Mar 2024 09:43:39 +0900, Damien Le Moal wrote:
> The patch series introduces zone write plugging (ZWP) as the new
> mechanism to control the ordering of writes to zoned block devices.
> ZWP replaces zone write locking (ZWL) which is implemented only by
> mq-deadline today. ZWP also allows emulating zone append operations
> using regular writes for zoned devices that do not natively support this
> operation (e.g. SMR HDDs). This patch series removes the scsi disk
> driver and device mapper zone append emulation to use ZWP emulation.
> 
> [...]

Applied, thanks!

[01/30] block: Do not force full zone append completion in req_bio_endio()
        commit: 55251fbdf0146c252ceff146a1bb145546f3e034

Best regards,
-- 
Jens Axboe



