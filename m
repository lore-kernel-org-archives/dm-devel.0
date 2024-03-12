Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19665446A2;
	Tue, 12 Mar 2024 22:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710284114; cv=none; b=FLn14dXWSWjYzkXOnKdtNAoQpkIbs3kLAnwvaQFYe5CB6GCzywKkNtknUSGRoR4VeOA+O+SCcSD7WY8c0lDS/4aucqPCgVJojzQUpFsGHCQCk81/ZfoKNcqltGd+C0HGVwrAIfoWD/FZltUFtppQPaHiYEH27xhp9DVjfQQ1Yws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710284114; c=relaxed/simple;
	bh=pqB0kQNo2lOrlfpuu3b2oAK++B35JKyT39mKFe8+dtc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TV+FImfA5AB90WxsnXeBZWwRMkrD6Z68NxzGvqETJFPTtSqhYFd3GegddOR1TfAzWS5Qnsp+0sjZEVIr8RKlpIiCQUzFFGzZiFJ03T7F9oB3uI3aUjFmHVRkvtkhJxlkCGZi1aTjRECeDRc892IjsDouaejlrXLc2GoTCcXfHsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRLhNfN4; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRLhNfN4"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d33986dbc0so69500661fa.2;
        Tue, 12 Mar 2024 15:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710284110; x=1710888910; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dn4o2EhSzw/dPcbf0I+GhuZZGnLjYr0VW9p4Ognw3lA=;
        b=kRLhNfN4MOvltVcSCD4WChbGmAfqNg9EsWiEK2m/tSxZ6Tg0bYTdybeiEmgwRuPcNq
         TO8BDrRO4rEZjK3ScaU1e5J2ToXYQN5bGYivC6LVjcnlkXClIhAprofZAmfeLW/cV/Mq
         ClozsJ4/Bpl25UlAkXoZ/Wjn8cE0CzIutleXPVu5gVgOrGOkN8sHDcsGeT7F2qYbEMet
         InE0YG59Tsh9s+Ur730+nwFvlC9gkbrkMHu4nHzf1meJB1IFp4ls/jpnlSZOm2MhFtzJ
         wX86+h4E4S5u3x4U5xl/JEKK/1gefq9VFnlknQzy0pu3fkCcCcmk31DNyQMQn7rTfYt+
         7wfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710284110; x=1710888910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dn4o2EhSzw/dPcbf0I+GhuZZGnLjYr0VW9p4Ognw3lA=;
        b=U20FF5sUitVcTbM/lhPJreRcBzKUV+oduW6Vg83kzOf66/519uuYDKTtDy0jFxqLd0
         PhXJVm21V2hWB6jdIro4ytE09fFystuyABSktptUJDv1eEOcslekyk4aotZvH8Ue+LNL
         mtRxrsPG7Rq68sWCelLEPrFILuGiqKay+1bfdNyBmrXpz678R39rRc6PAFykTe876Jd3
         FFTX0BWTDnvQ52nMim5y4XSUpDTQLjg7wJeM/NZ0OrzQpKLZSNe4a9ebZpQoW1zljKqM
         +cum+S/1j6eUAmHNh4v98AuKobWX3R9pYOZvJtqN0I/N0vwcFyYCLt2bG53INaOykOlj
         PzHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTMAYtNnzvQY/7+0MgiWeQfbsnHmBFgERz6ec5owoUiGg+S3CZc+bNaDE68bJO3vPK4sCgWYj9X8AKghfxBwqllUlKpzOPM+Gch5Twkg0Q11VaEMDyWSaTEyRSd0eiKb4TP3KPaQ==
X-Gm-Message-State: AOJu0YwDTwj6RcXv45BvfqabYk/q2Ep+5jhgHUs5LjeCevTrPF+iYVg+
	pc/Wu/Tu/l0I7RY7HAOzVcOmdAjCBY1XQ55X7/X5FguPeOWNN03Y1yZP64VCazEkHfAgAYI4SPV
	yPITi2iZXyhcOCV3YbYfPbd6XyV0=
