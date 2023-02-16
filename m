Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBBDC61DA4
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 00:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676593680;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b9pgTuWZVhjUf9nkFCKswPUHC70ltzpzIYrSEmcQoNw=;
	b=N7j+tLoWdFHjxucfXt0iYR4VCruNYmbrSh7iFOafXfnoRill3YERuC4lt1t5UsCayJ99YA
	yN9iZPZmNUVGHX45HSGnX7CHCMkJ5AMFEBjRfw8HGEE8/528CHD4atIHmF4Swg+vB0vuU1
	wxkhctFXsWQDWjSl+f+Swsd7MrLj9Ac=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533--6uj8lpTP76mmu4_ZB2eoQ-1; Thu, 16 Feb 2023 19:27:57 -0500
X-MC-Unique: -6uj8lpTP76mmu4_ZB2eoQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68B3638149B5;
	Fri, 17 Feb 2023 00:27:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19808492B15;
	Fri, 17 Feb 2023 00:27:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C77891946589;
	Fri, 17 Feb 2023 00:27:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1EC01946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 08:30:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C97FC15BAD; Thu, 16 Feb 2023 08:30:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46050C15BA0
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 08:30:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A3F11C189BA
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 08:30:26 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-K2QFFpeBPNijnAEeOavDIg-1; Thu, 16 Feb 2023 03:30:22 -0500
X-MC-Unique: K2QFFpeBPNijnAEeOavDIg-1
Received: by mail-qk1-f200.google.com with SMTP id
 s7-20020a05620a0bc700b006e08208eb31so782012qki.3
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 00:30:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=K3XO1pEQK9YqeErIwQ7kooxbuE+UvrgNYKm/A1tA7Zc=;
 b=zp7E1oSvg7wDD32ji0JqD4ekkLtcdFjeGOWU/fhvEfu65UslRTMVcXuJqoZ/pFY95o
 8mEZ4WulE3ozgYmi2NQSdvLEhXY0AWh4NvXaO4efMYtWiEkFrtvqs3l/CC+mfDXNmOIJ
 krhwUZ+P0HDbBt51B0YxijWI6aeUVvJqDbs27YALcE01rHMTRjoLlCxD1CisjqlmT1GH
 x893OnK/tUsWNDVNDwXZ5ww7UbUu4ZBrtGouM7D/5dc8n5Vqpi+dBtsoI5i/mZgFQiye
 HsP3hIXf4NmTOCnq04kqW7268f3dV6KzB478lKqJ6PlEqralBIgY9Ig64/KGOQJDFfKq
 ROQA==
X-Gm-Message-State: AO0yUKU9cKnAILpnrUSK4xKBWR56jTibxkFijeBOtrp/tI8r3k0vSAni
 ORR1rnpVjqglzNj9YSOBFJ3bYr4NOXv70EIoCLze/fGn+opHcbZ/rp5M3eRAIUBH9tlpFr91t1p
 RG+jr6fghEVdl8mPAB18T7Tr4cyQB/E8=
X-Received: by 2002:a37:5fc1:0:b0:73b:55b5:31da with SMTP id
 t184-20020a375fc1000000b0073b55b531damr251423qkb.134.1676536221627; 
 Thu, 16 Feb 2023 00:30:21 -0800 (PST)
X-Google-Smtp-Source: AK7set9eqGEa1Q5bhLEv5ZklAage0ZjLWnakxe57YvbcMk2VNlveh26ScS6Kl4yvBZTf7VZY8eLPW27fxlsi9/KC74I=
X-Received: by 2002:a37:5fc1:0:b0:73b:55b5:31da with SMTP id
 t184-20020a375fc1000000b0073b55b531damr251421qkb.134.1676536221417; Thu, 16
 Feb 2023 00:30:21 -0800 (PST)
MIME-Version: 1.0
References: <CAF+s44TZw40c_hNDi78VkMq6Xhp23h5j_cadHWirOnYW-wR=NQ@mail.gmail.com>
 <Y+10AxZ8tcd6SemJ@T590>
