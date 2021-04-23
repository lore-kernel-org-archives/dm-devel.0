Return-Path: <SRS0=sZ2e=JU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AA3C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 23 Apr 2021 02:39:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 002D661445
	for <dm-devel@archiver.kernel.org>; Fri, 23 Apr 2021 02:39:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 002D661445
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619145574;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EWz+Uz65O20YK9aG/7qpTutD6MYdDbnA9xAUqXhEhTs=;
	b=gBzcdIptSvfVFYW6Zbu4LdCEHVtHxIhgyqWcC1sRn9Kk9bBJ5ww0dMgdlhi6qitSeSgcmw
	2lBe2ibdFtE89H3MiGHLlP2xCC4CNXHcZOWj2KxPqk/pE4iDKbjvC3KoDoXVrXPM95grqR
	UKbC5qQ7V32D2biJD9rAlDKTh13b+zI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-Ha4AZnDdPRqq94NmMLRbNw-1; Thu, 22 Apr 2021 22:39:32 -0400
X-MC-Unique: Ha4AZnDdPRqq94NmMLRbNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4960383DD20;
	Fri, 23 Apr 2021 02:39:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22FE9100164C;
	Fri, 23 Apr 2021 02:39:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E67DF44A58;
	Fri, 23 Apr 2021 02:39:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13N2dNQc029748 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 22:39:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 183185C3FD; Fri, 23 Apr 2021 02:39:23 +0000 (UTC)
Received: from T590 (ovpn-13-78.pek2.redhat.com [10.72.13.78])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA7135C27C;
	Fri, 23 Apr 2021 02:39:03 +0000 (UTC)
Date: Fri, 23 Apr 2021 10:39:04 +0800
From: Ming Lei <ming.lei@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <YIIzSPUtZcV9mm0E@T590>
References: <20210422122038.2192933-1-ming.lei@redhat.com>
	<20210422122038.2192933-13-ming.lei@redhat.com>
	<3681e443-0381-b916-101d-f5e6cc2c8d7a@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <3681e443-0381-b916-101d-f5e6cc2c8d7a@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH V6 12/12] dm: support IO polling for
	bio-based dm device
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

On Fri, Apr 23, 2021 at 09:32:38AM +0800, JeffleXu wrote:
> 
> 
> On 4/22/21 8:20 PM, Ming Lei wrote:
> > From: Jeffle Xu <jefflexu@linux.alibaba.com>
> > 
> > IO polling is enabled when all underlying target devices are capable
> > of IO polling. The sanity check supports the stacked device model, in
> > which one dm device may be build upon another dm device. In this case,
> > the mapped device will check if the underlying dm target device
> > supports IO polling.
> > 
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> > Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/dm-table.c         | 24 ++++++++++++++++++++++++
> >  drivers/md/dm.c               |  2 ++
> >  include/linux/device-mapper.h |  1 +
> >  3 files changed, 27 insertions(+)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 95391f78b8d5..a8f3575fb118 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1509,6 +1509,12 @@ struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector)
> >  	return &t->targets[(KEYS_PER_NODE * n) + k];
> >  }
> >  
> > +static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
> > +				   sector_t start, sector_t len, void *data)
> > +{
> > +	return !blk_queue_poll(bdev_get_queue(dev->bdev));
> > +}
> > +
> >  /*
> >   * type->iterate_devices() should be called when the sanity check needs to
> >   * iterate and check all underlying data devices. iterate_devices() will
> > @@ -1559,6 +1565,11 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
> >  	return 0;
> >  }
> >  
> > +int dm_table_supports_poll(struct dm_table *t)
> > +{
> > +	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
> > +}
> > +
> 
> Since .poll_capable() has been dropped, dm_table_supports_poll() can be
> declared as 'static' here.
> 
> >  /*
> >   * Check whether a table has no data devices attached using each
> >   * target's iterate_devices method.
> > @@ -2079,6 +2090,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  
> >  	dm_update_keyslot_manager(q, t);
> >  	blk_queue_update_readahead(q);
> > +
> > +	/*
> > +	 * Check for request-based device is remained to
> > +	 * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
> > +	 * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
> > +	 * devices supporting polling.
> > +	 */
> > +	if (__table_type_bio_based(t->type)) {
> > +		if (dm_table_supports_poll(t))
> > +			blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> > +		else
> > +			blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
> > +	}
> >  }
> >  
> >  unsigned int dm_table_get_num_targets(struct dm_table *t)
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 50b693d776d6..1b160e4e6446 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2175,6 +2175,8 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
> >  		}
> >  		break;
> >  	case DM_TYPE_BIO_BASED:
> > +		/* tell block layer we are capable of bio polling */
> > +		md->disk->flags |= GENHD_FL_CAP_BIO_POLL;
> >  	case DM_TYPE_DAX_BIO_BASED:
> >  		break;
> >  	case DM_TYPE_NONE:
> 
> 
> > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > index 7f4ac87c0b32..31bfd6f70013 100644
> > --- a/include/linux/device-mapper.h
> > +++ b/include/linux/device-mapper.h
> > @@ -538,6 +538,7 @@ unsigned int dm_table_get_num_targets(struct dm_table *t);
> >  fmode_t dm_table_get_mode(struct dm_table *t);
> >  struct mapped_device *dm_table_get_md(struct dm_table *t);
> >  const char *dm_table_device_name(struct dm_table *t);
> > +int dm_table_supports_poll(struct dm_table *t);
> 
> Similarly, dm_table_supports_poll() doesn't need to be exported.

Yeah, has fixed it in V7.

Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

