Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F13C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 06:30:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-oj31A2igMBSCFaPMzrT5MA-1; Wed, 16 Feb 2022 01:30:14 -0500
X-MC-Unique: oj31A2igMBSCFaPMzrT5MA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3139D14759;
	Wed, 16 Feb 2022 06:30:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 166F74EC89;
	Wed, 16 Feb 2022 06:30:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E5A3D5003E;
	Wed, 16 Feb 2022 06:30:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FFnJ9p006353 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 10:49:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4B2F041136E8; Tue, 15 Feb 2022 15:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 465E841136E0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 15:49:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E257866DF8
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 15:49:19 +0000 (UTC)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com
	[209.85.166.180]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-202-x6X2OyP6PSGoO5AdZ9qWcQ-1; Tue, 15 Feb 2022 10:49:17 -0500
X-MC-Unique: x6X2OyP6PSGoO5AdZ9qWcQ-1
Received: by mail-il1-f180.google.com with SMTP id z18so15146177iln.2;
	Tue, 15 Feb 2022 07:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
	bh=PAKLLZo4d0SXE1xp9xl26Jdcj+uTN+GVetCZ7RxOyN4=;
	b=IUyyvM6t2yQRhvMvJphri1vSqOsiGEeD2wAvKj1lUKEPeHVJWSdlK3Axsz0h0I/seT
	m25vqaLoKAQmYtGvmK0RT+X5GP2CDBX9Z2BvKYLRccot9F3ygmoLP7d44iCorHjZ7RxI
	5n3eAeF3/h+z2ctE7RBapwf/x9ZJhVHdHXusdGeaV5/IplDWGjPLZO1HoXWbBzhve8yY
	dBFHeqSNGJ6HoB16v55fVv8w2xEmh+KkHZyjh5iFA5NCmxGo2gLrY5h/nuvTYillShTR
	3MJpnH+dWBZ2yh0KGCmnoLLoAFmdArU70Qb1mE3vEDRL5xAY9+C3j3awO2MHy+QInpKI
	Kvdw==
X-Gm-Message-State: AOAM533quHOg1T/jq8P7jdiII17qszPg0IiZ6yWRPk86MH9jTARiyqkG
	a5/jPU+YoR+IzUOH7UsGpPSY7/tPqS8urIBp9j4vxTnIu2A=
X-Google-Smtp-Source: ABdhPJyBbBvZmOMe+/H8pQFYg+ZvQ5o8Kgoz6qJc+VMjzJNOqAfk8ysifocmn9HLhTNqvNtlaJchErbrLWbOS4zxkr8=
X-Received: by 2002:a05:6e02:1bed:: with SMTP id
	y13mr2883374ilv.27.1644940156693; 
	Tue, 15 Feb 2022 07:49:16 -0800 (PST)
MIME-Version: 1.0
From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date: Tue, 15 Feb 2022 23:49:05 +0800
Message-ID: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
To: linux-scsi@vger.kernel.org, open-iscsi <open-iscsi@googlegroups.com>,
	dm-devel@redhat.com
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
X-Mailman-Approved-At: Wed, 16 Feb 2022 01:28:09 -0500
Cc: bob.liu@oracle.com, leech@redhat.com, lduncan@suse.com
Subject: [dm-devel] Question about iscsi session block
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, all

We have an online server which uses multipath + iscsi to attach storage
from Storage Server. There are two NICs on the server and for each it
carries about 20 iscsi sessions and for each session it includes about 50
 iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
 on the server). The problem is: once a NIC gets faulted, it will take too long
(nearly 80s) for multipath to switch to another good NIC link, because it
needs to block all iscsi devices over that faulted NIC firstly. The callstack is
 shown below:

    void iscsi_block_session(struct iscsi_cls_session *session)
    {
        queue_work(iscsi_eh_timer_workq, &session->block_work);
    }

 __iscsi_block_session() -> scsi_target_block() -> target_block() ->
  device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
 blk_mq_quiesce_queue()>synchronize_rcu()

For all sessions and all devices, it was processed sequentially, and we have
traced that for each synchronize_rcu() call it takes about 80ms, so
the total cost
is about 80s (80ms * 20 * 50). It's so long that the application can't
tolerate and
may interrupt service.

So my question is that can we optimize the procedure to reduce the time cost on
blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.

Thanks in advance.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

