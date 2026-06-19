Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C2A2BF002
	for <dm-devel@lists.linux.dev>; Fri, 19 Jun 2026 02:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781834838; cv=pass; b=kBvbJN6eeInXhaSKUlls0/8OsKEE7pWSbo8nAae1s1Hti913J/gKNZcxXr1zo3hVdKRUHHz+R7QPs/p7lJaiwGSTv7P8Bm/cacBNvz0QxuZRUC2l3NJ5e1bjnvmebi7zoBN9wpRjTKbDQ6rnqynebPK8D2pOHKOA4DLNnK0oyoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781834838; c=relaxed/simple;
	bh=+lAwZdOEr368mWww2qJWPQl/+LHxqo2IoMsWTLJ8lbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gPyXJdVpSihG0O8FQYgythRhYXHrrHW13gR3dXy95tnbZt3sMiFcInk7GIkPKbuVcFlUxFYXuo2y/UqCL+FznHql3c3hSkKcd9Xqai92h8NcDMYtZQVflhj+IMedSnz9ffSslHjjHBGlVEfb8ve6L+Fy8b8vDeH2MbD59lRDh0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=So53gseA; arc=pass smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="So53gseA"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3966e5e7cebso2401601fa.2
        for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 19:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781834835; cv=none;
        d=google.com; s=arc-20240605;
        b=QAFeX4I6mSvU9Fgrwj4HZzvIo481dld3LpvyHRpwN6/e3ofK33oYd5DgtNmjWDBvkb
         2vf/LUREgY7Uz9BpyVQPJW17wgFzZx2UUucw30ycuZnpTAOW2IwYn6ONM2QQ6szasaUk
         8LncAFkrnixYhXCxVXLueUL67jOmlDzxGcFem7TMd7aXe9U7iPP6tspdKgYH5H/ItobY
         I31YD02HfNdOrYm4wnbDkVyy0poQ0q/KAxsAnM+koIav3oGnwv+Psc0aGsRA8UkT+8qc
         08uJQw/q6+zMXTtUFbjY4bB7m9lRyJR5rFdwofyuT/kLUdC6tcqtOAaHMvpPPaKRPG3H
         cNsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QN90U2KCqArXMqHd53Vv9g008WAQGYM7QLU+yCipKHQ=;
        fh=/FGF1dOaRjcWnF3XGuZx9lcE6vCEXsYucKBM3gyqmgk=;
        b=K+ZJOf4TsZgqvymny0NffNeRktLzvsBRFEvou/EOtwywPf2cY+rlW1ReEBuqJ47xHZ
         ivBtAHL4XN5af8RzavdaT4vCm+d6UZued88zRr0ef8kIbNfhztI74A0WlsjeQuqfgy7k
         hMy12oCNkQtmAbs4/3w4abkyxm/96B4J06XoYou+0U6eR7YDb8Zq5GdiVr0aL6olXmuV
         zFOwQsKrRyVHE30hLo/fm132bI60ejSqZZUZQIeJMxNgo3zaOuLFnbBBjKXWPtbNz6Ud
         lRFnMb69sREKaBGLDDDPyihM5MN7OcAmhE5/+LNAtGBkkxjZRGsc3xRZUbPpRCQsQA0i
         Bf8A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781834835; x=1782439635; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QN90U2KCqArXMqHd53Vv9g008WAQGYM7QLU+yCipKHQ=;
        b=So53gseAsn50KoX1d4wsrzwMpDRwDlqs/QPbN1D8bR/NeEz6nd7k2Q1lj7Q8AFn4TU
         lxI0hDs9Tio5/nG0SflN2RCoopHA1IrzBA3lcFUuJ/DilE6beWJf6hMUrmoU4Qjr1aJY
         VApQz7wWvDGUiZER9LAjCqOlP3kDUR+P+KtZxLlLiVtsU0UC7jncXiymGV/DtgKnPh+q
         AeIzvCL90YFwJvyI9SQw1p1xje/eVM/gYD5/3sfNN82tP6DwRx+72zicnsGywj3EcwwY
         m2nXIGEKQ6kvykPNY73t3badiMoXW26AHKHbhbd8k+sCoXH3qkgoMtHYiibfSXFxPeOz
         I2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781834835; x=1782439635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QN90U2KCqArXMqHd53Vv9g008WAQGYM7QLU+yCipKHQ=;
        b=dVZjtBLe0DHsTKofb6KG/jgsS5P7n70StXvTLucL7WfmbJagEH1I0Adu94HfkFPzl4
         bFx3YG4tcz7MKmWP78JvSuvpk4y9nbYZDE9arLcmNrC4ztTobmTxq6GIpisSgYRnwYxX
         AyjFR4SefvSdfc136w6Sot21nB13IK/YMJ8uY8bgBjxM1bkLJL+HfsR3bY6hptuH/3A1
         qicF455QFEupdqLkqKXsvkfdztGMPFxy+2I4ZX1YZQI7wv2bIjKhEyO++tEJ6aeC3j/M
         Az/S5FbgCAQmlgax/PxwSRCsszDzxx81Jg8JD5sAwSLsSE361k+BT/utb4ma7U48p/FO
         GADA==
