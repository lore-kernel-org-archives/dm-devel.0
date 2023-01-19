Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0182C00A5A
	for <dm-devel@archiver.kernel.org>; Thu, 19 Jan 2023 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674121019;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=S9Qek0FmDUX5gzcBKUDYbQZcJyvXG20qGR/ssoKqp/g=;
	b=FNEBq4iRNnw5oW7mvA1nRxYF55+1n7uxOYSGbQO7eFwX0YD2pL22+0EsM3U1zLpAtwhqMe
	hc3wVJrHeCV6a8jKQRj5R31Q91WfvNK+c5ZBlGksFsc2g6e5O6mjlCLORIToL5dqWFfRJ1
	B1a3DavYj2uLICkpnwdC/letjsFTH1s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-a4y_69E6MJCVTs5_yw5e_g-1; Thu, 19 Jan 2023 04:36:56 -0500
X-MC-Unique: a4y_69E6MJCVTs5_yw5e_g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 303B7858F09;
	Thu, 19 Jan 2023 09:36:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B4796492C14;
	Thu, 19 Jan 2023 09:36:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 67A6C1946A6E;
	Thu, 19 Jan 2023 09:36:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4FE951946A6D
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 Jan 2023 09:36:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 24AC52166B2B; Thu, 19 Jan 2023 09:36:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D8092166B2A
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 09:36:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E898E882820
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 09:36:51 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-225-ChcW9X4PNZq1KL5pVnvMzw-1; Thu, 19 Jan 2023 04:36:48 -0500
X-MC-Unique: ChcW9X4PNZq1KL5pVnvMzw-1
Received: by mail-wm1-f48.google.com with SMTP id
 o17-20020a05600c511100b003db021ef437so782000wms.4
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 01:36:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=cEjhXsonR/zM+QRi2K93rKXiZIdp3YLfpvKpGcSFfA4=;
 b=otfqXFl75ckXgeef+YrnaOhwC9cjSwjf5qxyyBe7kkLpMC8uMwHRHS7KO58R+UpYgh
 LRexkmkmm4kivSEDjgDK8hDkQ5fBG2icjKq0Ns5AH97ymV6bhH/2UCQrED1BsZwA70Ho
 uxUyq5aTun9EBzMODn/GciDKHT5eYVbsQm79olCiKJ06Y+PeTnBI/ZEakOSS/IH3Hc5Q
 XuOpgeQBbyd0qx0BSG19F2X9a5QF3z+yyV9cdG9Pxiul5fUr0QdiBbfr+SXbUxKhLx5R
 BNBX+z+WxuyHp5RwRZfld6QSArWpIewZVDCs3tn5AEW0NjfxSd7RanZhNz6Uk20EBbTv
 IAkA==
X-Gm-Message-State: AFqh2kodoOoeypo9duAbQv8QwsZfzCVWdp4NwORloAJo7s3tB5ZKYQhl
 wfKVcBomKKiaF9ZPugb/+YyV9g==
X-Google-Smtp-Source: AMrXdXtPRb4Dn13xXvT9vbYxYWS23eyMwfrS86+yRgN1JgechHzzoTslOFjtWa5QQuB3Fc6ze/SvgA==
X-Received: by 2002:a05:600c:1e87:b0:3cf:69f4:bfd4 with SMTP id
 be7-20020a05600c1e8700b003cf69f4bfd4mr5701798wmb.7.1674121006551; 
 Thu, 19 Jan 2023 01:36:46 -0800 (PST)
Received: from [10.94.1.166] ([185.109.18.135])
 by smtp.gmail.com with ESMTPSA id
 k14-20020a05600c1c8e00b003d9ed40a512sm5981230wms.45.2023.01.19.01.36.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Jan 2023 01:36:45 -0800 (PST)
