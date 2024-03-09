Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9B222F07;
	Sat,  9 Mar 2024 20:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710016745; cv=none; b=p8d6zDdX0W3qYyACsnoChmddmpmcsf9sZ7LkzL6/FaxBJEDkYpaZu42T+W2vRGKKgwguL/zGJFCePqzG7++zRXQYPDC4pAd28oQsFWN1Y9ChUdS0QvO6ZRQdsnJuphOXaD8lGaMLVlaD/ZvtBUCzLHMg2yLSajUcVyZ1LVkl9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710016745; c=relaxed/simple;
	bh=08Kf6wLUralnLwdcMzfktgfwRNCnuyqHwA/xZ33ICdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GehoxrjvXB3xRIIMxV8ZgolEjjtstYsWqm1u9ePyqrvtbeWgHsg/UMyZVoF6lJiV5BkQDQtXaGcP6FPT3Q6oPJTMaAwhN8UOdZ0l04NVRP9k1yhEe88LBOp3VWl6ircGyjbpTJ/6giSlFFwDr2SWJjnCAO4d3M3T+QPM+0lXsy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ENclhA+O; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENclhA+O"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2d094bc2244so45545761fa.1;
        Sat, 09 Mar 2024 12:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710016741; x=1710621541; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JDiTA26ys4mFafvA8yF6JgwyplvVYoLA/SIyv4h4Hm8=;
        b=ENclhA+OgtLBO7lpVPZBgF4UVQ7iliUcP+qzap0gJddxvF7BSYWeJ7qIO8VbDyV/gf
         oMcmC8m9FaaB0iOb4Oz2mbFynI4e0O63mKZZg1+3TsAsgFwUbJuv4v9ssXiFiv8DdaQZ
         n0xTYrPP7O5j1Imld5WH3yhuduLhRa8NEfTOscpDPasGCKE+iE8c+xqrQoPgaOXsFrO4
         0S8lO14hoXNjPgVLFqn9pAV66wSleHcvLL3kdLZQvnvYq1miDSoWDldEXckcttfu3z/w
         COJ/R9qDIx5u4xFbJDhfe9HkpLgLVz6Uv8ODVV+JNVnqCLzm5a+aKmFzuk94On8MwY58
         BsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710016741; x=1710621541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JDiTA26ys4mFafvA8yF6JgwyplvVYoLA/SIyv4h4Hm8=;
        b=URtVs8S42gqS+31IkTV+FAubbKb8q/LA5MxL3Pi36KRVbhGPamJ/tki+YF9AIRbEif
         dwdbHFyTWAqlLoDIcCqY13+jtVocdJZdrBQKyOs1iFy6Kkm6IuVXDDtj8sUOnGKF2PhB
         1FwgSkFsz8snb1CVXXgP0ipIRrcarsnsNLrcepOZqwRDdcyVpbE+w8VCZY0lu9cqVCVj
         1NhIbrf7X4KjmoJVKUSp0Wrch+sV0ccpJC9uY1rIDcZE53UveM3hg/knsgF+Tz8Cq1ab
         snO4/VeCnCjPSfbUNOD9jOmmfr1f6zJA5DA59xOKcZji6avwz7zjFenpLQ4pzuk2CXnE
         wCpA==
X-Forwarded-Encrypted: i=1; AJvYcCXdrjWziLbVGZwaMpp5/1C8HJBrFx3W7TIQQ1kT+PNXQQI1NlvQ3wUDY7qNtgl623n6kS7kpRREoQHsJoAKrdONfVgWuxVNHamxYD3J8WEesKGKB9yYjczh+l62mmELWSqSMKSX0Q==
X-Gm-Message-State: AOJu0YxIyOEzH/Ll58U5d6zyXAUcypRmkxXXawqNBNqt/1sG/VbirRx9
	28uuxtkdvDun/T+ojbAl/mp44GRSVV3UTU+POMVN6MTkR99rcFtuLt/gEzsE5u4m/1G7cMnnlOA
	MNrs+WCF3CjEvuje6JY6rBOq9Ke0=
