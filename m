Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964CE377EB0
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 01:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781573140; cv=pass; b=kyVKuyMQ5Vgq1vChDwb2XTqNKUCaMbxp56XJjb3J3dKNRNI/Hvgl7ola3d44wI6GBdAiYu7ZJ079O0d6qHVtNBIUPYxh0uXjP3RUX9L9T1YJ7HxklIe8crPUGiMjw0ppjZSVRCQ63Yzd3f5RGsW0TXFWoIRIwpYyCF5zlvjSmEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781573140; c=relaxed/simple;
	bh=8ZWDRPXIPPON+VKKK+3tv+DwcJFH7k1tpUTtDI89Shw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jsCOArY8nffdDAP8NZ3YQkqrte4tUAn2UJC0VjkwWL61ala5hovjXUJC/WcPolPudCDYeQy24SiitL4f1Ito0tIocGpSPoTq7a25u/LrC1/B5SI79bBfb3ZAdqhpiXv1fke28aHil1cNqg25Kd82WQrh9tyduBwJbihnXaBbSCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bSWo9ZZR; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSWo9ZZR"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-39677114c7bso4290021fa.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 18:25:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781573137; cv=none;
        d=google.com; s=arc-20240605;
        b=VVRn8kmriLpDqnnZcc/lpFzHwtfl/bxShoGwo/ICOMI/KYf1A5AO8aXQhTs07axkbB
         JvL7S40L8caImtlkRRgbJDBx9ihr8ha7UE2v0Dg1w4TcpjXgQZQR8IrP1zLWGDKEPcpL
         XAS1Nx0XdolA4lXJHwg49329tu+u7687To1RlldCJT9eDv8+kdHNoXuyvFd3bVYpIjst
         0xN+g3I7DqXH4sTke/ya5tZJ78EvrKR+tVyRpOJT3QFZRTFPTgYIC/KzdvytL6r1oCS/
         4WzjIUCCzRzVNXZu0Xuh1ONgrlkKF1tVqWX6C1mAKlfslZ51gSKpjCu+1o8Y8/sp7pia
         FOmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HMsk01wlY4p5T/k9NAK6h3kYTzO1USl5GZhsDzmQ1Vk=;
        fh=caSsTGyMkk+uD6k7caV0YYs76WesFhMmdnS+SURioHA=;
        b=V35qsuOwKCYwPpPS0PEOumsMAXBXk6HKk/cmRiCbq9OhosUhxfOT7oPKw2CbG6KEut
         G9MVN+RCoTVhbSjzhslu80+tliiq0XZEb37PKgFbmxC16O0XaFf81xJhKHxzhsJUGhfy
         bo409ER8qUA4mhmpi3R2Kifn+7WLRo742LRvhvxyTxJ57pCMIhIgFlIOTl20N5wwezw0
         DwzBIqiAVK99HfL+I+X1ZDUd0NB/glOB4iz4L13iZvOGguJ9Ma8Sgtgbvec8+6pLjNzy
         mSW4aKzvfC6cWiXksS9c43xpO12Ho5r6ng7mP5VrG36pYn9dFDdz3jtFL06jaVU4M7n2
         6pmw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781573137; x=1782177937; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMsk01wlY4p5T/k9NAK6h3kYTzO1USl5GZhsDzmQ1Vk=;
        b=bSWo9ZZRWvsmKwDY/jJyCOIMm6UJ2Ohg5YOmE+LOJvAp2HnYm1D++0IrG7H2XwtE6U
         n2qToCXrdB1nVeem7MxFSV46Dw9+eU7quNMVR/bNyH5bQPduDmlfmH5rGztovjZjbHqq
         rO9Zyx1Jh63Uvlg/cVNZ6ZEIJ6sjIUepKX6Yqwk3+Abi4u+CNxGDCeoqZYUodqcBuxmc
         NlQjBg0KFta1euL85pKxgZFWhM9zkGxo5xkxpAAwc8HdNpi4Wwi/JIrM5JZW5tT0y7pu
         qoDvklz0ng93RM6TmlXaafW5x7OKpiBlDz99vWE4BWzhqxA/T9wdCDO8bJwFMGkSf/HX
         4TQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781573137; x=1782177937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HMsk01wlY4p5T/k9NAK6h3kYTzO1USl5GZhsDzmQ1Vk=;
        b=VoJsFBJbS+U+Dup6LIcF+a2jq6ueqzNo0SSmeXvk+gkXkoEjWWkaIuz0f0wMD5591p
         jMjlmRbupLPHV/LIdakfOONnNZfKkQ7qwLhQX6QXMy/OGDaiMnGP0/ycbSaVmFFJvp3S
         3cvD0WFU1W3F3iyskH75dVkaQzVLLkhWcCtPMVNxRhbT70XvPGxFPL/CqxcX7sl9wa6K
         xrw5o/XtoXFFKEh19DvR8NGxlRHu9uQFcitx5phtInxEAgkTZtfFW7x+PrK+yuPz6edH
         2cIQWgnnU+Y09lIUwWTy+YB+OPN3WBSttpcHpkIOT8i0kh/B8AabIoJBmvfWSC0zg784
         VV2Q==
