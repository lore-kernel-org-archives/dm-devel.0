Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F3FC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 03:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646624433;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g1nP4MDekTHRzlRNM6czbQ7Ttzh8KDDuCvu9jvM/7gs=;
	b=B7irxoJEZcNtqz1oQ0vprI+Pd1iDNl/xVngvU9nZJobyZm7jlCXn88J0zENFuoEMJ9D2Gv
	i8ofUSG6yUAliSb7StDTvxN7mfH5OTXTey59ytpvFfuhb128grPZPKKGhhY4Tyi9ovU6mE
	cbPQG10zFlA72bZrZ4AJ4JjNiYFAaxg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-ftGNRH9BNiWDXKPRtR02ig-1; Sun, 06 Mar 2022 22:40:30 -0500
X-MC-Unique: ftGNRH9BNiWDXKPRtR02ig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0E21811E75;
	Mon,  7 Mar 2022 03:40:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 550787AC3;
	Mon,  7 Mar 2022 03:40:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 17A031931BD5;
	Mon,  7 Mar 2022 03:40:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF0F6194F4B4
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:40:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6E12D4D730; Mon,  7 Mar 2022 03:40:23 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D38D4D70E;
 Mon,  7 Mar 2022 03:39:40 +0000 (UTC)
Date: Mon, 7 Mar 2022 11:39:35 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <YiV+d+B2+o7q63Bm@T590>
References: <20220305020804.54010-1-snitzer@redhat.com>
 <20220305020804.54010-3-snitzer@redhat.com>
 <20220306092937.GC22883@lst.de>
 <2ced53d5-d87b-95db-a612-6896f73ce895@kernel.dk>
 <YiVr4rna9DG0Oyng@T590>
 <89612542-0040-65bd-23bc-5bf8cac71f61@kernel.dk>
 <YiVw2y1eTcXrsdME@T590>
MIME-Version: 1.0
In-Reply-To: <YiVw2y1eTcXrsdME@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Subject: Re: [dm-devel] [PATCH v5 2/2] dm: support bio polling
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 07, 2022 at 10:41:31AM +0800, Ming Lei wrote:
> On Sun, Mar 06, 2022 at 07:25:11PM -0700, Jens Axboe wrote:
> > On 3/6/22 7:20 PM, Ming Lei wrote:
> > > On Sun, Mar 06, 2022 at 06:48:15PM -0700, Jens Axboe wrote:
> > >> On 3/6/22 2:29 AM, Christoph Hellwig wrote:
> > >>>> +/*
> > >>>> + * Reuse ->bi_end_io as hlist head for storing all dm_io instances
> > >>>> + * associated with this bio, and this bio's bi_end_io has to be
> > >>>> + * stored in one of 'dm_io' instance first.
> > >>>> + */
> > >>>> +static inline struct hlist_head *dm_get_bio_hlist_head(struct bio *bio)
> > >>>> +{
> > >>>> +	WARN_ON_ONCE(!(bio->bi_opf & REQ_DM_POLL_LIST));
> > >>>> +
> > >>>> +	return (struct hlist_head *)&bio->bi_end_io;
> > >>>> +}
> > >>>
> > >>> So this reuse is what I really hated.  I still think we should be able
> > >>> to find space in the bio by creatively shifting fields around to just
> > >>> add the hlist there directly, which would remove the need for this
> > >>> override and more importantly the quite cumbersome saving and restoring
> > >>> of the end_io handler.
> > >>
> > >> If it's possible, then that would be preferable. But I don't think
> > >> that's going to be easy to do...
> > > 
> > > I agree, now basically there isn't gap inside bio, so either adding one
> > > new field or reusing one existed field...
> > 
> > There'd no amount of re-arranging that'll free up 8 bytes, that's just
> > not happening. I'm not a huge fan of growing struct bio for that, and
> > the oddity here is mostly (to me) that ->bi_end_io is the one overlayed.
> > That would usually belong to the owner of the bio.
> > 
> > Maybe some commenting would help?
> 
> OK, ->bi_end_io is safe because it is only called until the bio is
> ended, so we can retrieve the list head and recover ->bi_end_io before
> polling.

->bi_private can be reused too, is that better?

Yeah, both belong to owner(higher level storage), then block layer can't touch
them inside submit_bio_noacct(), that is also why this trick is safe.

Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

