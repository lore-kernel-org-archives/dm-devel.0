Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05AEC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 07:23:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-asuSDSxEO2OpjAyu0NGGYg-1; Wed, 25 May 2022 03:23:01 -0400
X-MC-Unique: asuSDSxEO2OpjAyu0NGGYg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E46E71C16B42;
	Wed, 25 May 2022 07:22:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D120C492CA2;
	Wed, 25 May 2022 07:22:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8D22C194EB83;
	Wed, 25 May 2022 07:22:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB71E194704A
 for <dm-devel@listman.corp.redhat.com>; Tue, 24 May 2022 06:29:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD8792026E03; Tue, 24 May 2022 06:29:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A9C712026D2F
 for <dm-devel@redhat.com>; Tue, 24 May 2022 06:29:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E8311011637
 for <dm-devel@redhat.com>; Tue, 24 May 2022 06:29:37 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-ZCJhsgW9NXukVH4dmDSQfQ-1; Tue, 24 May 2022 02:29:35 -0400
X-MC-Unique: ZCJhsgW9NXukVH4dmDSQfQ-1
Received: by mail-wr1-f45.google.com with SMTP id e2so12583793wrc.1;
 Mon, 23 May 2022 23:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=v0KfzzJTrDnu9+V7St5lQ99gi7CdINuYwUWUnVmQOYI=;
 b=ty6Fbl6kHve1uOMlILnIzIima1ZJQ29JiiqWYTp/CQFaRL38+mdBemEyugQpY1EUGh
 4ybk+yVf5IGOZHx2/IUZ0/nLe7OwCBNz80gKkDdFXqZQf3h42V23KZITwaNUeRidZx5/
 tFdE2GN1qX0CKN/28POifJHRPaHWkayUogA2a52XEh4OgRFm3FCd9UiS5MeGjB4OdY9A
 k84ochPlT8hGg8WEepW2g+MqnHu8Pnohdkr10oM43S4g6x0AaHpNcuNntP+LDBeRCyFb
 DSS2jXTEQFwRrQAyqfFONVUrRapJCsdZehvHyZ0eaKj4fWd4YzFEdCukcfO2SaXdlzs3
 os3g==
X-Gm-Message-State: AOAM530+cc25hMMrRfzOBd6aHq1xllgOsWqvSChqdA77hOE2/IznxihA
 +3OGJo8dF0cVGrZcTlGZmXPSseyRERP2KVx0mwo=
X-Google-Smtp-Source: ABdhPJzoc8SJzNK/+30i+3SovXvrcAvAJQfZIg0PL7ZISuVlVsZo9PDmjZD6+1/2I+JaOXOBXIShmAtRptw4HPqfj1s=
X-Received: by 2002:a5d:6b07:0:b0:20d:97f:ca6b with SMTP id
 v7-20020a5d6b07000000b0020d097fca6bmr21420959wrw.390.1653373774400; Mon, 23
 May 2022 23:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAOOPZo4uNCicVmoHa2za0=O1_XiBdtBvTuUzqBTeBc3FmDqEJw@mail.gmail.com>
 <828ac69a-fe28-0869-bc1f-7fd106dff0aa@oracle.com>
 <CAOOPZo4Z2x_W7i=Vbnm-SsDgj5PndLVtOz6MqRzQxW-NeBwhRg@mail.gmail.com>
 <be26ef80-c3cf-713d-2a9f-4fb73cec7e17@oracle.com>
 <ec8d0b97-e94a-21e1-acdb-e90a7df39b72@oracle.com>
In-Reply-To: <ec8d0b97-e94a-21e1-acdb-e90a7df39b72@oracle.com>
From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date: Tue, 24 May 2022 14:29:22 +0800
Message-ID: <CAOOPZo58sfhqFEMvpUfnoU1ceHDpPnagMbPvDGrDXHZHq7bZLg@mail.gmail.com>
To: Mike Christie <michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Wed, 25 May 2022 07:22:55 +0000
Subject: Re: [dm-devel] Question about iscsi session block
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
Cc: dm-devel@redhat.com, open-iscsi <open-iscsi@googlegroups.com>,
 leech@redhat.com, lduncan@suse.com, linux-scsi@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, Mike,

