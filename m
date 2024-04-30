Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18723143757
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 14:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714488280; cv=none; b=cHpNGDX45KABINSY241+aK2Lrlq+2BshpSeLh+fd3TfzoRb/qj5PBTJRNpEye80S0z4RKALRKV5LQK6Syum6JqJU/VL5G7tQ+zBDEghRGOEqx/2nwXscrKrZrpdGsV+np+nxJuNvKrH9Mm4MB6UaRdy7B9/PkdJmsizPNw8FSOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714488280; c=relaxed/simple;
	bh=7ZMwW11yZL4P1ic3/vtvodC7DcvpmQjRkyDiPjf8R6Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kk22S4KqEAdOxGFxJaWvgwIZk4x7Oq3hUTJCNryDvdkDezJYLKGNgw2kxKOrbkGnAwTZkinbl4N7H8aqCHFPsrOStdRqcaHKO9TvE65Pk8uE35EMbOo/b3gszvPGoHYYBIV/APp2VJ7jEB5O/XW0GxrAZKnyHCemu6IyhUNlq+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com; spf=pass smtp.mailfrom=linbit.com; dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b=KNDVwz8o; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b="KNDVwz8o"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a58fc650f8fso295698566b.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 07:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20230601.gappssmtp.com; s=20230601; t=1714488276; x=1715093076; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZMwW11yZL4P1ic3/vtvodC7DcvpmQjRkyDiPjf8R6Y=;
        b=KNDVwz8oaayEMKsxLw4QXFY9BSPUeLhkjVGzmEo8QVWGRPvumeKMRIeSQGi3UYXgIs
         2QSCbhh21YJDmz4uMsmcVexdzLkHWqDxJT5AUNDPgW2JBiRUlcLBmLOXmb44oudV95Kn
         v8YmHsDnuJBonUnh/aZCW2K3tVKxJCdnf+ipZXubSDhnc0WRdCrlMD6Radomf96AZboB
         YqPe52j/uJcEdN3gNesol7VlVzPxm+a217Cxkz9WME8fYU9IDuIuy34ELf0Kr6Vvu6gY
         JgdW8nPYEASK/dasRzJErH4vPfsGDqipiP9IrZD9LvmOADH/I+3VLpoeJJW9nLtVFRVU
         bv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714488276; x=1715093076;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZMwW11yZL4P1ic3/vtvodC7DcvpmQjRkyDiPjf8R6Y=;
        b=AX2+62Z7QJ/Y4i+3KvatKXi8p0IzNAMB1HvJZbggB1zP1HdjtE+5XT57WbacyQfBWz
         9ZRs2kAsPgu60PCH3dz2ExXsTGPbutbqYXWF9XZ0H9kU7xDUOC/wcie4xJDUdoaTfQUM
         MRfZqV6RxBzIzDVYXRPYvhbfJq3u/z3zo4I3c+z9k+UxokLSSIiICeR0HdgNwj02EJHA
         zM9QL7TMrI5XkIFWz2nkJa2zXyi6vG0LsfZ+02924gUXkL5prS2TgYzzYCP+WUZe1mLJ
         qOVYsg4icGIp4JmE54wKFUe7Tv0LHrGNksabsJXmA4HFT7z/0ESFhRrmJHiZV2V7FrRJ
         /HTw==
X-Forwarded-Encrypted: i=1; AJvYcCVo76gYY4GMEnG7qdenq2kCLbDt/g5gylgopK2UuDSJec+CYXl30rlWsZ1WAOsFlnS2lV0xWD+a/olEwzREljLGWMmpG4XEKZI=
X-Gm-Message-State: AOJu0YwtMSqhQ6TDNyqQZrFUkgbHNj4CpbDT+VF9gZnDwd/BK0HMY52F
	tA+vWw820hg2SmulwghOIVp8OeYR2bjgKw9e+re8QZV/tws1yXQWEtUB33YjZucI5S6DoGKLp4P
	JIDloPMlpsjVU1nv9eSiTZYOl32e1LfHPwxn+5w==
X-Google-Smtp-Source: AGHT+IGVMKTGdIG3tO3983yHfPtD/1uhhwBTfCeGfbFyG+KrQrrAJgc1f+SLSqNgcz60yjg59xYUpMdl10v+1MGFArI=
X-Received: by 2002:a17:906:470d:b0:a52:5925:2a31 with SMTP id
 y13-20020a170906470d00b00a5259252a31mr8544052ejq.29.1714488276278; Tue, 30
 Apr 2024 07:44:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240426072135.291206-1-joel.colledge@linbit.com>
 <20240426072135.291206-2-joel.colledge@linbit.com> <71a31fdb-fad6-4ce9-bda0-2f86633d23a3@arm.com>
In-Reply-To: <71a31fdb-fad6-4ce9-bda0-2f86633d23a3@arm.com>
From: Joel Colledge <joel.colledge@linbit.com>
Date: Tue, 30 Apr 2024 16:44:25 +0200
Message-ID: <CAGNP_+Uocb_8YtY9P3EuMQ8sQwWaQtqEMszqbGZrVyrKw-udRg@mail.gmail.com>
Subject: Re: [PATCH 1/1] dm-delay: fix hung task introduced by kthread mode
To: Christian Loehle <christian.loehle@arm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Apr 2024 at 16:28, Christian Loehle <christian.loehle@arm.com> wrote:
> Is this an issue for delay > 0 too somehow?

I believe it is. If there is simply no IO to the delay device, then
nothing will wake the new thread and the same issue will occur.

I haven't yet reproduced this case, because the system I am testing on
submits reads on any new block device and I don't know offhand how to
disable them. I think the reads are from scans for multipathd,
bcachefs or similar.

> Indeed if we don't have a delay the process will never be woken up,
> but in that case, why create the worker in the first place?

I agree. If this were only an issue with delay == 0, it would make
more sense not to create the worker at all.

As mentioned above, I believe the issue can occur with delay > 0. So
not creating the worker in the delay == 0 case is an additional
optimization and out of the scope of this change.

> You're missing lkml as recipient btw.

Thanks for the pointer and thanks for your response!

Best regards,
Joel