X-Forwarded-Encrypted: i=1; AFNElJ9nA+W2diZ/A0hQ9H+Y6RXnbatcpZXtn+SHZnqV70MABTpBtrRytIVq3WuQrMyrWI1l1WcSWbgRhA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwcFdk3terZz5dWnpcmxhmSEzWUvN5RNNa7alS8NewXR5oFumsr
	QUakwwiFzspGCAwE5EM11o2C1+NleociC/8/O+oZxtTpWyQXs6kolOQDdp86Uc4ACd8WtheAVXr
	Dj7EBw7+jcOa06ONI8pfU1HHLjvX3Vs8=
X-Gm-Gg: Acq92OE2G4cTcUUZaLT1s09RWb5vRBXXNEB7SrcH6zmkHByHcbYwajOAwaADbfCdDMq
	aVM6xVzkPVyhm4Twx2yaTbxsB+OSjVCQgYbqO7cH1uCTt+BzJ1S/rUF54w3FoEeeAZ6Xfn4RW3j
	BXr+EgdpGfDIpSe+fjyMDq8Qx53kcihRQZpT1AiiDZBB7aWcHOPmq0LLtNq53/Z5Dgqt/wVyqKp
	kOJ5gEujwg5Vv3HEsihhbIpCwtW9OqRE9SXUCL4DJwx+84hyWySQx3qgffy4naRpD0r0YAuo4Rg
	VHPo64F5NuvIfYt9BH4BZy7V249n9guzS63TqHxW
X-Received: by 2002:a05:6512:12c8:b0:5ad:2ac0:9fb0 with SMTP id
 2adb3069b0e04-5ad2db7474bmr2458218e87.4.1781573136619; Mon, 15 Jun 2026
 18:25:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ai7rnH20IYeSmY8s@gallifrey> <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
 <ai_1LYtofh1fwD-N@gallifrey> <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
 <ajCTaUaACV9eNmWo@kbusch-mbp>
In-Reply-To: <ajCTaUaACV9eNmWo@kbusch-mbp>
From: Vjaceslavs Klimovs <vklimovs@gmail.com>
Date: Mon, 15 Jun 2026 18:25:24 -0700
X-Gm-Features: AVVi8CdeOn2G2EHhiSfuo8tXmtM_qTdklj5EzkCKuEDGG1otegoAzCBX5cL6vfA
Message-ID: <CAC_j7i2W5ihdGwTCKufsnU0KX3WQF-Xh3Bx8A+bog5cVWqrLFw@mail.gmail.com>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
To: Keith Busch <kbusch@kernel.org>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, Thorsten Leemhuis <regressions@leemhuis.info>, trnka@scm.com, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Keith,

Thanks. I tested both patches on current mainline
(v7.1-rc7-271-g424280953322) with my QEMU + LVM "--type mirror"
reproducer (virtio-blk, cache=3Dnone, aio=3Dnative).

With only the "block: check bio split for unaligned bvec" patch, the
hang still reproduces. The WARN fires from a kmirrord worker:

  WARNING: block/bio.c:1044 at bio_add_page+0x108/0x200
  Workqueue: kmirrord do_mirror
  Call Trace:
   bio_add_page+0x108/0x200
   do_region+0x21d/0x270
   dispatch_io+0xf1/0x150
   dm_io+0x136/0x240
   do_reads+0x13e/0x210
   do_mirror+0x117/0x2b0

