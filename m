Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E8D22334
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713365108; cv=none; b=U52EzBQj9l5/MPvH//vU3lg2cH3fYF5WsibRy8xdcMWoRZ0iT1R4CmqH6TBmqL211u9qs9p3uQCFJpqHUBQ7mEtTqNv29DBELEUy5cC2LGAmpl6c563hkp0BLQzP0Kutqir8+tsr4NyNz/OAf9392nKJLF9l05rxSd7uUuQy+gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713365108; c=relaxed/simple;
	bh=y1s9g8JMQaHSJ4n26wscCGHs2lvTNYLTQzw/P8zNfFE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ThwdtvWPaB5N7ApmhKhPe9ax280jvPusUO4NE+LD+X4K/wJRmHP4wtBEerEBvT3M/4cKAk+gIr6bVfcEQ2tAIa6bZ7RrvGCV+5bxlpK0a9xluMdu/smNyRfT+Cm1iHv/DTg2KpMzEWl59Qa/nUBeoZfLi60VN0+mJUOOoiO02WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uj1sOgGN; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uj1sOgGN"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7d9c78d108eso16062439f.3
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 07:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713365104; x=1713969904; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3imiXOhpbNzRxvj4fv0vsBxkQ4hjyHoSIAvra1r780I=;
        b=uj1sOgGNhwO5ywQpt/4qz92Y8NiaCrSFKafeB6+k25CJNtsrND4i6vAll5ZIFCvYh1
         KSK+8ZGTs3hQQ7wEJzlTzixeJuYhXzzLQuR1roJmKdNDUrWaluQc60jOasWyY6z6XZmO
         noNBxvXYO684iM2HsK6YkEG5JHtusNhaK9TEYv2ufQVs4WueOOoSnxdA7rs0G+eDd+ot
         DDDuiyIpnWKml73L6gY0iqwMKeSv1WGFsyL7/QvY+MRbNd/T0Vl182WKwQRTu6jLdU5R
         nES5j3lzwE/ig3OoWcLyETIIChGUlkAVXJtk5zwl8tv3YzkMa6mPqKyEicG5fdpTlz7Z
         NtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713365104; x=1713969904;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3imiXOhpbNzRxvj4fv0vsBxkQ4hjyHoSIAvra1r780I=;
        b=VcklDxP83+CVHGEqx1og1F2m7sNbu9lP7WFxwmBOwsLXLlu49E+nXcymseUXdhpWWh
         m2LMOosbG6bLCE3UMqs32cr6t/MeeHt/xohgyWzQ0EbQR24E3QCzKf3C1SUSSFa6MJJS
         KmcLD0H1XX+CrIItRNftYS2i6+VrYnPuIw/ddutDoXo1D5of2NPjSRIwgtrtYvZWDDle
         0qhTpEvXGRHwVpSBPkNblO9TnxeZz0jcfJv5yXfRNxWEpyPIB4ibUjj4c8al8c0D11kK
         emUIXFg4xbm+YACt3IDscg1OzduMQYNtRQm+6VRT8B04VRfbt8ehRU7WDZNwHQNABZ7i
         JC0A==
X-Forwarded-Encrypted: i=1; AJvYcCXz8X4UqoQLmJ42X0sJx9WpDNXCn60HUCd1v97PLNFtQreTAFUPfT5BQUHpVU8yKmGey0pe8dQ9VEcWBsMt/jBBGOQNitYaqlA=
X-Gm-Message-State: AOJu0YwarAjKkJdm30N6wBVmpiKgIgGrL79Pg4UBrB0f/YsyWrbmlQOT
	O0CWSQjJFeOkH9U92Y+Bu8DPkn+WNVgtHilnES01AstArRH60WNBQbMGfspxqK8=
X-Google-Smtp-Source: AGHT+IF0fdXNTAkJe0fRhzf9wvKPogLBbJtbaeMkiaL/Yy1YZ3LxzMQBRxxj8FFwz/o+EVr6wvaCXw==
X-Received: by 2002:a92:c14d:0:b0:36a:3ee8:b9f0 with SMTP id b13-20020a92c14d000000b0036a3ee8b9f0mr13764398ilh.0.1713365104702;
        Wed, 17 Apr 2024 07:45:04 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l2-20020a92d942000000b0036a373e3874sm3727881ilq.78.2024.04.17.07.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Apr 2024 07:45:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>, 
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Subject: Re: [PATCH v7 00/28] Zone write plugging
Message-Id: <171336510373.151809.107599732887371811.b4-ty@kernel.dk>
Date: Wed, 17 Apr 2024 08:45:03 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Mon, 08 Apr 2024 10:41:00 +0900, Damien Le Moal wrote:
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

