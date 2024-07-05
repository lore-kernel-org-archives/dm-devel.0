Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA56B143C5B
	for <dm-devel@lists.linux.dev>; Fri,  5 Jul 2024 06:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161756; cv=none; b=lQ3eA9PsrwHiiq4Otm6zfmrCI46H0IKJW3xHh7oKNghTE4xjES9ChmmJJLYXz29viTp5kS3PgjYKcfYO2swoZqAjO+xmB3+1+5iaTf9AEI+9hEfi0zDEcZtWxAuWxUgfLq1mk2nXTkAiBzxNt2aFzBYGeD5uakOUUeQjz5GMfJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161756; c=relaxed/simple;
	bh=CWl72ReHjXCYWhKlNG9N2O+IUodhLDJfcgQMkeLW04c=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fjCQLJVWsD5+fHRb5ISPaiXqdlNVHeBlznaaLEtmWFw983yKT4/JGVFC3KYYPl9PbFykV0cCHjuoL8a7Fjqk0hYWGnXBzOddr+1jRc4xeOcCTGyJu+RAq/gtNaMhoZxMm4Ghv5tA2dr/nW5hhj+Udj3hwJ6DSpNCij/15wMmvDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1CQ0yJj4; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1CQ0yJj4"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52e9d61a4b4so88997e87.3
        for <dm-devel@lists.linux.dev>; Thu, 04 Jul 2024 23:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720161753; x=1720766553; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=waQspLv/Jp+UpTZ4iMwnmeyNv2/eDMBAOGCEYrIWEFg=;
        b=1CQ0yJj4TohEO5nh4bkTAJzi0DN+WqpxEfJwrPwQssJBFiLLUYCTN+4Ei2Bo6YpWJM
         rN+10+fjQQ6BHx9U/7CgIjkBAUPV05CS6BJ1T/fxSijiSQjACn0yI40wZ1GvT/PzQnc/
         v4cWx5Sxdr6MNOmnNHBnoGhC9Pw0UK4ILB3pg1iVSFIOzw1c2u9BJw8tlPAUpaipqOSN
         u8SSorSu//z/xqSrClKeK8miMAr9Qwyas99883KPA94ZtwoE14an/d3dF7aONNRcCbHh
         s1aJu10pZxiQ2ViULgNr2SobZ6s6eZpLQ2VSLUcJoJbCwDFFXaFzUkayG6C26QzabPLy
         /UAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720161753; x=1720766553;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waQspLv/Jp+UpTZ4iMwnmeyNv2/eDMBAOGCEYrIWEFg=;
        b=DsGYpzMxjYVx1MN+9F0R1kabWDr6QPs2TCtJdTVkkWhYCwZPxS3dMllmAbDpgp2IMu
         09FFKDrdoCd4FE9Sep6/5m1ljZI1yF6EGe5JG+4gxFgiGUaPfeLu3I1F0SaE/MZ4MWYi
         59RHMFiAkSt/Pb8d8dgllrEat6on7I5P5ZVZFeOkIW7QPlH06l7sNePDIvVUw34kDBxR
         tcryHsqbMaNmDRT11y9mesU/xXn50+htbgCHMOk4TIpBAACZe0MmT0os9dT85UZe36Ed
         CIH7ra9Q2RTI7N6PONGDRm0lp79CF+jLgX09CvlYw6haTZsl3M+kN1kGkIOlVg68qdXO
         gOnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK8pbFArOLET2ogQOci7RGuT6kQfzZFNuh3HkYbeN/aWcFSuUQmsH6bBDMjqh5cyWopJPeXl9fDIvieDPTyiagn5k2iHfKzV8=
X-Gm-Message-State: AOJu0YxFjULQ/0GOpkwzH0cAZVwBJ9/GzXVlxe70xePsRFodbtRcsZyr
	/98uiPm8EWkdornfVIO5Jq/l6lfK1qPYglyxJTHvGInL3DxmL6qjj9MLteo2sUM=
X-Google-Smtp-Source: AGHT+IHQVZfmP8Kf7Vg7+YOar8W+pG2xnl2rTo85ayKWXNSneGGBg+vqVXwSHucIKC0g6Fn0qMkveA==
X-Received: by 2002:ac2:5a50:0:b0:52c:a7b6:bb11 with SMTP id 2adb3069b0e04-52ea0619e47mr2245356e87.1.1720161752595;
        Thu, 04 Jul 2024 23:42:32 -0700 (PDT)
Received: from [127.0.0.1] (87-52-80-167-dynamic.dk.customer.tdc.net. [87.52.80.167])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ea69513e4sm88226e87.289.2024.07.04.23.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 23:42:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-scsi@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 Ming Lei <ming.lei@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Christoph Hellwig <hch@lst.de>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240704052816.623865-1-dlemoal@kernel.org>
References: <20240704052816.623865-1-dlemoal@kernel.org>
Subject: Re: [PATCH v2 0/5] Remove zone reset all emulation
Message-Id: <172016175015.242380.5721463092175148141.b4-ty@kernel.dk>
Date: Fri, 05 Jul 2024 00:42:30 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Thu, 04 Jul 2024 14:28:11 +0900, Damien Le Moal wrote:
> Jens, Mike,
> 
> Here is a set of patches based on block/for-next to remove the emulation
> for zone reset all from the block layer and move it to device mapper.
> This is done because device mapper is the only zoned device driver that
> does not natively support REQ_OP_ZONE_RESET_ALL. With this change, the
> emulation that may be required depending on a mapped device zone mapping
> is moved to device mapper and the reset all feature
> (BLK_FEAT_ZONE_RESETALL) can be deleted, as well as all the code
> handling this feature in blk-zoned.c. The DM-based handling of
> REQ_OP_ZONE_RESET_ALL can also be much faster than the block layer
> emulation as that operation can be forwarded as is to targets mapping
> all sequential write required zones.
> 
> [...]

Applied, thanks!

[1/5] null_blk: Introduce the zone_full parameter
      commit: f4d5dc33c823ef1d7ccbbd2d1e40b871fad0012b
[2/5] dm: Refactor is_abnormal_io()
      commit: ae7e965b36e3132238d16b4ccd223f65162397b5
[3/5] dm: handle REQ_OP_ZONE_RESET_ALL
      commit: 81e7706345f06e1e97a092f59697b7e20a0ee868
[4/5] block: Remove REQ_OP_ZONE_RESET_ALL emulation
      commit: f2a7bea23710fceb99dac6da4ef82c3cc8932f7f
[5/5] block: Remove blk_alloc_zone_bitmap()
      commit: 2f20872ed43185780a5f30581472599342c86d4a

Best regards,
-- 
Jens Axboe