X-Google-Smtp-Source: AGHT+IFbWul1azbb7FTg9EddCY7T7oYsUqF6TE3i9r9b9TycKD6mwZxOcnZoYoeU6Y0yDRibf8dC3NEMMFfQCe9VDFo=
X-Received: by 2002:a05:651c:222b:b0:2d2:751f:abb2 with SMTP id
 y43-20020a05651c222b00b002d2751fabb2mr2507208ljq.3.1710284110049; Tue, 12 Mar
 2024 15:55:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAOCpoWexiuYLu0fpPr71+Uzxw_tw3q4HGF9tKgx5FM4xMx9fWA@mail.gmail.com>
 <a1e30dab-dfde-418e-a0dd-3e294838e839@inwind.it> <CAOCpoWeB=2j+n+5K5ytj2maZxdrV80cxJcM5CL=z1bZKgpXPWQ@mail.gmail.com>
 <a783e5ed-db56-4100-956a-353170b1b7ed@inwind.it> <ZedaKUge-EBo4CuT@redhat.com>
 <ZeiS/bjJaRcrerWW@fedora> <CAOCpoWeoQMh_-MxzxGBnK2Kf5EhvTLs=GrGwJ5XcfGVRTp73Eg@mail.gmail.com>
 <Ze2azGlb1WxVFv7Z@fedora> <Ze3RWqLvG18cQ4dz@redhat.com> <CAOCpoWf7C=B1sdeUL46sVVtVUDH8+o_T9LGJNTOYqA317uMdmA@mail.gmail.com>
 <Ze8DZLBHhCxgzc+r@fedora>
In-Reply-To: <Ze8DZLBHhCxgzc+r@fedora>
From: Patrick Plenefisch <simonpatp@gmail.com>
Date: Tue, 12 Mar 2024 18:54:59 -0400
Message-ID: <CAOCpoWd5VWZnAaYvkFDYo736ZXDK0bExC9NkwVGfLv_CATj9Rw@mail.gmail.com>
Subject: Re: LVM-on-LVM: error while submitting device barriers
To: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Goffredo Baroncelli <kreijack@inwind.it>, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, regressions@lists.linux.dev, 
	dm-devel@lists.linux.dev, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2024 at 9:13=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Sun, Mar 10, 2024 at 02:11:11PM -0400, Patrick Plenefisch wrote:
> > On Sun, Mar 10, 2024 at 11:27=E2=80=AFAM Mike Snitzer <snitzer@kernel.o=
rg> wrote:
> > >
> > > On Sun, Mar 10 2024 at  7:34P -0400,
> > > Ming Lei <ming.lei@redhat.com> wrote:
> > >
> > > > On Sat, Mar 09, 2024 at 03:39:02PM -0500, Patrick Plenefisch wrote:
> > > > > On Wed, Mar 6, 2024 at 11:00=E2=80=AFAM Ming Lei <ming.lei@redhat=
.com> wrote:
> > > > > >
> > > > > > #!/usr/bin/bpftrace
> > > > > >
> > > > > > #ifndef BPFTRACE_HAVE_BTF
> > > > > > #include <linux/blkdev.h>
> > > > > > #endif
> > > > > >
> > > > > > kprobe:submit_bio_noacct,
> > > > > > kprobe:submit_bio
> > > > > > / (((struct bio *)arg0)->bi_opf & (1 << __REQ_PREFLUSH)) !=3D 0=
 /
