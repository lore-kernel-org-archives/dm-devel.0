Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12ECC00140
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 01:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659490759;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZTySSwgymUV8k/soBTx+uwmWMPSDUNt4EuYuwDjEaMA=;
	b=IGd3Bb3eRw3cIaES8qj56ZoPFJL5rCBtdqWQeiTO7PpKFKgkY2UUFARQ0p9/rRN1/cO2O6
	jrG73s7qbRkGkizD6+wwbTC0I48+oZ9ZbnsvVjecikD/hU7IFl1uya8CezOlW7va7POh/r
	wre8ZYEC6z9zvdTJTlw2juAk8gdrfXY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-zfty8EX0PrWtfOd8jvqKTA-1; Tue, 02 Aug 2022 21:39:15 -0400
X-MC-Unique: zfty8EX0PrWtfOd8jvqKTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2397F29ABA0D;
	Wed,  3 Aug 2022 01:39:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 294772166B26;
	Wed,  3 Aug 2022 01:39:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D70911946A56;
	Wed,  3 Aug 2022 01:39:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A164F1946A4A
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 01:39:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8013D492CA2; Wed,  3 Aug 2022 01:39:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C218492C3B
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 01:39:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 623EE29ABA04
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 01:39:11 +0000 (UTC)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com
 [209.85.167.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-nVRpdERzPQi65POB5A7XAw-1; Tue, 02 Aug 2022 21:39:09 -0400
X-MC-Unique: nVRpdERzPQi65POB5A7XAw-1
Received: by mail-lf1-f48.google.com with SMTP id x39so14787146lfu.7
 for <dm-devel@redhat.com>; Tue, 02 Aug 2022 18:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=9mCEVvIsi0w6vNAlstP9oTjhW63skPYzqOP9HgmmqMo=;
 b=7sWu7En/7dhzENgmTk20lxBKbo3mMdnT6ahzYgEdrHkaW7nE5rPvhwITPm3ayB36SK
 y+1FLLnFGH9qqzju4L454mqH5R5RtC8uLOxrXEd9vGxyEOXtAl2ZWDwZY3y0cSuGAVqT
 ux5XnosSTIhLNYHb+SSVSXQ4py0PUaz7covNZiv7eYeJ46uuEVME+6btPl5mu0TLxqjl
 r8WUfD89JsnS5PvhP7/fdGUZLMpEHG7inMwtKp76TSUvPGbR/uFzuJdYLjS25fSRL9ga
 Sg7mWGkrMuHyT6udAUEQv6BN58ZgDa7zZmWARTkLjzHiteZAYXv7yq9Z5eafJwmVgLRP
 AklA==
X-Gm-Message-State: ACgBeo3PiE9bOqWjHam+mFbaPgLEQPoz1ui7iQf3vd2oVHgr9No4RtUV
 Q65rxl5a2eC+Gysu5YVhhJT8IFU6SvcWIq6/4cuiHg==
X-Google-Smtp-Source: AA6agR5Z4zcb09AzOg0ldv/K5Z8VA+x3QfNvmWrrSKZIx0LC97vRLuzjovV9FjnlSoW+M+YNmrz8y0oJIP6RBG194Gc=
X-Received: by 2002:ac2:4db6:0:b0:48a:f9b6:bac1 with SMTP id
 h22-20020ac24db6000000b0048af9b6bac1mr3821531lfe.669.1659490748050; Tue, 02
 Aug 2022 18:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220726160959.89247-1-snitzer@kernel.org>
 <6a158b48-10d3-6427-bc44-e7f78513380b@gmail.com>
 <YuBzAIXQXBRwukR7@redhat.com> <28afb65a-f15a-7f75-9a78-acae374f809b@gmail.com>
In-Reply-To: <28afb65a-f15a-7f75-9a78-acae374f809b@gmail.com>
From: Nathan Huckleberry <nhuck@google.com>
Date: Tue, 2 Aug 2022 18:39:00 -0700
Message-ID: <CAJkfWY5wbGB=2CxGKcSKSUCyE18fg4HHH4KuDw+1zRe5jNGmww@mail.gmail.com>
To: Milan Broz <gmazyland@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 0/6] dm verity: optionally use tasklets
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
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 27, 2022 at 1:23 AM Milan Broz <gmazyland@gmail.com> wrote:
>
> On 27/07/2022 01:04, Mike Snitzer wrote:
> > On Tue, Jul 26 2022 at  5:44P -0400,
> > Milan Broz <gmazyland@gmail.com> wrote:
> >
> >> On 26/07/2022 18:09, Mike Snitzer wrote:
> >>> Hi,
> >>>
> >>> Please see this updated patchset that reflects what I've staged for
> >>> the 5.20 merge window, see:
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20
> >>>
> >>> My only outstanding question, from previous v1 patchset, is: should
> >>> the verify_wq be created using WQ_HIGHPRI instead of WQ_CPU_INTENSIVE?
> >>> (I doubt it has a significant impact on performance but if you have
> >>> insight on why you made that change, and if it meaningful, I'd happily
> >>> apply the change).
> >>>
> >>> I've tested using cryptsetup's testsuite (which has dm-verity tests)
> >>> but I haven't tested the "try_verify_in_tasklet" feature.
> >
> > I wasn't lying above: I haven't tested the "try_verify_in_tasklet"
> > feature.  I just figured I didn't break what Huck posted by cleaning
> > it up while reviewing closely ;)
>
> :) What I am trying to avoid is that these patches reach Linux tree
> until properly tested even in non-standard configurations (like FEC enabled).
>
> Currently we have not even enough HW for GitLab runners for upstream cryptsetup
> CI testing and regression like these will cause *huge* pain for us later.
>
> >> I added new veritysetup option --use-tasklets for testing to a new branch
> >> https://gitlab.com/cryptsetup/cryptsetup/-/commits/verify-tasklet
> >>
> >> I tried to run verity-compat-test (on that branch above), not used the flag yet,
> >> just in one simple option flag test (see the branch).
> >
> > OK, thanks for doing this work, really appreciate it.  How is it I
> > would initiate this test using your "verify-tasklet" branch?
>
> Basically, just checkout that branch, compile it
> (autogen.sh, configure, make, make check-programs) and then run verity test
> cd tests; ./verity-compat-test
>
> Even without adding the feature, FEC tests are skipped for some reason...
> (Check for N/A that should not be there.)
>
> Then you can easily enable "--use-tasklets" for every open, I would just
> comment this line:
>
> --- a/src/veritysetup.c
> +++ b/src/veritysetup.c
> @@ -184,7 +184,7 @@ static int _activate(const char *dm_device,
>                  activate_flags |= CRYPT_ACTIVATE_IGNORE_ZERO_BLOCKS;
>          if (ARG_SET(OPT_CHECK_AT_MOST_ONCE_ID))
>                  activate_flags |= CRYPT_ACTIVATE_CHECK_AT_MOST_ONCE;
> -       if (ARG_SET(OPT_USE_TASKLETS_ID))
> +//     if (ARG_SET(OPT_USE_TASKLETS_ID))
>                  activate_flags |= CRYPT_ACTIVATE_TASKLETS;
>
>
> compile it, and run the verity-compat-test again.
>

> For me, it stucks on the first in-kernel verify (non-FEC) line.
> Some trace below...

I was able to fix this. There was a problem with falling back to a
work-queue after FEC fails. This caused an infinite loop. I have
dm-verity passing verity-compat-test with --use-tasklets; I'll send a
v3 soon.

Thanks,
Huck




>
> (Side note: we do not have any easy way to check that dm-verity
> is compiled without FEC. Target version is the same, and I do not
> want to introduce any config parsing in libcryptsetup....
> The same perhaps applies to other targets, any idea?
> I would help us to error the test in that case more clearly.)
>
> Milan
>
> Jul 27 10:10:20 : device-mapper: verity: 7:2: reached maximum errors
> Jul 27 10:10:21 : loop1: detected capacity change from 0 to 1094
> Jul 27 10:10:21 : device-mapper: verity: sha256 using implementation "sha256-generic"
> Jul 27 10:10:22 : loop1: detected capacity change from 0 to 1094
> Jul 27 10:10:22 : device-mapper: verity: sha256 using implementation "sha256-generic"
> Jul 27 10:15:29 : INFO: task systemd-udevd:6842 blocked for more than 122 seconds.
> Jul 27 10:15:29 :       Not tainted 5.19.0-rc8+ #767
> Jul 27 10:15:29 : "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jul 27 10:15:29 : task:systemd-udevd   state:D stack:    0 pid: 6842 ppid:   540 flags:0x00004006
> Jul 27 10:15:29 : Call Trace:
> Jul 27 10:15:29 :  __schedule+0x3f9/0xcc0
> Jul 27 10:15:29 :  schedule+0x40/0xb0
> Jul 27 10:15:29 :  io_schedule+0x3c/0x60
> Jul 27 10:15:29 :  folio_wait_bit_common+0xe2/0x310
> Jul 27 10:15:29 :  ? filemap_invalidate_unlock_two+0x40/0x40
> Jul 27 10:15:29 :  __filemap_get_folio+0x4d8/0x500
> Jul 27 10:15:29 :  truncate_inode_pages_range+0x1c2/0x4e0
> Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
> Jul 27 10:15:29 :  ? smp_call_function_many_cond+0x2e5/0x310
> Jul 27 10:15:29 :  ? on_each_cpu_cond_mask+0x32/0x60
> Jul 27 10:15:29 :  ? trace_hardirqs_on+0x35/0xd0
> Jul 27 10:15:29 :  ? smp_call_function_many_cond+0xe9/0x310
> Jul 27 10:15:29 :  ? buffer_exit_cpu_dead+0x80/0x80
> Jul 27 10:15:29 :  ? buffer_exit_cpu_dead+0x80/0x80
> Jul 27 10:15:29 :  ? generic_remap_file_range_prep+0xcb0/0xcb0
> Jul 27 10:15:29 :  ? on_each_cpu_cond_mask+0x3c/0x60
> Jul 27 10:15:29 :  ? generic_remap_file_range_prep+0xcb0/0xcb0
> Jul 27 10:15:29 :  truncate_inode_pages+0xc/0x10
> Jul 27 10:15:29 :  blkdev_flush_mapping+0x66/0x100
> Jul 27 10:15:29 :  blkdev_put_whole+0x38/0x40
> Jul 27 10:15:29 :  blkdev_put+0x92/0x1c0
> Jul 27 10:15:29 :  blkdev_close+0x13/0x20
> Jul 27 10:15:29 :  __fput+0x80/0x270
> Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
> Jul 27 10:15:29 :  ____fput+0x8/0x10
> Jul 27 10:15:29 :  task_work_run+0x4f/0x80
> Jul 27 10:15:29 :  do_exit+0x315/0x9a0
> Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
> Jul 27 10:15:29 :  do_group_exit+0x26/0x90
> Jul 27 10:15:29 :  get_signal+0xa2d/0xa60
> Jul 27 10:15:29 :  arch_do_signal_or_restart+0x1e/0x5c0
> Jul 27 10:15:29 :  ? __this_cpu_preempt_check+0xf/0x11
> Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
> Jul 27 10:15:29 :  ? exit_to_user_mode_prepare+0x10f/0x250
> Jul 27 10:15:29 :  ? syscall_exit_to_user_mode+0x1a/0x50
> Jul 27 10:15:29 :  exit_to_user_mode_prepare+0x129/0x250
> Jul 27 10:15:29 :  syscall_exit_to_user_mode+0x1a/0x50
> Jul 27 10:15:29 :  do_int80_syscall_32+0x3c/0x90
> Jul 27 10:15:29 :  entry_INT80_32+0xf0/0xf0
> Jul 27 10:15:29 : EIP: 0xb7f61022
> Jul 27 10:15:29 : EAX: fffffffc EBX: 00000005 ECX: 0054cbdc EDX: 00000100
> Jul 27 10:15:29 : ESI: b7ea8000 EDI: 00570820 EBP: 00570868 ESP: bfc0890c
> Jul 27 10:15:29 : DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 007b EFLAGS: 00000246
> Jul 27 10:15:29 : \x0aShowing all locks held in the system:
> Jul 27 10:15:29 : 1 lock held by khungtaskd/34:
> Jul 27 10:15:29 :  #0: c1b0bc98 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x1f/0x152
> Jul 27 10:15:29 : 2 locks held by kworker/u16:5/6148:
> Jul 27 10:15:29 : 1 lock held by systemd-udevd/6842:
> Jul 27 10:15:29 :  #0: c51344bc (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_put+0x30/0x1c0
> Jul 27 10:15:29 :
> Jul 27 10:15:29 : =============================================\x0a

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

