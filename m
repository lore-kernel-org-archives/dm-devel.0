Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16704C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 06:29:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-kVR8g0a3PKSoU8JU8nIUyg-1; Wed, 16 Feb 2022 01:29:16 -0500
X-MC-Unique: kVR8g0a3PKSoU8JU8nIUyg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBE96801B0C;
	Wed, 16 Feb 2022 06:29:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0F6955F50;
	Wed, 16 Feb 2022 06:29:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 95B9B1806D2E;
	Wed, 16 Feb 2022 06:29:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21G1SUKn029327 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 20:28:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6DB322144B25; Wed, 16 Feb 2022 01:28:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66CC52144B24
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 01:28:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0829C106655A
	for <dm-devel@redhat.com>; Wed, 16 Feb 2022 01:28:26 +0000 (UTC)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
	[209.85.166.53]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-93-g2CcMakxMU2zlRD34X2FXw-1; Tue, 15 Feb 2022 20:28:24 -0500
X-MC-Unique: g2CcMakxMU2zlRD34X2FXw-1
Received: by mail-io1-f53.google.com with SMTP id s1so484315iob.9;
	Tue, 15 Feb 2022 17:28:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=Z2OvqLfZl+hYuGhPphHFvWMwyNyMYmTbKrVX+fI0uIY=;
	b=UX4Cv1buK2lmE1DxP7PsRqWuQ5JrNBQaZWDHtIhUEd96FsoyKnC2F7Zp84azJuBnfx
	0Mt7tpQr/qdOut+w3aj3qdVSAHkIPYcWXfDsEUIm1528ayZK34xy5hGGN3wS3MfGjDVj
	YftxSFSiYWzdYbh0kAFI8RwP4p7W9Vl6LBGRDiD18fBUW9ov3c3GP6PqkrzS/sN42CRt
	grqeou7LSx0wMKt2JsmygGqIKhMF1FJ8NRxUujy4uPeVy9/gYZvz8kpizwwkaMbOz6nP
	duPby4zt+XaquIkwwn93a8vmcBk5A7VV43oSXbxgrW0cXG4fiSH5v2ywVpibuA+w2Di1
	2rHw==
X-Gm-Message-State: AOAM532GBnjRr/a6TI77fIPdyBgFcPaMoj3NZpbLGjL7Wcv5NR9NvXf+
	TzBbKxU7mE6TO7M3kVxFHv2WnOgzMitovmcF9PI=
X-Google-Smtp-Source: ABdhPJz7DsrPBvGZlDWuLBLGgUZa4AMDb918/ama7iYOx1jfyS9JIKqDPdJqnLBKyunjmRdBHfHe0u8pu28jtx7KyXc=
X-Received: by 2002:a6b:4f07:0:b0:613:f763:7d67 with SMTP id
	d7-20020a6b4f07000000b00613f7637d67mr374953iob.4.1644974903589;
	Tue, 15 Feb 2022 17:28:23 -0800 (PST)
MIME-Version: 1.0
References: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
	<828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com>
In-Reply-To: <828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com>
From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date: Wed, 16 Feb 2022 09:28:12 +0800
Message-ID: <CAOOPZo4Z2x_W7i=Vbnm-SsDgj5PndLVtOz6MqRzQxW-NeBwhRg@mail.gmail.com>
To: Mike Christie <michael.christie@oracle.com>
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
X-Mailman-Approved-At: Wed, 16 Feb 2022 01:28:09 -0500
Cc: dm-devel@redhat.com, open-iscsi <open-iscsi@googlegroups.com>,
	leech@redhat.com, lduncan@suse.com, linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] Question about iscsi session block
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 16, 2022 at 12:31 AM Mike Christie
<michael.christie@oracle.com> wrote:
>
> On 2/15/22 9:49 AM, Zhengyuan Liu wrote:
> > Hi, all
> >
> > We have an online server which uses multipath + iscsi to attach storage
> > from Storage Server. There are two NICs on the server and for each it
> > carries about 20 iscsi sessions and for each session it includes about 50
> >  iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
> >  on the server). The problem is: once a NIC gets faulted, it will take too long
> > (nearly 80s) for multipath to switch to another good NIC link, because it
> > needs to block all iscsi devices over that faulted NIC firstly. The callstack is
> >  shown below:
> >
> >     void iscsi_block_session(struct iscsi_cls_session *session)
> >     {
> >         queue_work(iscsi_eh_timer_workq, &session->block_work);
> >     }
> >
> >  __iscsi_block_session() -> scsi_target_block() -> target_block() ->
> >   device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
> >  blk_mq_quiesce_queue()>synchronize_rcu()
> >
> > For all sessions and all devices, it was processed sequentially, and we have
> > traced that for each synchronize_rcu() call it takes about 80ms, so
> > the total cost
> > is about 80s (80ms * 20 * 50). It's so long that the application can't
> > tolerate and
> > may interrupt service.
> >
> > So my question is that can we optimize the procedure to reduce the time cost on
> > blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
> > workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.
>
> We need a patch, so the unblock call waits/cancels/flushes the block call or
> they could be running in parallel.
>
> I'll send a patchset later today so you can test it.

I'm glad to test once you push the patchset.

Thank you, Mike.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

