Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F187E262BD;
	Sat,  3 Jan 2026 22:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767480631; cv=none; b=UUKTTHdNPLQ4Q4RM+GuGSqAD0z74/NBd2e7EYlRdRegrDikDYQWhQhMOXWXsOevE/Dmof5qbmC28gkYDkoXpTPA+keTBqoRO1JgNFblMFArz8PQ5o0MEW7B9aRP4BPskBNVWwLG6M5f/flNxZibR2yavyMwU21zfIVkdkRhj8O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767480631; c=relaxed/simple;
	bh=hn+0zZdvJlvu5sZ056JNmbyFertFtLTNjj7yOz+icOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqL5kfDJLoi5IKzjhuoVW1/9dU/BM7IyBs59giyPPqPj1ZnhimaqmMSdq4yRMqx7ypFDMUswL1hGFEdtQgw8jocVwqcAHBUe80vfSLMOtEtNxQlAY02/RU9NCUoGwNOAzhhjXrXVqz869bcLITxswN6MUw3A6LdiFpOTdJ59/Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PGa8EpQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PGa8EpQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D30C113D0;
	Sat,  3 Jan 2026 22:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767480630;
	bh=hn+0zZdvJlvu5sZ056JNmbyFertFtLTNjj7yOz+icOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PGa8EpQIcXxjsjQB2UG2qtmztDG+fg+drjofFl5HFAIt9KbTSsW2d0p5qDWmTKAMu
	 JFWlgBsDTm5OPjPusuzVoxwC4rrbAPXMZBup60y1exjjMWfZMHpG+SqvhKswC8Oecp
	 xhot8CEVErgwjIqaIG0BtNZuFG6iaO09tAnr+E0jGWXyDK2J9uU1clmhJTjSDuTZb0
	 pOmZOGtMn/r/uNoNUTiH0eVsyAZP/CMct89CYHOWHyz5VbtYUFybJAIA5e5t5WEMaS
	 mcnrJwkgAXhF1z/I4KzbHbycBBIFBopDSZr6XMHrF5LP2Nuk6oHRCfdmHTepJTL4Fq
	 pqoefFct1gH8A==
Date: Sat, 3 Jan 2026 17:50:28 -0500
From: Sasha Levin <sashal@kernel.org>
To: jaeyuel.im@lge.com
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org, loth.son@lge.com
Subject: Re: [PATCH v2] dm init: ensure block device is ready before creating
 mapped device
Message-ID: <aVmdNKfUCaRXT1WN@laps>
References: <20251212000955.171808-1-jaeyuel.im@lge.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251212000955.171808-1-jaeyuel.im@lge.com>

On Fri, Dec 12, 2025 at 12:09:55AM +0000, jaeyuel.im@lge.com wrote:
>From: "jaeyuel.im" <jaeyuel.im@lge.com>
>
>The current implementation of dm_init_init() uses early_lookup_bdev() to
>wait for the device node to appear. However, early_lookup_bdev() only
>verifies that the device node exists and returns the dev_t. It does not
>guarantee that the underlying block device structure is fully initialized
>and ready for I/O operations or to be opened.
>
>On certain platforms (e.g., embedded systems with specific storage
>drivers), this can lead to a race condition where dm_early_create()
>attempts to open the device immediately after early_lookup_bdev() returns,
>but fails because the device is not yet fully ready. This results in boot
>failures as the mapped device cannot be created.
>
>This patch adds an additional check using blkdev_get_no_open() after
>early_lookup_bdev() returns. This ensures that the struct block_device is
>actually available and the device is ready to be opened, effectively
>preventing the race condition.
>
>Changes in v2:
>- Pass autoload parameter for new blkdev_get_no_open()
>
>Signed-off-by: jaeyuel.im <jaeyuel.im@lge.com>
>---
> drivers/md/dm-init.c | 14 ++++++++++++++
> 1 file changed, 14 insertions(+)
>
>diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
>index b37bbe762500..b3905e094ffc 100644
>--- a/drivers/md/dm-init.c
>+++ b/drivers/md/dm-init.c
>@@ -296,10 +296,24 @@ static int __init dm_init_init(void)
> 	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
> 		if (waitfor[i]) {
> 			dev_t dev;
>+			struct block_device *bdev;
>
> 			DMINFO("waiting for device %s ...", waitfor[i]);
> 			while (early_lookup_bdev(waitfor[i], &dev))
> 				fsleep(5000);
>+
>+			/*
>+			 * early_lookup_bdev() only checks if the device node exists and
>+			 * returns the dev_t. It does not guarantee that the underlying
>+			 * block device is fully initialized and ready to be opened. On
>+			 * some platforms, this can lead to a race condition where
>+			 * dm_early_create() fails because the device is not yet ready.
>+			 * Ensure the block device is truly available by attempting to
>+			 * get it.
>+			 */
>+			while (!(bdev = blkdev_get_no_open(dev, false)))

This breaks the build when CONFIG_DM_INIT=y:

   drivers/md/dm-init.c:314:41: error: implicit declaration of function 'blkdev_get_no_open'; did you mean 'blkdev_get_zone_info'? [-Wimplicit-function-declaration]
     314 |                         while (!(bdev = blkdev_get_no_open(dev, false)))
   drivers/md/dm-init.c:316:25: error: implicit declaration of function 'blkdev_put_no_open' [-Wimplicit-function-declaration]
     316 |                         blkdev_put_no_open(bdev);

The problem is that blkdev_get_no_open() and blkdev_put_no_open() are declared
in block/blk.h, which is internal to the block layer and not accessible from
drivers/md/. These functions need to be exported to a public header, or
dm-init.c needs to use a different API.

-- 
Thanks,
Sasha
