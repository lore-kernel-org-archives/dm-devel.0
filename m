Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8644B20B3B
	for <dm-devel@lists.linux.dev>; Fri, 26 Jan 2024 06:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706252082; cv=none; b=ZLvc7lDw9uO/0V9tRUbKRSittHI6omEhIJeMo+4XmBgRgfO05TxNG4yCC2Fh1Jv3rbfXDLGelFsT5HjYQfZZQkToPcw/x2/OrnmEY1rBPAtO51mN9fxWhCGO7lnkQf3VTjtC/viAz0X7AMxQF3sRoLEVkV/3AMR8Vtlaarh+qec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706252082; c=relaxed/simple;
	bh=uoG58qsUIuPrJgiWfC5zhkPTEKjA9Xh2r2kKMwvbji8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WtKTu3A47L3DIc7JxMNa9Cz/7fLSGut/mVqa+5jnYD64Qpv2bdhsspk2pKGJj2UGZTK8ScWQ77eFKTZ3iCISreglyHn+TJX9vtp+DET8bbd0H9Z/lvGhNw9b/nrjGkhjC9ZV/b9HbUVX307wJwTf6Lv3GIwD925peCQo+mKAYqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gC6Q9Voz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gC6Q9Voz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706252079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ixVxFEqIR9qHljjoQEl4g5MmPcyEPhBU2r2mCNibjNE=;
	b=gC6Q9VozXpQnegqM6IIoqkrysv89ishxXZnuBzeJ8e5tZZACBb+iO5WkiN0EZtWwi6aIUI
	qOu+/L4ozcdWutimfkB329GnRWdXJr4FMj62lUKU6S459IdCq1/yGYJS5j5zYo1Ki09GhY
	6UFeQSVJq1iv6I+8q/+/ze1TZj+Ge9I=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-NtGja3D9Nuid3RfDcbALug-1; Fri, 26 Jan 2024 01:54:37 -0500
X-MC-Unique: NtGja3D9Nuid3RfDcbALug-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6dbcf18d487so372633b3a.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 22:54:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706252077; x=1706856877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ixVxFEqIR9qHljjoQEl4g5MmPcyEPhBU2r2mCNibjNE=;
        b=c4hvLjYSvGqv7246PMdfp18PXwbdrtBLv/12nWI+3O5n53E2fvT1sU4dc3C+OWaj68
         DzoyIw2bcH6mP62XCkzMsQ4UkzhprsgnM/UjtNLVceKzj+Z55fFzn7HstPBPNQGTS2NH
         U0g2R+XEedrB+KxhSHS+nbdaBIyurFwI8cUdFFV++Us1I4g2hLyYmavvJ29cxjpbQq/4
         rXCWTOOlK3gEinOrNmvaxCbn6X5mkk6kdZov241Xdg4FYu7BS3aKxaDgVm/0gs1pG3I+
         8LBjOnBaeCpZwJLOkQeEbGtqI6UzC3AmakM580n3bpf6X/aeg3yJwwyamcPf8bUEy8z/
         Ve8g==
X-Gm-Message-State: AOJu0YySLLTmh5/inYhzPRWxRlXMbSDPLdhJKPkWAt1876FDcN9F10br
	OgcMZtyvER+c8zTai7KKep0JOzhcvQ74IoRMNzG7SY609OK0YOlYeqJRsXwssSR+ufsvDiGaPcg
	0FcbYxSl6RLSvDgL6X05QHzmhpB3yoUsXYsYl/bs06Alossa/fj3RuPIOfbZGBsyBxZk4Pwe8um
	9Rxx1clbF49m9tWeCkbUj1T2CzAx7C7tg=
X-Received: by 2002:a05:6a00:3d4b:b0:6db:af73:bd9a with SMTP id lp11-20020a056a003d4b00b006dbaf73bd9amr779056pfb.30.1706252076891;
        Thu, 25 Jan 2024 22:54:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkvjyZRZHVXgRsEU8lr2R5Dm/blrCJkBEkj8VqTTJXI87y6srCsSTHexV363ricMY1HODnu3VUd1JhtQ3tYbM=
X-Received: by 2002:a05:6a00:3d4b:b0:6db:af73:bd9a with SMTP id
 lp11-20020a056a003d4b00b006dbaf73bd9amr779048pfb.30.1706252076625; Thu, 25
 Jan 2024 22:54:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240124091421.1261579-1-yukuai3@huawei.com> <20240124091421.1261579-6-yukuai3@huawei.com>
 <CALTww291wiYYMWuqUdDf1t7cKkHFs9gGQSRw+iPhUCsNv-Y6yg@mail.gmail.com> <CAPhsuW4kauNB8jAsXYjRohCBMDvY15y0CzzWYqzGvNsqAJ59jQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4kauNB8jAsXYjRohCBMDvY15y0CzzWYqzGvNsqAJ59jQ@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 26 Jan 2024 14:54:25 +0800
Message-ID: <CALTww2_f_orkTXPDtA4AJsbX-UmwhAb-AF_tujH4Gw3cX3ObWg@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] md: export helpers to stop sync_thread
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>, agk@redhat.com, snitzer@kernel.org, 
	mpatocka@redhat.com, dm-devel@lists.linux.dev, jbrassow@f14.redhat.com, 
	neilb@suse.de, heinzm@redhat.com, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 26, 2024 at 8:14=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Hi Xiao,
>
> On Thu, Jan 25, 2024 at 5:33=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi all
> >
> > I build the kernel 6.7.0-rc8 with this patch set. The lvm2 regression
> > test result:
>
> I believe the patchset is built on top of upstream (6.8-rc1). There are
> quite some md and dm changes between 6.7-rc8 and 6.8-rc1. Could
> you please rerun the test on top of 6.8-rc1? Once we identify the right
> set of fixes, we will see which ones to back port to older kernels.
>
> Thanks,
> Song

Hi all

I tried to run tests on 6.8-rc1, the failure number increases to 72.

And I ran the tests on 6.6, there are only 4 failed cases
###       failed: [ndev-vanilla] shell/lvconvert-cache-abort.sh
###       failed: [ndev-vanilla] shell/lvresize-fs-crypt.sh
###       failed: [ndev-vanilla] shell/pvck-dump.sh
###       failed: [ndev-vanilla] shell/select-report.sh

Best Regards
Xiao

