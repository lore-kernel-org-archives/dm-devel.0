Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370843C46E
	for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707752501; cv=none; b=jxG2sNEB+060PCWuFNPWv7maI7fIbWH6TqNvOPh2NqPRg5iZJY3DAU2yEKeSOZk/RrGcIy/Wenpi8bxu81eM1Lfpn7ebExn3MeN2ZfzOYz2DOWMh9bfWvufuzPnnfZR30vwG86hoQeEQiQRKqcbq3uMH+HQuKMmuop3CVSHWW+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707752501; c=relaxed/simple;
	bh=rvBLEOBpcb9d59U2CHqDALH8dS8IUh6n3YOhvzkSpgs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=t/7KHlLgzPjn1gxIWcRv3BMRQlO6J9oK41uQaWyYKyRkOIXlCgtJRdhWDXSaKVsqd2Z5DluOIXX7Q5WgtPCa0EtmilPpIbH8OaMug3fYaExQNV9CuYXQXcTipk5CTBB4eNodTxc0ASklkEtcdKOa5Hm/2Bu0uQcww2XmPtp0lKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cfpXyu50; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cfpXyu50"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-363f0a9cf87so5403255ab.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Feb 2024 07:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707752498; x=1708357298; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0mXhrpRS+p0F3dgHMjFx7EMsz8T+uz8plxGpEvyFag=;
        b=cfpXyu50Wdrf2vRcT82tk11VLIE+cfe4W2DB5miEF0lgMe1Zp594AqZkFciej19+Di
         pI+oSCwJDGR+LS0BMAU4TMihiWlnwyGrApt+HWNDnKchvnmnDyz+0c2Qv6PNXSpMSrN6
         YO0UiBdV9xOsfV85bf69a9axthQkOc9cZLXJbe1iHQl5WU7Rd7O5zHGy15wow80JqW/g
         bHWzcreqh5FVFpaKgA9QwBHwTi0qTrT50PuiABQYAbJ41qMLWk9s9FSQCBkmnnq8r4w+
         6ynR4kE2ilnK2VKQiZnMvwCoYsSH3OwFzluoCl+nXoD5Z+46YGugu/gSHjiLLbnOwZJf
         gSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707752498; x=1708357298;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0mXhrpRS+p0F3dgHMjFx7EMsz8T+uz8plxGpEvyFag=;
        b=RQg2jqVvn5OCKPWOQco/hsQATSD9WkyRBlR/ZiYrHKfjIM4on6TexsqgHVol5FbKzI
         rjdvEoB07FymTXBn9G81u7xEHuEXi/xaqqm9AhhbZ0uqNeB5Yj4j48+qWWeSWv/t/WPQ
         aAAKiBXmTqJFtb63WQ35NSZwYgjXMkB1DuZPlLmJb75nSm0MbL9ZhHDklxY8AHjfyOl3
         21Hln6TmaHNwjol6bs4c4O6djCwKpME9GJQYjd7HoMDJlHEtDqn5NWGdJTspJUMkPQeD
         z0Fga3ka1HjJwFraYqK7EKKpti3iTrBRjbzagiMhjjIDKmY061NzUYHBTRFyc+6iiKLU
         exDg==
X-Forwarded-Encrypted: i=1; AJvYcCWoqybUpQGCRLXAPdHqEt5Y+RoLsnST3rw3yQ03yeqE3y3Pl5ZdO31SWMWFpJQcGugI0V0st+yX0TUYpodh2SfIfswLsLitGHE=
X-Gm-Message-State: AOJu0YznpgfRhQtjgNDdD1OEVkBGaNdJ3E+Sm/VFRppoDZL0d09WoW70
	sVyMgHxPud1GbBgHT+2glx1q+gxYU7dilyeqQK0cdGX3KYnwtQUF4GIXIhCQCeo=
