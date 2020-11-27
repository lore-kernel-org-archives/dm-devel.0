Return-Path: <SRS0=2hlQ=FB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7614FC2D0E4
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 09:41:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD67120B80
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 09:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD67120B80
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-ESPRstn-Mt-M5Ai2fdX-Lw-1; Fri, 27 Nov 2020 04:41:39 -0500
X-MC-Unique: ESPRstn-Mt-M5Ai2fdX-Lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09F9E180A0AD;
	Fri, 27 Nov 2020 09:41:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC5FF5B4A0;
	Fri, 27 Nov 2020 09:41:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 79329180954D;
	Fri, 27 Nov 2020 09:41:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AR9fJ2g029026 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Nov 2020 04:41:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D493ED74DA; Fri, 27 Nov 2020 09:41:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF1CAD7B0C
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 09:41:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C3FC800889
	for <dm-devel@redhat.com>; Fri, 27 Nov 2020 09:41:17 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-42-Ud1xbIy3NcmhLCw8JDD36A-1;
	Fri, 27 Nov 2020 04:41:13 -0500
X-MC-Unique: Ud1xbIy3NcmhLCw8JDD36A-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id D046C68B05; Fri, 27 Nov 2020 10:41:09 +0100 (CET)
Date: Fri, 27 Nov 2020 10:41:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Message-ID: <20201127094109.GB14976@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-30-hch@lst.de>
	<20201126165036.GO422@quack2.suse.cz>
	<20201126175208.GA24843@lst.de>
	<20201126180408.GB422@quack2.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20201126180408.GB422@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Chao Yu <yuchao0@huawei.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 29/44] block: remove the nr_sects field in
 struct hd_struct
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 26, 2020 at 07:04:08PM +0100, Jan Kara wrote:
> On Thu 26-11-20 18:52:08, Christoph Hellwig wrote:
> > On Thu, Nov 26, 2020 at 05:50:36PM +0100, Jan Kara wrote:
> > > > +	if (size == capacity ||
> > > > +	    (disk->flags & (GENHD_FL_UP | GENHD_FL_HIDDEN)) != GENHD_FL_UP)
> > > > +		return false;
> > > > +	pr_info("%s: detected capacity change from %lld to %lld\n",
> > > > +		disk->disk_name, size, capacity);
> > > > +	kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
> > > 
> > > I think we don't want to generate resize event for changes from / to 0...
> > 
> > Didn't you ask for that in the last round?
> 
> I've asked for the message - which you've added :). But the udev event was
> correct in the previous version IMHO...

Note that this version only prints if the gendisk is up.  So any initial
setup does not see a message.  I think that is a better indicator than
checking for 0.  Especially as say a remotely triggered change to 0
is an even worth printing, and except for DRBD all drivers did print
the message.

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
---end quoted text---

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

