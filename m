Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB17C43334
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 23:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657842179;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BbqPxMgF94MZ6sm7WIQ4LFofvC/xriWzBhX7dzeY5OE=;
	b=Htd438yssbXCV5ZycxYRKRsg1ac+rAtJ+1e3yeIITqwygxP91C+oA1i8OFn8poPBBm5RQh
	z1W/1bUxpjxWQif0fT34bQ4PvV9+0C0M1AW1PUlMFMP2uzvGu4TAIrIH0k4TPqB5I0cgU7
	jiK6o+E56mTUc+cv+jxUUs/lHUyePpg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-IdloauXXOHOwt7xb9tLvYw-1; Thu, 14 Jul 2022 19:42:56 -0400
X-MC-Unique: IdloauXXOHOwt7xb9tLvYw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 599D8801755;
	Thu, 14 Jul 2022 23:42:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97DF8492CA2;
	Thu, 14 Jul 2022 23:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78F3B1947071;
	Thu, 14 Jul 2022 23:42:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96D1D194706D
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 23:42:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 75980492CA2; Thu, 14 Jul 2022 23:42:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7174B492C3B
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 23:42:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57B1F185A794
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 23:42:53 +0000 (UTC)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com
 [209.85.128.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-Ev2p99W_NN-ysIoVUAqLAQ-1; Thu, 14 Jul 2022 19:42:51 -0400
X-MC-Unique: Ev2p99W_NN-ysIoVUAqLAQ-1
Received: by mail-yw1-f173.google.com with SMTP id
 00721157ae682-31df2545d87so9627977b3.10
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 16:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=hrcyqVkvy4izwFpTLzF8br5+AKNersnOh/LCuMYgV0U=;
 b=2l17cVhOYiZ0dtlZ1x1Kjk28OzxRa+R3Tq/fGoKYYQd0Ge8kimeve+oDYMNRnw8J4o
 BrBIZWWj5GrzizzJHWV3M/1uLUnQPjzHAcwBamZ4koqKJXLrKHs870A5D3nA8YHk5qMD
 8zs4jjDOMfddF02RDsg1582+UG+njy+mCxUbr/g6MAj86drL9sq3qDPgUqdBGeqSbrue
 R68RtHU+wqa0o9RA1RbkrcxVRcZ6psGpXKOSgGYeDsDg2A4MxS9p72ZpEgF9BrwLGr+j
 SKaT+8Ft8aN1/uEv3pkSfWTERzxv8yiNksUkNAYEek8ch/OQSJIxJEWyQbsLLTpWSAkZ
 mSMA==
X-Gm-Message-State: AJIora9G0BHzTjglsQXTEHCo8JNisqardVsZnjtdiOq4oZ6EFIJLQaa1
 LQ4dpAbu4nahaiuc1hNwD+SV/krUBtgENFW3EDPm+A==
X-Google-Smtp-Source: AGRyM1swk3ZebWHTl5akundABJu3szM9NM1kLcNezSZ8tPiefLK5HQYfShJehVqnXx5XxLK+oiQC7CJN42AWYT7KO+M=
X-Received: by 2002:a0d:f147:0:b0:31c:c8fd:7160 with SMTP id
 a68-20020a0df147000000b0031cc8fd7160mr12868565ywf.420.1657842170848; Thu, 14
 Jul 2022 16:42:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
 <YtB45Lte5UhlEE6y@redhat.com>
In-Reply-To: <YtB45Lte5UhlEE6y@redhat.com>
From: Daniil Lunev <dlunev@chromium.org>
Date: Fri, 15 Jul 2022 09:42:39 +1000
Message-ID: <CAONX=-dEG121RQ6L-4fPMXrLXb3JeYNVNiPzHXNaRLbwRzb3bw@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 1/1] dm: add message command to disallow
 device open
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
Cc: dm-devel@redhat.com, Brian Geffon <bgeffon@google.com>,
 Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike,
Thank you for your response. I should have probably added more context
to the commit message that I specified in the cover letter. The idea is to
prohibit access of all userspace, including the root. The main concern here
is potential system applications' vulnerabilities that can trick the system to
operate on non-intended files with elevated permissions. While those could
also be exploited to get more access to the regular file systems, those firstly
has to be useable by userspace for normal system operation (e.g. to store
user data), secondly, never contain plain text secrets. Swap content is a
different story - access to it can leak very sensitive information, which
otherwise is never available as plaintext on any persistent media - e.g. raw
user secrets, raw disk encryption keys etc, other security related tokens.
Thus we propose a mechanism to enable such a lockdown after necessary
configuration has been done to the device at boot time.
--Daniil

