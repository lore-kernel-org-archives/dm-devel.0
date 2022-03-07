Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D4AC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 02:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646619689;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kZ6PsWj/zs5bXU6Va0rV+6Z9aSLi2iPyCMTY0/Pt43k=;
	b=URUXlv6cveJ/L3XqFWIuf60wjkWb+sqHKSyAhA03BrBNiBbgFpL1RRUZRm+daV9/+W/z1N
	xb+EOMT6b89tJrNTGipxkZk/cz7ueNiEASCo+lMCTj1ndQLikw6TDOWfeOhLXH2iIPO9AX
	xGQ8wcMwGOn2tpME82wbWMv0NwWgACY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-JMFze96WNZC3RzwKgAcnng-1; Sun, 06 Mar 2022 21:21:28 -0500
X-MC-Unique: JMFze96WNZC3RzwKgAcnng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FEFC3C01B96;
	Mon,  7 Mar 2022 02:21:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8F6D2166B2D;
	Mon,  7 Mar 2022 02:21:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1DFBE194E107;
	Mon,  7 Mar 2022 02:21:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95767194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 02:21:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F7592B178; Mon,  7 Mar 2022 02:21:21 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E10245D91;
 Mon,  7 Mar 2022 02:20:23 +0000 (UTC)
Date: Mon, 7 Mar 2022 10:20:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <YiVr4rna9DG0Oyng@T590>
References: <20220305020804.54010-1-snitzer@redhat.com>
 <20220305020804.54010-3-snitzer@redhat.com>
 <20220306092937.GC22883@lst.de>
 <2ced53d5-d87b-95db-a612-6896f73ce895@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <2ced53d5-d87b-95db-a612-6896f73ce895@kernel.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Mar 06, 2022 at 06:48:15PM -0700, Jens Axboe wrote:
> On 3/6/22 2:29 AM, Christoph Hellwig wrote:
> >> +/*
> >> + * Reuse ->bi_end_io as hlist head for storing all dm_io instances
> >> + * associated with this bio, and this bio's bi_end_io has to be
> >> + * stored in one of 'dm_io' instance first.
> >> + */
> >> +static inline struct hlist_head *dm_get_bio_hlist_head(struct bio *bio)
> >> +{
> >> +	WARN_ON_ONCE(!(bio->bi_opf & REQ_DM_POLL_LIST));
> >> +
> >> +	return (struct hlist_head *)&bio->bi_end_io;
> >> +}
> > 
> > So this reuse is what I really hated.  I still think we should be able
> > to find space in the bio by creatively shifting fields around to just
> > add the hlist there directly, which would remove the need for this
> > override and more importantly the quite cumbersome saving and restoring
> > of the end_io handler.
> 
> If it's possible, then that would be preferable. But I don't think
> that's going to be easy to do...

I agree, now basically there isn't gap inside bio, so either adding one
new field or reusing one existed field...


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

