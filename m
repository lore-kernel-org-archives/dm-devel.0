Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA1E17741
	for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 08:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708071797; cv=none; b=Q5CPODb79JCDo84wDKwE1gKyQxT9JiB/X4Gn3YQhRUn9YBzSlXJdE8tecDBZKq8SzMhq3aXhOuqODZKxUwWbS0p/Zq3PwmTz++euTx7c0L0rR35LJeWe1xzmqO+YzGU1cjIsbV5fhLdhgYC5prfq8fxkXEyg1aALuqcVIAZwnFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708071797; c=relaxed/simple;
	bh=fUUn6AnMvlCd1xQgv5EKb346fzCDc72nsHuZzfqrAhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=akpl7OYqm2Zl/15jvnHw3M9LEl4fCjN5ECRobuuCumFwmansvzgPXyC/68JvTOFZsU4TK6tHuiFE/rAzaR3GLBvY6i2ohwDTl+OWWrjKS76AyuTHE84RHNbTC6OY7jOhvJ2i/mDd2dBcmE3Z5U5D3VbEnUQRAuruIwwbzkHa/vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kbZR67Ga; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kbZR67Ga"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-56037115bb8so4602a12.0
        for <dm-devel@lists.linux.dev>; Fri, 16 Feb 2024 00:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708071794; x=1708676594; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUUn6AnMvlCd1xQgv5EKb346fzCDc72nsHuZzfqrAhM=;
        b=kbZR67Ga5Wsz7yzGdLtDw1QIS4MssPR483ypwtH8g3Y4XCIU6Dcdg0zqYO/zFnAdsv
         z6BkQO9Z7y+IeuuP7REr59qd30HWUanr7+/xYZHXHdy+kASd9OuWD7DbZcaaqsAGaQG6
         IZqJnJPCLRGD872Hs2geh6AbZEajKQeUZ7oyQwIiLecMqOJZxTeW0kBoc1t0Ictwgu+n
         Li2waP0TKV+97APAZ/fkpQLDzVayJKjfr/1QbRyQfnFwaTzDACDSnyk05bWkzSZEHir+
         FC76MFONvwwo9m+MeOD4hUT4SZPoGeI0VzObb+mKFjorz4nqVu9SPG4T9WG02cpCY3/c
         9wyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708071794; x=1708676594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fUUn6AnMvlCd1xQgv5EKb346fzCDc72nsHuZzfqrAhM=;
        b=Q7B+tkIHqEnbpRSrRLRdE2hzMRu0zL3EUj0+tt1WEHTYAm64GdVCZcRiy7rEKhuaaF
         4hR0G+FM4r7pu2yd7/944ATsKMsDuCiFF0oTWBWYnbKMYJtt7HO5bLPg7+IWYC8kkb25
         GqP3N5I1RERgKjxsAhGq3N/NAiIfzsfhvD0oOLt+Ecfi9vvSY/YLftuhwCFUd1NIEdvA
         aaVcbqLQ+Pl5pbPs3IKJyUpVTleHT9Pw1kHyEU5VgiYaZfMRnW/EKcOZOu5Hs4LnMeCt
         TRmTEZzSCR4KE/LrW8GgLYYa0ioiz/YHu/7AOsdCWnNzvIVkkxIgvBxuzfRjNMZ/k6k5
         Ik8w==
X-Forwarded-Encrypted: i=1; AJvYcCUo3z0PgWRtRk5g8Pl7Nj7emyMq1/jQjDDcaUsRiQA2NK2mBQo2QVFNuZyki1hirWQJ5VyNIofv0oImQJmM/MF6579aSLb+SZ8=
X-Gm-Message-State: AOJu0Ywgw/71/+XUl2L4LnMduiapfD/zroMCgQlodp24Iwb2UYeIcxz7
	p6rW5qkZUAXDGUquLmNTFWWMSCQR8jjXT0LGd0XLnhp3Fy4CHf8brBTRSzxbomSBg26d8XXjpQf
	iet7Kcr5LCadI9QMJeMyjnCvp7Ar+XU8HlE+w
X-Google-Smtp-Source: AGHT+IG1QaSo/SWZpMQwRSx5xsZV5+mFf4z/pSJbIJII2nQ9E44C3wuuDXCC6XbcQpq3b9IZr10OXvVAvpJ8usiMmIk=
X-Received: by 2002:a50:cd8c:0:b0:562:70d:758 with SMTP id p12-20020a50cd8c000000b00562070d0758mr130337edi.2.1708071793909;
 Fri, 16 Feb 2024 00:23:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-7-tj@kernel.org>
 <Zc7zLsEhDzGkCH9m@slm.duckdns.org>
In-Reply-To: <Zc7zLsEhDzGkCH9m@slm.duckdns.org>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 16 Feb 2024 09:23:00 +0100
Message-ID: <CANn89iKDsJPY=QQrTHK0Jw=s=A_G_GzcOA0WsqXaytWAVV3R4Q@mail.gmail.com>
Subject: Re: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, allen.lkml@gmail.com, kernel-team@meta.com, 
	"David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, David Wei <davidhwei@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 16, 2024 at 6:31=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Mon, Jan 29, 2024 at 11:11:53PM -1000, Tejun Heo wrote:
> > The only generic interface to execute asynchronously in the BH context =
is
> > tasklet; however, it's marked deprecated and has some design flaws. To
> > replace tasklets, BH workqueue support was recently added. A BH workque=
ue
> > behaves similarly to regular workqueues except that the queued work ite=
ms
> > are executed in the BH context.
> >
> > This patch converts TCP Small Queues implementation from tasklet to BH
> > workqueue.
> >
> > Semantically, this is an equivalent conversion and there shouldn't be a=
ny
> > user-visible behavior changes. While workqueue's queueing and execution
> > paths are a bit heavier than tasklet's, unless the work item is being q=
ueued
> > every packet, the difference hopefully shouldn't matter.
> >
> > My experience with the networking stack is very limited and this patch
> > definitely needs attention from someone who actually understands networ=
king.
>
> On Jakub's recommendation, I asked David Wei to perform production memcac=
he
> benchmark on the backported conversion patch. There was no discernible
> difference before and after. Given that this is likely as hot as it gets =
for
> the path on a real workloal, the conversions shouldn't hopefully be
> noticeable in terms of performance impact.
>
> Jakub, I'd really appreciate if you could ack. David, would it be okay if=
 I
> add your Tested-by?

I presume memcache benchmark is using small RPC ?

TSQ matters for high BDP, and is very time sensitive.

Things like slow TX completions (firing from napi poll, BH context)
can hurt TSQ.

If we add on top of these slow TX completions, an additional work
queue overhead, I really am not sure...

I would recommend tests with pfifo_fast qdisc (not FQ which has a
special override for TSQ limits)

Eventually we could add in TCP a measure of the time lost because of
TSQ, regardless of the kick implementation (tasklet or workqueue).
Measuring the delay between when a tcp socket got tcp_wfree approval
to deliver more packets, and time it finally delivered these packets
could be implemented with a bpftrace program.
