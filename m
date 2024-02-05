Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D791F58106
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 21:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707168727; cv=none; b=AyMhbir/iIXj787thheTXgbkvnyd3+FLiIxtN3VA2EtnZ2aeWlE2ckJetjL4eh5lvzxGudSjhS7WRMMdg2m/9pZ3vhEUrUZAaRL9uhRF6p7/N1N4dwyUMpV4GNhk0Ozbm8/6Vo5umsyJzZR0lS4zxm9fI5sj93QQiVvXPBra+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707168727; c=relaxed/simple;
	bh=iZASGz5Z5rm1aG0lLGE6OGbes9D4mJXmBzxTO9ghwcU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=doXtefVuQFz846oKcKp1XtE2e5q1Uza2/C0DKZJtfngDjcX/cA0XxAkjpMf6co61q9Qfe6xFBWy64VKAHlYKq0CihnxHtq+o4dBtWyWu85lVtpxp0NbRhm45aJV7ukZEiAxDUsqVZJ0cFjjkjio/pGruQqkHQpn9qIP5i2AEFlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqJQZ6e6; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqJQZ6e6"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4c02af52a21so639062e0c.3
        for <dm-devel@lists.linux.dev>; Mon, 05 Feb 2024 13:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707168724; x=1707773524; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JiHlMRBtTUoGCPlkucZ3M1GzAWqR70W8aj3H555n2D0=;
        b=dqJQZ6e6OiE0/WtFG0PvTD9JT5mclmMM9qqJRVEKMNdDy7u7Mz/MrU78tzwIM/sNwP
         3NeWjNhhpmxDa58s4/6hGZ35ZMUxJqa+i3RyEeDfNTQ6Kf6yc48gRckJc6rk/cuxa9xJ
         Fve8UVXLED0vdbEFusNln5F9mCW0tTjwvLxvMDDxyz8wTs/y57qhJEMPvG/x7YhoinGM
         RQ22qaDETyXiyoRBPF2WAb7Vel8VwX1I/v4NoDYV5CWpurC/sfzDLd4KCeAkJp6vfOaN
         GshVw3xdjXQXwJOUarpJQfFaS9MZPj3yNBlSUGupGALO8ieAfhddopzqtV2KM8yTb8SB
         f3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707168724; x=1707773524;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JiHlMRBtTUoGCPlkucZ3M1GzAWqR70W8aj3H555n2D0=;
        b=MyWKzgnx9Fa9Wm8sBeZKxHWcw0tpxNOXurCRQ/kuw4Fmw2mNE+0viY7YvsG9gOQuSL
         5dwGLzFT31RwW4yeENVbpsZUpQ6w325TUveUxK/yFdPpDIcZr/FXXitkWpl6nbKY3NVF
         e5Yu6mUKpiV4tMmG4hSaIDPr9cLrFsHoYfN3bm5pihVpJm+5gmGr6A2HUzi8tiXP4umH
         ydMQxMJ+x0e8Gm0FS/dO9mkl28mTYQM0q2UxnNQ5SJSEZ8uTdGufu+bz4NaE8nFIyd2i
         lg6EojQoBK+/FQS81WhuuqgS8KLgT9FaiE9+rv3ydFy5NUaA65VQ6Ph+pEWadTOU0+Is
         UjGA==
X-Gm-Message-State: AOJu0Yynda3uPDAHOdpD8cANZcH3Mav6zbpq0iHHNH4KYCy36EYueP9S
	QF5Blc76AWfrmARsHhGmgsH0OT/JO3m3j4nKi8ooBAKzlq6QPngNAOq+yeYlwFzy+VZKFpGL4Y6
	qtOj+u2QCGfjc1Hxstvt92lmIThI=
X-Google-Smtp-Source: AGHT+IFAPAEBv4SxXrw9QXtxsPmPBONJ9K2vokDXIug8vw/xA6OukvoHu9dDYGWxR+zA6Klp4z162ZXW/vH/q0w/rbM=
X-Received: by 2002:a05:6122:16a4:b0:4c0:2af5:bb70 with SMTP id
 36-20020a05612216a400b004c02af5bb70mr209268vkl.4.1707168724324; Mon, 05 Feb
 2024 13:32:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <ZcACvVz83QFuSLR6@slm.duckdns.org>
 <CAOMdWSLNMqsZNJ-oCLN2RjckZmJSvdU_Yq0F0frmqMqa67Oy1g@mail.gmail.com> <ZcFPKaWwxJhgy8HQ@slm.duckdns.org>
In-Reply-To: <ZcFPKaWwxJhgy8HQ@slm.duckdns.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 5 Feb 2024 13:31:50 -0800
Message-ID: <CAOMdWSKQC4UWXp57qubcSOHmPj0E7wHZWWbCz+yCZqROhoPSGw@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

Tejun,
> On Mon, Feb 05, 2024 at 12:50:28PM -0800, Allen wrote:
> > Thank you. I am basing my work on the branch you have
> > pushed.(or-6.9-bh-conversions)
> > https://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git/log/?h=for-6.9-bh-conversions
> >
> > In the order of priority, I have started converting drivers/media/*,
> > drivers/dma/* followed by drivers/net/*
> > which constitutes the majority. Putting my plan out here so that the
> > work is not duplicated.
> > I will write back in a day and share the branch for review.
>
> That's great. Thanks.
>
> > W.r.t the conversion, there are drivers which call
> > tasklet_[disable/enable](), which I suppose
> > can be ignored in the case of workqueues, I am not entirely sure if
> > this is the right approach.
> > Please correct me if I am wrong.
>
> I don't think we can ignore them. I was just looking at tasklet_kill() and
> thought we're good because that seemed to map well to cancel_work_sync().
> workqueue doesn't have the counterpart for tasklet_[disable/enable](). I'll
> look through them and think on it.
>

Okay, I will look into it too. I have these rough and completely untested
functions. All I am trying to do is to match what tasklets are currently doing.

static inline void workqueue_disable(struct work_struct *work)
{
     cancel_work_sync(work);
     flush_workqueue(system_bh_wq);
     smp_mb();
}

static inline void workqueue_enable(struct work_struct *work)
{
    smp_mb__before_atomic();
  //  atomic_inc(&work->data);
}

I have to figure out a better way to handle atomic_inc() in the enable
function.

Thanks.

      - Allen