X-Google-Smtp-Source: AGHT+IEnm3ePbL8fRCn1bW7XxydRwFQeu0nYxrSBLL9n45bkvISdrumwN+YpZk9VT+q4F3sMK0GEkg==
X-Received: by 2002:a05:6602:1235:b0:7c4:4e3d:36ce with SMTP id z21-20020a056602123500b007c44e3d36cemr6321073iot.0.1707752498059;
        Mon, 12 Feb 2024 07:41:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWnVzGOtmdX7AszrJhRBwMaathZlE7sOIhhmBCZ172Waj/mNt1jVoILjXxsGEIpU2TQcVluLp7cNz/UtFbkni0EEdCOEBsy/xjyiNN/ght5OTEHQGRjxcAlTGlfhtrYbg3hw+98adb+8nL6IVMAAdlU5lTU5EMAAbXgYb1397xO6lrjdnnTP69LWHcEoBVSq9uifg1lQQ9Ljz/8jHJ3IKlWa5Mx1nZXHyLPSF1uiYtAt13KF5itfaSyN9/vDJFXPojaV54onxtzBNZLDWpmBUHVv6moas9okmEo0rIUPz456FSRkUNBLBCQlDnRzZMpsaO/RZkw+TBhPRGJA1oLMS5He4v/Ih2pvl6T9uB988xPxT+TKw7HrN6VyXeP2HkOu+x92KwNyb1cX7tCV7BZ8axVukDGWSvzLjHyfNghSq6t5+2VF2GvOLv8pcXWDwCiqCxajdZ8jKz0iLniEYWXEpLOzgVKGnWA5Kl1UiZvYR8PslSJ7A6DIv7vFdsrJOdn/B9UWWWz2VH4LT+taUOVnIfIddOSfNHB78L9qrXbAmYHMPq7wmT7+C8mZQVNJDyqZwF0UBwGVxnx11Jn9i4gYo/B389dXczXZ8oahlKZYLTMuN0na4Xb4SUUEogYLcOT+oFjiYIu7JWMeiTv
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d62-20020a0285c4000000b0047148f44e27sm1464516jai.2.2024.02.12.07.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 07:41:37 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Chao Yu <chao@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
In-Reply-To: <20240128-zonefs_nofs-v3-0-ae3b7c8def61@wdc.com>
References: <20240128-zonefs_nofs-v3-0-ae3b7c8def61@wdc.com>
Subject: Re: [PATCH v3 0/5] block: remove gfp_mask for blkdev_zone_mgmt()
Message-Id: <170775249673.1914864.6863373275533824749.b4-ty@kernel.dk>
Date: Mon, 12 Feb 2024 08:41:36 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Sun, 28 Jan 2024 23:52:15 -0800, Johannes Thumshirn wrote:
> Fueled by the LSFMM discussion on removing GFP_NOFS initiated by Willy,
> I've looked into the sole GFP_NOFS allocation in zonefs. As it turned out,
> it is only done for zone management commands and can be removed.
> 
> After digging into more callers of blkdev_zone_mgmt() I came to the
> conclusion that the gfp_mask parameter can be removed alltogether.
> 
> [...]

Applied, thanks!

[1/5] zonefs: pass GFP_KERNEL to blkdev_zone_mgmt() call
      commit: 9105ce591b424771b1502ef9836ca7953c3e0af4
[2/5] dm: dm-zoned: guard blkdev_zone_mgmt with noio scope
      commit: 218082010aceb40b5495ebc30028ede6e30ee755
[3/5] btrfs: zoned: call blkdev_zone_mgmt in nofs scope
      commit: d9d556755f16f6af8d1d8ebac38b83a9263394c5
[4/5] f2fs: guard blkdev_zone_mgmt with nofs scope
      commit: 147ec1c60e3273d21ea1f212c6636f231d6d2771
[5/5] block: remove gfp_flags from blkdev_zone_mgmt
      commit: 71f4ecdbb42addf82b01b734b122a02707fed521

Best regards,
-- 
Jens Axboe



