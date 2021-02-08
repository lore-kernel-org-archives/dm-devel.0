Return-Path: <SRS0=blFE=HK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A01CC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 07:41:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5604164DD6
	for <dm-devel@archiver.kernel.org>; Mon,  8 Feb 2021 07:41:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5604164DD6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-KUfWSf1ENMai9GVUDuY6mw-1; Mon, 08 Feb 2021 02:41:44 -0500
X-MC-Unique: KUfWSf1ENMai9GVUDuY6mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 918ED85EE61;
	Mon,  8 Feb 2021 07:41:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9FF21002388;
	Mon,  8 Feb 2021 07:41:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 075E84EE83;
	Mon,  8 Feb 2021 07:41:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1187fTDC022548 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Feb 2021 02:41:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EFA6A2166B32; Mon,  8 Feb 2021 07:41:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAC182166B31
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 07:41:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46495800B29
	for <dm-devel@redhat.com>; Mon,  8 Feb 2021 07:41:26 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-383-T0cmiREGN26IDNa7D_fZKg-1; Mon, 08 Feb 2021 02:41:19 -0500
X-MC-Unique: T0cmiREGN26IDNa7D_fZKg-1
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DYybS5Qr0z7hwM;
	Mon,  8 Feb 2021 15:39:48 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server
	id 14.3.498.0; Mon, 8 Feb 2021 15:41:08 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
Message-ID: <15415073-3b0b-c5a3-ec1d-ced704a42a86@huawei.com>
Date: Mon, 8 Feb 2021 15:41:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> 
> There are other stacks in 0.7.7
> Second stack:
> #0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:51
> #1  0x0000ffff9d8d281c in __GI_abort () at abort.c:79
> #2  0x0000ffff9d90b818 in __libc_message (action=action@entry=do_abort, fmt=fmt@entry=0xffff9d9cb888 "%s\n") at ../sysdeps/posix/libc_fatal.c:181
> #3  0x0000ffff9d911f6c in malloc_printerr (str=str@entry=0xffff9d9c90d0 "free(): invalid pointer") at malloc.c:5389
> #4  0x0000ffff9d913780 in _int_free (av=0xffff9da0ba58 <main_arena>, p=0xffff98000070, have_lock=0) at malloc.c:4172
> #5  0x0000ffff9dc2b608 in internal_hashmap_clear (h=h@entry=0xffff9814dfa0, default_free_key=<optimized out>, default_free_value=<optimized out>) at ../src/basic/hashmap.c:902
> #6  0x0000ffff9dc2b700 in internal_hashmap_free (h=<optimized out>, default_free_key=<optimized out>, default_free_value=<optimized out>, default_free_value=<optimized out>, default_free_key=<optimized out>,
>     h=<optimized out>) at ../src/basic/hashmap.c:874
> #7  0x0000ffff9dc2b88c in ordered_hashmap_free_free_free () at ../src/basic/hashmap.h:118
> #8  device_free (device=0xffff9814d420) at ../src/libsystemd/sd-device/sd-device.c:68
> #9  sd_device_unref (p=<optimized out>) at ../src/libsystemd/sd-device/sd-device.c:78
> #10 0x0000ffff9dc36cc8 in sd_device_unrefp () at ../src/systemd/sd-device.h:118
> #11 device_new_from_nulstr (len=<optimized out>, nulstr=0xffff9d3253d0 "SEQNUM", ret=<synthetic pointer>) at ../src/libsystemd/sd-device/device-private.c:448
> #12 device_monitor_receive_device (m=0xffff98000b20, ret=ret@entry=0xffff9d327388) at ../src/libsystemd/sd-device/device-monitor.c:447
> #13 0x0000ffff9dc38bf4 in udev_monitor_receive_sd_device (ret=0xffff9d327388, udev_monitor=0xffff98000c70) at ../src/libudev/libudev-monitor.c:207
> #14 udev_monitor_receive_device (udev_monitor=0xffff98000c70, udev_monitor@entry=0xffff9d3273a0) at ../src/libudev/libudev-monitor.c:253
> #15 0x0000ffff9dcd9478 in uevent_listen (udev=0xffff9d327f40) at uevent.c:853
> #16 0x0000aaaae3783514 in ueventloop (ap=0xffffe160fe80) at main.c:1518
> #17 0x0000ffff9dbb67ac in start_thread (arg=0xffff9d3ad380) at pthread_create.c:486
> #18 0x0000ffff9d97047c in thread_start () at ../sysdeps/unix/sysv/linux/aarch64/clone.S:78
> 

Hi Martin,

There is a _cleanup_ in device_new_from_nulstr. If uevent_thr exit in
device_new_from_nulstr and some keys is not be append to sd_device,
the _cleanup_ will be called, which leads to multipathd crashes with
the stack.

When I use your advice,


On 2021/1/26 16:34, Martin Wilck wrote:
>     int oldstate;
>
>     pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate);
>
>     udev_monitor_receive_device(...)
>
>     pthread_setcancelstate(oldstate, NULL);
>     pthread_testcancel();

this coredump does not seem to appear anymore (several hours with test scripts).

Here are some discussion in https://github.com/systemd/systemd/issues/18376.

Should be pthread cancellation set in multipath-tools?

Regards,
Lixiaokeng



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

