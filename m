Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEC84C4708E
	for <dm-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670459777;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n0gvPrLJcIvf3LctH4i2ZQ51LJYY1uuxbcf9s/vR3ss=;
	b=fGmxsVi4qIftocX9ZATfOluR+U8+iRIyLS3IT4DrSPgyaYcaFnBjg5I6eaMcynmh+Zu5pD
	PU7FK9JeYb01JsRtdZMfgscDdeS2Eka340YSFiO2MqlBoz+vgxBwyJtVB+qUWNL92HtCxp
	D6wsMO1XQwSE7TG6/Hf7GFyxio+um94=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-QPhIisZ_M8SqlE1ZM0DNdw-1; Wed, 07 Dec 2022 19:36:14 -0500
X-MC-Unique: QPhIisZ_M8SqlE1ZM0DNdw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05FC980A0BC;
	Thu,  8 Dec 2022 00:36:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 15DA5492B04;
	Thu,  8 Dec 2022 00:36:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D9DFD19465B9;
	Thu,  8 Dec 2022 00:36:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A2AA19465B1
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Dec 2022 00:36:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C552540C6EC3; Thu,  8 Dec 2022 00:36:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE07C40C6EC2
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 00:36:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A309C185A7A3
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 00:36:06 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-UoXBRjZ6My-cYIzWRzzFkA-1; Wed, 07 Dec 2022 19:36:04 -0500
X-MC-Unique: UoXBRjZ6My-cYIzWRzzFkA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id D8F8D61D04;
 Thu,  8 Dec 2022 00:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AF6C433C1;
 Thu,  8 Dec 2022 00:35:58 +0000 (UTC)
Date: Thu, 8 Dec 2022 00:35:55 +0000
From: Keith Busch <kbusch@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <Y5Exa1TV/2VLcEWR@kbusch-mbp>
References: <20221207223204.22459-1-gulam.mohamed@oracle.com>
 <abaa2003-4ddf-5ef9-d62c-1708a214609d@kernel.dk>
 <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <09be5cbe-9251-d28c-e91a-3f2e5e9e99f2@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [RFC for-6.2/block V2] block: Change the granularity
 of io ticks from ms to ns
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
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "song@kernel.org" <song@kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
 "joe.jin@oracle.com" <joe.jin@oracle.com>,
 "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
 "ngupta@vflare.org" <ngupta@vflare.org>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
 Gulam Mohamed <gulam.mohamed@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "colyli@suse.de" <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 Jens Axboe <axboe@kernel.dk>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 "junxiao.bi@oracle.com" <junxiao.bi@oracle.com>,
 "minchan@kernel.org" <minchan@kernel.org>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 07, 2022 at 11:17:12PM +0000, Chaitanya Kulkarni wrote:
> On 12/7/22 15:08, Jens Axboe wrote:
> > 
> > My default peak testing runs at 122M IOPS. That's also the peak IOPS of
> > the devices combined, and with iostats disabled. If I enabled iostats,
> > then the performance drops to 112M IOPS. It's no longer device limited,
> > that's a drop of about 8.2%.
> > 
> 
> Wow, clearly not acceptable that's exactly I asked for perf
> numbers :).

For the record, we did say per-io ktime_get() has a measurable
performance harm and should be aggregated.

  https://www.spinics.net/lists/linux-block/msg89937.html

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

