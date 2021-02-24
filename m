Return-Path: <SRS0=vUAV=H3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC31C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED97964EBA
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 09:27:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED97964EBA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-Es9QaS-0O1qmgXDChVqrxQ-1; Thu, 25 Feb 2021 04:27:24 -0500
X-MC-Unique: Es9QaS-0O1qmgXDChVqrxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BA4B80402C;
	Thu, 25 Feb 2021 09:27:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6091760BE5;
	Thu, 25 Feb 2021 09:27:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 39C5A18095CB;
	Thu, 25 Feb 2021 09:27:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O9BS2b013817 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 04:11:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D5953FDCF6; Wed, 24 Feb 2021 09:11:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D02117AC3
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 09:11:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 189B6100AFF0
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 09:11:26 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-581-83RO42T4PrGbyW5Tx9zc9Q-1;
	Wed, 24 Feb 2021 04:09:34 -0500
X-MC-Unique: 83RO42T4PrGbyW5Tx9zc9Q-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7237F64ED6;
	Wed, 24 Feb 2021 09:09:31 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id e8so1550549ljj.5;
	Wed, 24 Feb 2021 01:09:31 -0800 (PST)
X-Gm-Message-State: AOAM531gPSy+mhG7yWpY6j99p6tlWZCTKq/ngp4Kgcu5rvyNj1KOKCOe
	nmHPVwTzwh+9h/kZCdWVgask1gtZExX5VrPLqM4=
X-Google-Smtp-Source: ABdhPJxIxpGmVpd0hvF9qqK6G6MCtyhOx+u4kaepzzQYkt4E1gzjn3RRlO7Jg+o/FiaQQwZ4vH9tbwiZ10YIzGucjgw=
X-Received: by 2002:a2e:9b05:: with SMTP id u5mr13811463lji.167.1614157769559; 
	Wed, 24 Feb 2021 01:09:29 -0800 (PST)
MIME-Version: 1.0
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
In-Reply-To: <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
From: Song Liu <song@kernel.org>
Date: Wed, 24 Feb 2021 01:09:18 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
Message-ID: <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 25 Feb 2021 04:27:13 -0500
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
	it+raid@molgen.mpg.de, Donald Buczek <buczek@molgen.mpg.de>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
	reconfig_mutex held
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> [+cc Donald]
>
> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
> > Unregister sync_thread doesn't need to hold reconfig_mutex since it
> > doesn't reconfigure array.
> >
> > And it could cause deadlock problem for raid5 as follows:
> >
> > 1. process A tried to reap sync thread with reconfig_mutex held after echo
> >     idle to sync_action.
> > 2. raid5 sync thread was blocked if there were too many active stripes.
> > 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
> >     which causes the number of active stripes can't be decreased.
> > 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
> >     to hold reconfig_mutex.
> >
> > More details in the link:
> > https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> >
> > And add one parameter to md_reap_sync_thread since it could be called by
> > dm-raid which doesn't hold reconfig_mutex.
> >
> > Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> > Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

I don't really like this fix. But I haven't got a better (and not too
complicated)
alternative.

> > ---
> > V2:
> > 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
> >
> >   drivers/md/dm-raid.c |  2 +-
> >   drivers/md/md.c      | 14 +++++++++-----
> >   drivers/md/md.h      |  2 +-
> >   3 files changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index cab12b2..0c4cbba 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
> >       if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
> >               if (mddev->sync_thread) {
> >                       set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> > -                     md_reap_sync_thread(mddev);
> > +                     md_reap_sync_thread(mddev, false);

I think we can add mddev_lock() and mddev_unlock() here and then we don't
need the extra parameter?

Thanks,
Song

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

