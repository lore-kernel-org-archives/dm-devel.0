Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52D61442E8
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741273339; cv=none; b=nfBJLmvFRCpTUCyB9HROoqf7RG3/+kMvWDK5316gXSTsEJXbbz71X74lZLgwqeYpCql0AK9ExqiS7rMeuaUEGBp9gbiWssrnllGRdU1bIsJdIreFWyVRvzPMNPlp6DlK0dUZpbhKVj8QmEtrN6Io5uK/e3clTW3KFLjv3+yFj2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741273339; c=relaxed/simple;
	bh=TNHYt9OrG7z20k4JSs77FE0a0Uuxd1mThM9cNp/g3qw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lO0Dk+2xGejBLJeP4zJnzGDalmqWeUonPj8jHvUSQKIjJeSVR6glp8v/N9qIVhxDlY6Mwraxsh3Up6nrZvAts7NS7bFlNoRKHI6cZkgUmIWx3VENpPGJNwLCggYzEFf2bvLSV/WOq5sVhyEBUr87z6LxkVXor9X6tzUcLG7v8Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CBvPVS+v; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CBvPVS+v"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d3e25323cfso6307545ab.3
        for <dm-devel@lists.linux.dev>; Thu, 06 Mar 2025 07:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741273336; x=1741878136; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85jq1Q6VP5GwImlSpp7X1r/ay/vqE02iBEhuFPnO6PI=;
        b=CBvPVS+vJWHa3An2C+niCizoqV6d6diZU1LF/sRxstZ9FhtGxxHrcJ6aaEOatX12on
         Wl/O+A8PZfVHsJwCDTnAkp4hCBNGHpOJvaHrs596hOAZ1tD5lqoSS7eHaISMuZs55udg
         qxqdyoor2mRiJrMHVR//KAgCKx0/RceaMO7SQO65lDR0EtFGYMyjplQijFhVkyRkXGRM
         z90jnVsJmyNT2x6pHvMggpw4anC38mwtieX07MZZlAVRs3VCNkHyk85CVj3D5F8kcxg8
         Pj5j7VWBJ05VAz34kt1I/kq3+8pryD8GDY9GDpI6qAWOb3ZrsCdpBMV5jCZQHvoVXaDL
         fjsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741273336; x=1741878136;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=85jq1Q6VP5GwImlSpp7X1r/ay/vqE02iBEhuFPnO6PI=;
        b=ldjxkkKl3DdvKWC1lL1ewhTZJRc7FXJJYUhwpd5c/VMmR6ACWwr0Oj9wlyVgZyyj7D
         yh0nG1OoBJcKzAVFKUUdoDOQuiBLhF4eBLSFBPfTj7vycsHSqrCIovx2JMHuMM/6vi4L
         61Ga1IMVwh71xr/wrdgyIZxqq5G0XrFX5hiUNb9TLmfzzkckP8gqBfIJ0e7W/FceZxNm
         tWOUTOgUzkR2vVkv8TUdci8rBFl8VpsqyZ/Nz6S6cXLmVa0fN5srpD5O1lrTQMFywtXh
         wju18nlqlFv7fnBQaGb8nqSOeUm9DznsURYjmVPUcd+gemFP6wg2e8MkUD13JK9oY4c0
         /5Tg==
X-Forwarded-Encrypted: i=1; AJvYcCVeLYAX+RmqJmhHfOU0QEkSGwO61Mz6L9dmmuqH6p977gpTs+puBBDzEqXgut5pCybJ684k/XQoYg==@lists.linux.dev
X-Gm-Message-State: AOJu0YykWMQo/Lx6jFq8UIBWBcgj0K6s5tqhFWg6ukyzUErkAveQFTLA
	G+LEMMzBgWUGUDM/oQMjPyRGXyd01LxMiOJfM+gV6gRx9O4kgsLJB5sDoiaLICg=
X-Gm-Gg: ASbGncvn+Eza/LvtfmPxaf+DqJHGgFQq57ikcRzkTvvosgogJgZsVFoJ4JRIxE7Jxqe
	AuI6Plxt786ZZ/TAaduZPssIL8q74KXulIvPLtNetJnfIwCMUPtqKVoS3aKGhCnv2wO+rCoqWh9
	gbspiPuWURqDFpWUfYS9UZOnjV1uhkjT6+ehp2OopjvfPqnr8HA1LgD0tuptXiA4a/ovDangmeC
	iq8MZwQZ424YreP2QwjcuE1Mk4O1qzXOPARE7pAn5BGJmZM+gMKCyIZfo2PmwT+Je1TVTTTldO9
	x4ZnNTKuI5ak5017Oj84G7rKrI+krF1IJ8nB
X-Google-Smtp-Source: AGHT+IFLAobN1y/JaLFeXk9mcMrXNaETTC2QGpW5wyvCdzhLBlyXi27OPaIuZlvogV6xlSSS4u8ADg==
X-Received: by 2002:a05:6e02:1985:b0:3cf:bb6e:3065 with SMTP id e9e14a558f8ab-3d42b75767bmr95773635ab.0.1741273335734;
        Thu, 06 Mar 2025 07:02:15 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f20a06a6a7sm375874173.134.2025.03.06.07.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 07:02:14 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: hch@lst.de, martin.petersen@oracle.com, 
 Anuj Gupta <anuj20.g@samsung.com>
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com, 
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
 linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
In-Reply-To: <20250305063033.1813-1-anuj20.g@samsung.com>
References: <CGME20250305063900epcas5p38bb20587ccf4310cfb0f3307180eb536@epcas5p3.samsung.com>
 <20250305063033.1813-1-anuj20.g@samsung.com>
Subject: Re: [PATCH v3 0/2] Fix integrity sysfs reporting inconsistencies
Message-Id: <174127333427.62743.13850185317855218553.b4-ty@kernel.dk>
Date: Thu, 06 Mar 2025 08:02:14 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Wed, 05 Mar 2025 12:00:31 +0530, Anuj Gupta wrote:
> Patch 1: Ensures DM devices correctly propagate
> device_is_integrity_capable
> Patch 2: initialize nogenerate and noverify correctly
> 
> Changes since v2:
> Ensure that integrity capability gets propogated correctly for all cases
> in DM (hch)
> 
> [...]

Applied, thanks!

[1/2] block: ensure correct integrity capability propagation in stacked devices
      commit: 677e332e4885a17def5efa4788b6e725a737b63c
[2/2] block: Correctly initialize BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY
      commit: 85f72925000e924291a0ebf63d2234994a4f22bd

Best regards,
-- 
Jens Axboe