X-Google-Smtp-Source: AGHT+IERdTqVKoEUSiKVsznN2p28O7YPJAQLGRcEucrnAT2z/cFJQ/aJKo0t7/J70EHiCTkANMK5kbyYF9wJmGkOoy0=
X-Received: by 2002:a2e:8ec5:0:b0:2d4:21d6:b05e with SMTP id
 e5-20020a2e8ec5000000b002d421d6b05emr1605477ljl.52.1710016741237; Sat, 09 Mar
 2024 12:39:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAOCpoWc_HQy4UJzTi9pqtJdO740Wx5Yd702O-mwXBE6RVBX1Eg@mail.gmail.com>
 <CAOCpoWf3TSQkUUo-qsj0LVEOm-kY0hXdmttLE82Ytc0hjpTSPw@mail.gmail.com>
 <CAOCpoWeNYsMfzh8TSnFqwAG1BhAYnNt_J+AcUNqRLF7zmJGEFA@mail.gmail.com>
 <672e88f2-8ac3-45fe-a2e9-730800017f53@libero.it> <CAOCpoWexiuYLu0fpPr71+Uzxw_tw3q4HGF9tKgx5FM4xMx9fWA@mail.gmail.com>
 <a1e30dab-dfde-418e-a0dd-3e294838e839@inwind.it> <CAOCpoWeB=2j+n+5K5ytj2maZxdrV80cxJcM5CL=z1bZKgpXPWQ@mail.gmail.com>
 <a783e5ed-db56-4100-956a-353170b1b7ed@inwind.it> <ZedaKUge-EBo4CuT@redhat.com>
 <ZeiS/bjJaRcrerWW@fedora>
In-Reply-To: <ZeiS/bjJaRcrerWW@fedora>
From: Patrick Plenefisch <simonpatp@gmail.com>
Date: Sat, 9 Mar 2024 15:39:02 -0500
Message-ID: <CAOCpoWeoQMh_-MxzxGBnK2Kf5EhvTLs=GrGwJ5XcfGVRTp73Eg@mail.gmail.com>
Subject: Re: LVM-on-LVM: error while submitting device barriers
To: Ming Lei <ming.lei@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Goffredo Baroncelli <kreijack@inwind.it>, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, regressions@lists.linux.dev, 
	dm-devel@lists.linux.dev, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 6, 2024 at 11:00=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Tue, Mar 05, 2024 at 12:45:13PM -0500, Mike Snitzer wrote:
