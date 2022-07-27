Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F514C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 08:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658910234;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nx6oAOYJyC/pIB3mb7n4bbfJu5F3lR5jyV6luWTGTXY=;
	b=L9UjWASZZ7qeHz4MGgwKu3Q12VnRiemia1dToVmB/Um3MPdSmAnSFoBtNK62ZQ+bzfc6mx
	MLNMwMPjIuuGJkQjY+FkkXUA+Q8tGmW9LTwzmc+NdPyPiiKksR2FxINI+CcZnQbK+aYAW9
	9g8gNt9rsiOWiAUOfYZLV7YtjjoDs8g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-SiWFJ5-iNFyRy7fUE2oHqQ-1; Wed, 27 Jul 2022 04:23:50 -0400
X-MC-Unique: SiWFJ5-iNFyRy7fUE2oHqQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E6C6803520;
	Wed, 27 Jul 2022 08:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D958F492CA2;
	Wed, 27 Jul 2022 08:23:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 906DE1945D8F;
	Wed, 27 Jul 2022 08:23:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8ADCA1945D89
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 08:23:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6A56740CFD0A; Wed, 27 Jul 2022 08:23:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 662CA40CF8E2
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 08:23:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D5DE85A581
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 08:23:42 +0000 (UTC)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
 [209.85.208.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-TncpCXqROLGHjs6QObIX2g-1; Wed, 27 Jul 2022 04:23:40 -0400
X-MC-Unique: TncpCXqROLGHjs6QObIX2g-1
Received: by mail-ed1-f45.google.com with SMTP id e15so20485730edj.2;
 Wed, 27 Jul 2022 01:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=HwXpGtiEmjz+PfdfLmOfPFJxt3gzyiH3GKxaF6pjrjU=;
 b=VX1clzcWpU2iY9+fr3LmCpVu2FI9m1kDEysmuSmzYaVLok8VyD1OjM8RSf4sBusfd9
 qkDD9NmG1TYmONlz7LRtnuugEwGT+I5m2gbDWpAPIYq2e+0viT0Wo7JupK1AUcU5aJI6
 jMXuu23J1bKRMjFonYIMAhJMlgaamjJCZKWNloC0AYVXtxxGrCqi4hHb0KK3W6RrMuuw
 asGqHIj6TrWZlzJslsA1kPDq7adBT56Wh4GU5XzY/Qv+9JscDUkSGHUXRE7LRfFa1Qn/
 gxsDpTYz09s/QODBBMdamagH5UHWfgpOHegDmUx5MVyVi3T9CGl+zNZcaajFJ8gOzGGL
 68NQ==
X-Gm-Message-State: AJIora96wMLAkExAEYN177tEGx42eGrIJeyXZFoFDb19tnK0940fUpRl
 OQ/ZsSyR3U/OutTGhFF4bCNxjQa58MM=
X-Google-Smtp-Source: AGRyM1sThhuuRzvJs7k8GVf1m47S7tCcu4RfgKTSHsUrqAPufjTDAO0bpLkWkOD3H+rt3SA16x1QSw==
X-Received: by 2002:a05:6402:32a7:b0:437:a341:9286 with SMTP id
 f39-20020a05640232a700b00437a3419286mr10863527eda.156.1658910218912; 
 Wed, 27 Jul 2022 01:23:38 -0700 (PDT)
Received: from [192.168.2.27] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
 by smtp.gmail.com with ESMTPSA id
 ga2-20020a170906b84200b00724261b592esm7332298ejb.186.2022.07.27.01.23.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Jul 2022 01:23:38 -0700 (PDT)
Message-ID: <28afb65a-f15a-7f75-9a78-acae374f809b@gmail.com>
Date: Wed, 27 Jul 2022 10:23:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Mike Snitzer <snitzer@redhat.com>
References: <20220726160959.89247-1-snitzer@kernel.org>
 <6a158b48-10d3-6427-bc44-e7f78513380b@gmail.com>
 <YuBzAIXQXBRwukR7@redhat.com>
From: Milan Broz <gmazyland@gmail.com>
In-Reply-To: <YuBzAIXQXBRwukR7@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 27/07/2022 01:04, Mike Snitzer wrote:
> On Tue, Jul 26 2022 at  5:44P -0400,
> Milan Broz <gmazyland@gmail.com> wrote:
> 
>> On 26/07/2022 18:09, Mike Snitzer wrote:
>>> Hi,
>>>
>>> Please see this updated patchset that reflects what I've staged for
>>> the 5.20 merge window, see:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.20
>>>
>>> My only outstanding question, from previous v1 patchset, is: should
>>> the verify_wq be created using WQ_HIGHPRI instead of WQ_CPU_INTENSIVE?
>>> (I doubt it has a significant impact on performance but if you have
>>> insight on why you made that change, and if it meaningful, I'd happily
>>> apply the change).
>>>
>>> I've tested using cryptsetup's testsuite (which has dm-verity tests)
>>> but I haven't tested the "try_verify_in_tasklet" feature.
> 
> I wasn't lying above: I haven't tested the "try_verify_in_tasklet"
> feature.  I just figured I didn't break what Huck posted by cleaning
> it up while reviewing closely ;)

