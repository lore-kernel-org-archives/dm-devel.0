Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E941F4D9E8
	for <dm-devel@lists.linux.dev>; Thu, 18 Apr 2024 16:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713456915; cv=none; b=GNZOYGAi3YdxKf61H4m6TWfxQxWl9FBlcm9sab5ezQ5TqsfXcYmpDyM16YM6xVcSGg6BUYiGRcWLbz26qzOqpSw2pnjtnlKFYpQI/TNUhvGg8BuMUO7tGAyrhsmqBJh48gmjfY+Q0GiPdUpB2iBhwjO2FKHjMHWvaHezeMyZi6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713456915; c=relaxed/simple;
	bh=q/oyaADR6y1Yq6DCRTNBX42MV7N6DcDfF1sT7CgSabA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=IZpwlnde677RszBLC1ouq+K/Ubp7uFvRS02o8uthtKiA0s62Qm6PUzTj3kmBdkl/3gByHsw9AqKxFtms3fP33v0lwMHKsZ9Mhu+obuZCLE/rtfRkELrR1fm/9/BnnraKPImjEwnMSxxz9Y7BVbUtxHZRNkXKzIfCPbZ1fNeNLFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c1EWAvzB; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1EWAvzB"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6eb7ef71c03so581194a34.0
        for <dm-devel@lists.linux.dev>; Thu, 18 Apr 2024 09:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713456912; x=1714061712; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VAWJsbeIDSPygX7YaLR6isLPd2p07JOTl8DsjelWL0A=;
        b=c1EWAvzBLbAx3y239camEJYnyeqnD3gETyXCXzeN67qNc/Fem2dVq7oTG3+86ffK7w
         lA10ooX9531ZBMuVqPfRedRkqHRUiHIpdFdcLScEwZrJjxmypLYRLULoTOS/NaPAKxsz
         EBkmS11yPSae33V3G8dSbHJ5FJjDBDeg70hY7GaEzUk80Npnf2qvmBcPGNicjX2hITCz
         KpLbhqB+jETLvoWKVmuHxRyd3J8SN4eEO+rLjlfOYfDKxIzia8RcSOgcpl/D6GWP3pzN
         6yqHdUr1bWAsPkCJAi/vP7Z1raNUdDCnmWFdu0H8rdmQleakJGG0+cvfMCK80km8TLzH
         7QrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713456912; x=1714061712;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VAWJsbeIDSPygX7YaLR6isLPd2p07JOTl8DsjelWL0A=;
        b=GnRCR4PsEl9QKVyWaoRe4752u++wztNQkQVZn46ppdPaE4paMHGXhNVOcrVKBNhXIQ
         rMu1CFPFXY+yN+SPOD0o9fic+HL9wYhKu1uwuDRL74eyXV8TlRR88UQipje19fbO/V6p
         EZPDfYjBg0mApr7CtRDhinU37PLvCJ3joRaa4j3RLkzbkNsecVO79IViNoAamDZn03jE
         X3P9c1ZY5Z5t/9KYtVdJHLQZrBmyNUI8wEUUc3AAa3yUvKlhQuVBcBC3m5kfYGmShuFy
         CfZXPQMuE8IXIub7jc8D06hD86O0bC0cMVcbqlyNEA3BvyxGV/vwFZe9EHhn7rpUnL1h
         izwg==
X-Gm-Message-State: AOJu0Yxg/AMovIyJcYonV46WQ4ToJmeGwcUNunud3epqwpt8OpH4U0fu
	lwkpBKonBTkpYtXx2VjOUN+bQphI5oYmT/UgK3IheR0f0mS87qVF2iJ7Gcof4/tZXKlKECzpJ+s
	HyB3c4unQW6Rg0Mvb2U0EGrgc5H9zyp3P
X-Google-Smtp-Source: AGHT+IG9WoTS6CA6T+P4LiuddqiFyJz0c0N9Gx5lD4u5hg/Ucy1y20EiZHQHrEnpCML7PkJHTGCD5Nho5c5mAzYpSwY=
X-Received: by 2002:a05:6870:ac0c:b0:238:ffae:b5fd with SMTP id
 kw12-20020a056870ac0c00b00238ffaeb5fdmr2521205oab.54.1713456912677; Thu, 18
 Apr 2024 09:15:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: dE <de.techno@gmail.com>
Date: Thu, 18 Apr 2024 21:45:01 +0530
Message-ID: <CADofXPAz2v0teH91QtAzNQ5jfp8bU1+8hwoZUs-0h+G7KLdZkw@mail.gmail.com>
Subject: Decrypting only uses 2 threads.
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi.
    I'm trying to encrypt some block devices and trying to use a
cipher and mode which is multithreaded. I'm trying out
aes-ctr-essiv:sha256 to test multithreading, but have also tried
aes-xts-essiv:sha256 with the same result.

The encryption is definitely multithread (massively), but while
reading from the encrypted block device, I see that only 2 threads are
being used. As a result when the CPU is throttled (deliberately), I
see a drop in throughput while increased CPU utilization only in 2
cores.
The following commands were used to setup the encryption --

cryptsetup -y -d - -c aes-ctr-essiv:sha256 --key-size 256 create disk1 /dev/sda

Is there anything I can do to increase concurrency while decrypting?
