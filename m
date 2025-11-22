Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C871E13777E
	for <dm-devel@lists.linux.dev>; Sat, 22 Nov 2025 22:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763851678; cv=none; b=gR1KZdptmr9aQp0xKPuBHgRho06nknfPBm0ETAYs5zoY5THhMQhAM65VFkrG7zwv5ShjjD4/PmtkVJ+HdDb7yVXbwSp5NMGZ7fRI/0GLlPDGNwoM7oreSvDfjNBt42k754xOKdoG4obRlANxAVA8J1ThFskM7MpEWulvznDJ+Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763851678; c=relaxed/simple;
	bh=mDmOqDRRV1GxRTkt03uYnfvm5YBI/u/mWZasnkUTwrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq2LPAd0ubgfRrAEooKkCE0qDvR/tb0kNJQ6KKv2oVshUSPO3WP6bapCVHCikV82YaUY3x8aHSsDy2a7p4yzPc4k94BlikpQWBegOEuDMAEercFMKkBuBEpDSdKpZx6yNyEPmnbckfhrKORVcw5OmOgvBOVfTlg4tpU5717W2oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TvWAfVpb; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TvWAfVpb"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59583505988so4513586e87.1
        for <dm-devel@lists.linux.dev>; Sat, 22 Nov 2025 14:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763851674; x=1764456474; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mm9cJVhutkedd51ycbYwKmMqp19QwPFiX/ffFg8rVcg=;
        b=TvWAfVpbGetCW1LYJUdJ7UPtX+M9OB8xLXx9HsZh5CVUZ1O8fbM+4TVPxG00sXvcf2
         GTI6r8odIU/pgdn7sftlrF4Z8frboqXNWQ7VowyuEvnjeSZ8Et2S5vNi0lJrD5kYq0t1
         wm3LRPgzKrBKgLvHIOKonPH5mClFHK3+EOcOFsY43bSmYgOtgokQT+yu87fchu7NB5zI
         A+5GVCYwGS15szqIZZWSy24EJehlCkGN27vcBKJ/w/LcuAwR55OjQKMbPNjzOTyeLJA1
         nBgXWTtedWeNRAMP/BAEE5NAV/S7SSCe+CBs+sm/Yh3lWO8bhBnxcRRXYcfcf1WRgqQP
         utKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763851674; x=1764456474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mm9cJVhutkedd51ycbYwKmMqp19QwPFiX/ffFg8rVcg=;
        b=WupBeeX58pW8oX8PfUs4dgna1WnBCMTKw8FpciWGOPRw6ZroVJfVmdIB7gBs305/R2
         DlMq0Vlmk0M9aKzHdEr09EAZonXLHO5i2vf7C/YZkTTVV/t2DKGILY+ZRu+rfmX9l8Yd
         e8OdSOoTEqZlrhpwkgG7SxFcRZJuY0rBlaTVlsFQy4WVTrC6PgfJeCT3eErP8ZiZLY1x
         v2tx2OOsMtXHX2cbqPZW3G1yb6n5Qr4/FwLl7NmlbKezmxX9bl4HFgnRS2/jSDBtO3nv
         lzsFNowJryCQIV0vZuI4OqcSIgG/+x24ddms816KNQFpb1FPjOyhVYb7cuudbzD/rheS
         no0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHU2LGAmix6RVNqk7VwD+M+qRc08nywzfcEsIK6uHN6MyqgGH1XONlofLhDvEZ/tiwnJyhT2vJWA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyPRTzD1TjI/SGf6YE4sQcZKL4I9rSnQqtg4fi//vEOkay8lkjA
	RiHc63QrG/vOC2isEzaTeQpDxTwjYkw2xeqii3CuJVEc94VdFesmYvsB
X-Gm-Gg: ASbGnctPOjdl9biO6ppXK9kRVMXnEJOIBLZcCFzJaOAQS0x+mcWTkaOS/ivXhZrdr5r
	XLr0cFXh9ojEVYEU8D8AxWyJPX94qiH1g2R5Gm5R1GUwyEDbBcJ1vuC1Fc5cjpVHmIlGsLd4R5l
	cTJhKaeV9DNHFa87KTipG1aUhj6FCPoFLHyG1ue5xv727F9fDhmSkrJwuakTAyr03kYF31Sztrt
	Muf2xKQgFHOD6SohT1/8RYLnJYAYa6seFgVilv1AJTX7KaF8axDDDdSxuI1WBFf5pL7/nJND9cS
	dzgHTGPDFemVlTDe7h4WTar+B3Srl9OnPgKyuZX5EIexWJYHoE7S4xiZwlOYTMVFXJdAouSG/8y
	cqBP+V6N6WYb8/pDCcmRDiajRx9+U1Uq4sV8Yc6OFiI77NhWWYtFtmQ2GT8APE9bf5hq3csUcr/
	cnFVn9qhdTKQ==
X-Google-Smtp-Source: AGHT+IG25dEQnHwaBToxpvBjTeZ/3RB3yCymIb0k9rzfOt31nS8ruDCrSu8IePguUMWt0EMXA9m5xw==
X-Received: by 2002:a05:6512:308c:b0:596:a000:596 with SMTP id 2adb3069b0e04-596a0000a2bmr3428587e87.10.1763851673743;
        Sat, 22 Nov 2025 14:47:53 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5969dbc5988sm2742367e87.78.2025.11.22.14.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 14:47:52 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
Date: Sun, 23 Nov 2025 01:47:48 +0300
Message-ID: <20251122224748.3724202-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> 
> There was reported failure that suspend doesn't work with dm-integrity.
> The reason for the failure is that the suspend code doesn't issue the
> FLUSH bio - the data still sits in the dm-integrity cache and they are
> lost when poweroff happens.

I tested this patchset (in Qemu). It works.

Here is script I used for testing:

https://zerobin.net/?66669be7d2404586#xWufhCq7zCoOk3LJcJCj7W4k3vYT3U4vhGutTN3p8m0=

Here are logs:

https://zerobin.net/?5d4a2abbad751890#WMcQl4FAZC9KqcAuJU3TSVr7wuVnPFwI7dlinA9QHOo=

Tested-By: Askar Safin <safinaskar@gmail.com>

There was no any reason to wait for me. You could easily test using script above.

Also: Linux shows this scary message when booting in Qemu:

[    0.512581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

So, FUA is not supported? Does it mean that this patch is wrong, and works purely
by chance?

-- 
Askar Safin
