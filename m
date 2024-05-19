Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CEE8F48
	for <dm-devel@lists.linux.dev>; Sun, 19 May 2024 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716101113; cv=none; b=VGaCpLIYuqWaH0hXWbGScBh64w1XLp7ytt5tAF1ZZLbQ4WK/A59IxcieE5Kep5ivp4pcKsv5T/7EgruU3pjgPifWiHIc/YDVZ8GBo3I0nU8N34NtBKoHSz31byDM1kyqkI8oxcRbzdccvVp6eDO2GLPy8JjasoVRMRrZlh/+MVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716101113; c=relaxed/simple;
	bh=G865fXdj+sosunlocs16X9nGNdszDaBoL4YzLrpqAG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DpPCzSnyHEHH9POrGsk+j+mxP/55L6uYJI+92ID18dctKBLMiUAqOpRT8ZGw6rzjnA5NCeoPWiaC8WpExCyNs9ViXnlxvEPLRqzHMYKU0WCpMHkMMO4bN52sihx/wZd6PT8dUGGmSkgEtqlKVgkuWAkPs7dwNo48hh+E7LcqAe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SO5txHS2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SO5txHS2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716101110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=plNyuXmD1Ji89xE61Dccqoh9CyJKA79E3n8nKWDIGAo=;
	b=SO5txHS23qwXGbYhtKCWuU9TGLOxoe1zRS2N9gDkDGblChDvO9nMaBF3m6VeRVmpM1v3IT
	rQg1wuTjgjw1H8KuBOotW5LbsXQ9lNT+/A9JHn9GDIhQigjsid0fqw6Y+UeirQfOgzrS7l
	anbt2t/NKVmT+SZElzV6qULXOJMAFqc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-t6JvUmMGOS6A3q0oiz21og-1; Sun, 19 May 2024 02:45:09 -0400
X-MC-Unique: t6JvUmMGOS6A3q0oiz21og-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ba068e59daso2831536a91.0
        for <dm-devel@lists.linux.dev>; Sat, 18 May 2024 23:45:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716101108; x=1716705908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=plNyuXmD1Ji89xE61Dccqoh9CyJKA79E3n8nKWDIGAo=;
        b=JZeMy2dixGi5glhWwkTkdjgfH1YWqt+ZAb3L6BiUZBcSHdOqQceYFtwmLzxu2CQNqz
         XQUI6wwT4Y/j0crq8xqGHuSsvkCVKW0H2QNB2/cT5QAUf/dMOjEUuKY/lZvcYyMcy6ak
         haX0BXHN8eLjEMT1eCMlIJhl1DrK2/8zYusVAhdnsdS9W1yEMAnIVHzEXz/dl/af/S9B
         nJ5HuZ43EVrCrZLB4LL+QkeR+t/iB8dCAaExqeoexPBNMbziFklU/t1Fr9adTCkwjpnO
         iJaHyPHm4S8ifYK5pJkRHntzNhvRvBZSorIVMCFVhisp30HBL5XL8spoLz1z6XnQ83+p
         4FMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbbQlF1l73cTl2SL5I+X7IhWSxExasYhF0tIiFDM6Borsiq3XTr65sStQ6rSlHEpsJPBt2RiE4i+wJagBPpnr6my7rvXFF/mk=
X-Gm-Message-State: AOJu0YzslYzv3tOuMO2I+nPd7nNekdc/R6PbRUnpaenffWaTlTq4HaL3
	O9/K52oJQ2+qjizps9iZfY9Jrh37Lxgl1/1I5mX435jOx/SIIFqJIK8nNwJZBUP6jx3bATGoXYt
	YgYToj2LNCZFXNx0tIfVq1WqzfIKITiyW0n61RdZ1a/KFna0prgIsUcs1RzReEt9bxL2OKix7hE
	tV2v4BmcRSSnbu1/nXhqPxbV1D3iHVuYo179mXosp2F74H7Ps=
X-Received: by 2002:a17:90a:f2c7:b0:2bd:4c28:1cbe with SMTP id 98e67ed59e1d1-2bd6037a475mr4287434a91.8.1716101107519;
        Sat, 18 May 2024 23:45:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLH6lZr/nk1eD0HX+/IA0O4LxFeI5NvDDKR4IjT3WLIy8Mcto0PV+Zf06aDf3SGB+ZvuF/EJFI4fsdsv3d0QQ=
X-Received: by 2002:a17:90a:f2c7:b0:2bd:4c28:1cbe with SMTP id
 98e67ed59e1d1-2bd6037a475mr4287417a91.8.1716101107100; Sat, 18 May 2024
 23:45:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora> <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com> <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com>
