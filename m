Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C73EC32793
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674059312;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6C4sW0Cjfds438kirmYV5a9hu6QZH6tDRGy+z1bvPn8=;
	b=bpQMEV9PHziMBCCJE54kTH/VKBAT14T1h+TEe7fDZNuWqnlc2iFRcffYkwBtr7FlWKATfF
	n4ckmm0PZgS/61/WepVE8uBPI/OYDyi27Ls1VIHz/GxZZMnN/edfoxnwg5EQ02lqwAleyR
	Ct0er9cBp5amsdFMtfyCj1GtX8As0Vk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-tIpWrC_kM3STC7es80WACw-1; Wed, 18 Jan 2023 11:28:29 -0500
X-MC-Unique: tIpWrC_kM3STC7es80WACw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C4CA100F90F;
	Wed, 18 Jan 2023 16:28:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E725940C6EC4;
	Wed, 18 Jan 2023 16:28:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A00FA1946A6B;
	Wed, 18 Jan 2023 16:28:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F0AE31946A45
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Jan 2023 16:28:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CED2C40C2004; Wed, 18 Jan 2023 16:28:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C688140C2064
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 16:28:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C411C0879C
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 16:28:24 +0000 (UTC)
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-dFuefas_M8-GH6taGIGESg-1; Wed, 18 Jan 2023 11:28:23 -0500
X-MC-Unique: dFuefas_M8-GH6taGIGESg-1
Received: by mail-vk1-f199.google.com with SMTP id
 n131-20020a1f2789000000b003d93a6e6162so10481446vkn.21
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 08:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=uWaUu0jqwiMlv4ZeZDdm6Vl4uyNfh6w+M6AJoJOESgo=;
 b=xT+Akrd9iL8xX5RBET/pQpNHnk3u54wzjUuzon/EqJdnXXqGFEEw+7pNGOr2C0Raqo
 mRF+RhQUONUKG+WsndecVT9Kvl/Zu3jlwBNUBdz6BWI0Yuxy8VgtcNZnE+ciN1fkRg4P
 UZVaNJ/rItX7GVQY6JXcMxpxJGddQQYxBO5fBLG7klbBE/2e00hfj8Im3yVtGohseduq
 ZHaFsxnrqoIp1JvGetQGSjjBL0oDwy1T9jrC+dGiBPr+7zIbdiy02S6AoWSSHFbJrTLb
 s6Bs8V2MGlRd0a7RVf17TpmuITAeaWwynixxe6NrJTMeHGjUpcGip4TFO7daaZ3rKRcO
 FzCQ==
X-Gm-Message-State: AFqh2krjMJwXGgHtlJViAOxnK2EMuRnqrbZo5cUzKmYAuTX2AY3K3cvP
 3wnVO5SLPOJoaKFkinAHMD2qYl4MQqj2Ryxiq6ANe2IjL3pM09ETPMFGGPtH3aNKNX/Eqx6imrW
 3nWZYPt2O3pld7A==
X-Received: by 2002:a1f:2188:0:b0:3d5:9f06:3321 with SMTP id
 h130-20020a1f2188000000b003d59f063321mr4330015vkh.15.1674059301954; 
 Wed, 18 Jan 2023 08:28:21 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtkn0ukRvWuOuJNVYOhRYhKW0kNtvN0suCLOcgtq4eHbcoOMSblM6yl2xqMJNg6j9XBjJEL3g==
X-Received: by 2002:a1f:2188:0:b0:3d5:9f06:3321 with SMTP id
 h130-20020a1f2188000000b003d59f063321mr4329990vkh.15.1674059301607; 
 Wed, 18 Jan 2023 08:28:21 -0800 (PST)
Received: from localhost (pool-68-160-145-102.bstnma.fios.verizon.net.
 [68.160.145.102]) by smtp.gmail.com with ESMTPSA id
 w6-20020a05620a444600b00706719da000sm6078220qkp.103.2023.01.18.08.28.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Jan 2023 08:28:21 -0800 (PST)
