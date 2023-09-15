Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90064EED616
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694794484;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H4dTNYsyfu5c+/IqdYf1Q302EbAf9iC1Wrd2MKsPcNU=;
	b=N+HXwZJ/0YrF6dpOZRL4Vre7UvNTCo04Ean/bZzhkjdkhNPqVolRM/0/2GTF9lHgSjhbPO
	UxwZfISwbfoeCwJmS6AmTKrrjo2WX28ZNINj+BnEOLdr6h9uXV8MsSuypOXwsVWSQA9+IM
	Vha39ITcRQsp8ha48VIa7DCG4eInNSU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-fUd2hTAuMDq2L8PhDWiHaA-1; Fri, 15 Sep 2023 12:14:43 -0400
X-MC-Unique: fUd2hTAuMDq2L8PhDWiHaA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 041CE101B04E;
	Fri, 15 Sep 2023 16:14:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C39721B20B1;
	Fri, 15 Sep 2023 16:14:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25DE8194658C;
	Fri, 15 Sep 2023 16:14:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 030D51946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 16:14:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E1E45170EE; Fri, 15 Sep 2023 16:14:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9D8A170E4
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 16:14:27 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B96EC949A01
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 16:14:27 +0000 (UTC)
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com
 [209.85.166.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-hAtkjTtjOCipAF3-y-49wQ-1; Fri, 15 Sep 2023 12:14:26 -0400
X-MC-Unique: hAtkjTtjOCipAF3-y-49wQ-1
Received: by mail-il1-f182.google.com with SMTP id
 e9e14a558f8ab-34f69780037so2193415ab.1
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 09:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694794465; x=1695399265;
 h=content-transfer-encoding:in-reply-to:references:to:from
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=fEO9Acq2FuoJ6qxT/y6x6s7adS2i8VzzC4Qnhu1RjYs=;
 b=Ye6/5vDn7CjFgQhGOnCmdvomL+sJprZD8zCF4T4u5Vbjm6U75kiPG/rZsNCxQYeX1W
 0EMgsTdzDPYdNHs+RkPzSDXIeJKnmDXCBU9oC8bqPgUoCxE/knXkLz9a1dM9BjNQsyjl
 pViwypWLF+2KZIKorIO0TCmyqs1eXMKTk37oXSLdBGcnTxENBmZSwb6S8yj+TByc0GBE
 yJObLjtL3VmzkCTrlYLPz/0v2SW44Ep4PzHCkrmAuak3ils/j/thOeCJDSnucS7r34QE
 5KcQlD/6XpgjftVKitHrCI99Ta61GmAj1nHi6o7KTJIPlSiK5ms0UTR31vsM+SfMhPq9
 a/9w==
X-Gm-Message-State: AOJu0YxxkDRv+9wS3PjpNOThctjGj4XgrEY2W6uwdq1FBrNyQM1jEl7y
 fyY/q1l08fR9Og8OcpApr93bgOOqceaBu76l8DTihA==
X-Google-Smtp-Source: AGHT+IEmDbybVTu19sp+GwlDQHeaVcN+QEEBVpNS9xuNe2Z67u1Tjei0wcsFx/9mebXO7L2871yxjA==
X-Received: by 2002:a92:d74f:0:b0:34f:a4f0:4fc4 with SMTP id
 e15-20020a92d74f000000b0034fa4f04fc4mr2462610ilq.2.1694794464767; 
 Fri, 15 Sep 2023 09:14:24 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 b4-20020a920b04000000b003459023deaasm1203235ilf.30.2023.09.15.09.14.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 Sep 2023 09:14:24 -0700 (PDT)
Message-ID: <514767b4-5b2a-4f8e-a6ba-6722ddac5330@kernel.dk>
Date: Fri, 15 Sep 2023 10:14:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@redhat.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <4f5737f0-9299-4968-8cb5-07c7645bbffd@kernel.dk>
In-Reply-To: <4f5737f0-9299-4968-8cb5-07c7645bbffd@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] DM brokeness with NOWAIT
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/15/23 10:04 AM, Jens Axboe wrote:
> Hi,
> 
> Threw some db traffic into my testing mix, and that ended in tears
> very quickly:
> 
> CPU: 7 PID: 49609 Comm: ringbuf-read.t Tainted: G        W          6.6.0-rc1-g39956d2dcd81 #129
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x11d/0x1b0
>  __might_resched+0x3c3/0x5e0
>  ? preempt_count_sub+0x150/0x150
>  mempool_alloc+0x1e2/0x390
>  ? sanity_check_pinned_pages+0x23/0x1010
>  ? mempool_resize+0x7d0/0x7d0
>  bio_alloc_bioset+0x417/0x8c0
>  ? bvec_alloc+0x200/0x200
>  ? __gup_device_huge+0x900/0x900
>  bio_alloc_clone+0x53/0x100
>  dm_submit_bio+0x27f/0x1a20
>  ? lock_release+0x4b7/0x670
>  ? pin_user_pages_fast+0xb6/0xf0
>  ? blk_try_enter_queue+0x1a0/0x4d0
>  ? dm_dax_direct_access+0x260/0x260
>  ? rcu_is_watching+0x12/0xb0
>  ? blk_try_enter_queue+0x1cc/0x4d0
>  __submit_bio+0x239/0x310
>  ? __bio_queue_enter+0x700/0x700
>  ? kvm_clock_get_cycles+0x40/0x60
>  ? ktime_get+0x285/0x470
>  submit_bio_noacct_nocheck+0x4d9/0xb80
>  ? should_fail_request+0x80/0x80
>  ? preempt_count_sub+0x150/0x150
>  ? folio_flags+0x6c/0x1e0
>  submit_bio_noacct+0x53e/0x1b30
>  blkdev_direct_IO.part.0+0x833/0x1810
>  ? rcu_is_watching+0x12/0xb0
>  ? lock_release+0x4b7/0x670
>  ? blkdev_read_iter+0x40d/0x530
>  ? reacquire_held_locks+0x4e0/0x4e0
>  ? __blkdev_direct_IO_simple+0x780/0x780
>  ? rcu_is_watching+0x12/0xb0
>  ? __mark_inode_dirty+0x297/0xd50
>  ? preempt_count_add+0x72/0x140
>  blkdev_read_iter+0x2a4/0x530
>  ? blkdev_write_iter+0xc40/0xc40
>  io_read+0x369/0x1490
>  ? rcu_is_watching+0x12/0xb0
>  ? io_writev_prep_async+0x260/0x260
>  ? __fget_files+0x279/0x410
>  ? rcu_is_watching+0x12/0xb0
>  io_issue_sqe+0x18a/0xd90
>  io_submit_sqes+0x970/0x1ed0
>  __do_sys_io_uring_enter+0x14d4/0x2650
>  ? io_submit_sqes+0x1ed0/0x1ed0
>  ? rcu_is_watching+0x12/0xb0
>  ? __do_sys_io_uring_register+0x3f6/0x2190
>  ? io_req_caches_free+0x500/0x500
>  ? ksys_mmap_pgoff+0x85/0x5b0
>  ? rcu_is_watching+0x12/0xb0
>  ? trace_irq_enable.constprop.0+0xd0/0x100
>  do_syscall_64+0x39/0xb0
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> which seems to demonstrate a misunderstanding on what REQ_NOWAIT is
> about. In particulary, it seems to assume you can then submit with
> atomic context? DM does an rcu_read_lock() and happily proceeds to
> attempt to submit IO under RCU being disabled.

Did a quick check to see where this came from, and it got added with:

commit 563a225c9fd207326c2a2af9d59b4097cb31ce70
Author: Mike Snitzer <snitzer@kernel.org>
Date:   Sat Mar 26 21:08:36 2022 -0400

    dm: introduce dm_{get,put}_live_table_bio called from dm_submit_bio

which conspiciously doesn't include any numbers on why this is necessary
or a good thing, and notably probably wasn't tested? This landed in 5.19
fwiw.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

