Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCB1502BE
	for <dm-devel@lists.linux.dev>; Sun, 25 May 2025 03:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748145154; cv=none; b=BiV7f7sjAVbJ0gtU6s7IvJkRQYkG2VNR5rEVz3ZeyN6CL/ULlJezL56oGhMSCgs/7Xs6n+lEaAH4SI/AK9rQTNXchO4y6r6a2DsyzxosEM1SUewFjysjPxbHM1XeJlDSU5yXxyCxGaB2YTQ46LBbPvbb69l/XPXfzxaPheCGRqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748145154; c=relaxed/simple;
	bh=pHLVULE/I1fAdN8C6lYNaTg/sArg2xYUJqAANI/uVto=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JqSPlr2gRYueGzUswy1vPbBCy24O+L3bj0d8yRVsHwjwC0M2SdgAwxjAkyfj+pu0ihX1zo11OYq0tzGacisG6LBYHpvNL0x9bQTSFUcDr83GQ5gj1P7IBQ+Oej4TUF9G0FxXzLyGYXKLnCS9G2OWzGcVVdLMqVCYcrrOuHURemM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QADwaNXa; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QADwaNXa"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3da73e9cf17so11649095ab.2
        for <dm-devel@lists.linux.dev>; Sat, 24 May 2025 20:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748145151; x=1748749951; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bPvy3X1tUJGOYPMJnEfmPJ0GVPke5vL+/ijzUX6vRs=;
        b=QADwaNXaRdP3rBF6dR1Lbxx+uS4XF9URaVadmXAChlbQFncxwaNUIGS6qiPNQRWUfd
         3z+LfPdyZun09EN8+8jeHHDWztrnI8/99PV9xgFQzuyslq916GArB+a7cWAfbZhHWLHs
         ZDu0HQT88HDM/iP4RCIauSw1oYxiXZ4HO8V9YI4nt5hkackhhRK2+rt50QSqArbKzbFE
         1dIyv0Vu1PC+VVi4Yh9aMjrjzWPB/p8OdWUo41fvCzO59cfhdAoBjCd24rciTQ6AeATk
         hMtDmWtAUo+ObM+MsZCo5M+Lgc3ZFNEqjkrgPOpSLYDgt3CPtRA6LpznUMypboI2p9us
         VDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748145151; x=1748749951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4bPvy3X1tUJGOYPMJnEfmPJ0GVPke5vL+/ijzUX6vRs=;
        b=MG+kRwMLe3X2osu1Fs86MRqaZIbpuCWtT0ETqcJyQT+JZJUCXy4picpMOBspHcN5/t
         Jcp7ql1A1XyNlvRLCgsIJRKjVbOHifwJJSs1kDLZTaJIJPWJmBZqth9IBQYr93qt5BkX
         gj1C1bWzcJfgwH6n7Qb7evBqJigVhLz5ijuPus5+caSuX1WG5iU1YeDXCuc5fcUZ4v3u
         6dyRcdtEHsAm1Loe252UpKVQCTIsSI7ranqGnYQkoaRBmjIh593rBWktJtgEQchs4Rib
         gyuh809opq0dJVUGoNJWOB5kfRQwsh5Jg4dhL2kzBXY0UpbIiad6km18rp/jWtwolIaF
         0+1A==
X-Forwarded-Encrypted: i=1; AJvYcCXpib2+kSuMK/jubxVp1JZ8XQIGp9RQSK6T8/Wv4zAeYEZtINp0Ka5vC9xFbn5pzm1DegMwzj8xQg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyaRFyiNyY3vldtkxQdhhV6kbb6Mr7pPHB2QVyhMNx0QWF/w4LN
	m/WloioXlgVPvRILyZGrodbs79bXkXgxX6EoHmKFjTQ56EvZWhl0vOORmn1cX/gdkp43Vjd1Tb4
	BrgxxGUl3eYMSjreqY0BGFxxyOuNJCTI=
X-Gm-Gg: ASbGncsJBbSg1Bw9fE1z//PyQaZk4ABnqo9pNeaqh+8+kymg9RuQPiyVFUXZoKBAgUO
	qJ10/x48p1mEo1IYZ204BpfKvXeL6idVqLHcT5gQPxYhkSsMBuVYelofBeU7s9JB89h4UX1Ugdu
	a5v4qgWoa2uMyBdzP9jgzDzOJAWeZUGnh+
