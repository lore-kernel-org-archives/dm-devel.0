Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5453D64B;
	Wed,  1 Nov 2023 01:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YB6hno11"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-d9a3d737d66so4977454276.2;
        Tue, 31 Oct 2023 18:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698802056; x=1699406856; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9F2S85nrQwVjkJXZ1QXNB9unaOxe7JFrDjf8Uexjb0=;
        b=YB6hno11RDrqmMpSqbbT4GgBGsStBCzoAZlk9WCB+fKEmsvmBp0AvO8ZafGcmmwv+e
         6xTD8cSgonKT/214Zd+aPg11bLKI0bTxp1d6IjZjQSwRa5gquzI5Wq9XjD/Tu7RQT7Sv
         hbYWi/VbsnFar3L1BofYmOzfYuq8++D3TESoI9ONsfS4r8ZV+Wuw/+yADaJjrRthnVU1
         VgHm3b13Yie62hM8N0NGPmbepNqP5FQF4SACQnIVNfAtY0xny5hixzXr2omNbM7gZUu+
         Z4TUwLnayKGT+MtZ3zL2HACeAIAFP6Yaj57pvWnk1j6Zv7ujZG3pG+/BldCA4W4TKT3E
         mCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698802056; x=1699406856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9F2S85nrQwVjkJXZ1QXNB9unaOxe7JFrDjf8Uexjb0=;
        b=kksymnPj2K886+cNjuI4Qnl3ONXmsggZk0OBjbpoH68+SarHMZFUTVqTYXqMS+FLyA
         2gWghHFoSnOSgXz2lxtT+2ueKD8xDb48Zxc+pEMypgrwyCPmugCN4jC/0nUSMvWcgqrN
         GNeLk+Gb6bRCaN4/vayrc5qZ9ZFYOkqVrajasVFKvuciO1pww8LLUechqQ8F6H0Y2Smk
         G+mVlBUtycUrMoFyjrUbBpOD23XYg4NnXscNwp79uSWURkHdrzOfV5zSEJXrjUzr3ktv
         wo5PlL7ms+KO+WdrWlMCLiC6onLkyj/v/Vjh3yg2ox7si2KUt92bq4IZ0TsmHBEZE6Lq
         /Dgw==
X-Gm-Message-State: AOJu0Yx7BoZ/AueUx/oHfiLeXj5XYcfPgIWlFQuiNbyi3lt6BPnbhbk1
	5EDr5f2GSPIeSH67Pni+1L4sastSUSe8rHPNhyE=
X-Google-Smtp-Source: AGHT+IGE/c64lLcNYlD85SNTuo1FeA7mh/riwGBmUgRjj+nc5k98CezvOKtRYTWCC891QYGix030sHR2YhBq+BrvIh4=
X-Received: by 2002:a25:b318:0:b0:da0:c49a:5fdf with SMTP id
 l24-20020a25b318000000b00da0c49a5fdfmr10745700ybj.7.1698802056126; Tue, 31
 Oct 2023 18:27:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com>
 <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz> <20231030122513.6gds75hxd65gu747@quack3>
 <ZT+wDLwCBRB1O+vB@mail-itl> <a2a8dbf6-d22e-65d0-6fab-b9cdf9ec3320@redhat.com>
 <20231030155603.k3kejytq2e4vnp7z@quack3> <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com> <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3> <ZUEgWA5P8MFbyeBN@mail-itl>
In-Reply-To: <ZUEgWA5P8MFbyeBN@mail-itl>
From: Ming Lei <tom.leiming@gmail.com>
Date: Wed, 1 Nov 2023 09:27:24 +0800
Message-ID: <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com>
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
To: =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= <marmarek@invisiblethingslab.com>
Cc: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org, regressions@lists.linux.dev, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 11:42=E2=80=AFPM Marek Marczykowski-G=C3=B3recki
<marmarek@invisiblethingslab.com> wrote:
>
> On Tue, Oct 31, 2023 at 03:01:36PM +0100, Jan Kara wrote:
> > On Tue 31-10-23 04:48:44, Marek Marczykowski-G=C3=B3recki wrote:
> > > Then tried:
> > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D4 - cannot reproduce,
> > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D5 - cannot reproduce,
> > >  - PAGE_ALLOC_COSTLY_ORDER=3D4, order=3D6 - freeze rather quickly
> > >
> > > I've retried the PAGE_ALLOC_COSTLY_ORDER=3D4,order=3D5 case several t=
imes
> > > and I can't reproduce the issue there. I'm confused...
> >
> > And this kind of confirms that allocations > PAGE_ALLOC_COSTLY_ORDER
> > causing hangs is most likely just a coincidence. Rather something eithe=
r in
> > the block layer or in the storage driver has problems with handling bio=
s
> > with sufficiently high order pages attached. This is going to be a bit
> > painful to debug I'm afraid. How long does it take for you trigger the
> > hang? I'm asking to get rough estimate how heavy tracing we can afford =
so
> > that we don't overwhelm the system...
>
> Sometimes it freezes just after logging in, but in worst case it takes
> me about 10min of more or less `tar xz` + `dd`.

blk-mq debugfs is usually helpful for hang issue in block layer or
underlying drivers:

(cd /sys/kernel/debug/block && find . -type f -exec grep -aH . {} \;)

BTW,  you can just collect logs of the exact disks if you know what
are behind dm-crypt,
which can be figured out by `lsblk`, and it has to be collected after
the hang is triggered.

Thanks,
Ming Lei