:) What I am trying to avoid is that these patches reach Linux tree
until properly tested even in non-standard configurations (like FEC enabled).

Currently we have not even enough HW for GitLab runners for upstream cryptsetup
CI testing and regression like these will cause *huge* pain for us later.

>> I added new veritysetup option --use-tasklets for testing to a new branch
>> https://gitlab.com/cryptsetup/cryptsetup/-/commits/verify-tasklet
>>
>> I tried to run verity-compat-test (on that branch above), not used the flag yet,
>> just in one simple option flag test (see the branch).
> 
> OK, thanks for doing this work, really appreciate it.  How is it I
> would initiate this test using your "verify-tasklet" branch?

Basically, just checkout that branch, compile it
(autogen.sh, configure, make, make check-programs) and then run verity test
cd tests; ./verity-compat-test

Even without adding the feature, FEC tests are skipped for some reason...
(Check for N/A that should not be there.)

Then you can easily enable "--use-tasklets" for every open, I would just
comment this line:

--- a/src/veritysetup.c
+++ b/src/veritysetup.c
@@ -184,7 +184,7 @@ static int _activate(const char *dm_device,
                 activate_flags |= CRYPT_ACTIVATE_IGNORE_ZERO_BLOCKS;
         if (ARG_SET(OPT_CHECK_AT_MOST_ONCE_ID))
                 activate_flags |= CRYPT_ACTIVATE_CHECK_AT_MOST_ONCE;
-       if (ARG_SET(OPT_USE_TASKLETS_ID))
+//     if (ARG_SET(OPT_USE_TASKLETS_ID))
                 activate_flags |= CRYPT_ACTIVATE_TASKLETS;


compile it, and run the verity-compat-test again.

For me, it stucks on the first in-kernel verify (non-FEC) line.
Some trace below...

(Side note: we do not have any easy way to check that dm-verity
is compiled without FEC. Target version is the same, and I do not
want to introduce any config parsing in libcryptsetup....
The same perhaps applies to other targets, any idea?
I would help us to error the test in that case more clearly.)

Milan

Jul 27 10:10:20 : device-mapper: verity: 7:2: reached maximum errors
Jul 27 10:10:21 : loop1: detected capacity change from 0 to 1094
Jul 27 10:10:21 : device-mapper: verity: sha256 using implementation "sha256-generic"
Jul 27 10:10:22 : loop1: detected capacity change from 0 to 1094
Jul 27 10:10:22 : device-mapper: verity: sha256 using implementation "sha256-generic"
Jul 27 10:15:29 : INFO: task systemd-udevd:6842 blocked for more than 122 seconds.
Jul 27 10:15:29 :       Not tainted 5.19.0-rc8+ #767
Jul 27 10:15:29 : "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 27 10:15:29 : task:systemd-udevd   state:D stack:    0 pid: 6842 ppid:   540 flags:0x00004006
Jul 27 10:15:29 : Call Trace:
Jul 27 10:15:29 :  __schedule+0x3f9/0xcc0
Jul 27 10:15:29 :  schedule+0x40/0xb0
Jul 27 10:15:29 :  io_schedule+0x3c/0x60
Jul 27 10:15:29 :  folio_wait_bit_common+0xe2/0x310
Jul 27 10:15:29 :  ? filemap_invalidate_unlock_two+0x40/0x40
Jul 27 10:15:29 :  __filemap_get_folio+0x4d8/0x500
Jul 27 10:15:29 :  truncate_inode_pages_range+0x1c2/0x4e0
Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
Jul 27 10:15:29 :  ? smp_call_function_many_cond+0x2e5/0x310
Jul 27 10:15:29 :  ? on_each_cpu_cond_mask+0x32/0x60
Jul 27 10:15:29 :  ? trace_hardirqs_on+0x35/0xd0
Jul 27 10:15:29 :  ? smp_call_function_many_cond+0xe9/0x310
Jul 27 10:15:29 :  ? buffer_exit_cpu_dead+0x80/0x80
Jul 27 10:15:29 :  ? buffer_exit_cpu_dead+0x80/0x80
Jul 27 10:15:29 :  ? generic_remap_file_range_prep+0xcb0/0xcb0
Jul 27 10:15:29 :  ? on_each_cpu_cond_mask+0x3c/0x60
Jul 27 10:15:29 :  ? generic_remap_file_range_prep+0xcb0/0xcb0
Jul 27 10:15:29 :  truncate_inode_pages+0xc/0x10
Jul 27 10:15:29 :  blkdev_flush_mapping+0x66/0x100
Jul 27 10:15:29 :  blkdev_put_whole+0x38/0x40
Jul 27 10:15:29 :  blkdev_put+0x92/0x1c0
Jul 27 10:15:29 :  blkdev_close+0x13/0x20
Jul 27 10:15:29 :  __fput+0x80/0x270
Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
Jul 27 10:15:29 :  ____fput+0x8/0x10
Jul 27 10:15:29 :  task_work_run+0x4f/0x80
Jul 27 10:15:29 :  do_exit+0x315/0x9a0
Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
Jul 27 10:15:29 :  do_group_exit+0x26/0x90
Jul 27 10:15:29 :  get_signal+0xa2d/0xa60
Jul 27 10:15:29 :  arch_do_signal_or_restart+0x1e/0x5c0
Jul 27 10:15:29 :  ? __this_cpu_preempt_check+0xf/0x11
Jul 27 10:15:29 :  ? lockdep_hardirqs_on+0xbf/0x150
Jul 27 10:15:29 :  ? exit_to_user_mode_prepare+0x10f/0x250
Jul 27 10:15:29 :  ? syscall_exit_to_user_mode+0x1a/0x50
Jul 27 10:15:29 :  exit_to_user_mode_prepare+0x129/0x250
Jul 27 10:15:29 :  syscall_exit_to_user_mode+0x1a/0x50
Jul 27 10:15:29 :  do_int80_syscall_32+0x3c/0x90
Jul 27 10:15:29 :  entry_INT80_32+0xf0/0xf0
Jul 27 10:15:29 : EIP: 0xb7f61022
Jul 27 10:15:29 : EAX: fffffffc EBX: 00000005 ECX: 0054cbdc EDX: 00000100
Jul 27 10:15:29 : ESI: b7ea8000 EDI: 00570820 EBP: 00570868 ESP: bfc0890c
Jul 27 10:15:29 : DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 007b EFLAGS: 00000246
Jul 27 10:15:29 : \x0aShowing all locks held in the system:
Jul 27 10:15:29 : 1 lock held by khungtaskd/34:
Jul 27 10:15:29 :  #0: c1b0bc98 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x1f/0x152
Jul 27 10:15:29 : 2 locks held by kworker/u16:5/6148:
Jul 27 10:15:29 : 1 lock held by systemd-udevd/6842:
Jul 27 10:15:29 :  #0: c51344bc (&disk->open_mutex){+.+.}-{3:3}, at: blkdev_put+0x30/0x1c0
Jul 27 10:15:29 :
Jul 27 10:15:29 : =============================================\x0a

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

