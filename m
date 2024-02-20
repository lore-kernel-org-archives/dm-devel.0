Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EE177621
	for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708451751; cv=none; b=nB27wm2AO1zwWRmCXt3eJw2L3uWvBistsDaKL8xjlsJKlLO6BY/6CGcLa3f/5erYBF/SEpHMPMWeW/VZ7DSgogQS8VZVhKmj+xMLGRy37DngpmSfz1gQ9794uFxvLsPVTTGeI6zKoYLtkH31BjLloSsFh6XGhCfIINeXW/YDYzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708451751; c=relaxed/simple;
	bh=hqb1KpK8idTkVHw05D9DaOecFdA77V8n0hYYGqZ4o2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=qsUQN1CTyB76sfwuVnsClpyfwuq3bxvBdZAu2LMlbLLv1lH8sO7+je3eXjw3R3syBl502OcfdeRJhThz+IHbaJMagjB58082FMOl8caPHyXQ+4v3CWSFGcg8pR0yBOckCJl+zGqTv8YSETXlJqyiQD5YWmI0CCL2pTl0fvJYPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CC3VJNLF; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CC3VJNLF"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a36126ee41eso763748466b.2
        for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 09:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1708451747; x=1709056547; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cs7a6JxSri8UPMBfIFAC6zzBgd9E4B30piovcQly+DY=;
        b=CC3VJNLFf0Re1k+Bx8oPg2czuiCr2p284evecJrT5TUUcB1dpRMum4QbHkL1z4g+Gn
         Yzy4lLvLQKJzudW0y2QX7sMJ6orMgzHF7b6ziKckPfWDeg3VVNK+UPiA4vfuUxj6z12z
         ZzsSIS66J7d4AOr1OWBOVhJU0hxUBFVQxZrVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708451747; x=1709056547;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cs7a6JxSri8UPMBfIFAC6zzBgd9E4B30piovcQly+DY=;
        b=tcldkM6cPnVvAqdPx6VGeIvfhiVIiktTSi47v6zHkWtQepjQZ4bwTiq6b4S/muHNVo
         hycHkO5hNmO5/2HebH4UdmoKpBriGoyjVbBQa5V/F4/zsbv9oLfRe1DI7KiA08Vm4IIe
         +Je6ZafqWlsY1svIAVBdZGlftVWH0XmSlwb2n4ZQRTrHwI16MRj0QwhAxZ+e1bLOC/OY
         OZzJ1hHZHb4yonYZtoPoJelbsoDjMF/GoxChQAmqwknMnvTpQ/kgMcLy05FBLFa5+Oy0
         oKw3ZLK123CZJ7nRv2FT6IZ+2Rf05oViUrKyo3DJMfP4d/niaHlHPAA30u11gsLkoK2w
         Cjow==
X-Forwarded-Encrypted: i=1; AJvYcCXvoDDCZvOjokR8k1hw+zS3zMRLTYeVnn0eLkKrXTe7LHUbTKq2hsDEY+MBGQVz3lgLhKCxB2GJ7OTLSf2UsQRdqghOLJuEf0U=
X-Gm-Message-State: AOJu0YzUgt2xIfti7Qr43c1XIeEPepT37NbF74wJJMWlWxatYjeuK0Lk
	eIGzWo4XC6rKEhuDRCv9iew46GEXwYNLJPyqyQBSfVv2oFaSFC/Fr6ZlhZB+M2BrOiyYAOfLNOX
	zCjLYwQ==
X-Google-Smtp-Source: AGHT+IGD+7B3yF/n5iul/YxM8QjOd01e3saNAJ7+tDmMf+o4N/ZIZH5dOHkC11IROfG5rzuCcrJR0Q==
X-Received: by 2002:a17:906:354a:b0:a3f:2597:f90b with SMTP id s10-20020a170906354a00b00a3f2597f90bmr328945eja.9.1708451747684;
        Tue, 20 Feb 2024 09:55:47 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id tj9-20020a170907c24900b00a3ca56e9bcfsm4182063ejc.187.2024.02.20.09.55.46
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 09:55:46 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563c0f13cabso7132777a12.3
        for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 09:55:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV5pWa0OOpqQnQmYWQRz/V7b5rl9bo5qrrZ4T0d+7Lul5Ao2GbSE9Fgnkxwxsdb1Xm5lciA2QzkI4WS8N8O7zFBOmgGIDhpUuI=
X-Received: by 2002:aa7:d393:0:b0:564:3d68:55f5 with SMTP id
 x19-20020aa7d393000000b005643d6855f5mr5518556edq.5.1708451746591; Tue, 20 Feb
 2024 09:55:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-6-tj@kernel.org>
 <bckroyio6l2nt54refuord4pm6mqylt3adx6z2bg6iczxkbnyk@bb5447rqahj5>
In-Reply-To: <bckroyio6l2nt54refuord4pm6mqylt3adx6z2bg6iczxkbnyk@bb5447rqahj5>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Feb 2024 09:55:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=whqae-+7Q7wbtnEj7YmR8vsx6skTj6j-srV2Fz7cBZ2ag@mail.gmail.com>
Message-ID: <CAHk-=whqae-+7Q7wbtnEj7YmR8vsx6skTj6j-srV2Fz7cBZ2ag@mail.gmail.com>
Subject: Re: [PATCH 5/8] usb: core: hcd: Convert from tasklet to BH workqueue
To: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, allen.lkml@gmail.com, kernel-team@meta.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, 
	linux-usb@vger.kernel.org, mchehab@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 Feb 2024 at 09:25, Davidlohr Bueso <dave@stgolabs.net> wrote:
>
> In the past this tasklet removal was held up by Mauro's device not properly
> streaming - hopefully this no longer the case. Cc'ing.
>
> https://lore.kernel.org/all/20180216170450.yl5owfphuvltstnt@breakpoint.cc/

Oh, lovely - an actual use-case where the old tasklet code has known
requirements.

Mauro - the BH workqueue should provide the same kind of latency as
the tasklets, and it would be good to validate early that yes, this
workqueue conversion works well in practice. Since you have an actual
real-life test-case, could you give it a try?

You can find the work in

   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
refs/heads/for-6.9-bh-conversions

although it's possible that Tejun has a newer version in some other
branch. Tejun - maybe point Mauro at something he can try out if you
have updated the conversion since?

                Linus
