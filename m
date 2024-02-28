Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE7274426;
	Wed, 28 Feb 2024 19:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149080; cv=none; b=dzBubnjeWvxmK/DbadQ5HhHFvftznVNhe+sLtV1+c+x1hGcRhe0Q+QxFPDoAUS8U8MsNxRYMb1yR9bEHYzSaBEpIpInkzCwSnMpDNYqrwH4e+DnuMXqDJPV+zYdryqz5ccDKY0qq592PAtbZHd/Ds7+TKDBFwgcUXUYYZrKe/b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149080; c=relaxed/simple;
	bh=EFmB4lWDphV8+EpOjlrT5HS+VlJ+NqK1Vzka+3xudRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uJBJbLpAhsd49PQbIrD//UtsCbaNTQXMirO62mYfIh/4rUPqZCf93epUI4z1lo/rOzIawQTDPzCLtkYyAgQugJgfw7sETA9LX0nODtk+hZTmhh5sXm3nYLPUR/RJ3wq484vYmh/sLIM2q/4ugb3M9mdGWIykGqq9tzJlF+EH3ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cfkDZP0d; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cfkDZP0d"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d23114b19dso1080921fa.3;
        Wed, 28 Feb 2024 11:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709149077; x=1709753877; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyl4cRu1qlUcGFJZjiydTaxtRFK5CrOEvpLgHrcgqZA=;
        b=cfkDZP0dqElspGgbNtRQ33eHPsGSUHOTQ6AnyTvNDvs/w6xpJEddtv7U2VkjGSKn0n
         jw+3WQaekWl+BvOcjLV/Z09Ocb3MR8/OQ00Bu7vyhWWq6Pyf2Uuq5/U4ck618LQRE1Xy
         veYAA9Gkrl8m2kRZCMKAubW8g8IvQQpkV1vQd7Mj3v9E4wnIbr9vHMyXgZdVbxv2QdII
         gWYCS3iUdtFRAoVjtiUTl9fRNUPagHKObpF15TTNGg+VqVWufBrgQVU57tlHjxtxPR30
         K+YvM5AIMS+Dj3DRFly8cU+/De3h4xE3/rOaDsLgquYm304WnMWwphsQHWIY9A1f1N+f
         MsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709149077; x=1709753877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyl4cRu1qlUcGFJZjiydTaxtRFK5CrOEvpLgHrcgqZA=;
        b=RHX019X/biDulam0O1f8tnliufESMQ1ugGi9dKordkwtIVBHdXte80nhf9n0R7LJgQ
         8cx56yI0fFwI7T5whiduJkUMd70l/amYarkLDFPO7oHIXxKWzE8dSU37WJhkv5om4exB
         lNT+pMd+9jPlk8cLiZ2HfU5h/HTTCPlTHZy71sn3KfAVm0H4qUbVArd+zduoilJPmZxf
         ZGZjhalYraGVS24Drma19O8lEpeMQfpimGF6Ph5Xjo5A+1Fw5tw/Y4Z0mQMx/RzDATs6
         PITEGDsNNtA9b2YvzzFgV3I8FiVRYOJFrIGY3DubVCDzqe2vUmfyWfgiSzZ0hlKuNChh
         fTmA==
X-Forwarded-Encrypted: i=1; AJvYcCXjbDY8d5LIy+f7sPodCPNk82mjCRmZai8I9ncMSPomvbtKwFRCmCRDbLrvRtZDUOMhaMbobRpfPrRYXbTn4YelcMO9JtuN6eOAqQl+3ACFlIZ9euften+qIVFOAr06QSnu78PW+A==
X-Gm-Message-State: AOJu0YziakgnXT+MPA062m+Fsy5TZWsTiHduI2hhytK9K4zjYouV1Ppu
	g+DckUBs5I/I3shKnaEkzxqpOQhGtRUkxA2X0b3MIKdN56WmUTAhFHVmwuV95nlmJjMw/VEbKTA
	AyqzWe0Pb+TCxi/AR1avDjOLWCu8=
