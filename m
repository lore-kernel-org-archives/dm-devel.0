Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74B3C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 19:09:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7048364F7B
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 19:09:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7048364F7B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615576197;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZCSCIl14sznvDdcS1OlaBaW6o8DR1jWghmiGYeu1tEk=;
	b=FiriU6rYvUI8oC8B9pyNmLiXtBD29xNHtR6PRBsYrHvK4Wl7ozW/pqVdLbVbLCOlEs4zLx
	iOK5lSBrihCTZ4zuK+IqmyenrV1IUNzVdfnUkX9nIw52asC9Or+ot09lOT7vkBed8UV3Z4
	dgW/Bx8BmolyGvxc/aM0UYha2p5xVEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-vfDZBhILMOCNHdMjIws3Qg-1; Fri, 12 Mar 2021 14:09:54 -0500
X-MC-Unique: vfDZBhILMOCNHdMjIws3Qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 927F584B9A1;
	Fri, 12 Mar 2021 19:09:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 461FD10016FB;
	Fri, 12 Mar 2021 19:09:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 095741800232;
	Fri, 12 Mar 2021 19:09:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12CJ9muL008040 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 14:09:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2375460918; Fri, 12 Mar 2021 19:09:48 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0B7760CDE;
	Fri, 12 Mar 2021 19:09:47 +0000 (UTC)
Date: Fri, 12 Mar 2021 14:09:46 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20210312190946.GA2591@redhat.com>
References: <20210310082547.576372-1-shinichiro.kawasaki@wdc.com>
	<20210311175440.GA28509@redhat.com>
	<BL0PR04MB6514474389D7E7EEAC82B2CBE7909@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB6514474389D7E7EEAC82B2CBE7909@BL0PR04MB6514.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm table: Fix zoned model check and zone sectors
	check
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

On Thu, Mar 11 2021 at  6:30pm -0500,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:

> On 2021/03/12 2:54, Mike Snitzer wrote:
> > On Wed, Mar 10 2021 at  3:25am -0500,
> > Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com> wrote:
> > 
> >> Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
> >> capability checks") triggered dm table load failure when dm-zoned device
> >> is set up for zoned block devices and a regular device for cache.
> >>
> >> The commit inverted logic of two callback functions for iterate_devices:
> >> device_is_zoned_model() and device_matches_zone_sectors(). The logic of
> >> device_is_zoned_model() was inverted then all destination devices of all
> >> targets in dm table are required to have the expected zoned model. This
> >> is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
> >> since each target has only one destination device. However, this results
> >> in failure for dm-zoned with regular cache device since that target has
> >> both regular block device and zoned block devices.
> >>
> >> As for device_matches_zone_sectors(), the commit inverted the logic to
> >> require all zoned block devices in each target have the specified
> >> zone_sectors. This check also fails for regular block device which does
> >> not have zones.
> >>
> >> To avoid the check failures, fix the zone model check and the zone
> >> sectors check. For zone model check, invert the device_is_zoned_model()
> >> logic again to require at least one destination device in one target has
> >> the specified zoned model. For zone sectors check, skip the check if the
> >> destination device is not a zoned block device. Also add comments and
> >> improve error messages to clarify expectations to the two checks.
> >>
> >> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> >> Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
> >> ---
> >>  drivers/md/dm-table.c | 21 +++++++++++++++------
> >>  1 file changed, 15 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> >> index 95391f78b8d5..04b7a3978ef8 100644
> >> --- a/drivers/md/dm-table.c
> >> +++ b/drivers/md/dm-table.c
> >> @@ -1585,13 +1585,13 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
> >>  	return true;
> >>  }
> >>  
> >> -static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
> >> -				  sector_t start, sector_t len, void *data)
> >> +static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
> >> +				 sector_t start, sector_t len, void *data)
> >>  {
> >>  	struct request_queue *q = bdev_get_queue(dev->bdev);
> >>  	enum blk_zoned_model *zoned_model = data;
> >>  
> >> -	return blk_queue_zoned_model(q) != *zoned_model;
> >> +	return blk_queue_zoned_model(q) == *zoned_model;
> >>  }
> >>  
> >>  static bool dm_table_supports_zoned_model(struct dm_table *t,
> >> @@ -1608,7 +1608,7 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
> >>  			return false;
> >>  
> >>  		if (!ti->type->iterate_devices ||
> >> -		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
> >> +		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
> >>  			return false;
> >>  	}
> > 
> > The point here is to ensure all zoned devices match the specific model,
> > right?
> > 
> > I understand commit 24f6b6036c9e wasn't correct, sorry about that.
> > But I don't think your change is correct either.  It'll allow a mix of
> > various zoned models (that might come after the first positive match for
> > the specified zoned_model)... but because the first match short-circuits
> > the loop those later mismatched zoned devices aren't checked.
> > 
> > Should device_is_zoned_model() also be trained to ignore BLK_ZONED_NONE
> > (like you did below)?
> 
> Thinking more about this, I think we may have a deeper problem here. We need to
> allow the combination of BLK_ZONED_NONE and BLK_ZONED_HM for dm-zoned multi
> drive config using a regular SSD as cache. But blindly allowing such combination
> of zoned and non-zoned drives will also end up allowing a setup combining these
> drive types with dm-linear or dm-flakey or any other target that has the
> DM_TARGET_ZONED_HM feature flag set. And that will definitely be bad and break
> things if the target is not prepared for that.
> 
> Should we introduce a new feature flag ? Something like DM_TARGET_MIXED_ZONED_HM
> ? (not sure about the name of the flag. Suggestions ?)
> We can then refine the validation and keep it as is (no mixed drive types) for a
> target that has DM_TARGET_ZONED_HM, and allow mixing drive types if the target
> has DM_TARGET_MIXED_ZONED_HM. This last case would be dm-zoned only for now.
> Thoughts ?

Think I'll struggle to give you a great answer until I understand which
target(s) would be setting DM_TARGET_MIXED_ZONED_HM (or whatever name).

I'll defer to you to sort out how best to validate only the supported
configs are allowed.  I trust you! ;)

Think this an instance where a patch (RFC or otherwise) would be quicker
way to discuss.

Thanks,
Mike

> 
> > 
> > But _not_ invert the logic, so keep device_not_zoned_model.. otherwise
> > the first positive return of a match will short-circuit checking all
> > other devices match.
> > 
> >>  
> >> @@ -1621,9 +1621,18 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
> >>  	struct request_queue *q = bdev_get_queue(dev->bdev);
> >>  	unsigned int *zone_sectors = data;
> >>  
> >> +	if (blk_queue_zoned_model(q) == BLK_ZONED_NONE)
> >> +		return 0;
> >> +
> >>  	return blk_queue_zone_sectors(q) != *zone_sectors;
> >>  }
> > 
> > Thanks,
> > Mike
> > 
> > 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