> > > > > > {
> > > > > >         $bio =3D (struct bio *)arg0;
> > > > > >         @submit_stack[arg0] =3D kstack;
> > > > > >         @tracked[arg0] =3D 1;
> > > > > > }
> > > > > >
> > > > > > kprobe:bio_endio
> > > > > > /@tracked[arg0] !=3D 0/
> > > > > > {
> > > > > >         $bio =3D (struct bio *)arg0;
> > > > > >
> > > > > >         if (($bio->bi_flags & (1 << BIO_CHAIN)) && $bio->__bi_r=
emaining.counter > 1) {
> > > > > >                 return;
> > > > > >         }
> > > > > >
> > > > > >         if ($bio->bi_status !=3D 0) {
> > > > > >                 printf("dev %s bio failed %d, submitter %s comp=
letion %s\n",
> > > > > >                         $bio->bi_bdev->bd_disk->disk_name,
> > > > > >                         $bio->bi_status, @submit_stack[arg0], k=
stack);
> > > > > >         }
> > > > > >         delete(@submit_stack[arg0]);
> > > > > >         delete(@tracked[arg0]);
> > > > > > }
> > > > > >
> > > > > > END {
> > > > > >         clear(@submit_stack);
> > > > > >         clear(@tracked);
> > > > > > }
> > > > > >
> > > > >
> > > > > Attaching 4 probes...
> > > > > dev dm-77 bio failed 10, submitter
> > > > >        submit_bio_noacct+5
> > > > >        __send_duplicate_bios+358
> > > > >        __send_empty_flush+179
> > > > >        dm_submit_bio+857
> > > > >        __submit_bio+132
> > > > >        submit_bio_noacct_nocheck+345
> > > > >        write_all_supers+1718
> > > > >        btrfs_commit_transaction+2342
> > > > >        transaction_kthread+345
> > > > >        kthread+229
> > > > >        ret_from_fork+49
> > > > >        ret_from_fork_asm+27
> > > > > completion
> > > > >        bio_endio+5
> > > > >        dm_submit_bio+955
> > > > >        __submit_bio+132
> > > > >        submit_bio_noacct_nocheck+345
> > > > >        write_all_supers+1718
> > > > >        btrfs_commit_transaction+2342
> > > > >        transaction_kthread+345
> > > > >        kthread+229
> > > > >        ret_from_fork+49
> > > > >        ret_from_fork_asm+27
> > > > >
> > > > > dev dm-86 bio failed 10, submitter
> > > > >        submit_bio_noacct+5
> > > > >        write_all_supers+1718
> > > > >        btrfs_commit_transaction+2342
> > > > >        transaction_kthread+345
> > > > >        kthread+229
> > > > >        ret_from_fork+49
> > > > >        ret_from_fork_asm+27
> > > > > completion
> > > > >        bio_endio+5
> > > > >        clone_endio+295
> > > > >        clone_endio+295
> > > > >        process_one_work+369
> > > > >        worker_thread+635
> > > > >        kthread+229
> > > > >        ret_from_fork+49
> > > > >        ret_from_fork_asm+27
> > > > >
> > > > >
> > > > > For context, dm-86 is /dev/lvm/brokenDisk and dm-77 is /dev/lower=
VG/lvmPool
> > > >
> > > > io_status is 10(BLK_STS_IOERR), which is produced in submission cod=
e path on
> > > > /dev/dm-77(/dev/lowerVG/lvmPool) first, so looks it is one device m=
apper issue.
> > > >
> > > > The error should be from the following code only:
> > > >
> > > > static void __map_bio(struct bio *clone)
> > > >
> > > >       ...
> > > >       if (r =3D=3D DM_MAPIO_KILL)
> > > >               dm_io_dec_pending(io, BLK_STS_IOERR);
> > > >       else
> > > >               dm_io_dec_pending(io, BLK_STS_DM_REQUEUE);
> > > >     break;
> > >
> > > I agree that the above bpf stack traces for dm-77 indicate that
> > > dm_submit_bio failed, which would end up in the above branch if the
> > > target's ->map() returned DM_MAPIO_KILL or DM_MAPIO_REQUEUE.
> > >
> > > But such an early failure speaks to the flush bio never being
> > > submitted to the underlying storage. No?
> > >
> > > dm-raid.c:raid_map does return DM_MAPIO_REQUEUE with:
> > >
> > >         /*
> > >          * If we're reshaping to add disk(s)), ti->len and
> > >          * mddev->array_sectors will differ during the process
> > >          * (ti->len > mddev->array_sectors), so we have to requeue
> > >          * bios with addresses > mddev->array_sectors here or
> > >          * there will occur accesses past EOD of the component
> > >          * data images thus erroring the raid set.
> > >          */
> > >         if (unlikely(bio_end_sector(bio) > mddev->array_sectors))
> > >                 return DM_MAPIO_REQUEUE;
> > >
> > > But a flush doesn't have an end_sector (it'd be 0 afaik).. so it seem=
s
> > > weird relative to a flush.
> > >
> > > > Patrick, you mentioned lvmPool is raid1, can you explain how lvmPoo=
l is
> > > > built? It is dm-raid1 target or over plain raid1 device which is
> > > > build over /dev/lowerVG?
> >
> > LVM raid1:
> > lvcreate --type raid1 -m 1 ...
>
> OK, that is the reason, as Mike mentioned.
>
> dm-raid.c:raid_map returns DM_MAPIO_REQUEUE, which is translated into
> BLK_STS_IOERR in dm_io_complete().
>
> Empty flush bio is sent from btrfs, both .bi_size and .bi_sector are set
> as zero, but the top dm is linear, which(linear_map()) maps new
> bio->bi_iter.bi_sector, and the mapped bio is sent to dm-raid(raid_map())=
,
> then DM_MAPIO_REQUEUE is returned.
>
> The one-line patch I sent in last email should solve this issue.
>
> https://lore.kernel.org/dm-devel/a783e5ed-db56-4100-956a-353170b1b7ed@inw=
ind.it/T/#m8fce3ecb2f98370b7d7ce8db6714bbf644af5459

With this patch on a 6.6.13 base, I can modify files and the BTRFS
volume stays RW, while no errors are logged in dmesg!


>
> But DM_MAPIO_REQUEUE misuse needs close look, and I believe Mike is worki=
ng
> on that bigger problem.
>
> I guess most of dm targets don't deal with empty bio well, at least
> linear & dm-raid, not look into others yet, :-(
>
>
> Thanks,
> Ming
>
