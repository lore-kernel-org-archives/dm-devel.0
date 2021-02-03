Return-Path: <SRS0=/TsO=HF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5BAC433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 10:49:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 36AB164F58
	for <dm-devel@archiver.kernel.org>; Wed,  3 Feb 2021 10:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36AB164F58
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-N06ORZflOEGJZcoep1wDug-1; Wed, 03 Feb 2021 05:49:07 -0500
X-MC-Unique: N06ORZflOEGJZcoep1wDug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 854C8107ACE4;
	Wed,  3 Feb 2021 10:49:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C73F277BE7;
	Wed,  3 Feb 2021 10:49:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 10D7957DFA;
	Wed,  3 Feb 2021 10:49:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 113Amvfu019303 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 05:48:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 92B5C2166B27; Wed,  3 Feb 2021 10:48:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DB672166B2A
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 10:48:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 139D6811E88
	for <dm-devel@redhat.com>; Wed,  3 Feb 2021 10:48:55 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-273-u7ClsmBVM6WLm9ETgbJ7xQ-1; Wed, 03 Feb 2021 05:48:52 -0500
X-MC-Unique: u7ClsmBVM6WLm9ETgbJ7xQ-1
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DVz0L67nQz7fxp;
	Wed,  3 Feb 2021 18:47:30 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server
	id 14.3.498.0; Wed, 3 Feb 2021 18:48:48 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
Date: Wed, 3 Feb 2021 18:48:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
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
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2021/2/3 4:52, Martin Wilck wrote:
> did this fix your "crash on exit" issue?

Unfortunately, the issue is not solved.


There are 100 luns and two scripts to reproduce the issue.

#!/bin/bash
while true
do
        for i in `seq 1 20`
        do
                udevadm trigger
        done
        sleep 1
done

#!/bin/bash
while true
do
        for i in `seq 1 10`
        do
                systemctl restart multipathd
        done
	kill -9 `pidof /sbin/multipathd`
	sleep 1
done

There will be some different coredump stack.

0.8.5 (I'm not sure there are only two stacks in 0.8.5)
First stack:
Program terminated with signal SIGSEGV, Segmentation fault.
#0  0x00007f59a0109647 in ?? ()
[Current thread is 1 (LWP 1997690)]
(gdb) bt
#0  0x00007f59a0109647 in ?? ()
#1  0x0000000000000000 in ?? ()
(gdb) info threads
  Id   Target Id         Frame
* 1    LWP 1997690       0x00007f59a0109647 in ?? ()
  2    LWP 1996840       0x00007f59a0531de7 in ?? ()
  3    LWP 1997692       0x00007f59a0109647 in ?? ()
  4    LWP 1996857       0x00007f59a020d169 in ?? ()

Second stack:
#0  0x0000ffffb6118f4c in aarch64_fallback_frame_state (context=0xffffb523f200, context=0xffffb523f200, fs=0xffffb523e700) at ./md-unwind-support.h:74
#1  uw_frame_state_for (context=context@entry=0xffffb523f200, fs=fs@entry=0xffffb523e700) at ../../../libgcc/unwind-dw2.c:1257
#2  0x0000ffffb6119ef4 in _Unwind_ForcedUnwind_Phase2 (exc=exc@entry=0xffffb52403b0, context=context@entry=0xffffb523f200) at ../../../libgcc/unwind.inc:155
#3  0x0000ffffb611a284 in _Unwind_ForcedUnwind (exc=0xffffb52403b0, stop=stop@entry=0xffffb64846c0 <unwind_stop>, stop_argument=0xffffb523f630) at ../../../libgcc/unwind.inc:207
#4  0x0000ffffb6484860 in __GI___pthread_unwind (buf=<optimized out>) at unwind.c:121
#5  0x0000ffffb6482d08 in __do_cancel () at pthreadP.h:304
#6  __GI___pthread_testcancel () at pthread_testcancel.c:26
#7  0x0000ffffb5c528e8 in ?? ()

There are other stacks in 0.7.7
Second stack:
#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:51
#1  0x0000ffff9d8d281c in __GI_abort () at abort.c:79
#2  0x0000ffff9d90b818 in __libc_message (action=action@entry=do_abort, fmt=fmt@entry=0xffff9d9cb888 "%s\n") at ../sysdeps/posix/libc_fatal.c:181
#3  0x0000ffff9d911f6c in malloc_printerr (str=str@entry=0xffff9d9c90d0 "free(): invalid pointer") at malloc.c:5389
#4  0x0000ffff9d913780 in _int_free (av=0xffff9da0ba58 <main_arena>, p=0xffff98000070, have_lock=0) at malloc.c:4172
#5  0x0000ffff9dc2b608 in internal_hashmap_clear (h=h@entry=0xffff9814dfa0, default_free_key=<optimized out>, default_free_value=<optimized out>) at ../src/basic/hashmap.c:902
#6  0x0000ffff9dc2b700 in internal_hashmap_free (h=<optimized out>, default_free_key=<optimized out>, default_free_value=<optimized out>, default_free_value=<optimized out>, default_free_key=<optimized out>,
    h=<optimized out>) at ../src/basic/hashmap.c:874
#7  0x0000ffff9dc2b88c in ordered_hashmap_free_free_free () at ../src/basic/hashmap.h:118
#8  device_free (device=0xffff9814d420) at ../src/libsystemd/sd-device/sd-device.c:68
#9  sd_device_unref (p=<optimized out>) at ../src/libsystemd/sd-device/sd-device.c:78
#10 0x0000ffff9dc36cc8 in sd_device_unrefp () at ../src/systemd/sd-device.h:118
#11 device_new_from_nulstr (len=<optimized out>, nulstr=0xffff9d3253d0 "SEQNUM", ret=<synthetic pointer>) at ../src/libsystemd/sd-device/device-private.c:448
#12 device_monitor_receive_device (m=0xffff98000b20, ret=ret@entry=0xffff9d327388) at ../src/libsystemd/sd-device/device-monitor.c:447
#13 0x0000ffff9dc38bf4 in udev_monitor_receive_sd_device (ret=0xffff9d327388, udev_monitor=0xffff98000c70) at ../src/libudev/libudev-monitor.c:207
#14 udev_monitor_receive_device (udev_monitor=0xffff98000c70, udev_monitor@entry=0xffff9d3273a0) at ../src/libudev/libudev-monitor.c:253
#15 0x0000ffff9dcd9478 in uevent_listen (udev=0xffff9d327f40) at uevent.c:853
#16 0x0000aaaae3783514 in ueventloop (ap=0xffffe160fe80) at main.c:1518
#17 0x0000ffff9dbb67ac in start_thread (arg=0xffff9d3ad380) at pthread_create.c:486
#18 0x0000ffff9d97047c in thread_start () at ../sysdeps/unix/sysv/linux/aarch64/clone.S:78

Some stacks in glibc and libgcc.

If exit() before all pthread_cancel in child of 0.7.7, there is no any crash.
So I believe there are many races in thread cancel but I don't know how it comes.

Regards,
Lixiaokeng

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

