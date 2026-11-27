Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795781091;
	b=3YfE7V3bpUVrtrOs+Jk2GH4lfDN97uaFbCaKgr2nUMvPwC3CfXQ5P/vc8gQyj2m0fMc2
	 gejiMOzQFhScxjePm0ogXKnTC4LU0DFftXk3sI/X1DYEz6rsUM3GlOmB8mbLh48jLWhdD
	 OlDDgPdr6FLXzJ3kuZyLE0+q3Lp059M9Cb2qz+B25vlpRnJ5//VG4j0zES/LjWCrNSDM1
	 X8SIPCvj87NJPUWgW/mO7sPR/hRRVDOyo40yYHio9uX1YLaaZPCHVtRAtLStJNMX4KDg3
	 XTR0eexk0yEH8YMcTlq5uamNtoq9f6s7IIgMGuGyQjUWP1Yzaav8X7XX7NooPktqpvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795781091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b4JpyJqTqKs/ooTkoGf0tRzxzjeh27dYY7H58le2fz8=;
	b=FFAb4GixWnQDjPwUBwfBC0tqSIWX1pxhq47hAWKdVsMw0rIeWmCMdf1Tbw36ra4Fb449
	 w4VwCpxNL9cKtZCPskFajWV1wSbyixBy85nx/lFtaDrb7JNtMr5IzoKgoOMK/P30GpKh+
	 5znUGFTLd/HVDrvHdx4GpNj82DRmwXOwF54ck3Fx5Kja3A47awPVbO3caeZOzMhpFOoGn
	 FDVYlHBEJVrcsyxgD/L3zvQRb7hJJqX/p+FER5khRjhmTOF3RX0CB1xz1+/57rHe+nv30
	 J6ACqnBaLxMwKSEANHMP7P9sArAbibDYIUaO0NoiFv2Ne6XReB7paUrCC1BeQne18bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TrIyunAB;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479AB606A31C
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 12:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 479AB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TrIyunAB
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-38699cf08dfso10026181eec.1
        for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 04:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795781090; x=1796385890; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4JpyJqTqKs/ooTkoGf0tRzxzjeh27dYY7H58le2fz8=;
        b=TrIyunAB+h5JJDCxy+MHx9QSoLRsgivctfjQlu64DjQCyR7+zgjqgkuUEqbmy1QyS7
         wphbPRrz61+9mHLiVZAOnJqALy1HZTJ0eW2M9TccFoOSa7B5TxM/Xl+51o+YvjmWBOXz
         ejjjMVKcuPkhw0+VcRjAO5vOGKyl5HqNDeO8hwf5wecI8h2R3BYFfC3PPLXiCT/C9R6t
         fqu473Rp1UqqCE34SuAzMeVtnhICOJ07pVEvHynin/tymFoBtailXs1N70f/3wApFnWZ
         E4uoIzQW1qgInx4f+m1UleBI+JLRnVE+0THC1QS+VBl5POZ5MC1d28PPeJOwZ8thO5GZ
         IK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795781090; x=1796385890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b4JpyJqTqKs/ooTkoGf0tRzxzjeh27dYY7H58le2fz8=;
        b=YydzRGvGhPpKCGxMCGRr00KjSQpzeFqust44QXTY7Zh61fstsxXiZEYKT5N79EoxKi
         aCsGn7I7N/kQI0fiWzzi0JjgxZTQvfbNR64N/3qdjUCStSXZ7DdgvjCsKdI3RIYWKpxE
         /wRioqX2avlUOz4r0KnaeIS8f4c21Kw/aSd3A41yD4mUpV0C7dkrBsfp/HkEH2nMxbPP
         VEpkiZHOB8L40HYQasCl5Y0RUl66tpCeeriAO/+hGssCnFMqqeYQohQFZCZuO4FF5L7O
         Plc5EgTjr65pXTSPG1qzsopkivqhKv4MiA93kxY4gj2yQfdg7aGRN5K3tIikeophObEO
         sItA==
