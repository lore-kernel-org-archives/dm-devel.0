Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4ED26B95B
	for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869459; cv=none; b=jW8gUChvXMWJydwORwrJZ6SR49d+upSQmQHG6+kHygsyYjUgIBaw5xCblUVCI4p7fwKPdYc8mj6FijBrMYN9LZE2ue6xT77fXZYYuj4zjU0MOjP0+O7/AGt5I1lpM2I9hgj6eqNHyD7nqrRZD3AqEfgqOC0W+y9bCE+hBnxZPac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869459; c=relaxed/simple;
	bh=zNzBR/wZgvBggmWQ/khF4OFSadbAA0TH9VheG6vvXsI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AnHG1Map9xg2bSZkxdKdg0B+JhOLucOj74ODPPw9J/87FC4zpujQYy4aUEZbL5O09Jljgfm00o0Cj5HEbJBP7tQpe6CPxfKoq8t0MWWh+fqUwiXOGNcoKgFCAHaP3B34n7PuXJ6eCIu/YXUxGiA3Ro2hwnVSbLA2YrJ03s9aeG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CQ/I4jXZ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CQ/I4jXZ"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-236192f8770so1567995ad.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Jun 2025 09:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750869456; x=1751474256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMwMCyth2Egg/1nTuhCUVlgm1lii2/x1O3UKYqxEFzk=;
        b=CQ/I4jXZ1YoWbAJEEsqcrp9U0oIfe17ZgXqUCFWtlh2QCm4Gax2Xi43zMabos3iRRM
         Q2uSmKVBY9EbR4JjncgdKHvFIoP5B8a6IEIktTLZEQzA2qpuZ90DzNcXuPidAcMp5gLT
         NidfjH8UkPnfh8ntZn4T0rn7RgwMMMw+tH5CJ0hyGG4mZ/c4IC7OZLLLi7l8ZVZrnWU7
         Qz/98unBBxzlr62BoIb1VhCUIv9MN1ATBmLXJOtajDBLPGX7T3mKAwoB+F+UHB9SUAHd
         S3xqL6hO0v6SjaVjGpYUIrQJZ8BZeeO7Y8XzaayFI1cIdll1yDD74ODuNEfOfj22T4vt
         +mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750869456; x=1751474256;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMwMCyth2Egg/1nTuhCUVlgm1lii2/x1O3UKYqxEFzk=;
        b=MffdV1UKYIsbG4ExsTqirpQ0HpycARo5SpO4y/s24+p/pZkrFhS8ygp5QHr/kunPiU
         7JnKokLZSYaHJ+f+fIXuZ9yBtaWBXPSLZQ/CS8O15HYR3OemlgFT2opl9iJA+rzoLB/u
         UZsIVNv0QP6yfkE5a0N6M8kaX0QpAVGFb9Te11OhPtAwKjsE9uZa0K7I+7ickTH96f9f
         Wh2lS8reAZmYEusiP7Q5n8GWrjGgBIEbt9NvgCqkYOFozcwMLKeRWU1BdudtVYXD+b0g
         y4lO9LtfBD2eERbWXhejpuq+tJUm3Yrhi6Jtf8ivGtd3oKp9nPEsCGylqYcg0rdpIjf6
         0Jsw==
X-Forwarded-Encrypted: i=1; AJvYcCXId0IXpZnOY8od1IeLdjaeYpqQN1d2hqzzwqiKx1p76YSFdAdW4b3W3T3DkzBDBdCrTQtDG3pRhA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwUAl98jQKSetoPbAc4i8OAorH028SiZYUTR7yPkoe4rG50oFJs
	Z0tsGp/41KiXetE+H+YCEDkWSdtEljN71sgGZDOVxWTmAHr1sENgtEfwN4h1lJbC+5Y=
X-Gm-Gg: ASbGncuzHNxvRemvfiMcqjMnQV5YsiJ4f16xgHLpUZ5/htOkMjecaOYPqmkiyc8vLoo
	A5/51lzlWAsSs9c2W36QjVdWRxZPLyRKx3R8YdGBhgouNCsnoM5dv3Wq9zuw8tMkh+9Hw8ldKM4
	3aDqWx9MaVFWEWdr8gQTlYXIR+L3HTiZCc0JkWCUeA22zPhrMJjt08kRkU7H2BQqW/qTh96SZCS
	dVKs2qANIrLZndzBCONpBqA6LiAm4WvJK+wDSAoeiMZ3xskMDolA2uGCspDrt2u/lvbOGIXCU/W
	/QODi75HM0By3aodX5vOodYZpZwdItG5o1E9iDvOiYTCMxSQnFxnTQ==
X-Google-Smtp-Source: AGHT+IHKOBchkezkuA+yfLjfRpwjTNZtL5mBB+DBwdFO61OhOjFAEdtxhj2u3PMvrGVSnuNB6Jh+VA==
X-Received: by 2002:a17:903:23c3:b0:236:8b70:191b with SMTP id d9443c01a7336-238c8755cd0mr3022235ad.0.1750869456370;
        Wed, 25 Jun 2025 09:37:36 -0700 (PDT)
Received: from [127.0.0.1] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d81fbcb2sm134519865ad.0.2025.06.25.09.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 09:37:35 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250625093327.548866-1-dlemoal@kernel.org>
References: <20250625093327.548866-1-dlemoal@kernel.org>
Subject: Re: [PATCH v3 0/5] Fix write operation handling for zoned DM
 devices
Message-Id: <175086945525.168912.13714943214288580323.b4-ty@kernel.dk>
Date: Wed, 25 Jun 2025 10:37:35 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-d7477


On Wed, 25 Jun 2025 18:33:22 +0900, Damien Le Moal wrote:
> Jens, Mike, Mikulas,
> 
> Any zoned DM device using target drivers that internally split BIOs
> using dm_accept_partial_bio() can cause deadlocks with concurrent queue
> freeze operations. Furthermore, target splitting write operations used
> to emulate zone append requests break the emulation. This patch series
> addresses both issues by forcing DM to split BIOs to the DM device
> limits before passing the BIOs to the target map() function, and by
> avoiding calls to dm_accept_partial_bio() for Zoned DM targets that use
> zone append emulation.
> 
> [...]

Applied, thanks!

[1/5] block: Make REQ_OP_ZONE_FINISH a write operation
      commit: 24cb7af081023bbb7a25ae514e6e2b398d4ab25c
[2/5] block: Introduce bio_needs_zone_write_plugging()
      commit: bf7a8b5cbbb2d531f3336be2186af0c5590d157c
[3/5] dm: Always split write BIOs to zoned device limits
      commit: 74e93dbcd320a8e9d5f7b3f238eedc7da6d6ca7e
[4/5] dm: dm-crypt: Do not partially accept write BIOs with zoned targets
      commit: 0277a0d91194b79b4a3db0c53ba205a933554695
[5/5] dm: Check for forbidden splitting of zone write operations
      commit: e04a33a18fdb259d7ad3673ddfce6112f5ce30fd

Best regards,
-- 
Jens Axboe



