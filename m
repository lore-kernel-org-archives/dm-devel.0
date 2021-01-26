Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51CDC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 06:50:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1286622228
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 06:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1286622228
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-_ElBMHCePjqTbN_47YRy8g-1; Tue, 26 Jan 2021 01:50:42 -0500
X-MC-Unique: _ElBMHCePjqTbN_47YRy8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3B1A1573A;
	Tue, 26 Jan 2021 06:50:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C6F2100239F;
	Tue, 26 Jan 2021 06:50:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F1FD34A7C6;
	Tue, 26 Jan 2021 06:50:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10Q6oZGF021597 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 01:50:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9E23F2166B2C; Tue, 26 Jan 2021 06:50:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 988C32166B28
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 06:50:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A291101A53F
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 06:50:31 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-99-bVNwIqOlP_-oDaVBGPHbuA-1; Tue, 26 Jan 2021 01:50:24 -0500
X-MC-Unique: bVNwIqOlP_-oDaVBGPHbuA-1
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DPy4x1QC7z15y7l;
	Tue, 26 Jan 2021 14:49:05 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 26 Jan 2021 14:50:10 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <621a2062-b6eb-d88d-e53a-9c0a6b19cfbb@huawei.com>
Date: Tue, 26 Jan 2021 14:50:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
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
Cc: linfeilong <linfeilong@huawei.com>, hexiaowen@huawei.com
Subject: [dm-devel] [QUESTION] multipathd crash when stopping
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

When stopping multipathd (systemctl restart multipathd.service), there
is a multipathd crash occasionally(not reproduced).

Here is stack:
#0 __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:51
#1 0x0000ffff87d9e81c in __GI_abort () at abort.c:79
#2 0x0000ffff87dd7818 in __libc_message (action=action@entry=do_abort,
fmt=fmt@entry=0xffff87e97888 "%s\n") at ../sysdeps/posix/libc_fatal.c:181
#3 0x0000ffff87dddf6c in malloc_printerr (
str=str@entry=0xffff87e950d0 "free(): invalid pointer") at malloc.c:5389
#4 0x0000ffff87ddf780 in _int_free (av=0xffff87ed7a58 <main_arena>, p=0xffff80000070,
have_lock=0) at malloc.c:4172
#5 0x0000ffff880f55a8 in internal_hashmap_clear (h=h@entry=0xffff80027980,
default_free_key=, default_free_value=)
at ../src/basic/hashmap.c:902
#6 0x0000ffff880f56a0 in internal_hashmap_free (h=,
default_free_key=, default_free_value=,
default_free_value=, default_free_key=, h=)
at ../src/basic/hashmap.c:874
#7 0x0000ffff880f582c in ordered_hashmap_free_free_free () at ../src/basic/hashmap.h:118
#8 device_free (device=0xffff80027820) at ../src/libsystemd/sd-device/sd-device.c:68
#9 sd_device_unref (p=) at ../src/libsystemd/sd-device/sd-device.c:78
#10 0x0000ffff88100978 in sd_device_unrefp () at ../src/systemd/sd-device.h:118
#11 device_new_from_nulstr (len=, nulstr=0xffff877f93d0 "",
ret=) at ../src/libsystemd/sd-device/device-private.c:448
#12 device_monitor_receive_device (m=0xffff80000b20, ret=ret@entry=0xffff877fb388)
at ../src/libsystemd/sd-device/device-monitor.c:447
#13 0x0000ffff881028a4 in udev_monitor_receive_sd_device (ret=0xffff877fb388,
udev_monitor=0xffff80000c70) at ../src/libudev/libudev-monitor.c:207
#14 udev_monitor_receive_device (udev_monitor=0xffff80000c70,
udev_monitor@entry=0xffff877fb3a0) at ../src/libudev/libudev-monitor.c:253
#15 0x0000ffff881a3478 in uevent_listen (udev=0xffff877fbf40) at uevent.c:853
#16 0x0000aaaadc524514 in ueventloop (ap=0xffffc4134bd0) at main.c:1518
#17 0x0000ffff880827ac in start_thread (arg=0xffff8821e380) at pthread_create.c:486
#18 0x0000ffff87e3c47c in thread_start () at ../sysdeps/unix/sysv/linux/aarch64/clone.S:78

There's a strange phenomenon here.
In frame 11, nulstr=0xffff877f93d0 "". But in frame 12,
x/32bs (uint8_t*) &buf.raw[bufpos]
0xffff877f9360: "ACTION"
0xffff877f9367: "change"
0xffff877f936e: "DEVPATH"
0xffff877f9376: "/devices/virtual/block/dm-69"
0xffff877f9393: "SUBSYSTEM"
0xffff877f939d: "block"
0xffff877f93a3: "DM_COOKIE"
0xffff877f93ad: "23068672"
0xffff877f93b6: "DEVNAME"
0xffff877f93be: "/dev/dm-69"
0xffff877f93c9: "DEVTYPE"
0xffff877f93d1: "disk"
0xffff877f93d6: "SEQNUM"
0xffff877f93dd: "14437"
0xffff877f93e3: "USEC_INITIALIZED"
0xffff877f93f4: "8213096220"
0xffff877f93ff: "MAJOR"
0xffff877f9405: "253"
0xffff877f9409: "MINOR"
0xffff877f940f: "69"
0xffff877f9412: "DM_UDEV_DISABLE_LIBRARY_FALLBACK_FLAG"
0xffff877f9438: "1"
0xffff877f943a: "DM_UDEV_PRIMARY_SOURCE_FLAG"
0xffff877f9456: "1"
0xffff877f9458: "DM_SUBSYSTEM_UDEV_FLAG0"
0xffff877f9470: "1"
0xffff877f9472: "DM_ACTIVATION"
0xffff877f9480: "0"
0xffff877f9482: "DM_NAME"
0xffff877f948a: "36e02861100592fcc99ad3c3800000195"
0xffff877f94ac: "DM_UUID"
0xffff877f94b4: "mpath-36e02861100592fcc99ad3c3800000195"

The udev API is suspected at first. However, hashmap is a common data
structure of systemd. Systemd has never had the same call stack.
Can someone help me?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

