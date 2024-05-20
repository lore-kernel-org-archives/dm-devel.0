Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B6E53373
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 10:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716201556; cv=none; b=OXzIFulTEwcMs/XgKrGLaO1oj0b4kFlwrGoaxWXP43BPtmGdOa+L+gPo0CNmpwaBi9zPGg0J76phDXw/w/8INDQuA7Y4xXCuYgV/7KIHIBAH49yAmAinQtkuWwdQICYebnLBHsIXm0B+w/Pk5GaFhJm+epKjwFawflNQIPMwq5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716201556; c=relaxed/simple;
	bh=HFgWWZL2wifN2cwpEjonm57Q/k5K+tvVYKfhgGUwrSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nkXyhqjZYnNkp64gMP3Q7pGn6xQbbpX6z30DYVFLSWG7U/XUvCxcISyTWaS46TkXpRFdRdmhch5nxHRyhfo9CvnOTnncSEdGhULujQzdQyqAIyLNWdfIrunLXJ5cEQNes9oQVgVRc2N5ioE0gxSPB5bzx9pQnzGx4Muc0BtOC2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d2AKLo86; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d2AKLo86"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716201554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RlAqBOlKtvveeTtrv4Z304b9Esia2ku08LBiVu9x3+g=;
	b=d2AKLo86VvPj6L2bsyiFlJEQj+qw09+hWPGy3JYgLO4HT2sb2oIDzMyNlL3pXxc1I6n1HM
	mJgyWjYHSIthlIMZBQ4RZ+dIZ8eS56r5+spvlf4hAVYvvo13wiIcR10aD/ZbiajMeXWRMI
	Ck0o4jBSIirzlXIvJZmN+/J3ZFC0CM4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-GKUhI66wPYe8_iQPgH7UWg-1; Mon, 20 May 2024 06:39:12 -0400
X-MC-Unique: GKUhI66wPYe8_iQPgH7UWg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1eea09ec7ecso116011605ad.2
        for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 03:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716201551; x=1716806351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RlAqBOlKtvveeTtrv4Z304b9Esia2ku08LBiVu9x3+g=;
        b=KcXyjp4Qr6JCsl34QQLHwAkfK4t5+GvhrScmwZHgkaIgCIUA1gJnOyzYEa+r186mMu
         XGSGfqEmK17XkqWatqP4k9g9+1PupD/nr6nr3Ajk7kYs7yIOlGh5noHdsWKPGmUgoeai
         iKzbnHfaaeO8QxkJIwYDPm2gUnWlwmXYATMwExJ84Ua7Rxfx+I8fOPvzcT1QBmAnC2A/
         Jl0tzJHEBOMEgcQlocWqcoAyaYFEsUhggnhQyMraIvXR/82fybbTxu4YGr7P5N+7Dluc
         oPF7VYdCj5JKlJ6zoLzbJjxxY40Wffy9HvgAxmTzIBjC3JHyE2MGryB00KhaM84l7JKm
         UoZA==
X-Forwarded-Encrypted: i=1; AJvYcCXYPm42UlIjnC5XJajB7Umt2Uheh/FhGTpzYGtBKs7QSmOh2P/ySLNRV+cMsrayFcaTNiDpmPKJgCGP3YL4ZfNoI5CIvmDI6qM=
X-Gm-Message-State: AOJu0Yz0bm1mj+ve4T6fiRUP2CjDcdUzcOSypFOdV2EAchik00oER4GW
	2umSwwWi19alM38Bu4IzrbTodIfTYnA9xUBnxScxhxU+krudNwmolVfkdoS7SGOG5365YbnBojz
	qsAaG4pb3xlpzHg7sgOmK/BI4FuvF/YLonKV0xhKyqJO/fcTN3WXMJOqS3v0lXkTH6WJeGov/kM
	n1b2Cjs4J/l/71gZ0HW+K+cQUNFTR1S7I=
X-Received: by 2002:a05:6a20:dc95:b0:1aa:6613:2387 with SMTP id adf61e73a8af0-1afde1b01femr25864178637.47.1716201551308;
        Mon, 20 May 2024 03:39:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGweEbarBn6gVZIYtzMprWTNE7rrULCXr2Qkpb5hkVGaFeKkeBNZgclYJeiXDISg78hKS6RDFcIMHNXzq2EwxY=