Date: Wed, 18 Jan 2023 11:28:19 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <Y8geIzYJ4dCeXpEI@redhat.com>
References: <20230118122946.20435-1-ntsironis@arrikto.com>
MIME-Version: 1.0
In-Reply-To: <20230118122946.20435-1-ntsironis@arrikto.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 0/2] dm era: avoid deadlock when swapping
 table with dm-era target
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
Cc: dm-devel@redhat.com, snitzer@kernel.org, ejt@redhat.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 18 2023 at  7:29P -0500,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Under certain conditions, swapping a table, that includes a dm-era
> target, with a new table, causes a deadlock.
> 
> This happens when a status (STATUSTYPE_INFO) or message IOCTL is blocked
> in the suspended dm-era target.
> 
> dm-era executes all metadata operations in a worker thread, which stops
> processing requests when the target is suspended, and resumes again when
> the target is resumed.
> 
> So, running 'dmsetup status' or 'dmsetup message' for a suspended dm-era
> device blocks, until the device is resumed.
> 
> If we then load a new table to the device, while the aforementioned
> dmsetup command is blocked in dm-era, and resume the device, we
> deadlock.
> 
> The problem is that the 'dmsetup status' and 'dmsetup message' commands
> hold a reference to the live table, i.e., they hold an SRCU read lock on
> md->io_barrier, while they are blocked.
> 
> When the device is resumed, the old table is replaced with the new one
> by dm_swap_table(), which ends up calling synchronize_srcu() on
> md->io_barrier.
> 
> Since the blocked dmsetup command is holding the SRCU read lock, and the
> old table is never resumed, 'dmsetup resume' blocks too, and we have a
> deadlock.
> 
> The only way to recover is by rebooting.
> 
> Steps to reproduce:
> 
> 1. Create device with dm-era target
> 
>     # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"
> 
> 2. Suspend the device
> 
>     # dmsetup suspend eradev
> 
> 3. Load new table to device, e.g., to resize the device. Note, that, we
>    must load the new table _after_ suspending the device to ensure the
>    constructor of the new target instance reads up-to-date metadata, as
>    committed by the post-suspend hook of dm-era.
> 
>     # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"
> 
> 4. Device now has LIVE and INACTIVE tables
> 
>     # dmsetup info eradev
>     Name:              eradev
>     State:             SUSPENDED
>     Read Ahead:        16384
>     Tables present:    LIVE & INACTIVE
>     Open count:        0
>     Event number:      0
>     Major, minor:      252, 2
>     Number of targets: 1
> 
> 5. Retrieve the status of the device. This blocks because the device is
>    suspended. Equivalently, any 'dmsetup message' operation would block
>    too. This command holds the SRCU read lock on md->io_barrier.
> 
>     # dmsetup status eradev

I'll have a look at this flow, it seems to me we shouldn't stack up
'dmsetup status' and 'dmsetup message' commands if the table is
suspended.

I think it is unique to dm-era that you don't allow to _read_ metadata
operations while a device is suspended.  But messages really shouldn't
be sent when the device is suspended.  As-is DM is pretty silently
cutthroat about that constraint.

Resulting in deadlock is obviously cutthroat...

