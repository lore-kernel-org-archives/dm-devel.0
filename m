Return-Path: <SRS0=pEeb=F4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5674BC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 24 Dec 2020 18:46:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A65F322287
	for <dm-devel@archiver.kernel.org>; Thu, 24 Dec 2020 18:46:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A65F322287
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387--6lFKTnbNSO3D4Glu4yH0A-1; Thu, 24 Dec 2020 13:46:52 -0500
X-MC-Unique: -6lFKTnbNSO3D4Glu4yH0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89D031800D42;
	Thu, 24 Dec 2020 18:46:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F8656F92A;
	Thu, 24 Dec 2020 18:46:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3847B180954D;
	Thu, 24 Dec 2020 18:46:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BOIkbns031265 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Dec 2020 13:46:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1FDA22166B2B; Thu, 24 Dec 2020 18:46:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AA0B2166B29
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 18:46:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6AC0811E76
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 18:46:34 +0000 (UTC)
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com
	[209.85.166.177]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-432-geXbq1RtMcicuglhDeFe0Q-1; Thu, 24 Dec 2020 13:46:30 -0500
X-MC-Unique: geXbq1RtMcicuglhDeFe0Q-1
Received: by mail-il1-f177.google.com with SMTP id k8so2627114ilr.4
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 10:46:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=nsNUBloWAUhQfAKDNr2zmKo9lnafAmXiCyM9Nf0pRww=;
	b=nrVJFp1W6Wp6P6kYGx/YTVs6FUp1+ATZgyGe2MtLTz6LFIDbc1rS8iTzpJh23mQ7TN
	/nM9pq2JATLHi63JlXHNXmD/F6UkUgqQwsPC6zSDU+0ID7ofthHjlCwlF4hwrJyetFY9
	KubyVHb9Cb24C4swDgz12Zo0Ifh3ndbuAF43rNE+Wvea3sqjKIMi2tJb3zvMvXtSNHmQ
	mcQNyV1HI1Nmenh5CcWX2WbFtOChBh4aVb9U3Q8Bby+5Qrzf9usuYaIWT/xorEsuy43+
	XGcVRE3bfO6L5uYdSuAk+YSiHgQSolSPkFGfZgwz0s4pwNjEgYWczQliepO89/g3vjF1
	egfw==
X-Gm-Message-State: AOAM5308nXHX1w8jnQyxSCUSUKIFEYYLhfNog24jJ0YB4r3UQCcdulPw
	DQzi2YYmHo6/CxbeV5Ofh8sKsRoSsIACT9eegoW0xQ==
X-Google-Smtp-Source: ABdhPJzsmImv7k+5UrjMHFKA93tf3e/AzHOKBFsr40lui6mxYWeQ8BhATn0N88TYfOYKFQPj9VJF1PoQnqjwa/kciQI=
X-Received: by 2002:a05:6e02:5c2:: with SMTP id
	l2mr30093792ils.231.1608835589405; 
	Thu, 24 Dec 2020 10:46:29 -0800 (PST)
MIME-Version: 1.0
References: <16ffadab-42ba-f9c7-8203-87fda3dc9b44@maciej.szmigiero.name>
	<74c7129b-a437-ebc4-1466-7fb9f034e006@maciej.szmigiero.name>
	<20201223205642.GA19817@gondor.apana.org.au>
In-Reply-To: <20201223205642.GA19817@gondor.apana.org.au>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 24 Dec 2020 18:46:18 +0000
Message-ID: <CALrw=nFRLxpG+Qzy=wki1m6HnQUqPK9CQFGEEnB1tjSF0ex4UQ@mail.gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Mike Snitzer <snitzer@redhat.com>,
	kernel-team <kernel-team@cloudflare.com>, dm-crypt@saout.de,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Nobuto Murata <nobuto.murata@canonical.com>,
	Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
	device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>, Alasdair G Kergon <agk@redhat.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
Subject: Re: [dm-devel] dm-crypt with no_read_workqueue and
 no_write_workqueue + btrfs scrub = BUG()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 23, 2020 at 8:57 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Dec 23, 2020 at 04:37:34PM +0100, Maciej S. Szmigiero wrote:
> >
> > It looks like to me that the skcipher API might not be safe to
> > call from a softirq context, after all.
>
> skcipher is safe to use in a softirq.  The problem is only in
> dm-crypt where it tries to allocate memory with GFP_NOIO.

