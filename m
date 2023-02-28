Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14EE0C64ED6
	for <dm-devel@archiver.kernel.org>; Tue, 28 Feb 2023 07:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677571148;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cmqG/qJLe+qrs9e7lJcJB9mvL8Y/FBjWkJWS5ONbdGU=;
	b=ZJKyfp8/7qZvwpxPg2GUAylcwnrSdUljMIIGejTXPig0aoSzomE5Ok1S7l6gib5e8fGjwE
	B/nWlIXj3/8nkEW5qu021O2Y549C3/yPRcEdPWpaGdIz/4A+XOk2hbb1NvtvSrBAc1c10m
	guYckAY/cRvhWK/U/0ajGlwVSFbE0bI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-ipCxGcW6NhOeBolroDko-w-1; Tue, 28 Feb 2023 02:59:05 -0500
X-MC-Unique: ipCxGcW6NhOeBolroDko-w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F33E101D22A;
	Tue, 28 Feb 2023 07:59:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 198BC404BECE;
	Tue, 28 Feb 2023 07:59:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C1B291946A49;
	Tue, 28 Feb 2023 07:59:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C479A1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Feb 2023 01:51:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B38FD1121315; Tue, 28 Feb 2023 01:51:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB92F1121314
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:51:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CB00802D2F
 for <dm-devel@redhat.com>; Tue, 28 Feb 2023 01:51:11 +0000 (UTC)
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-ZyWbdsTXMCOpm5-Dx4h6xw-1; Mon, 27 Feb 2023 20:51:09 -0500
X-MC-Unique: ZyWbdsTXMCOpm5-Dx4h6xw-1
Received: by mail-yw1-f199.google.com with SMTP id
 00721157ae682-536c6ce8d74so176723877b3.9
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 17:51:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=zChK5+ddiv6SWLeSKoDd0fakedFtjYz+Eiu3nbJmpGk=;
 b=bNdRmn6jk+qtFP9M0ELzJ6ghBm94EioMAB942aHD7je+2Q1AWGa7aeopF6frsrsSI+
 QBtm61rlvDhCmT6q4tPSHnGa7HKu+poQXyeAA1a76QvvMiRv36bw1D0JTET/ZwcjDmNV
 JteB81rYEZqLC3NM7s1gD6+e2m0K/xWm8JwsKyA33O3U1jIss7tMhDbJEarDQJtXeqKv
 wYfa3RE0fhElOhqQmQ1jeKkAX5rdE12VeMJHKaGyjHAFNv+nXbquV1f01YBOES+CKxTj
 WBPJUbKT1qGEOOgmen3rbWlbp3/W2zlJ+BVPBRfhZsOlgiGmifOPOcVdDv7JVSSPRdHJ
 1/pQ==
X-Gm-Message-State: AO0yUKUa+yMspWk1TRrp0PXIBSWPQ7RSKF8WZ0rD5vclKHzTarvFXF9v
 +TRSi7R8nxAop+LPF+SjGjAEjQJOPqDQzmtbRf3LYQNDVOovTzqsKwI12vVVMC/2DFjt7L1nDx5
 xuyJZ6XNJFpCdziEiBksvjrXKgBVHs6E+awxbq6ok3Q==
X-Received: by 2002:a25:8e92:0:b0:a60:c167:c053 with SMTP id
 q18-20020a258e92000000b00a60c167c053mr389787ybl.11.1677549068975; 
 Mon, 27 Feb 2023 17:51:08 -0800 (PST)
X-Google-Smtp-Source: AK7set+FXCMrkNQwXw7lKwNmPcNVv6S6xYVomdkuJBNTc8TZxw+wj7pFUQ8vb/DcrEEeFmXiAIIXpa+roDmODAFj/z4=
X-Received: by 2002:a25:8e92:0:b0:a60:c167:c053 with SMTP id
 q18-20020a258e92000000b00a60c167c053mr389779ybl.11.1677549068625; Mon, 27 Feb
 2023 17:51:08 -0800 (PST)
MIME-Version: 1.0
From: Guangwu Zhang <guazhang@redhat.com>
Date: Tue, 28 Feb 2023 09:51:54 +0800
Message-ID: <CAGS2=YoXmMmA6wqoUxWenG=SpSOod6aAd-dhNkwQgSJ=8yHWog@mail.gmail.com>
To: dm-devel@redhat.com
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Tue, 28 Feb 2023 07:59:00 +0000
Subject: [dm-devel] [bug report] BUG: KASAN: slab-use-after-free in
 blkg_destroy+0x34b/0x380
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