Message-ID: <2f53c4ee-5bdf-e4e4-2dca-46ae4e22c312@arrikto.com>
Date: Thu, 19 Jan 2023 11:36:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Mike Snitzer <snitzer@redhat.com>
References: <20230118122946.20435-1-ntsironis@arrikto.com>
 <Y8geIzYJ4dCeXpEI@redhat.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <Y8geIzYJ4dCeXpEI@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 1/18/23 18:28, Mike Snitzer wrote:
> On Wed, Jan 18 2023 at  7:29P -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
>> Under certain conditions, swapping a table, that includes a dm-era
>> target, with a new table, causes a deadlock.
>>
>> This happens when a status (STATUSTYPE_INFO) or message IOCTL is blocked
>> in the suspended dm-era target.
>>
>> dm-era executes all metadata operations in a worker thread, which stops
>> processing requests when the target is suspended, and resumes again when
>> the target is resumed.
>>
>> So, running 'dmsetup status' or 'dmsetup message' for a suspended dm-era
>> device blocks, until the device is resumed.
>>
>> If we then load a new table to the device, while the aforementioned
>> dmsetup command is blocked in dm-era, and resume the device, we
>> deadlock.
>>
>> The problem is that the 'dmsetup status' and 'dmsetup message' commands
>> hold a reference to the live table, i.e., they hold an SRCU read lock on
>> md->io_barrier, while they are blocked.
>>
>> When the device is resumed, the old table is replaced with the new one
>> by dm_swap_table(), which ends up calling synchronize_srcu() on
>> md->io_barrier.
>>
>> Since the blocked dmsetup command is holding the SRCU read lock, and the
>> old table is never resumed, 'dmsetup resume' blocks too, and we have a
>> deadlock.
>>
>> The only way to recover is by rebooting.
>>
>> Steps to reproduce:
>>
>> 1. Create device with dm-era target
>>
>>      # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"
>>
>> 2. Suspend the device
>>
>>      # dmsetup suspend eradev
>>
>> 3. Load new table to device, e.g., to resize the device. Note, that, we
>>     must load the new table _after_ suspending the device to ensure the
>>     constructor of the new target instance reads up-to-date metadata, as
>>     committed by the post-suspend hook of dm-era.
>>
>>      # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"
>>
>> 4. Device now has LIVE and INACTIVE tables
>>
>>      # dmsetup info eradev
>>      Name:              eradev
>>      State:             SUSPENDED
>>      Read Ahead:        16384
>>      Tables present:    LIVE & INACTIVE
>>      Open count:        0
>>      Event number:      0
>>      Major, minor:      252, 2
>>      Number of targets: 1
>>
>> 5. Retrieve the status of the device. This blocks because the device is
>>     suspended. Equivalently, any 'dmsetup message' operation would block
>>     too. This command holds the SRCU read lock on md->io_barrier.
>>
>>      # dmsetup status eradev
> 
> I'll have a look at this flow, it seems to me we shouldn't stack up
> 'dmsetup status' and 'dmsetup message' commands if the table is
> suspended.
> 
> I think it is unique to dm-era that you don't allow to _read_ metadata
> operations while a device is suspended.  But messages really shouldn't
> be sent when the device is suspended.  As-is DM is pretty silently
> cutthroat about that constraint.
> 
> Resulting in deadlock is obviously cutthroat...
> 

Hi Mike,

Thanks for the quick reply.

I couldn't find this constraint documented anywhere and since the
various DM targets seem to allow message operations while the device is
suspended I drew the wrong conclusion.

Thanks for clarifying this.