X-Forwarded-Encrypted: i=1; AL+hErEEePFJ/FhUXd03jI6wAqPy6/lt5C37xaZ2S37ZEFPWPKGxO3JZzZmfCC0qG++KkjuGBp26tAhsPg==@lists.linux.dev
X-Gm-Message-State: APuU4Z8OzNsLMqb7L+aKA7FW5nrrYsllKA+A/r5726nRMhTiGRi/Q3mt
	3hBvHC/Kzl4nqvl7dRRREJW/QqpWk6qPSxIEVEvNTXfFdUcgq+hSftBX
X-Gm-Gg: AZFdTZd1wppxhX4c8EiFtmD1E9HcfiDr3XS/VYi/MGS/KOYMBSA8lnfFf4lr6KqwEXD
	MOJiKlF3wOO17LVgfrzBDoHTT3COSfj7Fc4cqTHXIhBr1lKvscQkq27/l9FLTc3uxd3dl7Avg7z
	WKCYuO1/JdU4nE/f/WLMtBZqQEDgpKi9X3KZVxL/Xd4+fcBttcrFtN+lEFtMljasoPovW75jJjI
	3y2EoLxicmM7Oh+1Lv9wWaj+8NTkNPEGIT13vLgvY/RLjlCdWIIW5526VztvI6pjp6hataHS6bG
	lBUIxELJXLUbw6zPiQrSevlHrf2kM+AWNsdiMmDx/cz5vR6LIc9rKSSt1IoGrZcijn9jg+21VVP
	jSyAMf6NsK5vX49b8sNAuQ4G07DynT4TBFiTANS7CrckW8sdFipYpk1KcfaerEbQfNDYBmGwck4
	HWB9fC8+eu2qZ0MrDMo52hhEKJHe75y34IO2Ln8zUdrh5+nTQp29Bh8FH7eH5aAfmTKJyeMwDzR
	3iJWcy8/pemDxVNauXGZtl2Bes/3Lla29dVyV+lMHZgSNQAN37fYqAsmxZQcxdyIIJ9dtxbSsV6
	kgJhmR/qflNeVmRrFX3bjmjtTLl3aPWfhQxp/rNHynA=
X-Received: by 2002:a05:7301:fc04:b0:386:ea31:7123 with SMTP id 5a478bee46e88-386ea318008mr2846416eec.25.1795781090329;
        Fri, 27 Nov 2026 04:04:50 -0800 (PST)
Received: from deepak-80tv ([2405:201:a40c:e0d8:ae82:1cfd:7bfd:2676])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567cafec4sm81729565eec.26.2026.11.27.04.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:04:49 -0800 (PST)
From: Deepak Pandey <deepak.os.system@gmail.com>
To: 847807867@qq.com
Cc: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	syzbot+1eda626824b6334f5ad3@syzkaller.appspotmail.com,
	Deepak Pandey <deepak.os.system@gmail.com>
Subject: Re: [PATCH] dm snap: clear pointers in alloc_area() error paths
Date: Fri, 27 Nov 2026 17:34:34 +0530
Message-ID: <20261127120434.746380-1-deepak.os.system@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <tencent_D498CB0489BB9C74184B927C7393282E9806@qq.com>
References: <tencent_D498CB0489BB9C74184B927C7393282E9806@qq.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Nov 27, 2026 at 09:58:00AM +0000, Shuai Liu wrote:
> alloc_area() vfrees ps->zero_area and ps->area on allocation failure
> but leaves the dangling pointers.  When the snapshot constructor then
> calls free_area() as part of teardown, it vfrees the same buffers
> again, triggering a WARNING in vfree().
>
> Set those pointers to NULL after vfree().  vfree(NULL) is a no-op,
> so free_area() is safe to call multiple times.

I reproduced this issue locally using the syzbot reproducer in QEMU and
verified that this patch resolves the double vfree() warning on -ENOMEM.

Tested-by: Deepak Pandey <deepak.os.system@gmail.com>
