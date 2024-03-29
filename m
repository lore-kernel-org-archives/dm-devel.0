Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF39F2C197
	for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 18:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711737158; cv=none; b=s+qDPzonQILgWqdpFYvYBRwXEZhjiQfTZFeb7f9pNVkttPRwX9wgFSylwK0hTHOhIdYR7og8Gn+EK1w+7bV/vCa2F9zyd1yHxF+sDvspORvYBzIRyivH2G9DVkpbCSfIk1PEGtmLI/tz+N/pFRkp7wH2WmAcMg6tnFLe07CbCMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711737158; c=relaxed/simple;
	bh=89P8xFdwNRsQGaELkVIPuf/jqJH5tKfLG5uP3475eNU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pEPoSqwfM9CYYY6MarIBA9KkVVFmmg4YOiG8MaAjRC9FSwIY5XOflo5KFOSC5Bl7UWM+g4k4Gy5YaXc7uKWehp/w61YDzvTMh5TwVFP+eFXdEO6+rjGoCCVxEAAjfica8DZA88pBdAMzG+OPyh4UzM0xhFI2fJg+fKIiNOXX9tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KZpld4Fv; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KZpld4Fv"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so451279a12.0
        for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 11:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711737154; x=1712341954; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/Tpqpd+XowKAeNmFVUx3aaouhXhfs+V2Z4XDOcPdis=;
        b=KZpld4FvB030kBlwxFhMAIUxaMtjv4rDty6dtqAGKr2tVpM2oQn4iG6MagqzgIIaZX
         tkQaTqZCmuGaa8XX2jR5pooDWbzScniKR/q1x6z1VnMeg/EhrHqSeBKAjeijHZVfFj1g
         5EuuO6Rbf87oEMC06zOxzPf4t5EZLdY9LxlvxafO57CbpCLzSlBSCg82TB+3JqnVTfq+
         OvwbZ6wQJjSpnLUVhUMXmTN/nVWSOFC13gi2djHfvWPKawvt3LInBTioX83qV2J1Fq0Y
         u1IcSWl7FAv5GQ0lnzmbQzblOyJDHO7e/1vAiJb3VK3ERlBYlsgL9taAmhkEf29oV6pA
         Qu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711737154; x=1712341954;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C/Tpqpd+XowKAeNmFVUx3aaouhXhfs+V2Z4XDOcPdis=;
        b=htknfjhnn5rgJA8lpoM1Cl95UL92q9t5hcVgk3vYMUiZe8iiIIO3akuAYLflS/Jt6/
         Q1cfvyeI2IgFDQbtlxOF5CkIVfBjkJr7l9ZhWKzqzHfIobUw+USPYeB7S+NArf6kvQLU
         CU15F7ENSSnuGUAP4vTnOJgwo+TmSLpyoa5kq6voEnI6B/kaQRvmlRDz2OicAU4KItHl
         mbGbP1ttWHLU4A1Te4z4aOtUOVScM3f020+kDbdxBcHu1KJTcxjx82QHZWtlTCa65LfV
         Emzv4HwILaMgytQ2nTEg0Nr7szM94yKjgS8tApo/M+9KGWpId5wKDh8fc9bLqMOl4NSk
         q4ug==
X-Forwarded-Encrypted: i=1; AJvYcCX0SKbscp3Drz1cZz0aUAjqbq0bo4UzCsGFLtaRxEeZ4wWjo2t3gOKeEacD6fmtOJolAQuvefFpWWyNkJm2zWpi/Fy1tukxREQ=
X-Gm-Message-State: AOJu0YwSI3/6jft4ntiuhJW5bpAFYB1hScR3+J/G7YTpQWueFAUPSTiR
	+jkSA6ycMoWli0dMO/HG9U1Ce38uHS5VwaxAEyvk7IakbLWTYxtStqsAgbAmVdXCnsBIhrKTSnn
	q
X-Google-Smtp-Source: AGHT+IGSjkQXsoReNcWtU/6vP8JEFFqWZTeD1QWgK0mtAmmxGqQBkW918F/Y7oP7x2jW69IsjahdEw==
X-Received: by 2002:a17:902:c255:b0:1de:e8ce:9d7a with SMTP id 21-20020a170902c25500b001dee8ce9d7amr3120790plg.5.1711737154073;
        Fri, 29 Mar 2024 11:32:34 -0700 (PDT)
Received: from [127.0.0.1] ([2620:10d:c090:600::1:a5ff])
        by smtp.gmail.com with ESMTPSA id l16-20020a170903121000b001e0c956f0dcsm3748761plh.213.2024.03.29.11.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 11:32:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 Matthew Sakai <msakai@redhat.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, dm-devel@lists.linux.dev, 
 cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-btrfs@vger.kernel.org
In-Reply-To: <20240328084147.2954434-1-hch@lst.de>
References: <20240328084147.2954434-1-hch@lst.de>
Subject: Re: add a bio_list_merge_init helper
Message-Id: <171173715281.870109.4128910475529577998.b4-ty@kernel.dk>
Date: Fri, 29 Mar 2024 12:32:32 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 28 Mar 2024 09:41:43 +0100, Christoph Hellwig wrote:
> the bio_list API is missing a helper that reinitializes the list
> spliced onto another one.  Add one to simplify the code similar
> to what the normal list.h can do.
> 
> Diffstat:
>  block/blk-cgroup.c            |    3 +--
>  drivers/md/dm-bio-prison-v2.c |    3 +--
>  drivers/md/dm-cache-target.c  |   12 ++++--------
>  drivers/md/dm-clone-target.c  |   14 +++++---------
>  drivers/md/dm-era-target.c    |    3 +--
>  drivers/md/dm-mpath.c         |    3 +--
>  drivers/md/dm-thin.c          |   12 +++---------
>  drivers/md/dm-vdo/data-vio.c  |    3 +--
>  drivers/md/dm-vdo/flush.c     |    3 +--
>  fs/btrfs/raid56.c             |    3 +--
>  include/linux/bio.h           |    7 +++++++
>  11 files changed, 26 insertions(+), 40 deletions(-)
> 
> [...]

Applied, thanks!

[1/4] block: add a bio_list_merge_init helper
      commit: 872fb30bf89598781d90bd2d6522f230cdf6494d
[2/4] blk-cgroup: use bio_list_merge_init
      commit: e19efc6e5d8ed46f407737033ffc0bdfe0b8dc67
[3/4] dm: use bio_list_merge_init
      commit: d35cd999db51da5706fc4d798b69e189b998ac4f
[4/4] btrfs use bio_list_merge_init
      commit: 5d363e4ee3cf8d4c4bc68956d89dcded30bc7e0c

Best regards,
-- 
Jens Axboe