>> 6. Resume the device. The resume operation tries to swap the old table
>>     with the new one and deadlocks, because it synchronizes SRCU for the
>>     old table, while the blocked 'dmsetup status' holds the SRCU read
>>     lock. And the old table is never resumed again at this point.
>>
>>      # dmsetup resume eradev
>>
>> 7. The relevant dmesg logs are:
>>
>> [ 7093.345486] dm-2: detected capacity change from 1048576 to 2097152
>> [ 7250.875665] INFO: task dmsetup:1986 blocked for more than 120 seconds.
>> [ 7250.875722]       Not tainted 5.16.0-rc2-release+ #16
>> [ 7250.875756] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 7250.875803] task:dmsetup         state:D stack:    0 pid: 1986 ppid:  1313 flags:0x00000000
>> [ 7250.875809] Call Trace:
>> [ 7250.875812]  <TASK>
>> [ 7250.875816]  __schedule+0x330/0x8b0
>> [ 7250.875827]  schedule+0x4e/0xc0
>> [ 7250.875831]  schedule_timeout+0x20f/0x2e0
>> [ 7250.875836]  ? do_set_pte+0xb8/0x120
>> [ 7250.875843]  ? prep_new_page+0x91/0xa0
>> [ 7250.875847]  wait_for_completion+0x8c/0xf0
>> [ 7250.875854]  perform_rpc+0x95/0xb0 [dm_era]
>> [ 7250.875862]  in_worker1.constprop.20+0x48/0x70 [dm_era]
>> [ 7250.875867]  ? era_iterate_devices+0x30/0x30 [dm_era]
>> [ 7250.875872]  ? era_status+0x64/0x1e0 [dm_era]
>> [ 7250.875877]  era_status+0x64/0x1e0 [dm_era]
>> [ 7250.875882]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
>> [ 7250.875900]  ? __mod_node_page_state+0x82/0xc0
>> [ 7250.875909]  retrieve_status+0xbc/0x1e0 [dm_mod]
>> [ 7250.875921]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
>> [ 7250.875932]  table_status+0x61/0xa0 [dm_mod]
>> [ 7250.875942]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
>> [ 7250.875956]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
>> [ 7250.875966]  __x64_sys_ioctl+0x8e/0xd0
>> [ 7250.875970]  do_syscall_64+0x3a/0xd0
>> [ 7250.875974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [ 7250.875980] RIP: 0033:0x7f20b7cd4017
>> [ 7250.875984] RSP: 002b:00007ffd443874b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> [ 7250.875988] RAX: ffffffffffffffda RBX: 000055d69d6bd0e0 RCX: 00007f20b7cd4017
>> [ 7250.875991] RDX: 000055d69d6bd0e0 RSI: 00000000c138fd0c RDI: 0000000000000003
>> [ 7250.875993] RBP: 000000000000001e R08: 00007f20b81df648 R09: 00007ffd44387320
>> [ 7250.875996] R10: 00007f20b81deb53 R11: 0000000000000246 R12: 000055d69d6bd110
>> [ 7250.875998] R13: 00007f20b81deb53 R14: 000055d69d6bd000 R15: 0000000000000000
>> [ 7250.876002]  </TASK>
>> [ 7250.876004] INFO: task dmsetup:1987 blocked for more than 120 seconds.
>> [ 7250.876046]       Not tainted 5.16.0-rc2-release+ #16
>> [ 7250.876083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 7250.876129] task:dmsetup         state:D stack:    0 pid: 1987 ppid:  1385 flags:0x00000000
>> [ 7250.876134] Call Trace:
>> [ 7250.876136]  <TASK>
>> [ 7250.876138]  __schedule+0x330/0x8b0
>> [ 7250.876142]  schedule+0x4e/0xc0
>> [ 7250.876145]  schedule_timeout+0x20f/0x2e0
>> [ 7250.876149]  ? __queue_work+0x226/0x420
>> [ 7250.876156]  wait_for_completion+0x8c/0xf0
>> [ 7250.876160]  __synchronize_srcu.part.19+0x92/0xc0
>> [ 7250.876167]  ? __bpf_trace_rcu_stall_warning+0x10/0x10
>> [ 7250.876173]  ? dm_swap_table+0x2f4/0x310 [dm_mod]
>> [ 7250.876185]  dm_swap_table+0x2f4/0x310 [dm_mod]
>> [ 7250.876198]  ? table_load+0x360/0x360 [dm_mod]
>> [ 7250.876207]  dev_suspend+0x95/0x250 [dm_mod]
>> [ 7250.876217]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
>> [ 7250.876231]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
>> [ 7250.876240]  __x64_sys_ioctl+0x8e/0xd0
>> [ 7250.876244]  do_syscall_64+0x3a/0xd0
>> [ 7250.876247]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [ 7250.876252] RIP: 0033:0x7f15e9254017
>> [ 7250.876254] RSP: 002b:00007ffffdc59458 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> [ 7250.876257] RAX: ffffffffffffffda RBX: 000055d4d99560e0 RCX: 00007f15e9254017
>> [ 7250.876260] RDX: 000055d4d99560e0 RSI: 00000000c138fd06 RDI: 0000000000000003
>> [ 7250.876261] RBP: 000000000000000f R08: 00007f15e975f648 R09: 00007ffffdc592c0
>> [ 7250.876263] R10: 00007f15e975eb53 R11: 0000000000000246 R12: 000055d4d9956110
>> [ 7250.876265] R13: 00007f15e975eb53 R14: 000055d4d9956000 R15: 0000000000000001
>> [ 7250.876269]  </TASK>
>>
>> Fix this by allowing metadata operations triggered by user space to run
>> in the corresponding user space thread, instead of queueing them for
>> execution by the dm-era worker thread.
> 
> Allowing them to run while the device is suspended is _not_ the
> correct way to work-around this deadlock situation.  I think it'd be
> useful to understand why your userspace is tools are allowing these
> messages and status to a device that is suspended.
> 

Ack.

The sequence of operations I provided is just a way to easily reproduce
the deadlock. The exact issue I am facing is the following:

1. Create device with dm-era target

     # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"

2. Load new table to device, e.g., to resize the device or snapshot it.

     # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"

3. Suspend the device

     # dmsetup suspend eradev

4. Someone else, e.g., a user or a monitoring daemon, runs an LVM
    command at this point, e.g. 'vgs'.

5. 'vgs' tries to retrieve the status of the dm-era device using the
    DM_TABLE_STATUS ioctl, and blocks, because the command is queued for
    execution by the worker thread, which is suspended while the device
    is suspended.

    Note, that, LVM uses the DM_NOFLUSH_FLAG, but this doesn't make a
    difference for dm-era, since the "problem" is not that it writes to
    the metadata, but that it queues the metadata read operation to the
    worker thread.

6. Resume the device: This deadlocks.

     # dmsetup resume eradev

So, I am not the one retrieving the status of the suspended device. LVM
is. LVM, when running commands like 'lvs' and 'vgs', retrieves the
status of the devices on the system using the DM_TABLE_STATUS ioctl.

The deadlock is a race that happens when someone runs an LVM command at
the "wrong" time.

Using an appropriate LVM 'global_filter' is a way to prevent this, but:

1. This is just a workaround, not a proper solution.
2. This is not always an option. Imagine someone running an LVM command
    in a container, for example. Or, we may not be allowed to change the
    LVM configuration of the host at all.

> FYI, status shouldn't trigger write IOs if the device is suspended.
> Both dm-cache and dm-thin have this in status as a guard around its
> work to ensure updated accounting (as a side-effect of committing
> metadata), e.g.:
> 
>                  /* Commit to ensure statistics aren't out-of-date */
>                  if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti))
>                          (void) commit(cache, false);
>   

Ack. The current behavior of dm-era wrt 'status' command is:

1. Queue the 'metadata_get_stats()' function for execution by the worker
    thread.
2. The worker runs the function and retrieves the statistics
3. The worker commits the metadata _after_ retrieving the statistics

Shall I just change 'era_status()' to read the metadata directly and
skip the metadata commit, instead of queuing the operation to the worker
thread, when the device is suspended?

I think we would still need a lock to synchronize access to the
metadata, since, if I am not mistaken, the pre-resume hook that starts
the worker runs before clearing the DMF_SUSPENDED flag, and can run
concurrently with the 'status' IOCTL. So, the worker might run
concurrently with a 'status' operation that sees the device as
suspended.

Nikos.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

