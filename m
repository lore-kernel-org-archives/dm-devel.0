Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7034F331203
	for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773238302; cv=none; b=qar59pPHpxyQad8geNlLQvUGU5PBjQnlERbdnY0IxuBDaztpmAuooNxoxwssrUD8H8pZENbY2fRAKstbJBtm8APQMaNiCY7vwpyCq5xqHudgpfGVwx9BeWIkT4C6L2b0tdkrdw3WyoK1qUfeFDzK6nU7ZEUSgVuu5pzRw3IRwn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773238302; c=relaxed/simple;
	bh=POUJjzeRhBIXfPGojdZfC417KH92loTKx1KmDpRcfoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iKM1ha3w+CPNE/bK7tcXvSZTfQY4JBg1awujHp/rQD9Pjn/uT0H6nQ79nKuygrMJ/dcEvmitlKYqChRofDchN1T/E9tjDurB/vZAT6ykd0FZPoe6NXWprJhpO98VeIVwh2z651bNy9X0J2DycYet3XjF7w0aRlLAu9znCjL3Tgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b96dc65b886so179852666b.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 07:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773238300; x=1773843100;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=rEwRu04whHa10MdMS1mSWalJvBDbCpGT+y3eokWjkZr8xqh8VO08mXWyDKp4b6scs9
         E8n8kTzHb8z4bFYdurEgbhJfkoS5C4TCuVhs4F66O5BGhy2mxiNgj3Iw2uI5sMkrSg2q
         N+HIa6LdWUCWp/oU13ZcZLq5t0GjaYDJGdkMqS4jnbzFHZP/PKM1gM4awHaIA+IRdHE/
         x+ImWT9Uqwc+XMcGSZqMf3rWu6omADLJ2zEL/N6dN1sBpAwsjFdaXRR8sBhKoeExdg0L
         H9hYEQK8tlw3K7oBwrSHzuSE3Id4A8YVrD6zVTWRGfSWMyRz7XPuZD3vvQn4OB6T3MSA
         K0RA==
X-Forwarded-Encrypted: i=1; AJvYcCW/4ZObDAG7L3WwlU42W3d0vwMzFq7LLxMyBOX1bI4CAVjFQttUNcHx/aey3WTsWYtdsAVSZzfFpg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxHAvkIdKznQ60jbuTwRFNhml2cR0RKd1KFt0DtDzVYjSpm3YiZ
	gJoiSWGpkq3HTIIK8028mC8sbJTL3MGEl6UGCfSFQVCyFBs7/Jknq/DVg+IV1uhS5touoQ==
X-Gm-Gg: ATEYQzzKHQ+pWA/qbC6yC0TlyxYrcSlb7Vvlm3s1dJsyLDwdCCM73DR6BT9U8+Praa+
	/bqU0yr2oB2n+ZzhMV07gXUn3toMd1r1DAx/ZZQrdWbz7e87ZPFmYlBH/L5kax4oTo6M7GkmTBO
	qgt1SNv5UbTkEkJhCvYPAYnUfssHGAz/IG42aLkZJFnopfc7sOhdLho4tBFmLci+gqCH0airjwu
	64PL0pL7eoLHj+jvoEqyxU25vntZWdCJibLIk5LgWbhf190+iMldJbSGknzOgGpNUCPrJ4QFlPX
	4E9PKtqC0djZ6fapE/8DrXIrmxfOpZtOY3peWyEeHXDnZaawkdv3Ab4A51NCLvoCbTSxeVQQdZN
	je6+zLQ6uSxqaYf2VoUxZ6QbR27hM5bTQkr2/OkasMM18GBtUq86oeRM0MNC7FWS1sGydb4YnR3
	8uBVigBkQLuvyqTMlVWrIrPMiWK9+Zzig5nWJvxwQQQEpwu7uf9qiL9DG+9Bg/tp8RKnw9tdI=
X-Received: by 2002:a17:907:c0f:b0:b8f:c684:db3f with SMTP id a640c23a62f3a-b97118b0cfamr464725666b.12.1773238299416;
        Wed, 11 Mar 2026 07:11:39 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6631476b1b5sm567571a12.15.2026.03.11.07.11.38
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:11:38 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66174cf4549so2111598a12.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 07:11:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUZvahQzIkOFWu9L1R/UL/MuOO/PcvgtPqq0rgp5H02FT0J3Jn0ln2Zkz/g00G3gMTKnUWUe/KtEw==@lists.linux.dev
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
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
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