Sorry for the delayed reply since I have no  environment to check your
bellow patcheset untile recently

https://lore.kernel.org/all/20220226230435.38733-1-michael.christie@oracle.com/

After applied those series, the total time has dropped from 80s to
nearly 10s, it's a great improvement.

Thanks, again

On Sun, Feb 27, 2022 at 7:00 AM Mike Christie
<michael.christie@oracle.com> wrote:
>
> On 2/15/22 8:19 PM, michael.christie@oracle.com wrote:
> > On 2/15/22 7:28 PM, Zhengyuan Liu wrote:
> >> On Wed, Feb 16, 2022 at 12:31 AM Mike Christie
> >> <michael.christie@oracle.com> wrote:
> >>>
> >>> On 2/15/22 9:49 AM, Zhengyuan Liu wrote:
> >>>> Hi, all
> >>>>
> >>>> We have an online server which uses multipath + iscsi to attach storage
> >>>> from Storage Server. There are two NICs on the server and for each it
> >>>> carries about 20 iscsi sessions and for each session it includes about 50
> >>>>  iscsi devices (yes, there are totally about 2*20*50=2000 iscsi block devices
> >>>>  on the server). The problem is: once a NIC gets faulted, it will take too long
> >>>> (nearly 80s) for multipath to switch to another good NIC link, because it
> >>>> needs to block all iscsi devices over that faulted NIC firstly. The callstack is
> >>>>  shown below:
> >>>>
> >>>>     void iscsi_block_session(struct iscsi_cls_session *session)
> >>>>     {
> >>>>         queue_work(iscsi_eh_timer_workq, &session->block_work);
> >>>>     }
> >>>>
> >>>>  __iscsi_block_session() -> scsi_target_block() -> target_block() ->
> >>>>   device_block() ->  scsi_internal_device_block() -> scsi_stop_queue() ->
> >>>>  blk_mq_quiesce_queue()>synchronize_rcu()
> >>>>
> >>>> For all sessions and all devices, it was processed sequentially, and we have
> >>>> traced that for each synchronize_rcu() call it takes about 80ms, so
> >>>> the total cost
> >>>> is about 80s (80ms * 20 * 50). It's so long that the application can't
> >>>> tolerate and
> >>>> may interrupt service.
> >>>>
> >>>> So my question is that can we optimize the procedure to reduce the time cost on
> >>>> blocking all iscsi devices?  I'm not sure if it is a good idea to increase the
> >>>> workqueue's max_active of iscsi_eh_timer_workq to improve concurrency.
> >>>
> >>> We need a patch, so the unblock call waits/cancels/flushes the block call or
> >>> they could be running in parallel.
> >>>
> >>> I'll send a patchset later today so you can test it.
> >>
> >> I'm glad to test once you push the patchset.
> >>
> >> Thank you, Mike.
> >
> > I forgot I did this recently :)
> >
> > commit 7ce9fc5ecde0d8bd64c29baee6c5e3ce7074ec9a
> > Author: Mike Christie <michael.christie@oracle.com>
> > Date:   Tue May 25 13:18:09 2021 -0500
> >
> >     scsi: iscsi: Flush block work before unblock
> >
> >     We set the max_active iSCSI EH works to 1, so all work is going to execute
> >     in order by default. However, userspace can now override this in sysfs. If
> >     max_active > 1, we can end up with the block_work on CPU1 and
> >     iscsi_unblock_session running the unblock_work on CPU2 and the session and
> >     target/device state will end up out of sync with each other.
> >
> >     This adds a flush of the block_work in iscsi_unblock_session.
> >
> >
> > It was merged in 5.14.
>
> Hey, I found one more bug when max_active > 1. While fixing it I decided to just
> fix this so we can do the sessions recoveries in parallel and the user doesn't have
> to worry about setting max_active.
>
> I'll send a patchset and cc you.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