Found kernel issue about dm-mod blkg_destroy, please have a look if
need more info.
kernel repo : https://github.com/torvalds/linux.git
kernel : 6.2.0.kasan

just found it once and not sure the reproducer

  OK
] Reached target
System Reboot
.
[ 3810.010126] systemd-shutdown[1]: Waiting for process: 119574
(bash), 119566 (rhts-reboot), 119584 (sleep), 119578 (sleep), 119575
(tee)
[-- MARK -- Mon Feb 27 10:25:00 2023]
[ 3890.110979] ==================================================================
[ 3890.118206] BUG: KASAN: slab-use-after-free in blkg_destroy+0x34b/0x380
[ 3890.124825] Read of size 8 at addr ff11000131856820 by task systemd-shutdow/1
[ 3890.131959]
[ 3890.133456] CPU: 8 PID: 1 Comm: systemd-shutdow Kdump: loaded Not
tainted 6.2.0.kasan+ #1
[ 3890.141628] Hardware name: Intel Corporation WHITLEY/WHITLEY, BIOS
WLYDCRB1.SYS.0020.P21.2012150710 12/15/2020
[ 3890.151613] Call Trace:
[ 3890.154065]  <TASK>
[ 3890.156172]  dump_stack_lvl+0x33/0x50
[ 3890.159846]  print_address_description.constprop.0+0x2c/0x3e0
[ 3890.165600]  print_report+0xb5/0x270
[ 3890.169176]  ? kasan_addr_to_slab+0x9/0xa0
[ 3890.173276]  ? blkg_destroy+0x34b/0x380
[ 3890.177117]  kasan_report+0xcf/0x100
[ 3890.180693]  ? blkg_destroy+0x34b/0x380
[ 3890.184525]  blkg_destroy+0x34b/0x380
[ 3890.188190]  ? percpu_ref_kill_and_confirm+0xa7/0x250
[ 3890.193244]  blkg_destroy_all.isra.0+0x101/0x1f0
[ 3890.197863]  blkcg_exit_disk+0x2f/0x70
[ 3890.201615]  disk_release+0x110/0x3f0
[ 3890.205281]  device_release+0x98/0x210
[ 3890.209042]  kobject_cleanup+0x101/0x360
[ 3890.212975]  cleanup_mapped_device+0x255/0x490 [dm_mod]
[ 3890.218219]  __dm_destroy+0x316/0x550 [dm_mod]
[ 3890.222680]  dev_remove+0x230/0x300 [dm_mod]
[ 3890.226970]  ctl_ioctl+0x4e8/0x790 [dm_mod]
[ 3890.231166]  ? __pfx_ctl_ioctl+0x10/0x10 [dm_mod]
[ 3890.235888]  ? kasan_save_stack+0x2e/0x40
[ 3890.239901]  ? kasan_save_stack+0x1e/0x40
[ 3890.243911]  ? task_work_add+0x73/0x210
[ 3890.247751]  ? filp_close+0xf3/0x150
[ 3890.251330]  ? __x64_sys_close+0x2c/0x70
[ 3890.255254]  ? do_syscall_64+0x59/0x90
[ 3890.259009]  ? __pfx___wait_for_common+0x10/0x10
[ 3890.263630]  ? rseq_get_rseq_cs+0x6a/0x660
[ 3890.267733]  ? __fget_light+0x57/0x510
[ 3890.271489]  dm_ctl_ioctl+0xa/0x20 [dm_mod]
[ 3890.275689]  __x64_sys_ioctl+0x128/0x1a0
[ 3890.279617]  do_syscall_64+0x59/0x90
[ 3890.283196]  ? _raw_spin_lock+0x81/0xe0
[ 3890.287035]  ? __rseq_handle_notify_resume+0x64/0xd0
[ 3890.291999]  ? exit_to_user_mode_loop+0xd0/0x130
[ 3890.296617]  ? exit_to_user_mode_prepare+0xb6/0x100
[ 3890.301498]  ? syscall_exit_to_user_mode+0x12/0x30
[ 3890.306290]  ? do_syscall_64+0x69/0x90
[ 3890.310042]  ? do_syscall_64+0x69/0x90
[ 3890.313796]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[ 3890.318848] RIP: 0033:0x7fb97303ec6b


--

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

