Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98C21A9B35
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145068; cv=none; b=gcWBHpslVO4hV9NQ8Zr25wl1yE+ZrWcEXFP+RAFxGfygwTqqPErJ5Br8dUOFJqnJCaifbbvEuvoyzxOGuRqw3AOtD9cQ2eAF1uE93EzdPw/NttDXpGp6goR+9AdCtGYn8Lrs/VAaJ18NpSWCDW7NdPPtAo34fVdwsO6+dt8UTmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145068; c=relaxed/simple;
	bh=dVzqiFcZBuXVHk6HLMWLRs+HLmmoRxUiHymSqqkdtKw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lEWM1YRar/K249OJh2FlCEDZnn92D+FtOyope7ePM0FNX2CzxvhfvmZQ4QisGvg4SHWPJtl1HGxU/+VZweyUbXG77SVNtT9iWmhb2Gd9txwZUDeu2nkw7nX3rUnExKzSR8KGUID730yPILztSNpTTQaS0GEAo9dnHH/CWl4QTrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K4BOc5HZ; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K4BOc5HZ"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so91202839f.2
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737145066; x=1737749866; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLxmCJlbafkuvfH6Qxktog1C8CaKggnWioDyBY6DGok=;
        b=K4BOc5HZWvBfqM4eCKWT3XkeLXlL/RC2zCYnKYVIF/inuhOdG1KqPAFhnlUq3RI1Jl
         Ig3r5e+95tELae28WDZwvbGsiJW5CkEZ/C1a+2IdUxjJV5VaBqV6ZwmDbAfgEY3zlFIF
         fSmII/0n4BqK7Vxuntg0doq9hBOLSH00JF0S0kyrTG3xyJWO/CTIiYnOUMnPCvM1lBgv
         SKEiKawCHFAhVVLcrcUfy75zWEzgGFL9fxZpc+jwwbt3KSzO/T6qgoW8Y5RNPHe/KMkG
         HFVCEhKpR9wVyvOiU7ifLyGfwckveQrEU4SnVz03felg2cMwTVhUwXcFv/T1tr7Ss+4W
         R5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145066; x=1737749866;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLxmCJlbafkuvfH6Qxktog1C8CaKggnWioDyBY6DGok=;
        b=PSmwUbc6WajnIJMtHGC1RbOBIIva6JSIgaRYpWpgi1kDh9lNoqSKQDypAXMPWWqF1m
         5Xwnuw76k5sa7/AgG3gqo/7tJr7zQNlPS4os1uaWpA9wIZs+TKRD4+sVeHXy6PcS5AKP
         xMBl5YzUGxJJUjr4Hxz/z9SQMEdI14FS5+SpJfXQgcF1VK2MZcLEEX+SVMN30NzN2vSq
         L/cvYRagasUb3eNh8bzilSH5kOAcuLncu2NQuRB+XUsjvzkEex8LM7vR6zY7o4nuRYn9
         1tcBrmeSYFvScuCOVUHpdsmluWgyqiKcqRlXQi5CZSFuhZrbQ68wDPZAH+p+v9Yd2GXL
         DgUg==
X-Forwarded-Encrypted: i=1; AJvYcCXFy8TIW5scKVEMHqfU5EiydX9ZdbUnHM1O17qXg109M18Vm/e11Paw6CCTfSVN2uxEg2f43wc2Rg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyrPcQ094iXj5gY3aTm9kGZaYWjq0nIsQGr2h9euhCgOk27oOSg
	EE3w3A5Hyu9uQ4PfzL5Xp9E39LnEw/kMYFJlHarsHJKWtLl5jLyP8eyFRK1dfj4=
X-Gm-Gg: ASbGncsfwi794pdBdrroRc8+3GPiYugEW5H/qYXEqJJhOuEwrE6dQwYrRL1khYW1nmM
	vO+Y/o0m/K3JLe+MpCFjRtZGN6QZQpGRHvt/slCQjG4ZW7vbq5w0E9IHvTEWGQqcUSCe2GGRrlS
	9jUJxNs6RVtXBnMax17w8e8riyCjV/J1I7BHTGa9og8TBepL1K1RqhLmygZUs/5Ub0iTIx3mhrq
	34gM7uMN/da/5nfKtEe2A2t4oy5rxZKIq7O8heWcyWGyTC5
X-Google-Smtp-Source: AGHT+IFKrGW/S+uGv2I4EYYiUbyKoOPoxLNw8UsgVKt5gU/rDXc3yKG6eiPIIz1vOQY4yFiQfe+oBQ==
X-Received: by 2002:a05:6e02:16cd:b0:3ce:f1b5:6d19 with SMTP id e9e14a558f8ab-3cf7447859dmr36866315ab.18.1737145065752;
        Fri, 17 Jan 2025 12:17:45 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71b441e5sm7336155ab.57.2025.01.17.12.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 12:17:45 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, mpatocka@redhat.com, hch@lst.de, 
 John Garry <john.g.garry@oracle.com>
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, 
 sagi@grimberg.me, James.Bottomley@HansenPartnership.com, 
 martin.petersen@oracle.com, linux-block@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-scsi@vger.kernel.org
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Subject: Re: (subset) [PATCH RFC v2 0/8] device mapper atomic write support
Message-Id: <173714506441.181264.7271209320638609494.b4-ty@kernel.dk>
Date: Fri, 17 Jan 2025 13:17:44 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Thu, 16 Jan 2025 17:02:53 +0000, John Garry wrote:
> This series introduces initial device mapper atomic write support.
> 
> Since we already support stacking atomic writes limits, it's quite
> straightforward to support.
> 
> Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
> more personalities could be supported in future.
> 
> [...]

Applied, thanks!

[1/8] block: Add common atomic writes enable flag
      commit: 6a7e17b22062c84a111d7073c67cc677c4190f32
[2/8] block: Don't trim an atomic write
      commit: 554b22864cc79e28cd65e3a6e1d0d1dfa8581c68

Best regards,
-- 
Jens Axboe