X-Google-Smtp-Source: AGHT+IFr8Dy0vd+CWwPk6/6vxQc4Lc0pIfgo9F4ScipgWNlM+NiqFebxiO0hpCqIsRTpWsBoy5CcS04jzTzjwy6WBdE=
X-Received: by 2002:a2e:92c9:0:b0:2d2:393d:91b7 with SMTP id
 k9-20020a2e92c9000000b002d2393d91b7mr8098184ljh.52.1709149076723; Wed, 28 Feb
 2024 11:37:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAOCpoWc_HQy4UJzTi9pqtJdO740Wx5Yd702O-mwXBE6RVBX1Eg@mail.gmail.com>
 <CAOCpoWf3TSQkUUo-qsj0LVEOm-kY0hXdmttLE82Ytc0hjpTSPw@mail.gmail.com>
 <CAOCpoWeNYsMfzh8TSnFqwAG1BhAYnNt_J+AcUNqRLF7zmJGEFA@mail.gmail.com> <672e88f2-8ac3-45fe-a2e9-730800017f53@libero.it>
In-Reply-To: <672e88f2-8ac3-45fe-a2e9-730800017f53@libero.it>
From: Patrick Plenefisch <simonpatp@gmail.com>
Date: Wed, 28 Feb 2024 14:37:45 -0500
Message-ID: <CAOCpoWexiuYLu0fpPr71+Uzxw_tw3q4HGF9tKgx5FM4xMx9fWA@mail.gmail.com>
Subject: Re: [REGRESSION] LVM-on-LVM: error while submitting device barriers
To: kreijack@inwind.it
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>, regressions@lists.linux.dev, dm-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 2:19=E2=80=AFPM Goffredo Baroncelli <kreijack@liber=
o.it> wrote:
>
> On 28/02/2024 18.25, Patrick Plenefisch wrote:
> > I'm unsure if this is just an LVM bug, or a BTRFS+LVM interaction bug,
> > but LVM is definitely involved somehow.
> > Upgrading from 5.10 to 6.1, I noticed one of my filesystems was
> > read-only. In dmesg, I found:
> >
> > BTRFS error (device dm-75): bdev /dev/mapper/lvm-brokenDisk errs: wr
> > 0, rd 0, flush 1, corrupt 0, gen 0
> > BTRFS warning (device dm-75): chunk 13631488 missing 1 devices, max
> > tolerance is 0 for writable mount
> > BTRFS: error (device dm-75) in write_all_supers:4379: errno=3D-5 IO
> > failure (errors while submitting device barriers.)
> > BTRFS info (device dm-75: state E): forced readonly
> > BTRFS warning (device dm-75: state E): Skipping commit of aborted trans=
action.
> > BTRFS: error (device dm-75: state EA) in cleanup_transaction:1992:
> > errno=3D-5 IO failure
> >
> > At first I suspected a btrfs error, but a scrub found no errors, and
> > it continued to be read-write on 5.10 kernels.
> >
> > Here is my setup:
> >
> > /dev/lvm/brokenDisk is a lvm-on-lvm volume. I have /dev/sd{a,b,c,d}
> > (of varying sizes) in a lower VG, which has three LVs, all raid1
> > volumes. Two of the volumes are further used as PV's for an upper VGs.
> > One of the upper VGs has no issues. The non-PV LV has no issue. The
> > remaining one, /dev/lowerVG/lvmPool, hosting nested LVM, is used as a
> > PV for VG "lvm", and has 3 volumes inside. Two of those volumes have
> > no issues (and are btrfs), but the last one is /dev/lvm/brokenDisk.
> > This volume is the only one that exhibits this behavior, so something
> > is special.
> >
> > Or described as layers:
> > /dev/sd{a,b,c,d} =3D> PV =3D> VG "lowerVG"
> > /dev/lowerVG/single (RAID1 LV) =3D> BTRFS, works fine
> > /dev/lowerVG/works (RAID1 LV) =3D> PV =3D> VG "workingUpper"
> > /dev/workingUpper/{a,b,c} =3D> BTRFS, works fine
> > /dev/lowerVG/lvmPool (RAID1 LV) =3D> PV =3D> VG "lvm"
> > /dev/lvm/{a,b} =3D> BTRFS, works fine
> > /dev/lvm/brokenDisk =3D> BTRFS, Exhibits errors
>
> I am a bit curious about the reasons of this setup.

