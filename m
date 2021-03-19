Return-Path: <SRS0=txDK=IU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1A4C433C1
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 07:13:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D21C76196E
	for <dm-devel@archiver.kernel.org>; Mon, 22 Mar 2021 07:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D21C76196E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-3FWmqALdMf6YqaK9xGxmEg-1; Mon, 22 Mar 2021 03:13:06 -0400
X-MC-Unique: 3FWmqALdMf6YqaK9xGxmEg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 075498189CB;
	Mon, 22 Mar 2021 07:13:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD39760C0F;
	Mon, 22 Mar 2021 07:13:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D6B54180B450;
	Mon, 22 Mar 2021 07:12:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12JN0iCS025870 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Mar 2021 19:00:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6837E10545BE; Fri, 19 Mar 2021 23:00:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63C7E1054E2E
	for <dm-devel@redhat.com>; Fri, 19 Mar 2021 23:00:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63DA51010365
	for <dm-devel@redhat.com>; Fri, 19 Mar 2021 23:00:41 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-428-M0pdtPKTMpSN-t2afipSig-1;
	Fri, 19 Mar 2021 19:00:35 -0400
X-MC-Unique: M0pdtPKTMpSN-t2afipSig-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A4F06197E;
	Fri, 19 Mar 2021 23:00:34 +0000 (UTC)
Received: by mail-lf1-f46.google.com with SMTP id o10so12392608lfb.9;
	Fri, 19 Mar 2021 16:00:34 -0700 (PDT)
X-Gm-Message-State: AOAM531lHFIxycau+82bJfafUCGFqXmXcsgae9wNB/OA1T0ncL82BeEr
	WpPdW4ESoq6HQ+33xKEISw8J1Mx+T2v1ATr21cs=
X-Google-Smtp-Source: ABdhPJyuYpsBckXvuNGEwrJFRxOMsLjC17aINViOKRnv3rEyRl44Dyv9TvN5AqSbrH/x7YstV/yjnxFmW3yF2TJTtkM=
X-Received: by 2002:a05:6512:3582:: with SMTP id
	m2mr2121239lfr.10.1616194832629; 
	Fri, 19 Mar 2021 16:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
	<9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
In-Reply-To: <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
From: Song Liu <song@kernel.org>
Date: Fri, 19 Mar 2021 16:00:21 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
Message-ID: <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 22 Mar 2021 03:12:32 -0400
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Mike Snitzer <snitzer@redhat.com>,
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

On Wed, Feb 24, 2021 at 1:26 AM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
>
>
> On 2/24/21 10:09, Song Liu wrote:
> > On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
> >>
> >> [+cc Donald]
> >>
> >> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
> >>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
> >>> doesn't reconfigure array.
> >>>
> >>> And it could cause deadlock problem for raid5 as follows:
> >>>
> >>> 1. process A tried to reap sync thread with reconfig_mutex held after echo
> >>>      idle to sync_action.
> >>> 2. raid5 sync thread was blocked if there were too many active stripes.
> >>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
> >>>      which causes the number of active stripes can't be decreased.
> >>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
> >>>      to hold reconfig_mutex.
> >>>
> >>> More details in the link:
> >>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> >>>
> >>> And add one parameter to md_reap_sync_thread since it could be called by
> >>> dm-raid which doesn't hold reconfig_mutex.
> >>>
> >>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
> >>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> >
> > I don't really like this fix. But I haven't got a better (and not too
> > complicated)
> > alternative.
> >
> >>> ---
> >>> V2:
> >>> 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
> >>>
> >>>    drivers/md/dm-raid.c |  2 +-
> >>>    drivers/md/md.c      | 14 +++++++++-----
> >>>    drivers/md/md.h      |  2 +-
> >>>    3 files changed, 11 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>> index cab12b2..0c4cbba 100644
> >>> --- a/drivers/md/dm-raid.c
> >>> +++ b/drivers/md/dm-raid.c
> >>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
> >>>        if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
> >>>                if (mddev->sync_thread) {
> >>>                        set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> >>> -                     md_reap_sync_thread(mddev);
> >>> +                     md_reap_sync_thread(mddev, false);
> >
> > I think we can add mddev_lock() and mddev_unlock() here and then we don't
> > need the extra parameter?
> >
>
> I thought it too, but I would prefer get the input from DM people first.
>
> @ Mike or Alasdair

Hi Mike and Alasdair,

Could you please comment on this option: adding mddev_lock() and mddev_unlock()
to raid_message() around md_reap_sync_thread()?

Thanks,
Song

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

