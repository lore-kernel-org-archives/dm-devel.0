Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B68C77B6F
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157990;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=5vdyuAViGIzDtwpFDSD3Tp3I6ZhoZBjP15c3mBMGH6E=;
	b=G57gKDJIaW3mgPST5YXKXrv/bpPQmy9loyYKvxb0jc9T1k0YyO6mbRL6suITIIl9SnmxPC
	oMtwkmVSOAUeyV5iaPDTIUgcwDt44i/jpwRPofd2vRA5OVdfNX28eoRUkmtKyqkMAcnvl+
	Za1/aDwrEwz3U4kzX9cAuFq+eE3rYLE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-6qWIsN6BOSmbVoIryv5bsQ-1; Thu, 30 Mar 2023 02:33:06 -0400
X-MC-Unique: 6qWIsN6BOSmbVoIryv5bsQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE07238221F6;
	Thu, 30 Mar 2023 06:33:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A72CC492B0B;
	Thu, 30 Mar 2023 06:33:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9CB119472D1;
	Thu, 30 Mar 2023 06:32:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F9431946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 15:32:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE2344020C85; Wed, 29 Mar 2023 15:32:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3A144020C83
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:32:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D267B18F0254
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:31:49 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-1SThjiHBMDiV7DGmz5C8Sw-1; Wed, 29 Mar 2023 11:31:40 -0400
X-MC-Unique: 1SThjiHBMDiV7DGmz5C8Sw-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230329153137epoutp0276c6d66b82d4dc16128ffe1213d22142~Q7ZfgirpT2847128471epoutp02p
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:31:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230329153137epoutp0276c6d66b82d4dc16128ffe1213d22142~Q7ZfgirpT2847128471epoutp02p
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230329153136epcas5p4fd59fa4179af42ca335419492928ffd9~Q7Ze2fHia0774607746epcas5p4n;
 Wed, 29 Mar 2023 15:31:36 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4PmrBH1Sqvz4x9Pv; Wed, 29 Mar
 2023 15:31:35 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 54.35.55678.7D954246; Thu, 30 Mar 2023 00:31:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230329121341epcas5p45333599c9e32850de632a1c3859b0f1c~Q4sq0wktm0120401204epcas5p47;
 Wed, 29 Mar 2023 12:13:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230329121341epsmtrp1ffb23e4e63f785ac676c4cb2239c699a~Q4sqzmkfq2849028490epsmtrp1-;
 Wed, 29 Mar 2023 12:13:41 +0000 (GMT)
X-AuditID: b6c32a4a-909fc7000000d97e-08-642459d72a8a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 2B.C0.31821.57B24246; Wed, 29 Mar 2023 21:13:41 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230329121337epsmtip18397af4feb26451d5131597edd8b0f18~Q4snsNtwN0677706777epsmtip1a;
 Wed, 29 Mar 2023 12:13:37 +0000 (GMT)