X-Google-Smtp-Source: AGHT+IHML8z+fBuAR5gSeQKnWfF6QyKfvKaLwPoxYEp9zEWpgn3R5AIjLcNCoDFERW2G/VaGqflZPrwXI1ZrWd439Q4=
X-Received: by 2002:a05:6e02:4413:20b0:3dd:74f3:a059 with SMTP id
 e9e14a558f8ab-3dd74f3a1d7mr5014185ab.16.1748145151426; Sat, 24 May 2025
 20:52:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-7-tj@kernel.org>
In-Reply-To: <20240130091300.2968534-7-tj@kernel.org>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Sun, 25 May 2025 11:51:55 +0800
X-Gm-Features: AX0GCFvMTnvD93mMCuhocC7VIYR-b_mSbMYR0FBqdB1w_EjU_WDhtkY7J00XsRM
Message-ID: <CAL+tcoCKqs1m4bAWTWv9aoQKs7ZpC5PXtMS2ooi6xEB6CbxN1w@mail.gmail.com>
Subject: Re: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, allen.lkml@gmail.com, kernel-team@meta.com, 
	Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 5:24=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> The only generic interface to execute asynchronously in the BH context is
> tasklet; however, it's marked deprecated and has some design flaws. To
> replace tasklets, BH workqueue support was recently added. A BH workqueue
> behaves similarly to regular workqueues except that the queued work items
> are executed in the BH context.
>
> This patch converts TCP Small Queues implementation from tasklet to BH
> workqueue.
>
> Semantically, this is an equivalent conversion and there shouldn't be any
> user-visible behavior changes. While workqueue's queueing and execution
> paths are a bit heavier than tasklet's, unless the work item is being que=
ued
> every packet, the difference hopefully shouldn't matter.
>
> My experience with the networking stack is very limited and this patch
> definitely needs attention from someone who actually understands networki=
ng.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [IPv4/=
IPv6])
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org (open list:NETWORKING [TCP])

Hi Tejun,

Sorry to revive the old thread! I noticed this change because I've
been doing an investigation around TSQ recently. I'm very cautious
about the change in the core/sensitive part of the networking area
because it might affect some corner cases beyond our limited test,
even though I've tested many rounds and no regression results
(including the latency between tcp_wfree and tcp_tsq_handler) show up.
My main concern is what the exact benefit/improvement it could bring
with the change applied since your BH workqueue commit[1] says the
tasklet mechanism has some flaws. I'd like to see if I can
reproduce/verify it.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/co=
mmit/?id=3D4cb1ef64609f9

Thanks,
Jason