> 6. Resume the device. The resume operation tries to swap the old table
>    with the new one and deadlocks, because it synchronizes SRCU for the
>    old table, while the blocked 'dmsetup status' holds the SRCU read
>    lock. And the old table is never resumed again at this point.
> 
>     # dmsetup resume eradev
> 
> 7. The relevant dmesg logs are:
> 
> [ 7093.345486] dm-2: detected capacity change from 1048576 to 2097152
> [ 7250.875665] INFO: task dmsetup:1986 blocked for more than 120 seconds.
> [ 7250.875722]       Not tainted 5.16.0-rc2-release+ #16
> [ 7250.875756] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7250.875803] task:dmsetup         state:D stack:    0 pid: 1986 ppid:  1313 flags:0x00000000
> [ 7250.875809] Call Trace:
> [ 7250.875812]  <TASK>
> [ 7250.875816]  __schedule+0x330/0x8b0
> [ 7250.875827]  schedule+0x4e/0xc0
> [ 7250.875831]  schedule_timeout+0x20f/0x2e0
> [ 7250.875836]  ? do_set_pte+0xb8/0x120
> [ 7250.875843]  ? prep_new_page+0x91/0xa0
> [ 7250.875847]  wait_for_completion+0x8c/0xf0
> [ 7250.875854]  perform_rpc+0x95/0xb0 [dm_era]
> [ 7250.875862]  in_worker1.constprop.20+0x48/0x70 [dm_era]
> [ 7250.875867]  ? era_iterate_devices+0x30/0x30 [dm_era]
> [ 7250.875872]  ? era_status+0x64/0x1e0 [dm_era]
> [ 7250.875877]  era_status+0x64/0x1e0 [dm_era]
> [ 7250.875882]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
> [ 7250.875900]  ? __mod_node_page_state+0x82/0xc0
> [ 7250.875909]  retrieve_status+0xbc/0x1e0 [dm_mod]
> [ 7250.875921]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
> [ 7250.875932]  table_status+0x61/0xa0 [dm_mod]
> [ 7250.875942]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
> [ 7250.875956]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
> [ 7250.875966]  __x64_sys_ioctl+0x8e/0xd0
> [ 7250.875970]  do_syscall_64+0x3a/0xd0
> [ 7250.875974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 7250.875980] RIP: 0033:0x7f20b7cd4017
> [ 7250.875984] RSP: 002b:00007ffd443874b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [ 7250.875988] RAX: ffffffffffffffda RBX: 000055d69d6bd0e0 RCX: 00007f20b7cd4017
> [ 7250.875991] RDX: 000055d69d6bd0e0 RSI: 00000000c138fd0c RDI: 0000000000000003
> [ 7250.875993] RBP: 000000000000001e R08: 00007f20b81df648 R09: 00007ffd44387320
> [ 7250.875996] R10: 00007f20b81deb53 R11: 0000000000000246 R12: 000055d69d6bd110
> [ 7250.875998] R13: 00007f20b81deb53 R14: 000055d69d6bd000 R15: 0000000000000000
> [ 7250.876002]  </TASK>
> [ 7250.876004] INFO: task dmsetup:1987 blocked for more than 120 seconds.
> [ 7250.876046]       Not tainted 5.16.0-rc2-release+ #16
> [ 7250.876083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 7250.876129] task:dmsetup         state:D stack:    0 pid: 1987 ppid:  1385 flags:0x00000000
> [ 7250.876134] Call Trace:
> [ 7250.876136]  <TASK>
> [ 7250.876138]  __schedule+0x330/0x8b0
> [ 7250.876142]  schedule+0x4e/0xc0
> [ 7250.876145]  schedule_timeout+0x20f/0x2e0
> [ 7250.876149]  ? __queue_work+0x226/0x420
> [ 7250.876156]  wait_for_completion+0x8c/0xf0
> [ 7250.876160]  __synchronize_srcu.part.19+0x92/0xc0
> [ 7250.876167]  ? __bpf_trace_rcu_stall_warning+0x10/0x10
> [ 7250.876173]  ? dm_swap_table+0x2f4/0x310 [dm_mod]
> [ 7250.876185]  dm_swap_table+0x2f4/0x310 [dm_mod]
> [ 7250.876198]  ? table_load+0x360/0x360 [dm_mod]
> [ 7250.876207]  dev_suspend+0x95/0x250 [dm_mod]
> [ 7250.876217]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
> [ 7250.876231]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
> [ 7250.876240]  __x64_sys_ioctl+0x8e/0xd0
> [ 7250.876244]  do_syscall_64+0x3a/0xd0
> [ 7250.876247]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 7250.876252] RIP: 0033:0x7f15e9254017
> [ 7250.876254] RSP: 002b:00007ffffdc59458 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [ 7250.876257] RAX: ffffffffffffffda RBX: 000055d4d99560e0 RCX: 00007f15e9254017
> [ 7250.876260] RDX: 000055d4d99560e0 RSI: 00000000c138fd06 RDI: 0000000000000003
> [ 7250.876261] RBP: 000000000000000f R08: 00007f15e975f648 R09: 00007ffffdc592c0
> [ 7250.876263] R10: 00007f15e975eb53 R11: 0000000000000246 R12: 000055d4d9956110
> [ 7250.876265] R13: 00007f15e975eb53 R14: 000055d4d9956000 R15: 0000000000000001
> [ 7250.876269]  </TASK>
> 
> Fix this by allowing metadata operations triggered by user space to run
> in the corresponding user space thread, instead of queueing them for
> execution by the dm-era worker thread.

Allowing them to run while the device is suspended is _not_ the
correct way to work-around this deadlock situation.  I think it'd be
useful to understand why your userspace is tools are allowing these
messages and status to a device that is suspended.

FYI, status shouldn't trigger write IOs if the device is suspended.
Both dm-cache and dm-thin have this in status as a guard around its
work to ensure updated accounting (as a side-effect of committing
metadata), e.g.:

                /* Commit to ensure statistics aren't out-of-date */
                if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti))
                        (void) commit(cache, false);
 
> This way, even if the device is suspended, the metadata operations will
> run and release the SRCU read lock, preventing a subsequent table reload
> (dm_swap_table()) from deadlocking.
> 
> To make this possible use a mutex to serialize access to the metadata
> between the worker thread and the user space threads.
> 
> This is a follow up on https://listman.redhat.com/archives/dm-devel/2021-December/msg00044.html.
> 
> Nikos Tsironis (2):
>   dm era: allocate in-core writesets when loading metadata
>   dm era: avoid deadlock when swapping table
> 
>  drivers/md/dm-era-target.c | 78 ++++++++++++++++++++++++++++++--------
>  1 file changed, 63 insertions(+), 15 deletions(-)
> 
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

