Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A49EEB64DD
	for <dm-devel@archiver.kernel.org>; Sat, 22 Jul 2023 01:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689991169;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=5uPDNKNWlhoHWb0lKTjE5snY5ZooRwvujqcSqdxVaCY=;
	b=Nz9TJl7VEYcI8wDG3qQEYS+H1tf+ttrD0LLUB6f52ElFm31dU6wolsIvQYmvaOPbPKYxmO
	syNYhoDLuhGkkNxgtdkeX9ljHYfH/t4Nu89mmYxWr3Rf9jyKcO77bnDY7Entg5br35iW4P
	M0LIDXQbg0Ht6PPh1UbBWbmmEnaErEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-AG-SHMmFPgqKmxs6TY3umA-1; Fri, 21 Jul 2023 21:59:25 -0400
X-MC-Unique: AG-SHMmFPgqKmxs6TY3umA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 002F5803470;
	Sat, 22 Jul 2023 01:59:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65096492C13;
	Sat, 22 Jul 2023 01:59:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CB4B1946A43;
	Sat, 22 Jul 2023 01:59:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F1CC1946586
 for <dm-devel@listman.corp.redhat.com>; Sat, 22 Jul 2023 01:59:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2158D40C6CCD; Sat, 22 Jul 2023 01:59:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 18C9840C6F4F
 for <dm-devel@redhat.com>; Sat, 22 Jul 2023 01:59:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEF85185A78B
 for <dm-devel@redhat.com>; Sat, 22 Jul 2023 01:59:19 +0000 (UTC)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-Zw_eex_cMsimhLQe-YwnPg-1; Fri, 21 Jul 2023 21:59:18 -0400
X-MC-Unique: Zw_eex_cMsimhLQe-YwnPg-1
Received: by mail-pj1-f72.google.com with SMTP id
 98e67ed59e1d1-2630307e6f4so1923380a91.2
 for <dm-devel@redhat.com>; Fri, 21 Jul 2023 18:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689991157; x=1690595957;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=3FbyS06rdHjZtALa07O8vipFqDrD5myi3gbAVHRPzPU=;
 b=LJ1vwh8LDlNO5jF7mEjzwpaiF0j+6cS19iwj8NkOqLks00pGk7ThmnrjdUKulYVJ/8
 zEYktfpszmcwZwpvL6Tmh1K9MwVIM0hCh8fMw29cBuqj6J1oAU+rb3sAKjOvht/J23CL
 4KnunzUmrh06u9HaZ4s5iNbNdVqLUFHDZPa7lGS5mOlgb7gH8LzSyZfOoZAxAx5q3CwQ
 Tp+YzAX3BSY4oljA+OwAqUaizBzaZoFTiNbuszTRcvNtli3tdrjjqkBy8Lz2pOOa4D0x
 9ZoM4co4xS3wfVVKuqCgMRXNTDQyDUeWRBULg75El4OzJn9PMymQr0lh2ZnwdhjGdsJs
 kuqw==
X-Gm-Message-State: ABy/qLZqRR8Cw87GDMmNqwYDoZ1/rJcgMRKOGOZNDK8+bzFcaEWgYaZx
 P5kKKqyxrE8D2RoJntbxj8mDOEoWWcthpBuSauV87tgN2bri6o9ELIa2M8krFGO4ORrrBwdkIxC
 1hf/TYqxQ54PdJ73+1sdQ+Jc7qN5/JU0=
X-Received: by 2002:a17:90a:fa3:b0:261:49b:d65 with SMTP id
 32-20020a17090a0fa300b00261049b0d65mr3421275pjz.28.1689991157447; 
 Fri, 21 Jul 2023 18:59:17 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEVOZfJeA9pu5Qnsu+BBcHTEY8tht4ivS2nGvi2HJLXhzvzEFPRYf1sjRLw5w02IDPmdxBC78iuKT01Mrrajic=
X-Received: by 2002:a17:90a:fa3:b0:261:49b:d65 with SMTP id
 32-20020a17090a0fa300b00261049b0d65mr3421264pjz.28.1689991157131; Fri, 21 Jul
 2023 18:59:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230523214539.226387-1-corwin@redhat.com>
 <ZLa086NuWiMkJKJE@redhat.com>
In-Reply-To: <ZLa086NuWiMkJKJE@redhat.com>
From: Kenneth Raeburn <raeburn@redhat.com>
Date: Fri, 21 Jul 2023 21:59:05 -0400
Message-ID: <CAK1Ur396ThV5AAZx2336uAW3FqSY+bHiiwEPofHB_Kwwr4ag5A@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [vdo-devel] [PATCH v2 00/39] Add the dm-vdo
 deduplication and compression device mapper target.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com,
 ebiggers@kernel.org, tj@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8085261285150505613=="

--===============8085261285150505613==
Content-Type: multipart/alternative; boundary="00000000000098417a060109ba11"

--00000000000098417a060109ba11
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 11:51=E2=80=AFAM Mike Snitzer <snitzer@kernel.org> =
wrote:

>
> But the long-standing dependency on VDO's work-queue data
> struct is still lingering (drivers/md/dm-vdo/work-queue.c). At a
> minimum we need to work toward pinning down _exactly_ why that is, and
> I think the best way to answer that is by simply converting the VDO
> code over to using Linux's workqueues.  If doing so causes serious
> inherent performance (or functionality) loss then we need to
> understand why -- and fix Linux's workqueue code accordingly. (I've
> cc'd Tejun so he is aware).
>

 We tried this experiment and did indeed see some significant performance
differences. Nearly a 7x slowdown in some cases.

