Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6350EC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 15:05:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-2NNLW3NeNliP08pSq06_dw-1; Thu, 06 Jan 2022 10:04:54 -0500
X-MC-Unique: 2NNLW3NeNliP08pSq06_dw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DA93802E64;
	Thu,  6 Jan 2022 15:04:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27D99108646E;
	Thu,  6 Jan 2022 15:04:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5F5F4A70D;
	Thu,  6 Jan 2022 15:04:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206F4Za7029055 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 10:04:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 531781410DD6; Thu,  6 Jan 2022 15:04:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E571140EBFE
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 15:04:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34B6580A0B1
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 15:04:35 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-523-pYHeeVksOM-Ga-dsJ5cgzQ-1; Thu, 06 Jan 2022 10:04:33 -0500
X-MC-Unique: pYHeeVksOM-Ga-dsJ5cgzQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id B8FC5B82225;
	Thu,  6 Jan 2022 15:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C8EC36AE0;
	Thu,  6 Jan 2022 15:04:29 +0000 (UTC)
Date: Thu, 6 Jan 2022 16:04:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YdcE+9ppXYnPzijZ@kroah.com>
References: <20220106100231.3278554-1-gregkh@linuxfoundation.org>
	<Ydb7xzmOC8VN8miQ@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Ydb7xzmOC8VN8miQ@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] dm sysfs: use default_groups in kobj_type
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 06, 2022 at 09:25:11AM -0500, Mike Snitzer wrote:
> On Thu, Jan 06 2022 at  5:02P -0500,
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > There are currently 2 ways to create a set of sysfs files for a
> > kobj_type, through the default_attrs field, and the default_groups
> > field.  Move the dm sysfs code to use default_groups field which has
> > been the preferred way since aa30f47cf666 ("kobject: Add support for
> > default attribute groups to kobj_type") so that we can soon get rid of
> > the obsolete default_attrs field.
> > 
> > Cc: Alasdair Kergon <agk@redhat.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Cc: dm-devel@redhat.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/md/dm-sysfs.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
> > index a05fcd50e1b9..e28c92478536 100644
> > --- a/drivers/md/dm-sysfs.c
> > +++ b/drivers/md/dm-sysfs.c
> > @@ -112,6 +112,7 @@ static struct attribute *dm_attrs[] = {
> >  	&dm_attr_rq_based_seq_io_merge_deadline.attr,
> >  	NULL,
> >  };
> > +ATTRIBUTE_GROUPS(dm);
> 
> Bit strange to pass "dm" but then have ATTRIBUTE_GROUPS assume dm_attrs defined.
> Feels like it'll invite janitors sending patches, that they never
> compile, to remove dm_attrs.

0-day would instantly catch that :)

That's the way the ATTRIBUTE_GROUPS() macro works.  It's tricky, yes,
and I don't like it all that much, but couldn't come up with a better
way at the time.  It saves lots and lots of boiler-plate code from
having to be typed all the time.

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

