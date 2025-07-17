Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B98429DB77
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 12:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752753800; cv=none; b=QgTlweZ/yBAsI0HMyj1pwMUuhj3RfYFPXTttbPSAt6Jnbsd1/9XWrROnymqiacBthcpdrL0oSXdCaKkiK+8QcKNp7lPRT42JFZDacrSmirOs43vlXWH6slFWYAAafXuDWeimdazV/WY8O/cwtuPAhGk9g5CF2mbH34kHbx/RBp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752753800; c=relaxed/simple;
	bh=jy1nYicwP571nkfz1sS0ftJUShTC8h6ew9d+l9gdzcs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Tl6LBwpgMjm4LxtE97bhSCmu8PhgvSWaLy5quveSAT6aJvFk6pJ7hU+c7Os+WSQ1v8QWmLalfs9tWY1ZU6aqiiAQp6xx4YpPZwXlfKLFlCJMgju2nHkhe2WLzsRX6BZSXw34KD8Yt8/jNR9mujq0AQ4Xsn+Kqv+G7b231Hkq1fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IIEw/XjT; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IIEw/XjT"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3e28058c18cso8893315ab.0
        for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 05:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752753797; x=1753358597; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lumM2yQ8Yhssc9akl4RdGjzpp2HwGSl6F0XVW4q/Y04=;
        b=IIEw/XjTXJsf+zjy3sTF2lttT2N3BF/9qBBzfzBRpKaYk+br23xhi9DXfZCtIe9Qy7
         G7kmWnRX4Ubvj/4ofg0nFV5Hd6eSWg+8rCmiv52pWIxauPY4oDatQn/zW9miPiParVGY
         bnk2fBNMhY3zk8u35vcX3dyuAsKEUooTkuzjHJWVzT3ST2xkHicIb44sQgwIBWYIGzo9
         Xizd/1JmPrRUWhnx3pldXY7b+5fdLCcu3qiAxirObeZYLGNoxA6x3thGdsz1HeX9TY9t
         UsKhRZlBIzKCp5syUpvzWABu2ZLimobiyzIL53jGyGrNE2rnwMDifYEFWB8PUdtqm3gE
         ekoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752753797; x=1753358597;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lumM2yQ8Yhssc9akl4RdGjzpp2HwGSl6F0XVW4q/Y04=;
        b=ThxZV/ube63L2bwfxSIPqsJ1ou2q6gYwElPtzPq0uvnTDD/y6ADZuNNTaZkgtSntnA
         ICb8n7y6mEVwjJBqIPGrPFzOt8+jTWPT7moEpaDeDdaZYBnAdmY66RChNFtlt2LfThus
         dUiX+5rrhUA5RP+03ybJNG5H/d1zymdXNptrJO7y/H9VOV8g82D1sXTV7uMef8sy+VDp
         TeA538grfHZOxPUMB5CFTqW/Qr00SBtYd+EzALHkP0ljRIFQVTUun+mN/eSOiXv7URcu
         WI4+7kf8IKldYACimdVq/M3Zz8QygzNYu3qL/d5fotNk1goCBj6Mv68Lf7TT2nx4sJ5s
         vUUw==
X-Forwarded-Encrypted: i=1; AJvYcCWG/5Ghe1tdLbjBhOvVqjMM57x1eGZFEpmbRGj5+AI6sQHcS2/pE8tkRUtaOKhNuJLUr/Y7p6iEMA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxkbHexgEn4kiFh/Mo5VmbtWJC3KofzPxAqZCtb4nmkbei3NYY8
	K7+iNXyyeBtgLLwvWoTel0D/0gnSA7UZJNPjduRUpaGZ4jAv1BgQxFTKanFFTYGuwt0=
X-Gm-Gg: ASbGncvUwK6sAfM55ZAbuctJj8o0Pziro6LVldOYZKW2suOsR4bMrTOmXgaI6uq5qaF
	27uc+Deks/fEbko372zWxWWn/010uHopKB48M6bi7J6E/dTj1F6B4Wa6s/KKxVnVDK5AWf7Xvdy
	cIPOFswIH+6XuiOWNjD4/Kpne4dxHhNKr6uQmlXwlkGHWDLTJE25lIikMO/2+YeYwNGyhKOQ6GK
	PJdTv371tLMflovKJR/i0JY03i2lHDywO17b77WnKBPS0qyt6oXy8hJ0eXq1mgNaKy7gGkuX0I6
	dtL/l3AeaVDZ+qu8jVQApTikCCAJvh41C0/z/wN/Bv4+Xp6TZweOeGa9AnApVckVUjxREXfCFi9
	MHR7klGsyZU3S8w==
X-Google-Smtp-Source: AGHT+IESYYPRRnwpIfIUlJmZvxU37W0TRppo3py5BUppAuu9K4QZ3AtW+Gdv9q6Kcv0H8Z/O4o9tCQ==
X-Received: by 2002:a05:6e02:16c7:b0:3df:4cf8:dd50 with SMTP id e9e14a558f8ab-3e282ecaaf5mr67232655ab.19.1752753796717;
        Thu, 17 Jul 2025 05:03:16 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24620ac53sm52360525ab.41.2025.07.17.05.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 05:03:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>
In-Reply-To: <20250717103539.37279-1-shinichiro.kawasaki@wdc.com>
References: <20250717103539.37279-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH for-next v2] dm: split write BIOs on zone boundaries
 when zone append is not emulated
Message-Id: <175275379583.372539.3488682715732901571.b4-ty@kernel.dk>
Date: Thu, 17 Jul 2025 06:03:15 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Thu, 17 Jul 2025 19:35:39 +0900, Shin'ichiro Kawasaki wrote:
> Commit 2df7168717b7 ("dm: Always split write BIOs to zoned device
> limits") updates the device-mapper driver to perform splits for the
> write BIOs. However, it did not address the cases where DM targets do
> not emulate zone append, such as in the cases of dm-linear or dm-flakey.
> For these targets, when the write BIOs span across zone boundaries, they
> trigger WARN_ON_ONCE(bio_straddles_zones(bio)) in
> blk_zone_wplug_handle_write(). This results in I/O errors. The errors
> are reproduced by running blktests test case zbd/004 using zoned
> dm-linear or dm-flakey devices.
> 
> [...]

Applied, thanks!

[1/1] dm: split write BIOs on zone boundaries when zone append is not emulated
      commit: 675f940576351bb049f5677615140b9d0a7712d0

Best regards,
-- 
Jens Axboe



