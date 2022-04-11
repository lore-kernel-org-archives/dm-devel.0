Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FBDC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 00:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649637397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9xm7vbEek7WMLliks6czQxqZIur3f6jBe1PmmTZFh+k=;
	b=SBgfcS7quT1XvtcxWSOHeMgg7CKipnFvmAiuIpPsx3KHB6N7RD3FB6xHqVjrjVE1S+FC9H
	QjP76UyPpUkHooLJOxTnJAO7aTYGr/2Tx4y1b4JMIKKq65okZO3ETDoc7/UrmCgXTsH7yk
	8Ld0QIExobWniKKtjydT/dpg7AOQgJM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-n2ZGz_8MN8q0OMuoDKEQMQ-1; Sun, 10 Apr 2022 20:36:33 -0400
X-MC-Unique: n2ZGz_8MN8q0OMuoDKEQMQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00A09800B28;
	Mon, 11 Apr 2022 00:36:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D6A02166BA9;
	Mon, 11 Apr 2022 00:36:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C19C19451F1;
	Mon, 11 Apr 2022 00:36:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9748419466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 00:36:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 77FF6C28115; Mon, 11 Apr 2022 00:36:29 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 562C0C07F43;
 Mon, 11 Apr 2022 00:36:25 +0000 (UTC)
Date: Mon, 11 Apr 2022 08:36:20 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <YlN4BC2qbGODxbVz@T590>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
 <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>,
 Mike Snitzer <snitzer@redhat.com>
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

On Mon, Apr 11, 2022 at 09:18:56AM +0900, Damien Le Moal wrote:
> On 4/9/22 02:12, Ming Lei wrote:
> > dm_zone_map_bio() is only called from __map_bio in which the io's
> > reference is grabbed already, and the reference won't be released
> > until the bio is submitted, so no necessary to do it dm_zone_map_bio
> > any more.
> 
> I do not think that this patch is correct. Removing the extra reference on
> the io can lead to problems if the io is completed in the target
> ->map(ti, clone) call or before dm_zone_map_bio_end() is called for the
> DM_MAPIO_SUBMITTED or DM_MAPIO_REMAPPED cases. dm_zone_map_bio_end() needs

__map_bio():
	...
	dm_io_inc_pending(io);
	...
	dm_zone_map_bio(tio);
	...

dm_submit_bio():
	dm_split_and_process_bio
		init_clone_info(&ci, md, map, bio)
			atomic_set(&io->io_count, 1)
		...
		__map_bio()
		...
		dm_io_dec_pending()

The target io can only be completed after the above line returns,
so the extra reference in dm_zone_map_bio() doesn't make any difference,
does it?


Thanks, 
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