In-Reply-To: <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Sun, 19 May 2024 14:44:55 +0800
Message-ID: <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
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

On Fri, May 17, 2024 at 10:49=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
>
> Thanks for the test, this do look like a deadlock, beside
> raise_barrier(), is there any other victim? I can't reporduce this,
> and I have no clue yet. The possible next step might be bisect to
> locate the blame commit first. Maybe related to dm-raid1.
>
> Thanks,
> Kuai
>

Hi=EF=BC=8CYu Kuai

I tried to do git bisect and got the following result, please help check=EF=
=BC=8C

[czhong@vm linux-block]$ git bisect start
[czhong@vm linux-block]$ git bisect bad
[czhong@vm linux-block]$ git bisect good
d0487577e6e0b640d71375a6ec2f9e8a2d3555f2
Bisecting: 2652 revisions left to test after this (roughly 11 steps)
[895621f1c81695da7660fe909173e9f98619e89c] bnxt_en: Don't support
offline self test when RoCE driver is loaded
[czhong@vm linux-block]$
[czhong@vm linux-block]$ git bisect good
Bisecting: 1219 revisions left to test after this (roughly 10 steps)
[6c60000f0b9ae7da630a5715a9ba33042d87e7fd] Merge tag 'soc-dt-6.10' of
git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
[czhong@vm linux-block]$
[czhong@vm linux-block]$ git bisect good
Bisecting: 612 revisions left to test after this (roughly 9 steps)
[87caef42200cd44f8b808ec2f8ac2257f3e0a8c1] Merge tag
'hardening-6.10-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
[czhong@vm linux-block]$
[czhong@vm linux-block]$ git bisect bad
Bisecting: 303 revisions left to test after this (roughly 8 steps)
[25c73642cc5baea5b91bbb9b1f5fcd93672bfa08] Merge tag
'keys-next-6.10-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd
[czhong@vm linux-block]$ git bisect good
Bisecting: 155 revisions left to test after this (roughly 7 steps)
[f4e8d80292859809ea135e9f4c43bae47e4f58bc] Merge tag 'vfs-6.10.rw' of
git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs
[czhong@vm linux-block]$
[czhong@vm linux-block]$ git bisect good
Bisecting: 77 revisions left to test after this (roughly 6 steps)
[ac5f71a3d9d7eb540f6bf7e794eb4a3e4c3f11dd] io_uring/net: add provided
buffer support for IORING_OP_SEND
[czhong@vm linux-block]$ git bisect good
Bisecting: 37 revisions left to test after this (roughly 5 steps)
[0c9f4ac808b017a0013cee92a30de980550145d5] Merge tag
'for-6.10/block-20240511' of git://git.kernel.dk/linux
[czhong@vm linux-block]$ git bisect bad
Bisecting: 19 revisions left to test after this (roughly 4 steps)
[a3166c51702bb00b8f8b84022090cbab8f37be1a] blk-throttle: delay
initialization until configuration
[czhong@vm linux-block]$
[czhong@vm linux-block]$ git bisect bad
Bisecting: 9 revisions left to test after this (roughly 3 steps)
[e8b4869bc78da1a71f2a2ab476caf50c1dcfeed0] block: add a
blk_alloc_discard_bio helper
[czhong@vm linux-block]$ git bisect good
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[3a861560ccb35f2a4f0a4b8207fa7c2a35fc7f31] bcache: fix variable length
array abuse in btree_iter
[czhong@vm linux-block]$ git bisect good
Bisecting: 2 revisions left to test after this (roughly 1 step)
[99dc422335d8b2bd4d105797241d3e715bae90e9] block: support to account
io_ticks precisely
[czhong@vm linux-block]$
[czhong@vm linux-block]$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[060406c61c7cb4bbd82a02d179decca9c9bb3443] block: add plug while submitting=
 IO
[czhong@vm linux-block]$ git bisect bad
060406c61c7cb4bbd82a02d179decca9c9bb3443 is the first bad commit
commit 060406c61c7cb4bbd82a02d179decca9c9bb3443
Author: Yu Kuai <yukuai3@huawei.com>
Date:   Thu May 9 20:38:25 2024 +0800

    block: add plug while submitting IO

    So that if caller didn't use plug, for example, __blkdev_direct_IO_simp=
le()
    and __blkdev_direct_IO_async(), block layer can still benefit from cach=
ing
    nsec time in the plug.

    Signed-off-by: Yu Kuai <yukuai3@huawei.com>
    Link: https://lore.kernel.org/r/20240509123825.3225207-1-yukuai1@huawei=
cloud.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

 block/blk-core.c | 6 ++++++
 1 file changed, 6 insertions(+)
[czhong@vm linux-block]$

Thanks=EF=BC=8C
Changhui

