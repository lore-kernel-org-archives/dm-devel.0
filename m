Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23672C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:07:58 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-IKX7ssiHNO2vY-b3-TiTpQ-1; Wed, 01 Dec 2021 12:07:53 -0500
X-MC-Unique: IKX7ssiHNO2vY-b3-TiTpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA4471853024;
	Wed,  1 Dec 2021 17:07:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DB3A10013D6;
	Wed,  1 Dec 2021 17:07:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E497B4BB7C;
	Wed,  1 Dec 2021 17:07:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1H7iG7018496 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 12:07:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 99BE84010E70; Wed,  1 Dec 2021 17:07:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94B6340CFD0E
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 17:07:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 776208027FB
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 17:07:44 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
	[209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-567-iTfEpq-5NDq_3e3lgsDVIA-1; Wed, 01 Dec 2021 12:07:42 -0500
X-MC-Unique: iTfEpq-5NDq_3e3lgsDVIA-1
Received: by mail-wm1-f47.google.com with SMTP id
	o19-20020a1c7513000000b0033a93202467so1675740wmc.2
	for <dm-devel@redhat.com>; Wed, 01 Dec 2021 09:07:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
	:mime-version:content-language:content-transfer-encoding;
	bh=hghqSMgZQ1oL7xflqeizAh1KzCiPuU5U/cSoMYYRaH0=;
	b=CahpHRZi6Cr0GSmf8E8EdQJfiK0WR+miot7gbtAuz3xtkrAbciQAmMqdbZjbl0Ytmb
	KIkEStKHviQ41+ZBH8RLvxJa+JjXrgZaosvwfTiGWupbNC0Qp3fvbGrPRXi1R/1NSP9c
	Kh5IvI8MJ4E1BvFOHQbe1090vaAVK0h81Pqbtw+P5ywpX1xdS3MNprjGBOfk4qF6Trlc
	1UEAFC4iUbRlOHPVm2zLAk5SeDJ9ds9USiaU8mXmcndddVc3qPYh3TUgnUT9NNGRTzPz
	h/W9ZpFqsfB/2BhXs48bBbfYjYCc2hxtVInqitrtDnqhiZy6zMZATnIxT6myNcEgtbw9
	2TZA==
X-Gm-Message-State: AOAM530ymbB3lZ1hyCKvEdvVXnkBppi6UVz+kt6JWZEDnZb9OLrR/rRk
	KPgB4boU9LTmDEcNWl3gUhNlDw==
X-Google-Smtp-Source: ABdhPJzrA3krDiBV7yqSpcHaoHTaCdDhAEmvI1yOAzl1azvACeEEOjzPe77+olPe3uoSULT3AGpjDg==
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr8573739wmb.174.1638378461141; 
	Wed, 01 Dec 2021 09:07:41 -0800 (PST)
Received: from [172.16.10.100] (62.1.222.48.dsl.dyn.forthnet.gr. [62.1.222.48])
	by smtp.gmail.com with ESMTPSA id l5sm426020wrs.59.2021.12.01.09.07.39
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 01 Dec 2021 09:07:40 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Message-ID: <1127b165-f886-e3cf-061d-141fa7fb7d97@arrikto.com>
Date: Wed, 1 Dec 2021 19:07:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.14.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: ejt@redhat.com, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: [dm-devel] Deadlock when swapping a table with a dm-era target
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hello,

Under certain conditions, swapping a table, that includes a dm-era
target, with a new table, causes a deadlock.

This happens when a status (STATUSTYPE_INFO) or message IOCTL is blocked
in the suspended dm-era target.

dm-era executes all metadata operations in a worker thread, which stops
processing requests when the target is suspended, and resumes again when
the target is resumed.

So, running 'dmsetup status' or 'dmsetup message' for a suspended dm-era
device blocks, until the device is resumed.

This seems to be a problem on its own.

If we then load a new table to the device, while the aforementioned
dmsetup command is blocked in dm-era, and resume the device, we
deadlock.

The problem is that the 'dmsetup status' and 'dmsetup message' commands
hold a reference to the live table, i.e., they hold an SRCU read lock on
md->io_barrier, while they are blocked.

When the device is resumed, the old table is replaced with the new one
by dm_swap_table(), which ends up calling synchronize_srcu() on
md->io_barrier.

Since the blocked dmsetup command is holding the SRCU read lock, and the
old table is never resumed, 'dmsetup resume' blocks too, and we have a
deadlock.

Steps to reproduce:

1. Create device with dm-era target

    # dmsetup create eradev --table "0 1048576 era /dev/datavg/erameta /dev/datavg/eradata 8192"

2. Suspend the device

    # dmsetup suspend eradev

3. Load new table to device, e.g., to resize the device

    # dmsetup load eradev --table "0 2097152 era /dev/datavg/erameta /dev/datavg/eradata 8192"

4. Device now has LIVE and INACTIVE tables

    # dmsetup info eradev
    Name:              eradev
    State:             SUSPENDED
    Read Ahead:        16384
    Tables present:    LIVE & INACTIVE
    Open count:        0
    Event number:      0
    Major, minor:      252, 2
    Number of targets: 1

5. Retrieve the status of the device. This blocks because the device is
    suspended. Equivalently, any 'dmsetup message' operation would block
    too. This command holds the SRCU read lock.

    # dmsetup status eradev

6. Resume the device. The resume operation tries to swap the old table
    with the new one and deadlocks, because it synchronizes SRCU for the
    old table, while the blocked 'dmsetup status' holds the SRCU read
    lock. And the old table is never resumed again at this point.

    # dmsetup resume eradev

7. The relevant dmesg logs are:


[ 7093.345486] dm-2: detected capacity change from 1048576 to 2097152
[ 7250.875665] INFO: task dmsetup:1986 blocked for more than 120 seconds.
[ 7250.875722]       Not tainted 5.16.0-rc2-release+ #16
[ 7250.875756] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7250.875803] task:dmsetup         state:D stack:    0 pid: 1986 ppid:  1313 flags:0x00000000
[ 7250.875809] Call Trace:
[ 7250.875812]  <TASK>
[ 7250.875816]  __schedule+0x330/0x8b0
[ 7250.875827]  schedule+0x4e/0xc0
[ 7250.875831]  schedule_timeout+0x20f/0x2e0
[ 7250.875836]  ? do_set_pte+0xb8/0x120
[ 7250.875843]  ? prep_new_page+0x91/0xa0
[ 7250.875847]  wait_for_completion+0x8c/0xf0
[ 7250.875854]  perform_rpc+0x95/0xb0 [dm_era]
[ 7250.875862]  in_worker1.constprop.20+0x48/0x70 [dm_era]
[ 7250.875867]  ? era_iterate_devices+0x30/0x30 [dm_era]
[ 7250.875872]  ? era_status+0x64/0x1e0 [dm_era]
[ 7250.875877]  era_status+0x64/0x1e0 [dm_era]
[ 7250.875882]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
[ 7250.875900]  ? __mod_node_page_state+0x82/0xc0
[ 7250.875909]  retrieve_status+0xbc/0x1e0 [dm_mod]
[ 7250.875921]  ? dm_get_live_or_inactive_table.isra.11+0x20/0x20 [dm_mod]
[ 7250.875932]  table_status+0x61/0xa0 [dm_mod]
[ 7250.875942]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
[ 7250.875956]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
[ 7250.875966]  __x64_sys_ioctl+0x8e/0xd0
[ 7250.875970]  do_syscall_64+0x3a/0xd0
[ 7250.875974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 7250.875980] RIP: 0033:0x7f20b7cd4017
[ 7250.875984] RSP: 002b:00007ffd443874b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 7250.875988] RAX: ffffffffffffffda RBX: 000055d69d6bd0e0 RCX: 00007f20b7cd4017
[ 7250.875991] RDX: 000055d69d6bd0e0 RSI: 00000000c138fd0c RDI: 0000000000000003
[ 7250.875993] RBP: 000000000000001e R08: 00007f20b81df648 R09: 00007ffd44387320
[ 7250.875996] R10: 00007f20b81deb53 R11: 0000000000000246 R12: 000055d69d6bd110
[ 7250.875998] R13: 00007f20b81deb53 R14: 000055d69d6bd000 R15: 0000000000000000
[ 7250.876002]  </TASK>
[ 7250.876004] INFO: task dmsetup:1987 blocked for more than 120 seconds.
[ 7250.876046]       Not tainted 5.16.0-rc2-release+ #16
[ 7250.876083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7250.876129] task:dmsetup         state:D stack:    0 pid: 1987 ppid:  1385 flags:0x00000000
[ 7250.876134] Call Trace:
[ 7250.876136]  <TASK>
[ 7250.876138]  __schedule+0x330/0x8b0
[ 7250.876142]  schedule+0x4e/0xc0
[ 7250.876145]  schedule_timeout+0x20f/0x2e0
[ 7250.876149]  ? __queue_work+0x226/0x420
[ 7250.876156]  wait_for_completion+0x8c/0xf0
[ 7250.876160]  __synchronize_srcu.part.19+0x92/0xc0
[ 7250.876167]  ? __bpf_trace_rcu_stall_warning+0x10/0x10
[ 7250.876173]  ? dm_swap_table+0x2f4/0x310 [dm_mod]
[ 7250.876185]  dm_swap_table+0x2f4/0x310 [dm_mod]
[ 7250.876198]  ? table_load+0x360/0x360 [dm_mod]
[ 7250.876207]  dev_suspend+0x95/0x250 [dm_mod]
[ 7250.876217]  ctl_ioctl+0x1b5/0x4f0 [dm_mod]
[ 7250.876231]  dm_ctl_ioctl+0xa/0x10 [dm_mod]
[ 7250.876240]  __x64_sys_ioctl+0x8e/0xd0
[ 7250.876244]  do_syscall_64+0x3a/0xd0
[ 7250.876247]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 7250.876252] RIP: 0033:0x7f15e9254017
[ 7250.876254] RSP: 002b:00007ffffdc59458 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 7250.876257] RAX: ffffffffffffffda RBX: 000055d4d99560e0 RCX: 00007f15e9254017
[ 7250.876260] RDX: 000055d4d99560e0 RSI: 00000000c138fd06 RDI: 0000000000000003
[ 7250.876261] RBP: 000000000000000f R08: 00007f15e975f648 R09: 00007ffffdc592c0
[ 7250.876263] R10: 00007f15e975eb53 R11: 0000000000000246 R12: 000055d4d9956110
[ 7250.876265] R13: 00007f15e975eb53 R14: 000055d4d9956000 R15: 0000000000000001
[ 7250.876269]  </TASK>

I was thinking of how to fix this, and I would like your feedback to
ensure I work on the right direction.

I have thought of the following possible solutions.

1. Have dm-era fail all operations while it's suspended.

    This would work for messages, since they return an error code, but
    the status operation doesn't return errors.

    Moreover, I think it makes sense for the status operation to work
    even if the device is suspended, so failing it doesn't seem the right
    thing to do.

    Maybe it's possible to fix dm-era to bypass the worker thread when
    suspended, and return a valid status? I haven't checked yet if this
    is possible.

2. Redesign dm-era to use locks for accessing its metadata, so we don't
    depend on the worker thread to serialize metadata operations.

    This way we can run all required metadata operations directly from
    the user thread that runs the dmsetup command.

3. Could DM core handle this situation somehow?

    As far as I can tell, the rest of the targets don't block in status
    and message operations until the target is resumed. Is this a
    requirement imposed by DM core, that dm-era violates? I couldn't find
    any documentation regarding this.

I think the right way to go is the second approach, that is redesign
dm-era to use locks instead of depending on the worker thread to
serialize metadata operations, but I would like your input before moving
on.

Looking forward to your feedback,
Nikos.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