Date: Wed, 29 Mar 2023 17:42:57 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20230329121257.GC11932@green5>
MIME-Version: 1.0
In-Reply-To: <3b9adeb6-4295-6e6a-9e93-7c5a06441830@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHc27b2wuOeeXlsWwTiguiAylru4Ox6ISwG1BD5iRBXEpDb3iV
 tvQh7JEMFOZ0MGony6gM2eIY8pSHyFNIFRkog6VQlFlEB0sQKg7HhBBwhQuL/31+3/P9nd/v
 /H45BMv1ey6PSFbqaI1SpuDjzuymm/47A0Zid8iDSq7iqLbvNgudMiyzUKWtAEfTN+cA+u7Z
 Igst9Q+wUMfTixx0v6sFQ+0/GTF0pbIbQ20//o2h7pd2HBnNVoAmh00Y6hjdjdo7etnI0lqM
 o0tlk1xk/vY0hponsgGqmZ5lo19HvdDAcg/nwFbKMhRFmR7241SLycalBsbq2JSlX0/VV5zF
 qYbLX1Bt97NwKv/0U4ch9yGHmr0xjFPfNFYAquHOZ9Tz+reo+gk7Fr35eOq+JFompzXetDJB
 JU9WJkr4UUelYVKROEgQIAhB7/G9lbI0WsIPPxQdEJGscIyA731SptA7pGiZVsvfE7pPo9Lr
 aO8klVYn4dNquUItVAdqZWlavTIxUEnr9gqCgoJFDmN8apLlj0GuusI381JOA5YFLF7ngBMB
 SSHstUyzzwFnwpVsA7D1+gzGBHMAdsyfwZngOYBzZXbORkrWKfu6qxXAhcIWLhNMAGjuqMZW
 XWzybXh1IMeRQRA4uRveeUmsyu6kCNrzctmrzCLLOHD2wdqlbqQEPr53DV9lF4c9z9bFZngL
 7C2aWGMnMgLm3LNyV9mD9IVdTT1rTUCy0glaS9u5q7UgGQ77zvoxjbrBJz2NXIZ5cKrgy3XO
 gFculONMbg6AphETYA72w9y+AhbTXDK8UDOOM/qbsLCvBmP012H+0gTG6C6wuWSDfWFVbem6
 fxu0vsheZwrethQDZkCLAJZP2bgGsN30yuNMr9Rj+B1Y2jbnYMLBXvCXFYJBf1jbuqcUcCrA
 NlqtTUuktSJ1sJLO+H/jCaq0erD2RXZFNoNH488CzQAjgBlAgsV3d1my8uWuLnLZJ5/SGpVU
 o1fQWjMQOXZ1nsXzSFA5/phSJxUIQ4KEYrFYGPKuWMDf6uIn6U1wJRNlOjqVptW0ZiMPI5x4
 WZiqk6ubi0iRrBz7+R+pX2ZcnCiTl3NSfcgvVx4+adAa7EV/EZbBTcthe6Wvzfzw4WJGfIlT
 6NmFg/MzqvIhhfFiRFH1loJ0pa2uxT30brDt0agP+tOwEDVZmjjWTn4duel82W+3quCAf9Wc
 os8n//CJlMbjO7uN40kxRo/QzOEHxYa2lR1+twxPvJd6mlIqhUedw8QZPBV7NJ3yDMmeXVJ/
 VJh8Pd7Vp8trKLL67vb3VSz1wuX0To8btP1IzOiLzrr9nsp/AzZ/MG2ejORHLehFBY/P6D93
 L/H0ivu90HokNnb+WPOBg1PNs7prM3kxeaaPT0iMXzmPJLwxuBI2VuGmOcxna5Nkgl0sjVb2
 H+6C8sGrBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Rf0yMcRzH931+9dxNejrJtyJ51Fit81tfhhlqz4Rlfo2Z83DP0o9Lu3Py
 a1xU1iWSduM0qqXWMbqLVHfZ7ahUS0jpUG1cZHalzI9Gh+sY/733fb1f7323D41L7EQgnZBy
 QFCm8MksJSaq77PBkeqIUPlccwOJbrU04uhk3hiOrveco9CH+yMA6T6O4uh7WzuO6gcvk8hu
 rcWQpSQfQxXXGzBkLh7GUMNPJ4XybV0A9XfqMVT/IgJZ6psJ1FFXSKGrZf1eyHbhFIZqHOkA
 3fwwRKCHL4JQ+1gTuXIK1/EsltP3tVFcrb7Hi2vvNRJcR5uaMxmyKa6q9ARntmsoLvfU4O9C
 Zh/JDd3rpLiztw2Aq2o9yn0yBXMmhxOL89khXiYXkhMOCso5K3aL9xU9ysFT34UcGu3PIjWg
 IkALRDRkFkLNSSemBWJawtQA6Bg47eUBAbBs7AHuyZNgheudl6f0GsBKSyblBgQTBivbM0gt
 oGmKiYCtP2n3sx+zCDrPZBLujDMGEvbWRbrzJGY5fN19Z1z1/l0/02MlPJujABo/FZAe4Aub
 Lzn+yOGw2/Uec+/jTBAsd43vi5gYmNHdNf7PycxMaK1uwvKAr/4/W/+frf9nFwHcAAKEVJUi
 XqGalzo/RUiTqniFSp0SL927X2EC49cPD68BFsNHqQ1gNLABSOOsn/f3LlYu8Zbzh48Iyv0y
 pTpZUNlAEE2wU7wfa5tlEiaePyAkCUKqoPxLMVoUqMGiFqR/K4/0IbpIcY6cjdxY++Oyb+eP
 jGgf6R6p/bBLM+IgJVF0SOv62fzmbXGLDcNRFwqqlizeWJRVwAPr1BPGFdWBrO7l6tMX7brg
 WTe6E7PTykd2GYr3NjcKA1r/a6FN5ruhW3IbRYmxpokz5oTIpC2Blgkuv7dLUebCWSuvCP03
 St8Us47hhD3RIbdL+l6t/toSs26oZGT5YExBi2mo1r9Y1yv7HIaSdp6Lleka3qJc3aaq57v9
 05MGjsvqpr/puDvN+gRPmH48cUOUeli6yGk0JsZJOm9G5zV92fp16lUn4mNy084eo1Ztr8xW
 nC9cg7KqOW1OqajQnPN0bTlLqPbx88JxpYr/BTJUoI1sAwAA