X-Forwarded-Encrypted: i=1; AFNElJ/4HtkT8J5fQtE7ry9Mr3T44hrlDAZ8dVmOMU1Ou4VuR9DX/M9InJHvogn4XoUCAI7Y7TUHW0cwpw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/x/eUHN2NxLQJJpfYZiYceXK7Zh2TFnGmqKnzqPynMyYg8Hy2
	F14VNAQUw461QekoucIEeiVnwG5/Zazik12sJgNJ0XnS3VBYfLNSjGy8LN8iJY0nJwtCkhM8OeS
	yP7CrmheIZFSdlM+xvOdPmVYRTfSYvBQ=
X-Gm-Gg: AfdE7ckVif0YJNeuoA9PGUEK0lvW3/WkMELtdveYkCPGs8TZYOE8XCHHv2KgwDr0DkC
	e1X2uiQiy9zYLcAgHZBjH7h8vYIDWGWB+L1QQw62x5rCwo2FyxLZxO0NdD6a+0Tu1ygmws6fuaO
	H//WCg1h0leZNK76SX+ghD0zHVZtmKya3L0NmnOY8PJIvUmin1v8f1a5pEEOcyqsSPFkFtd9kAn
	SSMt+0CbjTKUuO6syQQuKr0APkgtovn/xM3PDaYOyfYgqfs8q8It7+PD8B8qpKj8afr8xCoOl7w
	fPg/iEjTMMaswTQVCPFP/WFxbKzOZw==
X-Received: by 2002:a05:6512:3d0e:b0:5ad:d4f:4088 with SMTP id
 2adb3069b0e04-5ad562ebe8emr245066e87.5.1781834834988; Thu, 18 Jun 2026
 19:07:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260616150554.1686662-1-kbusch@meta.com> <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey> <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey> <ajK4YacvP7eQ-S2o@kbusch-mbp>
 <ajK-Y7uoK0QT5PVl@gallifrey> <ajLJiOwim7qBp_0P@kbusch-mbp>
 <ajLO80kZmFnyR2mH@gallifrey> <ajLRTkSZJ0WCYNk4@kbusch-mbp> <ajLSaiKXWIekcA97@gallifrey>
In-Reply-To: <ajLSaiKXWIekcA97@gallifrey>
From: Vjaceslavs Klimovs <vklimovs@gmail.com>
Date: Thu, 18 Jun 2026 19:07:03 -0700
X-Gm-Features: AVVi8CcwrDXFH9lG8MvQYBwBXKdIimW6ILBVKjqonKiYaALRjDRi14XoN5Nro2Y
Message-ID: <CAC_j7i3uL8mHgS=QRYwuD3DMK9_VasSyBmQ10igKvFP2kwKtXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O errors
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Keith Busch <kbusch@kernel.org>, regressions@leemhuis.info, 
	Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2026 at 08:05:53AM -0700, Keith Busch wrote:
> For DM_IO_BIO requests, do_region() built each destination bio by walking
> the source bio's biovec and re-adding the pages one at a time, tracking
> the remaining transfer in sectors.

Thanks Keith, this clears the dm-mirror hang for me.

I reproduced the original regression in a nested-QEMU harness: an LVM
legacy mirror LV (lvcreate --type mirror -m1, core log) on virtio-blk
PVs, used as the backing disk of a nested guest that issues misaligned
O_DIRECT reads via virtio-blk with cache=3Dnone,aio=3Dnative.

Without this series, on v7.1-rc7 (424280953322), the mirror read path
splats and then wedges:

  device-mapper: raid1: Mirror read failed from 252:0. Trying
alternative device.
  WARNING: block/bio.c:1044 at bio_add_page+0x108/0x200, CPU#1: kworker/1:1
  Workqueue: kmirrord do_mirror
  RIP: 0010:bio_add_page+0x108/0x200

kmirrord then stays stuck in do_mirror and the I/O never completes (the
guest hangs indefinitely).

With 1/2 and 2/2 applied on the same base, the WARN is gone, kmirrord no
longer wedges, the array is not degraded, and the misaligned O_DIRECT
read now completes normally instead of hanging. The --type raid1 (dm-raid
on md/raid1) variant of the same test is also clean.


On Wed, Jun 17, 2026 at 9:59=E2=80=AFAM Dr. David Alan Gilbert
<linux@treblig.org> wrote:
>
> * Keith Busch (kbusch@kernel.org) wrote:
> > On Wed, Jun 17, 2026 at 04:44:35PM +0000, Dr. David Alan Gilbert wrote:
> > > (It's a bit scary you're having to go around quite
> > > a few places and make similar fixes; I assume there
> > > are others that do similar things).
> >
> > Yes, I understand that. I'm looking into a common way to validate this.
> > The md raid doesn't have this problem because they always call
> > bio_split_to_limits() first, but that's not an optimal thing to do for
> > dm raid in the normal read/write path, so perhaps a common checker need=
s
> > to happen generically in the block layer. Yeah, I know I removed the
> > previous higher level validation ... I'll try find something less costl=
y
> > than what we had before.
>
> OK, thanks again
> (and to Thomas for gluing my query to those other two which got this
> moving!)
>
> Dave.
> --
>  -----Open up your eyes, open up your mind, open up your code -------
> / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \
> \        dave @ treblig.org |                               | In Hex /
>  \ _________________________|_____ http://www.treblig.org   |_______/
