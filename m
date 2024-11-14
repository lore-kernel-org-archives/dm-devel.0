Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D35B2309B8
	for <dm-devel@lists.linux.dev>; Thu, 14 Nov 2024 01:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731547965; cv=none; b=V+pE12Q5F+ibz9uuuep+PMGBM18MkGZM3AxIFtIEMXen2GIQ8Q0wpGzcAxJKVv9rphHzYpB6OHOLoE6kmVgvIwSPaAd0k3p9UpIEh8mkWEOLGADDd6Ak7o6oAoJ6Rdvm/Og1ciqZzwhmu040CaGlAmQwkmWnNzZ7pcjZ8clM06Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731547965; c=relaxed/simple;
	bh=uqiqhJUhTarQqj1Ecro+WFBTjwKtTJw1WbZEpuplcbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YSucZOSkhHO/3xe61kH+s9yrW8jzU3aK82oAsRlORC3uzW6vrIJ0AmFSWeC5xalw0YqEfx5dani/3KQGhiUKO5fVJZJFy/TIs+nmf78N/dEDppxzzKYnxl/qXK9vDjrb+CKgHmq3SkmvuGWf1v2eiyYTx04IiY2iqkikSvigT2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kHkD71LR; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kHkD71LR"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7ea8c4ce232so49157a12.0
        for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 17:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731547963; x=1732152763; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uqiqhJUhTarQqj1Ecro+WFBTjwKtTJw1WbZEpuplcbU=;
        b=kHkD71LRBjgUIEuOJR5B7U8bvzNuL0LSLVXs14MlX87mQjRO/AfZlQIjpQkkbL1ZGD
         3NiPSrQcQ99VnHbJP7SvSr0UcPCidcWJJY2Ijy0/7EUW9Bms3RluUvxTSDwxE72/FNoG
         tv9sTIT+cbzF6UYetfhyn44rdW5WlTLTaZhqld4qDlTG6oc0JdgsLyAZic7dDxh6lOhq
         JRVgwPxyODi/0nCvkqdZ7N5kGkWmvmmJukSqgPT8rOf949jbm/cboNhCscwcjY1JnbgQ
         BuXsuEAcbujb+u7CKiN/uCxuvgftqOTE/lTZpm0Ly0+ytkyAzOqvq2T0Rp6r3Uwbd5wD
         5Icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731547963; x=1732152763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uqiqhJUhTarQqj1Ecro+WFBTjwKtTJw1WbZEpuplcbU=;
        b=YTfuM8/pLdj9hSuZbuaTJcspAMTT4OiQ/xzuSwcNCSaQQ4CwuXippQuJbZvlUp3Jmb
         SvPSmu1RI57aFIuAigmczFcawZ666/pI4S8XwA7u9aZtfU/Uir2x5CwphjBi542jU5MT
         JaGpaaL29yUAgqONlBw69PlLgwbgjqSLQRoihEYEVrcSYHavI1YDfY4jhsWuOlDT14y1
         5xOs/nXqNgvf8gf4Kix9XBBMaC36RAOfy+lBE2vDzQnzdMmTkQH7sHfy+kSimeFxSYOf
         K4PlXEOWpkXoXFT4EnEba4vx1VdXaXLAoOZteL/R3foNQDczMG+d/Dz/u68UYiUzL6Fp
         aGjA==
X-Forwarded-Encrypted: i=1; AJvYcCV05NIZFIzyP3CeP7wtWp1vGoZf/n9WwgRvV15BceVcl25Gvh1Z+FR1axjMM851aL4zGsLqW3IgQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyyKbT8WM1JTv+ZUnX7BRF/DA8BrjGSLO1qaEhUgS45+dcxjFvT
	himKyah5LJeBldnjNMxdB9eXDo4LbzYAfwc/i1SwHchMKjXs3HWeCAyKHdOB8S37z6W/HbKrPj5
	vKYoDHhzMS6/NHDusWfMDTRDLeqYSsJlCnoDB