X-Received: by 2002:a05:6a20:dc95:b0:1aa:6613:2387 with SMTP id
 adf61e73a8af0-1afde1b01femr25864167637.47.1716201550946; Mon, 20 May 2024
 03:39:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora> <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
 <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com> <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
 <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com> <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
In-Reply-To: <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Mon, 20 May 2024 18:38:59 +0800
Message-ID: <CAGVVp+UdBekv2udwxtXBrtn0CMTrBa94oE4taUfynWncYF5ETQ@mail.gmail.com>
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>, Linux Block Devices <linux-block@vger.kernel.org>, 
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 10:55=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi, Changhui
>
> =E5=9C=A8 2024/05/20 8:39, Changhui Zhong =E5=86=99=E9=81=93:
> > [czhong@vm linux-block]$ git bisect bad
> > 060406c61c7cb4bbd82a02d179decca9c9bb3443 is the first bad commit
> > commit 060406c61c7cb4bbd82a02d179decca9c9bb3443
> > Author: Yu Kuai<yukuai3@huawei.com>
> > Date:   Thu May 9 20:38:25 2024 +0800
> >
> >      block: add plug while submitting IO
> >
> >      So that if caller didn't use plug, for example, __blkdev_direct_IO=
_simple()
> >      and __blkdev_direct_IO_async(), block layer can still benefit from=
 caching
> >      nsec time in the plug.
> >
> >      Signed-off-by: Yu Kuai<yukuai3@huawei.com>
> >      Link:https://lore.kernel.org/r/20240509123825.3225207-1-yukuai1@hu=
aweicloud.com
> >      Signed-off-by: Jens Axboe<axboe@kernel.dk>
> >
> >   block/blk-core.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
>
> Thanks for the test!
>
> I was surprised to see this blamed commit, and after taking a look at
> raid1 barrier code, I found that there are some known problems, fixed in
> raid10, while raid1 still unfixed. So I wonder this patch maybe just
> making the exist problem easier to reporduce.
>
> I'll start cooking patches to sync raid10 fixes to raid1, meanwhile,
> can you change your script to test raid10 as well, if raid10 is fine,
> I'll give you these patches later to test raid1.
>
> Thanks,
> Kuai
>

Hi=EF=BC=8C Kuai

I tested raid10 and trigger this issue too=EF=BC=8C

[  332.435340] Create raid10
[  332.573160] device-mapper: raid: Superblocks created for new raid set
[  332.595273] md/raid10:mdX: not clean -- starting background reconstructi=
on
[  332.595277] md/raid10:mdX: active with 4 out of 4 devices
[  332.597017] mdX: bitmap file is out of date, doing full recovery
[  332.603712] md: resync of RAID array mdX
[  492.173892] INFO: task mdX_resync:3092 blocked for more than 122 seconds=
.
[  492.180694]       Not tainted 6.9.0+ #1
[  492.184536] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  492.192365] task:mdX_resync      state:D stack:0     pid:3092
tgid:3092  ppid:2      flags:0x00004000
[  492.192368] Call Trace:
[  492.192370]  <TASK>
[  492.192371]  __schedule+0x222/0x670
[  492.192377]  schedule+0x2c/0xb0
[  492.192381]  raise_barrier+0xc3/0x190 [raid10]
[  492.192387]  ? __pfx_autoremove_wake_function+0x10/0x10
[  492.192392]  raid10_sync_request+0x2c3/0x1ae0 [raid10]
[  492.192397]  ? __schedule+0x22a/0x670
[  492.192398]  ? prepare_to_wait_event+0x5f/0x190
[  492.192401]  md_do_sync+0x660/0x1040
[  492.192405]  ? __pfx_autoremove_wake_function+0x10/0x10
[  492.192408]  md_thread+0xad/0x160
[  492.192410]  ? __pfx_md_thread+0x10/0x10
[  492.192411]  kthread+0xdc/0x110
[  492.192414]  ? __pfx_kthread+0x10/0x10
[  492.192416]  ret_from_fork+0x2d/0x50
[  492.192420]  ? __pfx_kthread+0x10/0x10
[  492.192421]  ret_from_fork_asm+0x1a/0x30
[  492.192424]  </TASK>

Thanks=EF=BC=8C
Changhui