The lowerVG is supposed to be a pool of storage for several VM's &
containers. [workingUpper] is for one VM, and [lvm] is for another VM.
However right now I'm still trying to organize the files directly
because I don't have all the VM's fully setup yet

> However I understood that:
>
> /dev/sda -+                +-- single (RAID1) -> ok             +-> a   o=
k
> /dev/sdb  |                |                                    |-> b   o=
k
> /dev/sdc  +--> [lowerVG]>--+-- works (RAID1) -> [workingUpper] -+-> c   o=
k
> /dev/sdd -+                |
>                             |                       +-> a          -> ok
>                             +-- lvmPool -> [lvm] ->-|
>                                                     +-> b          -> ok
>                                                     |
>                                                     +->brokenDisk  -> fai=
l
>
> [xxx] means VG, the others are LVs that may act also as PV in
> an upper VG

Note that lvmPool is also RAID1, but yes

>
> So, it seems that
>
> 1) lowerVG/lvmPool/lvm/a
> 2) lowerVG/lvmPool/lvm/a
> 3) lowerVG/lvmPool/lvm/brokenDisk
>
> are equivalent ... so I don't understand how 1) and 2) are fine but 3) is
> problematic.

I assume you meant  lvm/b for 2?

>
> Is my understanding of the LVM layouts correct ?

Your understanding is correct. The only thing that comes to my mind to
cause the problem is asymmetry of the SATA devices. I have one 8TB
device, plus a 1.5TB, 3TB, and 3TB drives. Doing math on the actual
extents, lowerVG/single spans (3TB+3TB), and
lowerVG/lvmPool/lvm/brokenDisk spans (3TB+1.5TB). Both obviously have
the other leg of raid1 on the 8TB drive, but my thought was that the
jump across the 1.5+3TB drive gap was at least "interesting"

>
>
> >
> > After some investigation, here is what I've found:
> >
> > 1. This regression was introduced in 5.19. 5.18 and earlier kernels I
> > can keep this filesystem rw and everything works as expected, while
> > 5.19.0 and later the filesystem is immediately ro on any write
> > attempt. I couldn't build rc1, but I did confirm rc2 already has this
> > regression.
> > 2. Passing /dev/lvm/brokenDisk to a KVM VM as /dev/vdb with an
> > unaffected kernel inside the vm exhibits the ro barrier problem on
> > unaffected kernels.
>
> Is /dev/lvm/brokenDisk *always* problematic with affected ( >=3D 5.19 ) a=
nd
> UNaffected ( < 5.19 ) kernel ?

Yes, I didn't test it in as much depth, but 5.15 and 6.1 in the VM
(and 6.1 on the host) are identically problematic

>
> > 3. Passing /dev/lowerVG/lvmPool to a KVM VM as /dev/vdb with an
> > affected kernel inside the VM and using LVM inside the VM exhibits
> > correct behavior (I can keep the filesystem rw, no barrier errors on
> > host or guest)
>
> Is /dev/lowerVG/lvmPool problematic with only "affected" kernel ?

Uh, passing lvmPool directly to the VM is never problematic. I tested
5.10 and 6.1 in the VM (and 6.1 on the host), and neither setup throws
barrier errors.

> [...]
>
> --
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>