Hm.. After eliminating the GFP_NOIO (as well as some other sleeping
paths) from dm-crypt softirq code I still hit an occasional crash in
my extreme setup (QEMU with 1 CPU and cryptd_max_cpu_qlen set to 1)
(decoded with stacktrace_decode.sh):

[   89.324723] BUG: kernel NULL pointer dereference, address: 0000000000000008
[   89.325713] #PF: supervisor write access in kernel mode
[   89.326460] #PF: error_code(0x0002) - not-present page
[   89.327211] PGD 0 P4D 0
[   89.327589] Oops: 0002 [#1] PREEMPT SMP PTI
[   89.328200] CPU: 0 PID: 21 Comm: kworker/0:1 Not tainted 5.10.0+ #79
[   89.329109] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 0.0.0 02/06/2015
[   89.330284] Workqueue: cryptd cryptd_queue_worker
[   89.330999] RIP: 0010:crypto_dequeue_request
(/cfsetup_build/./include/linux/list.h:112
/cfsetup_build/./include/linux/list.h:135
/cfsetup_build/./include/linux/list.h:146
/cfsetup_build/crypto/algapi.c:957)
[ 89.331757] Code: e9 c9 d0 a8 48 c7 c7 f9 c9 d0 a8 e8 c2 88 fe ff 4c
8b 23 48 c7 c6 e9 c9 d0 a8 48 c7 c7 f9 c9 d0 a8 49 8b 14 24 49 8b 44
24 08 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 49 89 04 24
48
All code
========
   0: e9 c9 d0 a8 48        jmpq   0x48a8d0ce
   5: c7 c7 f9 c9 d0 a8    mov    $0xa8d0c9f9,%edi
   b: e8 c2 88 fe ff        callq  0xfffffffffffe88d2
  10: 4c 8b 23              mov    (%rbx),%r12
  13: 48 c7 c6 e9 c9 d0 a8 mov    $0xffffffffa8d0c9e9,%rsi
  1a: 48 c7 c7 f9 c9 d0 a8 mov    $0xffffffffa8d0c9f9,%rdi
  21: 49 8b 14 24          mov    (%r12),%rdx
  25: 49 8b 44 24 08        mov    0x8(%r12),%rax
  2a:* 48 89 42 08          mov    %rax,0x8(%rdx) <-- trapping instruction
  2e: 48 89 10              mov    %rdx,(%rax)
  31: 48 b8 00 01 00 00 00 movabs $0xdead000000000100,%rax
  38: 00 ad de
  3b: 49 89 04 24          mov    %rax,(%r12)
  3f: 48                    rex.W

Code starting with the faulting instruction
===========================================
   0: 48 89 42 08          mov    %rax,0x8(%rdx)
   4: 48 89 10              mov    %rdx,(%rax)
   7: 48 b8 00 01 00 00 00 movabs $0xdead000000000100,%rax
   e: 00 ad de
  11: 49 89 04 24          mov    %rax,(%r12)
  15: 48                    rex.W
[   89.334414] RSP: 0018:ffffba64c00bbe68 EFLAGS: 00010246
[   89.335165] RAX: 0000000000000000 RBX: ffff9b9d6fc28d88 RCX: 0000000000000000
[   89.336182] RDX: 0000000000000000 RSI: ffffffffa8d0c9e9 RDI: ffffffffa8d0c9f9
[   89.337204] RBP: 0000000000000000 R08: ffffffffa906e708 R09: 0000000000000058
[   89.338208] R10: ffffffffa9068720 R11: 00000000fffffc00 R12: ffff9b9a43797478
[   89.339216] R13: 0000000000000020 R14: ffff9b9d6fc28e00 R15: 0000000000000000
[   89.340231] FS:  0000000000000000(0000) GS:ffff9b9d6fc00000(0000)
knlGS:0000000000000000
[   89.341376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.342207] CR2: 0000000000000008 CR3: 000000014cd76002 CR4: 0000000000170ef0
[   89.343238] Call Trace:
[   89.343609] cryptd_queue_worker (/cfsetup_build/crypto/cryptd.c:172)
[   89.344218] process_one_work
(/cfsetup_build/./arch/x86/include/asm/preempt.h:26
/cfsetup_build/kernel/workqueue.c:2284)
[   89.344821] ? rescuer_thread (/cfsetup_build/kernel/workqueue.c:2364)
[   89.345399] worker_thread
(/cfsetup_build/./include/linux/list.h:282
/cfsetup_build/kernel/workqueue.c:2422)
[   89.345923] ? rescuer_thread (/cfsetup_build/kernel/workqueue.c:2364)
[   89.346504] kthread (/cfsetup_build/kernel/kthread.c:292)
[   89.346986] ? kthread_create_worker_on_cpu
(/cfsetup_build/kernel/kthread.c:245)
[   89.347713] ret_from_fork (/cfsetup_build/arch/x86/entry/entry_64.S:302)
[   89.348255] Modules linked in:
[   89.348708] CR2: 0000000000000008
[   89.349197] ---[ end trace b7e9618b4122ed3b ]---
[   89.349863] RIP: 0010:crypto_dequeue_request
(/cfsetup_build/./include/linux/list.h:112
/cfsetup_build/./include/linux/list.h:135
/cfsetup_build/./include/linux/list.h:146
/cfsetup_build/crypto/algapi.c:957)
[ 89.350606] Code: e9 c9 d0 a8 48 c7 c7 f9 c9 d0 a8 e8 c2 88 fe ff 4c
8b 23 48 c7 c6 e9 c9 d0 a8 48 c7 c7 f9 c9 d0 a8 49 8b 14 24 49 8b 44
24 08 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 49 89 04 24
48
All code
========
   0: e9 c9 d0 a8 48        jmpq   0x48a8d0ce
   5: c7 c7 f9 c9 d0 a8    mov    $0xa8d0c9f9,%edi
   b: e8 c2 88 fe ff        callq  0xfffffffffffe88d2
  10: 4c 8b 23              mov    (%rbx),%r12
  13: 48 c7 c6 e9 c9 d0 a8 mov    $0xffffffffa8d0c9e9,%rsi
  1a: 48 c7 c7 f9 c9 d0 a8 mov    $0xffffffffa8d0c9f9,%rdi
  21: 49 8b 14 24          mov    (%r12),%rdx
  25: 49 8b 44 24 08        mov    0x8(%r12),%rax
  2a:* 48 89 42 08          mov    %rax,0x8(%rdx) <-- trapping instruction
  2e: 48 89 10              mov    %rdx,(%rax)
  31: 48 b8 00 01 00 00 00 movabs $0xdead000000000100,%rax
  38: 00 ad de
  3b: 49 89 04 24          mov    %rax,(%r12)
  3f: 48                    rex.W

Code starting with the faulting instruction
===========================================
   0: 48 89 42 08          mov    %rax,0x8(%rdx)
   4: 48 89 10              mov    %rdx,(%rax)
   7: 48 b8 00 01 00 00 00 movabs $0xdead000000000100,%rax
   e: 00 ad de
  11: 49 89 04 24          mov    %rax,(%r12)
  15: 48                    rex.W
[   89.353266] RSP: 0018:ffffba64c00bbe68 EFLAGS: 00010246
[   89.354003] RAX: 0000000000000000 RBX: ffff9b9d6fc28d88 RCX: 0000000000000000
[   89.355048] RDX: 0000000000000000 RSI: ffffffffa8d0c9e9 RDI: ffffffffa8d0c9f9
[   89.356063] RBP: 0000000000000000 R08: ffffffffa906e708 R09: 0000000000000058
[   89.357082] R10: ffffffffa9068720 R11: 00000000fffffc00 R12: ffff9b9a43797478
[   89.358088] R13: 0000000000000020 R14: ffff9b9d6fc28e00 R15: 0000000000000000
[   89.359127] FS:  0000000000000000(0000) GS:ffff9b9d6fc00000(0000)
knlGS:0000000000000000
[   89.360296] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   89.361129] CR2: 0000000000000008 CR3: 000000014cd76002 CR4: 0000000000170ef0
[   89.362160] Kernel panic - not syncing: Fatal exception in interrupt
[   89.363145] Kernel Offset: 0x26000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   89.364730] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

This happens when running dm-crypt with no_read_workqueues on top of
an emulated NVME in QEMU (NVME driver "completes" IO in IRQ context).
Somehow sending decryption requests to cryptd in some fashion in
softirq context corrupts the crypto queue it seems.

Regards,
Ignat


> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