> ---
>  include/net/tcp.h     |  2 +-
>  net/ipv4/tcp.c        |  2 +-
>  net/ipv4/tcp_output.c | 36 ++++++++++++++++++------------------
>  3 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index dd78a1181031..89f3702be47a 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -324,7 +324,7 @@ extern struct proto tcp_prot;
>  #define TCP_DEC_STATS(net, field)      SNMP_DEC_STATS((net)->mib.tcp_sta=
tistics, field)
>  #define TCP_ADD_STATS(net, field, val) SNMP_ADD_STATS((net)->mib.tcp_sta=
tistics, field, val)
>
> -void tcp_tasklet_init(void);
> +void tcp_tsq_work_init(void);
>
>  int tcp_v4_err(struct sk_buff *skb, u32);
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 1baa484d2190..d085ee5642fe 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4772,6 +4772,6 @@ void __init tcp_init(void)
>         tcp_v4_init();
>         tcp_metrics_init();
>         BUG_ON(tcp_register_congestion_control(&tcp_reno) !=3D 0);
> -       tcp_tasklet_init();
> +       tcp_tsq_work_init();
>         mptcp_init();
>  }
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index e3167ad96567..d11be6eebb6e 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -1049,15 +1049,15 @@ static unsigned int tcp_established_options(struc=
t sock *sk, struct sk_buff *skb
>   * needs to be reallocated in a driver.
>   * The invariant being skb->truesize subtracted from sk->sk_wmem_alloc
>   *
> - * Since transmit from skb destructor is forbidden, we use a tasklet
> + * Since transmit from skb destructor is forbidden, we use a BH work ite=
m
>   * to process all sockets that eventually need to send more skbs.
> - * We use one tasklet per cpu, with its own queue of sockets.
> + * We use one work item per cpu, with its own queue of sockets.
>   */
> -struct tsq_tasklet {
> -       struct tasklet_struct   tasklet;
> +struct tsq_work {
> +       struct work_struct      work;
>         struct list_head        head; /* queue of tcp sockets */
>  };
> -static DEFINE_PER_CPU(struct tsq_tasklet, tsq_tasklet);
> +static DEFINE_PER_CPU(struct tsq_work, tsq_work);
>
>  static void tcp_tsq_write(struct sock *sk)
>  {
> @@ -1087,14 +1087,14 @@ static void tcp_tsq_handler(struct sock *sk)
>         bh_unlock_sock(sk);
>  }
>  /*
> - * One tasklet per cpu tries to send more skbs.
> - * We run in tasklet context but need to disable irqs when
> + * One work item per cpu tries to send more skbs.
> + * We run in BH context but need to disable irqs when
>   * transferring tsq->head because tcp_wfree() might
>   * interrupt us (non NAPI drivers)
>   */
> -static void tcp_tasklet_func(struct tasklet_struct *t)
> +static void tcp_tsq_workfn(struct work_struct *work)
>  {
> -       struct tsq_tasklet *tsq =3D from_tasklet(tsq,  t, tasklet);
> +       struct tsq_work *tsq =3D container_of(work, struct tsq_work, work=
);
>         LIST_HEAD(list);
>         unsigned long flags;
>         struct list_head *q, *n;
> @@ -1164,15 +1164,15 @@ void tcp_release_cb(struct sock *sk)
>  }
>  EXPORT_SYMBOL(tcp_release_cb);
>
> -void __init tcp_tasklet_init(void)
> +void __init tcp_tsq_work_init(void)
>  {
>         int i;
>
>         for_each_possible_cpu(i) {
> -               struct tsq_tasklet *tsq =3D &per_cpu(tsq_tasklet, i);
> +               struct tsq_work *tsq =3D &per_cpu(tsq_work, i);
>
>                 INIT_LIST_HEAD(&tsq->head);
> -               tasklet_setup(&tsq->tasklet, tcp_tasklet_func);
> +               INIT_WORK(&tsq->work, tcp_tsq_workfn);
>         }
>  }
>
> @@ -1186,11 +1186,11 @@ void tcp_wfree(struct sk_buff *skb)
>         struct sock *sk =3D skb->sk;
>         struct tcp_sock *tp =3D tcp_sk(sk);
>         unsigned long flags, nval, oval;
> -       struct tsq_tasklet *tsq;
> +       struct tsq_work *tsq;
>         bool empty;
>
>         /* Keep one reference on sk_wmem_alloc.
> -        * Will be released by sk_free() from here or tcp_tasklet_func()
> +        * Will be released by sk_free() from here or tcp_tsq_workfn()
>          */
>         WARN_ON(refcount_sub_and_test(skb->truesize - 1, &sk->sk_wmem_all=
oc));
>
> @@ -1212,13 +1212,13 @@ void tcp_wfree(struct sk_buff *skb)
>                 nval =3D (oval & ~TSQF_THROTTLED) | TSQF_QUEUED;
>         } while (!try_cmpxchg(&sk->sk_tsq_flags, &oval, nval));
>
> -       /* queue this socket to tasklet queue */
> +       /* queue this socket to BH workqueue */
>         local_irq_save(flags);
> -       tsq =3D this_cpu_ptr(&tsq_tasklet);
> +       tsq =3D this_cpu_ptr(&tsq_work);
>         empty =3D list_empty(&tsq->head);
>         list_add(&tp->tsq_node, &tsq->head);
>         if (empty)
> -               tasklet_schedule(&tsq->tasklet);
> +               queue_work(system_bh_wq, &tsq->work);
>         local_irq_restore(flags);
>         return;
>  out:
> @@ -2623,7 +2623,7 @@ static bool tcp_small_queue_check(struct sock *sk, =
const struct sk_buff *skb,
>         if (refcount_read(&sk->sk_wmem_alloc) > limit) {
>                 /* Always send skb if rtx queue is empty or has one skb.
>                  * No need to wait for TX completion to call us back,
> -                * after softirq/tasklet schedule.
> +                * after softirq schedule.
>                  * This helps when TX completions are delayed too much.
>                  */
>                 if (tcp_rtx_queue_empty_or_single_skb(sk))
> --
> 2.43.0
>
>
