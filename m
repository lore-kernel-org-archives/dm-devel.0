Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1DAC61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 16 Feb 2023 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676568600;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j+lQOt1KWAKm+NXmB8O1gQAUWAMnjxSRarFSXCT+Yx4=;
	b=VRivW9ZfTZg/SmUaXPdbPidLZPjwmPcoRn12+RU6j6jK86KSM/MVwypPPW67F2qNWxbK8I
	NnY/ioT1LsDRPde79ATdekDbgJApSQlU8tCQA5FLRClCpGq7aupNz1RyGhUmuq5Zkl6f2I
	trTRgjZ7QLaG7kpxtBbNLL9gJZ/CoHk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-6yu55JGWNyGpdNTi_O5RMQ-1; Thu, 16 Feb 2023 12:29:56 -0500
X-MC-Unique: 6yu55JGWNyGpdNTi_O5RMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49849857A81;
	Thu, 16 Feb 2023 17:29:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3AE40B40C9;
	Thu, 16 Feb 2023 17:29:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A1931946589;
	Thu, 16 Feb 2023 17:29:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CEA01946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Feb 2023 17:29:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ADB072166B31; Thu, 16 Feb 2023 17:29:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A75B32166B30
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 17:29:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89DBD80D0E2
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 17:29:36 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-0gtg_wKDM9yyJXDkz6iswA-1; Thu, 16 Feb 2023 12:29:35 -0500
X-MC-Unique: 0gtg_wKDM9yyJXDkz6iswA-1
Received: by mail-qt1-f180.google.com with SMTP id b21so2918364qtr.13
 for <dm-devel@redhat.com>; Thu, 16 Feb 2023 09:29:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=J7R7K2HaOS399x/W/wFyXKjBxBxPKf6KElOSxqtkjpE=;
 b=LBeuED3VzFVv6/2mzPQVEatepwff1GgOk+n+ZQ/doqCnybwGPEo19zxGPqnBMu3Rms
 NntlfFNU9PPzF1tsHUz1QqbTuE82RaWI7wnV2NVBc9VrYxyz04YtW4KOmA4fzIIGObvB
 m2Sp9rda3ja3+YrPaTlatouIXQMSAfYzKqnsSwmxrgMVi+f88Ed/b2OuaWeeDsmasXuk
 YBJPgbnw2YGHSjyY5oXcWW1ga4dVQpPssqXKwRF8q56CuGaF9iL8JPz6jX2QUg90c5XK
 e3p7cT1mCNWPkzxppK+FZ8qaTrVMpyqDQ5TjwiSerq33TkOdRlS8bjckF1jvIbooa4bH
 BigQ==
X-Gm-Message-State: AO0yUKUimdF9jpBJBQzJVOJj1nFHU4SidPfTHfPIa8CtRAF69QT74An4
 5RY2bau1k53PpFnr4rmmTVblsAo=
X-Google-Smtp-Source: AK7set99mzWJIoVZb2dU0sdqJJh0hlvGzl1jtG1p6PLmaObmSURCTpkQhpQnx6EhroaOiXzIfYj5KQ==
X-Received: by 2002:a05:622a:15d3:b0:3b8:6db0:7565 with SMTP id
 d19-20020a05622a15d300b003b86db07565mr10046104qty.11.1676568574547; 
 Thu, 16 Feb 2023 09:29:34 -0800 (PST)
Received: from localhost ([37.19.196.223]) by smtp.gmail.com with ESMTPSA id
 x4-20020ac84d44000000b003b82a07c4d6sm1557230qtv.84.2023.02.16.09.29.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Feb 2023 09:29:34 -0800 (PST)
Date: Thu, 16 Feb 2023 12:29:33 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Pingfan Liu <piliu@redhat.com>
Message-ID: <Y+5n/cMlcVdfFhgr@redhat.com>
References: <CAF+s44TZw40c_hNDi78VkMq6Xhp23h5j_cadHWirOnYW-wR=NQ@mail.gmail.com>
 <Y+10AxZ8tcd6SemJ@T590>
 <CAF+s44Qqvvhywg4_8Sx3QZ0=_+jz3kPzvmr539uS8Y6LEGY2sg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAF+s44Qqvvhywg4_8Sx3QZ0=_+jz3kPzvmr539uS8Y6LEGY2sg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Cc: Ming Lei <ming.lei@redhat.com>, dm-devel@redhat.com,
 Zdenek Kabelac <zkabelac@redhat.com>, Ming Lei <minlei@redhat.com>,
 Tao Liu <ltao@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