and the VM then wedges.

With the dm-io.c clone patch applied on top, the WARN and the hang are
both gone. dm-mirror just fails the read instead:

  device-mapper: raid1: Mirror read failed from 252:0. Trying
alternative device.
  device-mapper: raid1: All sides of mirror have failed.
  device-mapper: raid1: Read failure on mirror device 252:1.  Failing I/O.

The guest still gets an I/O error, as you expected, but the host stays
up: no splat, no stuck task. For comparison, on the same kernel the
"--type raid1" case boots the guest and reads fine, and the 128 MB
mirror seed write goes through the clone path without trouble, so
normal I/O looks unaffected.

Thanks,
Vjaceslavs

On Mon, Jun 15, 2026 at 5:06=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Mon, Jun 15, 2026 at 04:16:12PM -0700, Vjaceslavs Klimovs wrote:
> > Your trace looks like what the two earlier reports hit: a read reaching
> > a leaf device with sectors > 0 but phys_seg 0 (an empty bio). One aside
> > that may help read the trace: blk_io_trace.error is a __u16, so the
> > bracketed values on your C lines are errnos as u16 (65514 =3D -EINVAL,
> > 65531 =3D -EIO).
> >
> > The WARN itself is new, the bad bio isn't. bio_add_page() only started
> > rejecting len =3D=3D 0 in 643893647cac ("block: reject zero length in
> > bio_add_page()", v7.1-rc1); on 7.0.8 the same empty bio tripped
> > scsi_alloc_sgtables()'s !nr_segs instead, which matches what you saw.
> > That fits your "not a recent regression": the condition is older, v7.1
> > just made it loud.
> >
> > For Tomas's and my reports (QEMU O_DIRECT to the LV block device) the
> > origin looks like 5ff3f74e145a ("block: simplify direct io validity
> > check", v6.18): blkdev_dio_invalid() now checks only aggregate
> > ki_pos | count alignment and dropped the per-segment
> > bdev_iter_is_aligned() walk, so a degenerate or misaligned O_DIRECT no
> > longer gets -EINVAL at the fops boundary. But your reproducer reads a
> > file, which goes through the filesystem O_DIRECT path and never calls
> > blkdev_dio_invalid(), and still makes the empty bio. So it isn't only
> > that one entry point.
> >
> > dm-mirror then hangs because Keith's f7b24c7b41f2 only covers md
> > raid1/raid10; legacy dm-mirror (dm-raid1.c) has no equivalent and
> > rebuilds the empty read onto the other leg. Note the leg's status isn't
> > even consistent (your SATA path returns BLK_STS_IOERR, not
> > BLK_STS_INVAL), so copying that status check into dm-mirror probably
> > wouldn't catch every case.
> >
> > For what it's worth, that points me toward rejecting the empty or
> > misaligned bio once, at submission, with -EINVAL, rather than teaching
> > each consumer to tolerate it. But you'll know the tradeoffs far better
> > than I do.
> >
> > I have a small QEMU + LVM raid1/mirror setup that reproduces the
> > block-device variant and bisects to 5ff3f74e. Happy to run your file
> > reproducer with some instrumentation at the dm-mirror read entry
> > (bi_size vs bio_sectors vs bvec lengths) to see whether the bio is
> > already empty on arrival or built that way on the retry, and to test
> > any patch.
>
> Thanks for following up here. I didn't initially see your follow-up
> until Thorsten linked it. I apologize for missing that, this feature is
> important so I don't want to see anything regress for it.
>
> There is a known bug fix I think future tests should include:
>
>   https://lore.kernel.org/linux-block/20260612223205.465913-1-kbusch@meta=
.com/
>
> This likely isn't the fix you're looking for, but including it rules out
> conditions that are not important here.
>
> After that, can we try this suggestion and see if the hang goes away?
>
>   https://lore.kernel.org/linux-block/ajBb8tK-0aJBpIgF@kbusch-mbp/
>
> I expect the original test case to still return an error (and I think it
> was designed to), but it shouldn't produce the warn or bug splats with a
> stuck uninterruptable task.
