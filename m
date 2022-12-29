Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395F9C54EF1
	for <dm-devel@archiver.kernel.org>; Mon,  2 Jan 2023 07:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672645391;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g0JU63xJD3KVhzalZw1ZEM/QQ8h34qNvuRaDAjSobjQ=;
	b=S//yOOytrw0PT4BhbGLXLuQEP8opnhFA79ECiSDAGoTqOvkw6hBPuUroXZKaNtmw5f3kDd
	gppbdGEXrepkH8J/FQc65CnWfz17gYytnU8I3sajsmk2DhVuNRtQpKBLFwAWXv94AknXQ7
	7sLKAZtLr5qUS42FxkpErmY7IL1uY1I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-Uyu3TzYhPLyNcywisf6vZA-1; Mon, 02 Jan 2023 02:43:08 -0500
X-MC-Unique: Uyu3TzYhPLyNcywisf6vZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 213B380D0F0;
	Mon,  2 Jan 2023 07:43:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DC39BC1602E;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C27E1946A40;
	Mon,  2 Jan 2023 07:43:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 935081946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Dec 2022 08:22:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68934C15E7F; Thu, 29 Dec 2022 08:22:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6158DC159BB
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:22:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 451832A5954B
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 08:22:46 +0000 (UTC)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com
 [209.85.208.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-zs-RIQvvN6OZg2XvNprd8A-1; Thu, 29 Dec 2022 03:22:44 -0500
X-MC-Unique: zs-RIQvvN6OZg2XvNprd8A-1
Received: by mail-ed1-f51.google.com with SMTP id g1so11585456edj.8
 for <dm-devel@redhat.com>; Thu, 29 Dec 2022 00:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=cdbk6YKET6QEGq9IebYDQMQPZF6j/6rc109njHhKlvI=;
 b=QpNyKT/PpoCfmIyRPQ5GhW9ezxIVTRchG6mi/7kQ8fDkWeWwC4Wp5gPkyx4/uF4qAW
 NsWjApiDn684/h5VyPp/zbc73LiJSjME/1u+Elq7COK0dt7nHo4ib82b/BoX/5m19FHy
 94pMxowEA1NYpWsWwfkG7rv3DrHJYx5D/J5WhU7ygeym9e8ZxFZErzZeqpJTV4nq8kx+
 saSUjnd0hU3Fw7Bb9HRA3ilGC0sIGDID9i1yNUXXlB+6m5PJbxDv0VoTEUU7GyAOnXrE
 XszRvk5SekBcmw0AqFkLFI82PjtZNGdNJCfs+92mVHT9IBYs5p4RwGquX5bpx+Z916+e
 HKDw==
X-Gm-Message-State: AFqh2kq5E0mT8riE2Gp+k1Yh0jrw+z4QTaa37cAaiPhLlCn7xNrjH7ta
 zU/2apqK2qbYUtx1SmoT8C+gq5VHyw9g2oRYOUVoCw==
X-Google-Smtp-Source: AMrXdXsQ7w+8O+47UlcrH/eyB1AcY+iw3zi67xHAp19yIp7KZoxSU3hceHOEF+dEFVjlYfKxx8GN7IxiiG1wtM0JlDA=
X-Received: by 2002:a05:6402:1654:b0:47f:e663:1d78 with SMTP id
 s20-20020a056402165400b0047fe6631d78mr1566473edx.237.1672302162986; Thu, 29
 Dec 2022 00:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-3-sarthakkukreti@google.com>
 <Yy3BXc9wf4PH6Rby@redhat.com>
In-Reply-To: <Yy3BXc9wf4PH6Rby@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 29 Dec 2022 00:22:32 -0800
Message-ID: <CAG9=OMMgtscWZyZYHsY0pp-9we+yxs=88sr_yMb6pfz7e75nyA@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Mon, 02 Jan 2023 07:42:59 +0000
Subject: Re: [dm-devel] [PATCH RFC 2/8] dm: Add support for block
 provisioning
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-ext4@vger.kernel.org,
 Evan Green <evgreen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 23, 2022 at 7:23 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Thu, Sep 15 2022 at 12:48P -0400,
> Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:
>
> > From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> >
> > Add support to dm devices for REQ_OP_PROVISION. The default mode
> > is to pass through the request and dm-thin will utilize it to provision
> > blocks.
> >
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> > ---
> >  drivers/md/dm-crypt.c         |  4 +-
> >  drivers/md/dm-linear.c        |  1 +
> >  drivers/md/dm-table.c         | 17 +++++++
> >  drivers/md/dm-thin.c          | 86 +++++++++++++++++++++++++++++++++--
> >  drivers/md/dm.c               |  4 ++
> >  include/linux/device-mapper.h |  6 +++
> >  6 files changed, 113 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 159c6806c19b..357f0899cfb6 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -3081,6 +3081,8 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
> >       if (ret)
> >               return ret;
> >
> > +     ti->num_provision_bios = 1;
> > +
> >       while (opt_params--) {
> >               opt_string = dm_shift_arg(&as);
> >               if (!opt_string) {
> > @@ -3384,7 +3386,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
> >        * - for REQ_OP_DISCARD caller must use flush if IO ordering matters
> >        */
> >       if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
> > -         bio_op(bio) == REQ_OP_DISCARD)) {
> > +         bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_PROVISION)) {
> >               bio_set_dev(bio, cc->dev->bdev);
> >               if (bio_sectors(bio))
> >                       bio->bi_iter.bi_sector = cc->start +
> > diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> > index 3212ef6aa81b..1aa782149428 100644
> > --- a/drivers/md/dm-linear.c
> > +++ b/drivers/md/dm-linear.c
> > @@ -61,6 +61,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >       ti->num_discard_bios = 1;
> >       ti->num_secure_erase_bios = 1;
> >       ti->num_write_zeroes_bios = 1;
> > +     ti->num_provision_bios = 1;
> >       ti->private = lc;
> >       return 0;
> >
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 332f96b58252..b7f9cb66b7ba 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1853,6 +1853,18 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
> >       return true;
> >  }
> >
> > +static bool dm_table_supports_provision(struct dm_table *t)
> > +{
> > +     for (unsigned int i = 0; i < t->num_targets; i++) {
> > +             struct dm_target *ti = dm_table_get_target(t, i);
> > +
> > +             if (ti->num_provision_bios)
> > +                     return true;
> > +     }
> > +
> > +     return false;
> > +}
> > +
>
> This needs to go a step further and verify a device in the stack
> actually services REQ_OP_PROVISION.
>
> Please see dm_table_supports_discards(): it iterates all devices in
> the table and checks that support is advertised.
>
> For discard, DM requires that _all_ devices in a table advertise
> support (that is pretty strict and likely could be relaxed to _any_).
>
> You'll need ti->provision_supported (like ->discards_supported) to
> advertise actual support is provided by dm-thinp (even if underlying
> devices don't support it).
>
> And yeah, dm-thinp passdown support for REQ_OP_PROVISION can follow
> later as needed (if there actual HW that would benefit from
> REQ_OP_PROVISION).
>
Done, thanks (the provision support, not the passdown)! I think the
one case where passdown might help is to build images with dm-thinp
already set up on one of the partitions (I have something in the works
for ChromiumOS images to do VM tests with preset state :)). That would
allow us to preallocate space for thin logical volumes inside the
image file.

> Mike
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