X-CMS-MailID: 20230329121341epcas5p45333599c9e32850de632a1c3859b0f1c
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084312epcas5p377810b172aa6048519591518f8c308d0
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084312epcas5p377810b172aa6048519591518f8c308d0@epcas5p3.samsung.com>
 <20230327084103.21601-8-anuj20.g@samsung.com>
 <3b9adeb6-4295-6e6a-9e93-7c5a06441830@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: Re: [dm-devel] [PATCH v8 7/9] dm: Add support for copy offload.
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_118c3d_"

------3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_118c3d_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Mar 29, 2023 at 05:59:49PM +0900, Damien Le Moal wrote:
> On 3/27/23 17:40, Anuj Gupta wrote:
> > From: Nitesh Shetty <nj.shetty@samsung.com>
> > 
> 
> Drop the period at the end of the patch title.


Acked

> 
> > Before enabling copy for dm target, check if underlying devices and
> > dm target support copy. Avoid split happening inside dm target.
> > Fail early if the request needs split, currently splitting copy
> > request is not supported.
> > 
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > ---
> >  drivers/md/dm-table.c         | 42 +++++++++++++++++++++++++++++++++++
> >  drivers/md/dm.c               |  7 ++++++
> >  include/linux/device-mapper.h |  5 +++++
> >  3 files changed, 54 insertions(+)
> > 
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 7899f5fb4c13..45e894b9e3be 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -1863,6 +1863,39 @@ static bool dm_table_supports_nowait(struct dm_table *t)
> >  	return true;
> >  }
> >  
> > +static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
> > +				      sector_t start, sector_t len, void *data)
> > +{
> > +	struct request_queue *q = bdev_get_queue(dev->bdev);
> > +
> > +	return !blk_queue_copy(q);
> > +}
> > +
> > +static bool dm_table_supports_copy(struct dm_table *t)
> > +{
> > +	struct dm_target *ti;
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < t->num_targets; i++) {
> > +		ti = dm_table_get_target(t, i);
> > +
> > +		if (!ti->copy_offload_supported)
> > +			return false;
> > +
> > +		/*
> > +		 * target provides copy support (as implied by setting
> > +		 * 'copy_offload_supported')
> > +		 * and it relies on _all_ data devices having copy support.
> > +		 */
> > +		if (!ti->type->iterate_devices ||
> > +		     ti->type->iterate_devices(ti,
> > +			     device_not_copy_capable, NULL))
> > +			return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> >  static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
> >  				      sector_t start, sector_t len, void *data)
> >  {
> > @@ -1945,6 +1978,15 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
> >  		q->limits.discard_misaligned = 0;
> >  	}
> >  
> > +	if (!dm_table_supports_copy(t)) {
> > +		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
> > +		/* Must also clear copy limits... */
> 
> Not a useful comment. The code is clear.

Acked

> 
> > +		q->limits.max_copy_sectors = 0;
> > +		q->limits.max_copy_sectors_hw = 0;
> > +	} else {
> > +		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
> > +	}
> > +
> >  	if (!dm_table_supports_secure_erase(t))
> >  		q->limits.max_secure_erase_sectors = 0;
> >  
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 2d0f934ba6e6..08ec51000af8 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1693,6 +1693,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
> >  	if (unlikely(ci->is_abnormal_io))
> >  		return __process_abnormal_io(ci, ti);
> >  
> > +	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
> > +			max_io_len(ti, ci->sector) < ci->sector_count)) {
> > +		DMERR("Error, IO size(%u) > max target size(%llu)\n",
> > +			ci->sector_count, max_io_len(ti, ci->sector));
> > +		return BLK_STS_IOERR;
> > +	}
> > +
> >  	/*
> >  	 * Only support bio polling for normal IO, and the target io is
> >  	 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
> > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > index 7975483816e4..44969a20295e 100644
> > --- a/include/linux/device-mapper.h
> > +++ b/include/linux/device-mapper.h
> > @@ -380,6 +380,11 @@ struct dm_target {
> >  	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
> >  	 */
> >  	bool needs_bio_set_dev:1;
> > +
> > +	/*
> > +	 * copy offload is supported
> > +	 */
> > +	bool copy_offload_supported:1;
> >  };
> >  
> >  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
> 
Thank you,
Nitesh Shetty

------3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_118c3d_
Content-Type: text/plain; charset="utf-8"


------3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_118c3d_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------3NzO0p8.1sh3-RRiYuI9FQqPO8oRjrHoddadEkfGMyLJmz0h=_118c3d_--

