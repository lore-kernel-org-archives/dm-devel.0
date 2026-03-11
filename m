Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E386B31691A
	for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773235375; cv=none; b=fnxwvrJNiOy5qllrabA8BjiOIxgxJFKXPlRJcgpMutogdNWQf14VZmWIlrlI3lY9DqCiGnkR8o8e6PnocYQZkNZWSexACdZq8JQqZDrfKC3JagaCaeMvrKLYqXUnI9E7+Ki3+afbrF5PFxekYn04Ir6rXW88i5FjvW8EhTHPZpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773235375; c=relaxed/simple;
	bh=bQRlE5OR+3/41N9B/xBGXfMeOTv3hgeQ2WrY6jcTpBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TZAzw1Gw6JklLl1upg8orCPy+pwc+hLynqRny78G+5zDRq/vwwnjqJ64x+g3249IInlsQS5fsJKSKWqf8H3zmZuqZRP6t6REfP+V5EhMq9JtSpjXi6LoIe/8u4DU3rg7AI//wghvD9LvmnjtSdP7w1OOKHQYGz9Egtq1HKgMaUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-56739adfa1aso10529661e0c.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 06:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235373; x=1773840173;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
        b=s7pi+uTmq4BbEgZZXZ0hlAwiYRWhRmOTFmMeJoGC71k5SAOTiQM46rMisvMVstn9W8
         fKoEZtoy1LDryqqLSdy77ef6YzYzh0eqAis56AmalJnhed9zUpMXuZzcPhAa8Vu9OnxD
         sMx03QDx7OoDezPM5qBYVwfV0oFf1Z660pG9p18u1qXFu3nI3bdaL1Cab8RksVoGidXY
         43X8WdOQM6oViuaxnzem0BU1EujY62Vu2L/PiOKBLMQyUha8Z3sXRiHvtwxcMR+1+LsE
         k7zbGNv4rgt7+EXe8WH+iGz1qA1TW5alU+EJadiP8okpEN7xExq9esooONwxZLGXiAjv
         ycJg==
X-Forwarded-Encrypted: i=1; AJvYcCXpWhtFkY7WWtahjNBf3mHpP7omFljdkrPOb1kswBZbDEv4CiL/iScHTZqHXh0lGRJWqZFZY4r+GQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxiuDSlvHoOnfG2tFFlzCQEIf1fG4ZIPdlaeJZ6NmuSJC4xPHuS
	8DEBca5aF0Hk951FZZVkg+EBLKGlywSP5285Y6goEU7VlBNLeRnPoDtSDRCslhqrd9E=
X-Gm-Gg: ATEYQzx1Q/ZUth/b9Xsy9WghgJ9MwcL8IzCC2lX6I3fNqwAbGZE1eIWrDS2k3oCE7wr
	t1gwtd/gzWzp6XGXKTwOd5dMCU8mzlE/qYQ3ZdmuLd0Zs9Xy1pNFezlRNaULEQfxIBGTznJu6kd
	p7esmzvh7ylpLuqs6oWPsASV0V0is65tebSep53Xn5rioBdcc8xkryfyPY2NgRkq/yIGDX++Ga+
	p4lhjsC/x1oNjyTD5Zz2oKOkJz6Hj72auUvsZx8vUqYojaDmiBMliNzQQCmRR5GYTdTynCkx/WB
	jOYpk3qbfl40ZikMzAWQ2ep80t7VQffwUsoLF9f7Rktwnupdh8tm4OoWJpKq4F4W2adgobV/mJI
	NQoFoZaMjSho7hqdRLCBFd9bHGHm3l7rsfnmi38NjquBOoQ5c/oXqYVUTuo9uYso+twppcwvoTA
	70N5ZXhgjuCt/rcKjPM2ZUqk1xM6E6nBGYh4Bpk9BhzgMhC2NAUtANblCHo4LJt92S
X-Received: by 2002:a05:6123:147:b0:56a:fb7b:7537 with SMTP id 71dfb90a1353d-56b4769d7fbmr875127e0c.19.1773235372736;
        Wed, 11 Mar 2026 06:22:52 -0700 (PDT)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94ecfc4dd70sm521462241.2.2026.03.11.06.22.52
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:22:52 -0700 (PDT)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-56ae58f3fc6so6636086e0c.3
        for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 06:22:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVw92/PYMvRxpvvB7cyylVCFXeSJZf53I7VmM8V8faDdGgzCmn9Aw58QSacMR09C683CKOtfsfbnA==@lists.linux.dev
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id
 71dfb90a1353d-56b4752d806mr922396e0c.10.1773234967338; Wed, 11 Mar 2026
 06:16:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 14:15:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
X-Gm-Features: AaiRm52J84H77ROK64ZWWtJfaiCpnFeKyoSRmPbi-NC8CN6Ju1TJEFxJU9gZQQ8
Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
Subject: Re: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Mar 2026 at 12:56, Philipp Hahn <phahn-oss@avm.de> wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Yoshinori Sato <ysato@users.sourceforge.jp>
> To: Rich Felker <dalias@libc.org>
> To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
