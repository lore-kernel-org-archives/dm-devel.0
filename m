Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA7FC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 13:47:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9043865016
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 13:47:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9043865016
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615902459;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Xn1KHT7x184vjzO++h7JoQpGZiKYpP327uTGjhsJP+o=;
	b=byDq03OSB/z0T3alsqdVbVfqOHLuyG4qzePwIvd0J/p00u0YdZeSF3CT516NGkyePnXern
	VPUaymB1EdjfzkJcpzw8hlZFbH7GsH5PbK52reeUILrNiNv740in3P5s7dI++9BFC3UqCM
	B+3FDaie93Bef5sSgBfgfa9Yq1wc2wQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-z4TNsQ1nNxmz9J82TOminA-1; Tue, 16 Mar 2021 09:47:37 -0400
X-MC-Unique: z4TNsQ1nNxmz9J82TOminA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C2B88030B5;
	Tue, 16 Mar 2021 13:47:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F19C9101E24F;
	Tue, 16 Mar 2021 13:47:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B814C4A717;
	Tue, 16 Mar 2021 13:47:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12GDlLin008202 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 09:47:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 35A5D6091A; Tue, 16 Mar 2021 13:47:21 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F01B60CCC;
	Tue, 16 Mar 2021 13:47:17 +0000 (UTC)
Date: Tue, 16 Mar 2021 09:47:16 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20210316134716.GA23081@redhat.com>
References: <20210316043602.1208915-1-shinichiro.kawasaki@wdc.com>
	<BL0PR04MB6514D80C4CDFE34F1A293397E76B9@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB6514D80C4CDFE34F1A293397E76B9@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm table: Fix zoned model check and zone
	sectors check
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

On Tue, Mar 16 2021 at  2:14am -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2021/03/16 13:36, Shin'ichiro Kawasaki wrote:
> > Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
> > capability checks") triggered dm table load failure when dm-zoned device
> > is set up for zoned block devices and a regular device for cache.
> > 
> > The commit inverted logic of two callback functions for iterate_devices:
> > device_is_zoned_model() and device_matches_zone_sectors(). The logic of
> > device_is_zoned_model() was inverted then all destination devices of all
> > targets in dm table are required to have the expected zoned model. This
> > is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
> > since each target has only one destination device. However, this results
> > in failure for dm-zoned with regular cache device since that target has
> > both regular block device and zoned block devices.
> > 
> > As for device_matches_zone_sectors(), the commit inverted the logic to
> > require all zoned block devices in each target have the specified
> > zone_sectors. This check also fails for regular block device which does
> > not have zones.
> > 
> > To avoid the check failures, fix the zone model check and the zone
> > sectors check. For zone model check, introduce the new feature flag
> > DM_TARGET_MIXED_ZONED_MODEL, and set it to dm-zoned target. When the
> > target has this flag, allow it to have destination devices with any
> > zoned model. For zone sectors check, skip the check if the destination
> > device is not a zoned block device. Also add comments and improve an
> > error message to clarify expectations to the two checks.
> > 
> > Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> > ---
> > Changes from v1:
> > * Added DM_TARGET_MIXED_ZONED_MODEL feature for zoned model check of dm-zoned
> > 
> >  drivers/md/dm-table.c         | 34 ++++++++++++++++++++++++++--------
> >  drivers/md/dm-zoned-target.c  |  2 +-
> >  include/linux/device-mapper.h | 15 ++++++++++++++-
> >  3 files changed, 41 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 95391f78b8d5..cc73d5b473eb 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1594,6 +1594,13 @@ static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
> >  	return blk_queue_zoned_model(q) != *zoned_model;
> >  }
> >  
> > +/*
> > + * Check the device zoned model based on the target feature flag. If the target
> > + * has the DM_TARGET_ZONED_HM feature flag set, host-managed zoned devices are
> > + * also accepted but all devices must have the same zoned model. If the target
> > + * has the DM_TARGET_MIXED_ZONED_MODEL feature set, the devices can have any
> > + * zoned model with all zoned devices having the same zone size.
> > + */
> >  static bool dm_table_supports_zoned_model(struct dm_table *t,
> >  					  enum blk_zoned_model zoned_model)
> >  {
> > @@ -1603,13 +1610,16 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
> >  	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> >  		ti = dm_table_get_target(t, i);
> >  
> > -		if (zoned_model == BLK_ZONED_HM &&
> > -		    !dm_target_supports_zoned_hm(ti->type))
> > -			return false;
> > -
> > -		if (!ti->type->iterate_devices ||
> > -		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
> > -			return false;
> > +		if (dm_target_supports_zoned_hm(ti->type)) {
> > +			if (!ti->type->iterate_devices ||
> > +			    ti->type->iterate_devices(ti,
> > +						      device_not_zoned_model,
> > +						      &zoned_model))
> > +				return false;
> > +		} else if (!dm_target_supports_mixed_zoned_model(ti->type)) {
> > +			if (zoned_model == BLK_ZONED_HM)
> > +				return false;
> > +		}
> >  	}
> >  
> >  	return true;
> > @@ -1621,9 +1631,17 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
> >  	struct request_queue *q = bdev_get_queue(dev->bdev);
> >  	unsigned int *zone_sectors = data;
> >  
> > +	if (!blk_queue_is_zoned(q))
> > +		return 0;
> > +
> >  	return blk_queue_zone_sectors(q) != *zone_sectors;
> >  }
> >  
> > +/*
> > + * Check consistency of zoned model and zone sectors across all targets. For
> > + * zone sectors, if the destination device is a zoned block device, it shall
> > + * have the specified zone_sectors.
> > + */
> >  static int validate_hardware_zoned_model(struct dm_table *table,
> >  					 enum blk_zoned_model zoned_model,
> >  					 unsigned int zone_sectors)
> > @@ -1642,7 +1660,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
> >  		return -EINVAL;
> >  
> >  	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
> > -		DMERR("%s: zone sectors is not consistent across all devices",
> > +		DMERR("%s: zone sectors is not consistent across all zoned devices",
> >  		      dm_device_name(table->md));
> >  		return -EINVAL;
> >  	}
> > diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> > index 697f9de37355..7e88df64d197 100644
> > --- a/drivers/md/dm-zoned-target.c
> > +++ b/drivers/md/dm-zoned-target.c
> > @@ -1143,7 +1143,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
> >  static struct target_type dmz_type = {
> >  	.name		 = "zoned",
> >  	.version	 = {2, 0, 0},
> > -	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
> > +	.features	 = DM_TARGET_SINGLETON | DM_TARGET_MIXED_ZONED_MODEL,
> 
> Thinking about it, DM_TARGET_SINGLETON is wrong for dm-zoned now that we can
> create devices using multiple devices... But it does not seem to matter much
> since it really looks like this flag is totally unused/unchecked by DM core.
> Maybe something we can remove in a followup cleanup ? Mike ?

Not sure why you think it unused, drivers/md/dm-table.c:dm_table_add_target:

        if (t->singleton) {
                DMERR("%s: target type %s must appear alone in table",
                      dm_device_name(t->md), t->targets->type->name);
                return -EINVAL;
        }

        ...

        if (dm_target_needs_singleton(tgt->type)) {
                if (t->num_targets) {
                        tgt->error = "singleton target type must appear alone in table";
                        goto bad;
                }
                t->singleton = true;
        }

So it really should be causing problems if you do in fact support/need
multiple targets combined with "zoned".

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