[01/28] block: Restore sector of flush requests
        commit: 6f8fd758de63bab513c551bb1796a14f8cdc40d9
[02/28] block: Remove req_bio_endio()
        commit: c0da26f950a355ef3540ca8d215351e1ed4cac47
[03/28] block: Introduce blk_zone_update_request_bio()
        commit: a0508c36efa838b16aa93a23e3583d68d3ef6c33
[04/28] block: Introduce bio_straddles_zones() and bio_offset_from_zone_start()
        commit: b85a3c1b7978f942fa5bf8cfe22b6a6aaa49d3b7
[05/28] block: Allow using bio_attempt_back_merge() internally
        commit: dd850ff3eee428b4e1276bd51263dd937643ba19
[06/28] block: Remember zone capacity when revalidating zones
        commit: ecfe43b11b02ffeb24c203af7d3947417d412cf7
[07/28] block: Introduce zone write plugging
        commit: dd291d77cc90eb6a86e9860ba8e6e38eebd57d12
[08/28] block: Fake max open zones limit when there is no limit
        commit: 843283e96e5a3d8379579ac13ce9cbf75522ffde
[09/28] block: Allow zero value of max_zone_append_sectors queue limit
        commit: ccdbf0aad2523ca133cceb22ce0f8306730e7ac3
[10/28] block: Implement zone append emulation
        commit: 9b1ce7f0c6f82e241196febabddba5fab66c8f05
[11/28] block: Allow BIO-based drivers to use blk_revalidate_disk_zones()
        commit: 946dd71ed87dfa8d72f1404f906e1ae413a62d0f
[12/28] dm: Use the block layer zone append emulation
        commit: f211268ed1f9bdf48f06a3ead5f5d88437450579
[13/28] scsi: sd: Use the block layer zone append emulation
        commit: 1846f308d66f9c9a9c4f20df530dc77e57e3d92b
[14/28] ublk_drv: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
        commit: 11be0cb5fe25603472831f85abb32f0112239238
[15/28] null_blk: Do not request ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
        commit: b66f79b706f0cfc09bde8465668428eef188a94c
[16/28] null_blk: Introduce zone_append_max_sectors attribute
        commit: 997a1f08b4d4283687477470bcc256dfd33ba9d0
[17/28] null_blk: Introduce fua attribute
        commit: f4f84586c8b9c7d5312d6f8fb4db1e12f2b83c27
[18/28] nvmet: zns: Do not reference the gendisk conv_zones_bitmap
        commit: d2a9b5fdc16941243bbd8b360cb6e4fd62f41265
[19/28] block: Remove BLK_STS_ZONE_RESOURCE
        commit: 63b5385e781417e73bda3fd652c2199826afda6e
[20/28] block: Simplify blk_revalidate_disk_zones() interface
        commit: 9b3c08b90fc212de58c34621d83e74977170b2cd
[21/28] block: mq-deadline: Remove support for zone write locking
        commit: fde02699c242e88a71286677d27cc890a959b67f
[22/28] block: Remove elevator required features
        commit: e4eb37cc0f3ed8971c50dddfbeb35a799e5b504e
[23/28] block: Do not check zone type in blk_check_zone_append()
        commit: bca150f0d4edbf02002efa3309bb8e8c9d6596c9
[24/28] block: Move zone related debugfs attribute to blk-zoned.c
        commit: d9f1439a30d607f7bd06494ea2a63018b7d46380
[25/28] block: Replace zone_wlock debugfs entry with zone_wplugs entry
        commit: a98b05b02f0f1f9f4a504564070af208b70214d0
[26/28] block: Remove zone write locking
        commit: 02ccd7c360b1692da164842f211d41fab7d83adc
[27/28] block: Do not force select mq-deadline with CONFIG_BLK_DEV_ZONED
        commit: 97abee507b4b71d43dc1c1d3de4739db2c86c0ac
[28/28] block: Do not special-case plugging of zone write operations
        commit: 99a9476b27e89525cef653b91e542baf61f105d2

Best regards,
-- 
Jens Axboe