[Top-posting but please don't...]

I've staged this fix for 6.3 inclusion and marked it for stable@:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=0ca44fcef241768fd25ee763b3d203b9852f269b

Ming, I also staged this similar fix (not reasoned through scenario
where it'd actually occur that dm_wq_requeue_work would loop endlessly
but its good practice to include cond_resched() in such a workqueue
while loop):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.3&id=f77692d65d54665d81815349cc727baa85e8b71d

Thanks,
Mike

On Thu, Feb 16 2023 at  3:30P -0500,
Pingfan Liu <piliu@redhat.com> wrote:

> Hi Ming,
> 
> Thank you for looking into this.
> 
> let me loop in Alasdair, Mike and Zdenek for further comment on LVM stuff
> 
> 
> Thanks,
> 
> Pingfan
> 
> On Thu, Feb 16, 2023 at 8:08 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Wed, Feb 15, 2023 at 07:23:40PM +0800, Pingfan Liu wrote:
> > > Hi guys,
> > >
> > > I encountered  a hang issue on a s390x system.  The tested kernel is
> > > not preemptible and booting with "nr_cpus=1"
> > >
> > > The test steps:
> > >       umount /home
> > >       lvremove /dev/rhel_s390x-kvm-011/home
> > >       ## uncomment "snapshot_autoextend_threshold = 70" and
> > >       "snapshot_autoextend_percent = 20" in /etc/lvm/lvm.conf
> > >
> > >       systemctl enable lvm2-monitor.service
> > >       systemctl start lvm2-monitor.service
> > >
> > >       lvremove -y rhel_s390x-kvm-011/thinp
> > >       lvcreate -L 10M -T rhel_s390x-kvm-011/thinp
> > >       lvcreate -V 400M -T rhel_s390x-kvm-011/thinp -n src
> > >       mkfs.ext4 /dev/rhel_s390x-kvm-011/src
> > >       mount /dev/rhel_s390x-kvm-011/src /mnt
> > >       for((i=0;i<4;i++)); do dd if=/dev/zero of=/mnt/test$i.img
> > > bs=100M count=1; done
> > >
> > > And the system hangs with the console log [1]
> > >
> > > The related kernel config
> > >
> > >     CONFIG_PREEMPT_NONE_BUILD=y
> > >     CONFIG_PREEMPT_NONE=y
> > >     CONFIG_PREEMPT_COUNT=y
> > >     CONFIG_SCHED_CORE=y
> > >
> > > It turns out that when hanging, the kernel is stuck in the dead-loop
> > > in the function dm_wq_work()
> > >         while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
> > >                 spin_lock_irq(&md->deferred_lock);
> > >                 bio = bio_list_pop(&md->deferred);
> > >                 spin_unlock_irq(&md->deferred_lock);
> > >
> > >                 if (!bio)
> > >                         break;
> > >                 thread_cpu = smp_processor_id();
> > >                 submit_bio_noacct(bio);
> > >         }
> > > where dm_wq_work()->__submit_bio_noacct()->...->dm_handle_requeue()
> > > keeps generating new bio, and the condition "if (!bio)" can not be
> > > meet.
> > >
> > >
> > > After applying the following patch, the issue is gone.
> > >
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index e1ea3a7bd9d9..95c9cb07a42f 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > > @@ -2567,6 +2567,7 @@ static void dm_wq_work(struct work_struct *work)
> > >                         break;
> > >
> > >                 submit_bio_noacct(bio);
> > > +               cond_resched();
> > >         }
> > >  }
> > >
> > > But I think it is not a proper solution. And without this patch, if
> > > removing nr_cpus=1 (the system has two cpus), the issue can not be
> > > triggered. That says when more than one cpu, the above loop can exit
> > > by the condition "if (!bio)"
> > >
> > > Any ideas?
> >
> > I think the patch is correct.
> >
> > For kernel built without CONFIG_PREEMPT, in case of single cpu core,
> > if the dm target(such as dm-thin) needs another wq or kthread for
> > handling IO, then dm target side is blocked because dm_wq_work()
> > holds the single cpu, sooner or later, dm target may have not
> > resource to handle new io from dm core and returns REQUEUE.
> >
> > Then dm_wq_work becomes one dead loop.
> >
> >
> > Thanks,
> > Ming
> >
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