On Fri, Jul 15, 2022 at 6:13 AM Mike Snitzer <snitzer@kernel.org> wrote:
>
> On Sun, Jul 03 2022 at  8:02P -0400,
> Daniil Lunev <dlunev@chromium.org> wrote:
>
> > A message can be passed to device mapper to prohibit open on a certain
> > mapped device. This makes possible to disallow userspace access to
> > raw swapped data if the system uses device mapper to encrypt it at rest.
> >
> > Signed-off-by: Daniil Lunev <dlunev@chromium.org>
>
> This commit header and patch make little sense to me.
>
> If you're concerned about a normal (non-root) user having read access
> to the swap device then disallow non-root user access permissions on
> the swap device.
>
> Why is an encrypted swap device any different than any other encrypted
> device?
>
> As is, this patch seems to be the wrong way to achieve your desired
> result.  If you or someone else on the chromium team can better
> defend/explain the need for this change please do so.
>
> Thanks,
> Mike
>
>
> > ---
> >
> >  drivers/md/dm-core.h          |  1 +
> >  drivers/md/dm-ioctl.c         | 10 ++++++++++
> >  drivers/md/dm.c               | 12 ++++++++++++
> >  drivers/md/dm.h               | 10 ++++++++++
> >  include/uapi/linux/dm-ioctl.h |  5 +++++
> >  5 files changed, 38 insertions(+)
> >
> > diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> > index 4277853c75351..37529b605b7c4 100644
> > --- a/drivers/md/dm-core.h
> > +++ b/drivers/md/dm-core.h
> > @@ -140,6 +140,7 @@ struct mapped_device {
> >  #define DMF_SUSPENDED_INTERNALLY 7
> >  #define DMF_POST_SUSPENDING 8
> >  #define DMF_EMULATE_ZONE_APPEND 9
> > +#define DMF_DISALLOW_OPEN 10
> >
> >  void disable_discard(struct mapped_device *md);
> >  void disable_write_zeroes(struct mapped_device *md);
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index 87310fceb0d86..e35d560aa2ff3 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -815,6 +815,9 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
> >       if (dm_test_deferred_remove_flag(md))
> >               param->flags |= DM_DEFERRED_REMOVE;
> >
> > +     if (dm_test_disallow_open_flag(md))
> > +             param->flags |= DM_DISALLOWED_OPEN;
> > +
> >       param->dev = huge_encode_dev(disk_devt(disk));
> >
> >       /*
> > @@ -1656,6 +1659,13 @@ static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
> >               }
> >               return dm_cancel_deferred_remove(md);
> >       }
> > +     if (!strcasecmp(argv[0], "@disallow_open")) {
> > +             if (argc != 1) {
> > +                     DMERR("Invalid arguments for @disallow_open");
> > +                     return -EINVAL;
> > +             }
> > +             return dm_disallow_open(md);
> > +     }
> >
> >       r = dm_stats_message(md, argc, argv, result, maxlen);
> >       if (r < 2)
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 82957bd460e89..3e53d1bd40f0c 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -327,6 +327,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
> >               goto out;
> >
> >       if (test_bit(DMF_FREEING, &md->flags) ||
> > +         test_bit(DMF_DISALLOW_OPEN, &md->flags) ||
> >           dm_deleting_md(md)) {
> >               md = NULL;
> >               goto out;
> > @@ -403,6 +404,12 @@ int dm_cancel_deferred_remove(struct mapped_device *md)
> >       return r;
> >  }
> >
> > +int dm_disallow_open(struct mapped_device *md)
> > +{
> > +     set_bit(DMF_DISALLOW_OPEN, &md->flags);
> > +     return 0;
> > +}
> > +
> >  static void do_deferred_remove(struct work_struct *w)
> >  {
> >       dm_deferred_remove();
> > @@ -2883,6 +2890,11 @@ int dm_test_deferred_remove_flag(struct mapped_device *md)
> >       return test_bit(DMF_DEFERRED_REMOVE, &md->flags);
> >  }
> >
> > +int dm_test_disallow_open_flag(struct mapped_device *md)
> > +{
> > +     return test_bit(DMF_DISALLOW_OPEN, &md->flags);
> > +}
> > +
> >  int dm_suspended(struct dm_target *ti)
> >  {
> >       return dm_suspended_md(ti->table->md);
> > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > index 9013dc1a7b002..da27f9dfe1413 100644
> > --- a/drivers/md/dm.h
> > +++ b/drivers/md/dm.h
> > @@ -163,6 +163,16 @@ int dm_test_deferred_remove_flag(struct mapped_device *md);
> >   */
> >  void dm_deferred_remove(void);
> >
> > +/*
> > + * Test if the device is openable.
> > + */
> > +int dm_test_disallow_open_flag(struct mapped_device *md);
> > +
> > +/*
> > + * Prevent new open request on the device.
> > + */
> > +int dm_disallow_open(struct mapped_device *md);
> > +
> >  /*
> >   * The device-mapper can be driven through one of two interfaces;
> >   * ioctl or filesystem, depending which patch you have applied.
> > diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
> > index 2e9550fef90fa..3b4d12d09c005 100644
> > --- a/include/uapi/linux/dm-ioctl.h
> > +++ b/include/uapi/linux/dm-ioctl.h
> > @@ -382,4 +382,9 @@ enum {
> >   */
> >  #define DM_IMA_MEASUREMENT_FLAG      (1 << 19) /* In */
> >
> > +/*
> > + * If set, the device can not be opened.
> > + */
> > +#define DM_DISALLOWED_OPEN   (1 << 20) /* Out */
> > +
> >  #endif                               /* _LINUX_DM_IOCTL_H */
> > --
> > 2.31.0
> >

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