In-Reply-To: <Y+10AxZ8tcd6SemJ@T590>
From: Pingfan Liu <piliu@redhat.com>
Date: Thu, 16 Feb 2023 16:30:10 +0800
Message-ID: <CAF+s44Qqvvhywg4_8Sx3QZ0=_+jz3kPzvmr539uS8Y6LEGY2sg@mail.gmail.com>
To: Ming Lei <ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 17 Feb 2023 00:27:53 +0000
Subject: Re: [dm-devel] A hang bug of dm on s390x
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
Cc: Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Zdenek Kabelac <zkabelac@redhat.com>, Ming Lei <minlei@redhat.com>,
 Tao Liu <ltao@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Ming,

Thank you for looking into this.

let me loop in Alasdair, Mike and Zdenek for further comment on LVM stuff


Thanks,

Pingfan

On Thu, Feb 16, 2023 at 8:08 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Wed, Feb 15, 2023 at 07:23:40PM +0800, Pingfan Liu wrote:
> > Hi guys,
> >
> > I encountered  a hang issue on a s390x system.  The tested kernel is
> > not preemptible and booting with "nr_cpus=1"
> >
> > The test steps:
> >       umount /home
> >       lvremove /dev/rhel_s390x-kvm-011/home
> >       ## uncomment "snapshot_autoextend_threshold = 70" and
> >       "snapshot_autoextend_percent = 20" in /etc/lvm/lvm.conf
> >
> >       systemctl enable lvm2-monitor.service
> >       systemctl start lvm2-monitor.service
> >
> >       lvremove -y rhel_s390x-kvm-011/thinp
> >       lvcreate -L 10M -T rhel_s390x-kvm-011/thinp
> >       lvcreate -V 400M -T rhel_s390x-kvm-011/thinp -n src
> >       mkfs.ext4 /dev/rhel_s390x-kvm-011/src
> >       mount /dev/rhel_s390x-kvm-011/src /mnt
> >       for((i=0;i<4;i++)); do dd if=/dev/zero of=/mnt/test$i.img
> > bs=100M count=1; done
> >
> > And the system hangs with the console log [1]
> >
> > The related kernel config
> >
> >     CONFIG_PREEMPT_NONE_BUILD=y
> >     CONFIG_PREEMPT_NONE=y
> >     CONFIG_PREEMPT_COUNT=y
> >     CONFIG_SCHED_CORE=y
> >
> > It turns out that when hanging, the kernel is stuck in the dead-loop
> > in the function dm_wq_work()
> >         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
> >                 spin_lock_irq(&md->deferred_lock);
> >                 bio = bio_list_pop(&md->deferred);
> >                 spin_unlock_irq(&md->deferred_lock);
> >
> >                 if (!bio)
> >                         break;
> >                 thread_cpu = smp_processor_id();
> >                 submit_bio_noacct(bio);
> >         }
> > where dm_wq_work()->__submit_bio_noacct()->...->dm_handle_requeue()
> > keeps generating new bio, and the condition "if (!bio)" can not be
> > meet.
> >
> >
> > After applying the following patch, the issue is gone.
> >
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index e1ea3a7bd9d9..95c9cb07a42f 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2567,6 +2567,7 @@ static void dm_wq_work(struct work_struct *work)
> >                         break;
> >
> >                 submit_bio_noacct(bio);
> > +               cond_resched();
> >         }
> >  }
> >
> > But I think it is not a proper solution. And without this patch, if
> > removing nr_cpus=1 (the system has two cpus), the issue can not be
> > triggered. That says when more than one cpu, the above loop can exit
> > by the condition "if (!bio)"
> >
> > Any ideas?
>
> I think the patch is correct.
>
> For kernel built without CONFIG_PREEMPT, in case of single cpu core,
> if the dm target(such as dm-thin) needs another wq or kthread for
> handling IO, then dm target side is blocked because dm_wq_work()
> holds the single cpu, sooner or later, dm target may have not
> resource to handle new io from dm core and returns REQUEUE.
>
> Then dm_wq_work becomes one dead loop.
>
>
> Thanks,
> Ming
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