VDO can be pretty CPU-intensive. In addition to hashing and compression, it
scans some big in-memory data structures as part of the deduplication
process. Some data structures are split across one or more "zones" to
enable concurrency (usually split based on bits of an address or something
like that), but some are not, and a couple of those threads can sometimes
exceed 50% CPU utilization, even 90% depending on the system and test data
configuration. (Usually this is while pushing over 1GB/s through the
deduplication and compression processing on a system with fast storage. On
a slow VM with spinning storage, the CPU load is much smaller.)

We use a sort of message-passing arrangement where a worker thread is
responsible for updating certain data structures as needed for the I/Os in
progress, rather than having the processing of each I/O contend for locks
on the data structures. It gives us some good throughput under load but it
does mean upwards of a dozen handoffs per 4kB write, depending on
compressibility, whether the block is a duplicate, and various other
factors. So processing 1 GB/s means handling over 3M messages per second,
though each step of processing is generally lightweight. For our dedicated
worker threads, it's not unusual for a thread to wake up and process a few
tens or even hundreds of updates to its data structures (likely benefiting
from CPU caching of the data structures) before running out of available
work and going back to sleep.

The experiment I ran was to create an ordered workqueue instead of each
dedicated thread where we need serialization, and unordered workqueues when
concurrency is allowed. On our slower test systems (> 10y old Supermicro
Xeon E5-1650 v2, RAID-0 storage using SSDs or HDDs), the slowdown was less
significant (under 2x), but on our faster system (4-5? year old Supermicro
1029P-WTR, 2x Xeon Gold 6128 =3D 12 cores, NVMe storage) we got nearly a 7x
slowdown overall. I haven't yet dug deeply into _why_ the kernel work
queues are slower in this sort of setup. I did run "perf top" briefly
during one test with kernel work queues, and the largest single use of CPU
cycles was in spin lock acquisition, but I didn't get call graphs.

(This was with Fedora 37 6.2.12-200 and 6.2.15-200 kernels, without the
latest submissions from Tejun, which look interesting. Though I suspect we
care more about cache locality for some of our thread-specific data
structures than for accessing the I/O structures.)

Ken

--00000000000098417a060109ba11
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jul 18, 2023 at 11:51=E2=80=
=AFAM Mike Snitzer &lt;<a href=3D"mailto:snitzer@kernel.org">snitzer@kernel=
.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex"><br>
But the long-standing dependency on VDO&#39;s work-queue data<br>
struct is still lingering (drivers/md/dm-vdo/work-queue.c). At a<br>
minimum we need to work toward pinning down _exactly_ why that is, and<br>
I think the best way to answer that is by simply converting the VDO<br>
code over to using Linux&#39;s workqueues.=C2=A0 If doing so causes serious=
<br>
inherent performance (or functionality) loss then we need to<br>
understand why -- and fix Linux&#39;s workqueue code accordingly. (I&#39;ve=
<br>
cc&#39;d Tejun so he is aware).<br></blockquote><div><br></div><div>=C2=A0W=
e tried this experiment and did indeed see some significant performance dif=
ferences. Nearly a 7x slowdown in some cases.<br><br>VDO can be pretty CPU-=
intensive. In addition to hashing and compression, it scans some big in-mem=
ory data structures as part of the deduplication process. Some data structu=
res are split across one or more &quot;zones&quot; to enable concurrency (u=
sually split based on bits of an address or something like that), but some =
are not, and a couple of those threads can sometimes exceed 50% CPU utiliza=
tion, even 90% depending on the system and test data configuration. (Usuall=
y this is while pushing over 1GB/s through the deduplication and compressio=
n processing on a system with fast storage. On a slow VM with spinning stor=
age, the CPU load is much smaller.)<br><br>We use a sort of message-passing=
 arrangement where a worker thread is responsible for updating certain data=
 structures as needed for the I/Os in progress, rather than having the proc=
essing of each I/O contend for locks on the data structures. It gives us so=
me good throughput under load but it does mean upwards of a dozen handoffs =
per 4kB write, depending on compressibility, whether the block is a duplica=
te, and various other factors. So processing 1 GB/s means handling over 3M =
messages per second, though each step of processing is generally lightweigh=
t. For our dedicated worker threads, it&#39;s not unusual for a thread to w=
ake up and process a few tens or even hundreds of updates to its data struc=
tures (likely benefiting from CPU caching of the data structures) before ru=
nning out of available work and going back to sleep.<br><br>The experiment =
I ran was to create an ordered workqueue instead of each dedicated thread w=
here we need serialization, and unordered workqueues when concurrency is al=
lowed. On our slower test systems (&gt; 10y old Supermicro Xeon E5-1650 v2,=
 RAID-0 storage using SSDs or HDDs), the slowdown was less significant (und=
er 2x), but on our faster system (4-5? year old Supermicro 1029P-WTR, 2x Xe=
on Gold 6128 =3D 12 cores, NVMe storage) we got nearly a 7x slowdown overal=
l. I haven&#39;t yet dug deeply into _why_ the kernel work queues are slowe=
r in this sort of setup. I did run &quot;perf top&quot; briefly during one =
test with kernel work queues, and the largest single use of CPU cycles was =
in spin lock acquisition, but I didn&#39;t get call graphs.<br><br>(This wa=
s with Fedora 37 6.2.12-200 and 6.2.15-200 kernels, without the latest subm=
issions from Tejun, which look interesting. Though I suspect we care more a=
bout cache locality for some of our thread-specific data structures than fo=
r accessing the I/O structures.)</div><div><br></div><div>Ken<br></div></di=
v></div>

--00000000000098417a060109ba11--

--===============8085261285150505613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8085261285150505613==--

