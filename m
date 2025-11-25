Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E52A221726
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764076889; cv=none; b=u6mAUF+96ywGZpAc+Kxka1juRV7t17LotZ7iM24Opsw5RMdHfZ4c06r+7NgDClo21KZICczHKnK7MOxFSrFp6ZHs9XOd8ePWHh8R2vQD56TCvcJ6thjmXml1qBO70e5XU0vGze/mKx2Aka/wIYzm67g7XVyC7OmL0iJn/oOusMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764076889; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TRJSPE3S7oclXCW4n6o924tBovR1+D/3ofcf24294/ycPyCX55yOUKrkc7QMNqoWmBTuPGjfRC8Pwcrh3QU9eOgW//DPbVPW9SpPTknIoyr7SLtcuafWbFSwvGA44HZyKo1PqkQ7qiKDRFCzndoYhPgBCQQN1kZ2rQqzQaLzh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUszTq22; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUszTq22"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so7669101a12.3
        for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 05:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764076886; x=1764681686; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=iUszTq228BW/dRQkMWhyVOjOhGYBD9Db27Qkj1LtBWEToFSKbzcxV+qwHpRnuKKcwh
         J0eSOFAefmX65c209iGkPNRdI24hBDkmt3N2KRmPf5PM903gv8z58vjPWzbGnS26tEmV
         Y/v02I/JoH/wMaXedApwtZ7LSDMBEomlIPAeypHKSyEAKjTTf56GoCaMM3HtLCBoNrrp
         C1gbmlG125Y8SwcbL6EEjXbCtJf1FD87ATIssK+6pwT+Woe4TaChJ11DqAH5Jli2f412
         IGr6fYlPgumR5xG2aiFUIaH/t3od8P8dU9jeeHgFgOYwePYnomOGkRTA7Ew36dlcTHU0
         W4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764076886; x=1764681686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=g4TnXet88Ug4Yg8J55m6YrAH22nNUwLO3z1bnRm88FvaURCMQzv3HC9pf6K428gm2s
         dzRd0zFYxhEKLsnTxzU2i5FtwcNMsHA9yAhCmQpYfbCUIMUu7cG8RH9hXmKDBbNK1BfA
         C4ZTY74/7RTaUBanMHIEhFq4Mfs142k0CdBQtWQAoVIneCjKqLaN5AcaQONeg7HCmDJh
         4nc3g/De5fjsw6I/yY2rBFO4RhubXX+DJvECHV4eN1qimUyC9W8HalpQO+/Gj/ebuvIM
         5l4xcks+2B14CsOFZdbMQkllZL10miaS4yanLsvVwEMXD20DLhXoz7aM9fQRhtRfDZp2
         nBlA==
X-Forwarded-Encrypted: i=1; AJvYcCWgVvfaSRueZQsB/70mJgz+HtbpHuticFEuC3ic4/JYRwURJor1m/xc3gMoKYJpCjC3JWC1TGLVIw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzHCNG2KNVnZAT2kNu7oxm9ydpBs+8pCfZUIJ3s728Y/BlAqo13
	aoyT/vv+d01W623fcEKVJtPT6UwahYsIDsjwyIoMd9UUsE1ANCexOuyf/nkJ6GwQKL9zN4UPhup
	RpRHwT8GSk1kSO5bQDtMQ2UeGoAaqkQ==
X-Gm-Gg: ASbGncs1Ep0TXGLnPMT2C+ZV/bD2iOnayiZqWc/XpYnE+CRd2J5IyoxUWaLW7m3QESi
	F1E0EqQO8BE+4TDc0bWISz5PFLRbn/z7WfLIufwBUz8RBtbW3gwXW4k+WiGpvmOD+J6tFO+Fxc9
	0wzldXEhXpw6pu23kjL4cHj3+y0KAM+WH1lXh59U49k7klW7dClfQauQBGUur9v7chj2pf9dY0Z
	9Du5PprvM2Soa2f1GZJfl6oQt7G3gs3iQX24JRZV2Q3Lc5u3p559MvUA1hRSyzuAZAY+gjBmFf8
	TxY6G4Fjb7CWoBzNPh1772Cvnrntm+wvD5NnIb8jI2ExmCtEuJY05Hao3w==
X-Google-Smtp-Source: AGHT+IFdAjUbTCRihlcnMQbRe3kaTpxY0zS2TJvPnabL+VI06FANQqQrLV6dY7bbefHQ9hiFBD+KK4yE+DNgNHPMVMo=
X-Received: by 2002:a05:6402:280c:b0:640:96fe:c7bb with SMTP id
 4fb4d7f45d1cf-6455469c726mr15216782a12.28.1764076885654; Tue, 25 Nov 2025
 05:21:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 25 Nov 2025 18:50:46 +0530
X-Gm-Features: AWmQ_bmI0Nc-U-7V1vG_PnxUMzavwAZMXSjJQCtXVqm1t0YM1hU1mPKj8-N19OU
Message-ID: <CACzX3Avd95DD0g1ec5y3Rqhs6fpo0dqcKBScUr17AOHcw_2JhA@mail.gmail.com>
Subject: Re: [PATCH V3 0/6] block: ignore __blkdev_issue_discard() ret value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, 
	kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
