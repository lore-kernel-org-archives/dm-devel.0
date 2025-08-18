Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6572741B5
	for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 19:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755543921; cv=none; b=X8QD6edWnNROjrJZgxwtogMOph8/I6x0ITZKQEfGE26+igz4x47oSEyMynkdE07zCf8K5+d47PNdj3qttXRatSt2kk3RUrP3yLIvoKJVGfDBiPjsmX6wZajt8CRmkLNPQvHluswLhcWDbUS+fU9VsKvbfMPRBet0OaVbg0PJmDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755543921; c=relaxed/simple;
	bh=TDuSJfdJGZwMOqpDTf8mdGyg0USAJVP6Wu3Zh4cN8Sg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Hzc6gy3Abu1ukknddmbCJZpi5vqDxADc+o3PkW2FzwStlvsXEzXp2k+te8ZiO7Jk21lzaCs0sZjKGXq7+7sdHNI1OJzygepz/jOftJIkmGtP6j5WlDWPIpsGsHjpOArbe5I5pjf0850YBAq9uYGzmt59ERMR3E3WFMK1AqtoijE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Egobqbvz; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Egobqbvz"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2449788923eso6196215ad.2
        for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 12:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755543919; x=1756148719; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TDuSJfdJGZwMOqpDTf8mdGyg0USAJVP6Wu3Zh4cN8Sg=;
        b=EgobqbvzOz/MtNeZysadTCxDme24yr+hiUTk83peLNMOp9PZiZEkJnOEFgnBVs/rfe
         M+RMhXSHfbi37fIEMH++Woq7+o22AzORZB/C4JYlkVSCXOy7QEMRr2JsgloWl5hDqQw7
         /vpS1oXiMJV+hHIu32SuPoTlbaY+rVXF4GV7zeIGj6FqkL/N46UTfBy15aA7QEsMyPrw
         ahSc5Bbb7Gbc20GTnXO8dLU9SSBpWjDNl8A1e4+2OaaAEZxtzJ2j9cLkhIoVKfSqxefq
         OsYXndKTZwo2XjqefbMbK646ljv7KVgk+E1FhmQoxiXdt6Pg4tXVFJvDPuS4UrUy6c9a
         Gb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755543919; x=1756148719;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TDuSJfdJGZwMOqpDTf8mdGyg0USAJVP6Wu3Zh4cN8Sg=;
        b=RLbv0+62mcsXbk5PMnpZextdHfHEFdeLgrTEs2qdt2Sh61gBOOB3t1Q01JmwPR/YzT
         2vGcUVfWaUN5zuqIfN3UWzxcvOj0ALKSFEEMPzbofWssd/k7i1i244icqPhe423RSAU/
         /0cakRv5I4pt33RP+lcuC0KdOrpwEzt/OQDf7hmRXJo6yJHULRqBN/tq3EXrOOXd1mRq
         o+bW7ggGxYeiOYldqG7QWII9BOxu+6bPHZHk0NKQTSoOgBX3gwNV4yPQx5skP0rbA5u3
         kzVwD7YSOk3Jr1C+mkY8CXtYpr6kkJ+r3fAsgL5wu6UHFTksdCM30mrFvzAAdgyOh66V
         x9LQ==
X-Gm-Message-State: AOJu0Yymgup9uxZLu8DiXuePWdBI3Z2JOp0nPgiddB0TRuXARiL+fGx1
	GyISOSfLEf+jwYlwiuPHP6IYV+9L3EKa7q9GYlizhy7lDj/FEAuwkHoECT3Iqj72U6Mp5Y5Azrt
	WlzEiyysLL292cJ8aegkxedUsajOWtlY5XA4pDKg=
X-Gm-Gg: ASbGncuzQsU0ElmvVLaIVCHbdpERn9ZRDIUVpzVEhYpc5bErQBeWb4schPaUtDDq03D
	liemqjaSZ8dB5JpEMs4SCVrZaTZOFTWKBJD8uxrbbQMbncoBwzMdGLIGgoXQkGTK03cYfUG4+5T
	wuB+vbxGMrxTVteIbq2/snOP5QAl7IGMMfmwqYAhYu+iKSlj032E6vtfQbOZCq/j5sQ4G6/FO41
	xRllvo3
X-Google-Smtp-Source: AGHT+IGk6Ar/JktlYXwHF2sK23VglInX0GaLFGzf2hAgzc8nC6ja8iZgjq1GJgf4orkSdY9h48/eNFFHOYLE2BZp3+Q=
X-Received: by 2002:a17:903:1a26:b0:243:3b4:3ac8 with SMTP id
 d9443c01a7336-2449cff0430mr4577215ad.50.1755543919347; Mon, 18 Aug 2025
 12:05:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: John Rinehart <johnrichardrinehart@gmail.com>
Date: Mon, 18 Aug 2025 12:05:08 -0700
X-Gm-Features: Ac12FXyUWUdhDQgXfk3uFgisI3jeJIkGKIm1vi9zAxg2sorQJ-s4B63jzwIck2Q
Message-ID: <CAGc5Yo9DFwyzNMtv5hochwhpqY3Pv6uqkqshUTOo++LAbs=jgw@mail.gmail.com>
Subject: dm-cache-statistics and DMEMIT
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

I'm using dm-cache in writeback mode and I'm trying to figure out how
I can see the cache stats in "real-time" (poll every second). Like, I
want to poll for the values in this data structure:
https://github.com/torvalds/linux/blob/be48bcf004f9d0c9207ff21d0edb3b42f253829e/drivers/md/dm-cache-target.c#L283-L295.

But, I'm at a loss for how to do that.

There are also these DMEMIT messages that I'm really interested in
printing to dmesg or subscribing to, or whatever, but I don't know how
to access them (CONFIG_DM_DEBUG didn't do anything useful - which
makes sense after reading the source a bit):
https://github.com/torvalds/linux/blob/be48bcf004f9d0c9207ff21d0edb3b42f253829e/drivers/md/dm-cache-target.c#L3184-L3197.

Can you help a brother out?

Thanks!

-- John Rinehart