> > On Thu, Feb 29 2024 at  5:05P -0500,
> > Goffredo Baroncelli <kreijack@inwind.it> wrote:
> >
> > > On 29/02/2024 21.22, Patrick Plenefisch wrote:
> > > > On Thu, Feb 29, 2024 at 2:56=E2=80=AFPM Goffredo Baroncelli <kreija=
ck@inwind.it> wrote:
> > > > >
> > > > > > Your understanding is correct. The only thing that comes to my =
mind to
> > > > > > cause the problem is asymmetry of the SATA devices. I have one =
8TB
> > > > > > device, plus a 1.5TB, 3TB, and 3TB drives. Doing math on the ac=
tual
> > > > > > extents, lowerVG/single spans (3TB+3TB), and
> > > > > > lowerVG/lvmPool/lvm/brokenDisk spans (3TB+1.5TB). Both obviousl=
y have
> > > > > > the other leg of raid1 on the 8TB drive, but my thought was tha=
t the
> > > > > > jump across the 1.5+3TB drive gap was at least "interesting"
> > > > >
> > > > >
> > > > > what about lowerVG/works ?
> > > > >
> > > >
> > > > That one is only on two disks, it doesn't span any gaps
> > >
> > > Sorry, but re-reading the original email I found something that I mis=
sed before:
> > >
> > > > BTRFS error (device dm-75): bdev /dev/mapper/lvm-brokenDisk errs: w=
r
> > > > 0, rd 0, flush 1, corrupt 0, gen 0
> > > > BTRFS warning (device dm-75): chunk 13631488 missing 1 devices, max
> > >                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > tolerance is 0 for writable mount
> > > > BTRFS: error (device dm-75) in write_all_supers:4379: errno=3D-5 IO
> > > > failure (errors while submitting device barriers.)
> > >
> > > Looking at the code, it seems that if a FLUSH commands fails, btrfs
> > > considers that the disk is missing. The it cannot mount RW the device=
.
> > >
> > > I would investigate with the LVM developers, if it properly passes
> > > the flush/barrier command through all the layers, when we have an
> > > lvm over lvm (raid1). The fact that the lvm is a raid1, is important =
because
> > > a flush command to be honored has to be honored by all the
> > > devices involved.
>
> Hello Patrick & Goffredo,
>
> I can trigger this kind of btrfs complaint by simulating one FLUSH failur=
e.
>
> If you can reproduce this issue easily, please collect log by the
> following bpftrace script, which may show where the flush failure is,
> and maybe it can help to narrow down the issue in the whole stack.
>
>
> #!/usr/bin/bpftrace
>
> #ifndef BPFTRACE_HAVE_BTF
> #include <linux/blkdev.h>
> #endif
>
> kprobe:submit_bio_noacct,
> kprobe:submit_bio
> / (((struct bio *)arg0)->bi_opf & (1 << __REQ_PREFLUSH)) !=3D 0 /
> {
>         $bio =3D (struct bio *)arg0;
>         @submit_stack[arg0] =3D kstack;
>         @tracked[arg0] =3D 1;
> }
>
> kprobe:bio_endio
> /@tracked[arg0] !=3D 0/
> {
>         $bio =3D (struct bio *)arg0;
>
>         if (($bio->bi_flags & (1 << BIO_CHAIN)) && $bio->__bi_remaining.c=
ounter > 1) {
>                 return;
>         }
>
>         if ($bio->bi_status !=3D 0) {
>                 printf("dev %s bio failed %d, submitter %s completion %s\=
n",
>                         $bio->bi_bdev->bd_disk->disk_name,
>                         $bio->bi_status, @submit_stack[arg0], kstack);
>         }
>         delete(@submit_stack[arg0]);
>         delete(@tracked[arg0]);
> }
>
> END {
>         clear(@submit_stack);
>         clear(@tracked);
> }
>

Attaching 4 probes...
dev dm-77 bio failed 10, submitter
       submit_bio_noacct+5
       __send_duplicate_bios+358
       __send_empty_flush+179
       dm_submit_bio+857
       __submit_bio+132
       submit_bio_noacct_nocheck+345
       write_all_supers+1718
       btrfs_commit_transaction+2342
       transaction_kthread+345
       kthread+229
       ret_from_fork+49
       ret_from_fork_asm+27
completion
       bio_endio+5
       dm_submit_bio+955
       __submit_bio+132
       submit_bio_noacct_nocheck+345
       write_all_supers+1718
       btrfs_commit_transaction+2342
       transaction_kthread+345
       kthread+229
       ret_from_fork+49
       ret_from_fork_asm+27

dev dm-86 bio failed 10, submitter
       submit_bio_noacct+5
       write_all_supers+1718
       btrfs_commit_transaction+2342
       transaction_kthread+345
       kthread+229
       ret_from_fork+49
       ret_from_fork_asm+27
completion
       bio_endio+5
       clone_endio+295
       clone_endio+295
       process_one_work+369
       worker_thread+635
       kthread+229
       ret_from_fork+49
       ret_from_fork_asm+27


For context, dm-86 is /dev/lvm/brokenDisk and dm-77 is /dev/lowerVG/lvmPool


>
>
> Thanks,
> Ming
>

And to answer Mike's question:
>
> Also, I didn't see any kernel logs that show DM-specific errors.  I
> doubt you'd have left any DM-specific errors out in your report.  So
> is btrfs the canary here?  To be clear: You're only seeing btrfs
> errors in the kernel log?

Correct, that's why I initially thought it was a btrfs issue. No DM
errors in dmesg, btrfs is just the canary