X-Google-Smtp-Source: AGHT+IH4ntnWEWbAgXYnT07o/PZI1nlk9a5LtZr+PAeXr3XfdfRy96Y5xQqjtRTYnWxLUF8GwABvipm7ZfWmWe9n/CM=
X-Received: by 2002:a05:6a20:7f93:b0:1db:eb5b:be50 with SMTP id
 adf61e73a8af0-1dc832e4455mr841220637.4.1731547963194; Wed, 13 Nov 2024
 17:32:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAO-8PLb0azRAuu2yJ3=K1EwiSXASDJ8nVBttbuOUV77==Xd2ug@mail.gmail.com>
 <94c895e2-0a71-73b2-2692-af8bf62fb340@redhat.com> <CAO-8PLYMFd3YLvfue_an7mc-O19fixJY4ZKybvjehxcm2tRYvA@mail.gmail.com>
 <CAO-8PLa3Qxhy1M1C_ZDTpOyXrhQ=UQKeKoDOmy-bbShb4rV03A@mail.gmail.com>
 <dcaed20c-2132-d453-9c04-b22417ba4010@redhat.com> <CAO-8PLbTAMO867ifaHOdSWQrErV+vfsg2udWF27PK_VKmrMFgw@mail.gmail.com>
 <aa42a2ba-ae99-c209-1289-a2b22dd3b6e8@redhat.com>
In-Reply-To: <aa42a2ba-ae99-c209-1289-a2b22dd3b6e8@redhat.com>
From: Jooyung Han <jooyung@google.com>
Date: Thu, 14 Nov 2024 10:32:30 +0900
Message-ID: <CAO-8PLbbsn=6KQ19oi7WpW2PcVHLfy13RT2Ce-5ePp-0j0sYEA@mail.gmail.com>
Subject: Re: [PATCH] dm: make it possible to open underlying devices in
 shareable mode
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you Mikulas and Alasdair for your thoughts and ideas about alternativ=
es.

I'm aware of those alternatives. Android already uses DIO for loop
devices for read performance for APEX mounts. Having an extra DM
device was in fact our immediate fallback solution when I found this
issue. Then, I thought that, if DM-device owned by another DM-device
can be shared, why not share it with another read-only filesystem.

> confuse dependencies in udev,

What would it be like when a DM device is shared by two other DM
devices like your suggestion #1 or #3? In #1 for example, a dm-verity
device is shared by two dm-linear devices: one for /system filesystem
mount and the other for APEX mount. I hope we can fix the issue around
udev dependencies if there's any.

> Will there be some performance degradation due to the extra linear device=
?
> Could you measure it?

I'll! There're two aspects: device creation and read performance. Both
will affect syshealth. Fewer devices should definitely be a win.
That's why I brought this to you ;-) If your patch can't make it, #1
is most likely the only option I have so I hope there's not much
degradation.

Thanks again.

On Thu, Nov 14, 2024 at 2:25=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Tue, 12 Nov 2024, Jooyung Han wrote:
>
> > Thanks Mikulas for the patch!
> >
> > This works like a charm. Here's how I tested: On Android, for an APEX
> > file in /system partition, I create a dm-linear device with "shared"
> > mode on top of the dm-verity device underlying the system partition.
> > Previously, this failed with EBUSY because the dm-verity device is
> > owned by the /system filesystem. But I was able to create it in a
> > shared mode with your patch applied. Thanks again!
> >
> > Jooyung
>
> Hi
>
> I discussed this patch with Alasdair Kergon <agk@redhat.com> and he said
> that it may confuse dependencies in udev, so the patch will likely not go
> in.
>
> But there are some alternatives:
>
> 1. create a linear device that maps the dm-verity device in 1:1
> relationship. Then, mount the filesystem on this linear device. The
> filesystem will claim only this linear device, so that you can create mor=
e
> linear devices on the top of the dm-verity device.
>
> Will there be some performance degradation due to the extra linear device=
?
> Could you measure it?
>
> 2. use the loop device and enable direct I/O mode (use the ioctl
> LOOP_SET_DIRECT_IO) - this should avoid double-caching and it should
> increase the performance of the loop device. Does it improve performance?
>
> 3. use two dm-verity instances over one physical device - then, you can
> mount the filesystem on one instance and create linear devices on the
> other.
>
> 4. use the dm-loop target - https://www.sourceware.org/lvm2/wiki/DMLoop
> https://patchwork.kernel.org/project/dm-devel/patch/1b84af841912065fc57cf=
e395d5214f4eee0f0fc.1516124587.git.heinzm@redhat.com/
> Some times ago we had a dm-loop target that queried the filesystem for a
> layout of a file and then remapped the bios quickly according to this
> layout tree. But now it's unmaintained and not updated to the latest
> kernel. Perhaps it could be used for your purpose. I'm not sure what
> filesystme maintainers will say about it.
>
> Mikulas
>
