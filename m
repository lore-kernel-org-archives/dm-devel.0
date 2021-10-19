Return-Path: <SRS0=V8Hk=PH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA80C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 07:28:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ADEDC61378
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 07:28:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ADEDC61378
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-v30h-F8CNcOwyertlQKivQ-1; Tue, 19 Oct 2021 03:28:07 -0400
X-MC-Unique: v30h-F8CNcOwyertlQKivQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 549B28066EF;
	Tue, 19 Oct 2021 07:28:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C24910027C4;
	Tue, 19 Oct 2021 07:28:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 149DB1801241;
	Tue, 19 Oct 2021 07:28:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19J7Ndu5021548 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Oct 2021 03:23:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 80719100913A; Tue, 19 Oct 2021 07:23:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7ABC9100CA53
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 07:23:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54642811E76
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 07:23:35 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-425-BivOMHq2NNenB1OObfnigA-1;
	Tue, 19 Oct 2021 03:23:31 -0400
X-MC-Unique: BivOMHq2NNenB1OObfnigA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id C6E1568BFE; Tue, 19 Oct 2021 09:23:26 +0200 (CEST)
Date: Tue, 19 Oct 2021 09:23:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20211019072326.GA23171@lst.de>
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-7-hch@lst.de>
	<20211018164351.GT24307@magnolia>
MIME-Version: 1.0
In-Reply-To: <20211018164351.GT24307@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: , linux-xfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, To-header@lst.de,
	Mike Snitzer <snitzer@redhat.com>, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, no@lst.de, on@lst.de,
	virtualization@lists.linux-foundation.org, "input <"@lst.de,
	dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 06/11] xfs: factor out a xfs_setup_dax helper
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

On Mon, Oct 18, 2021 at 09:43:51AM -0700, Darrick J. Wong wrote:
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -339,6 +339,32 @@ xfs_buftarg_is_dax(
> >  			bdev_nr_sectors(bt->bt_bdev));
> >  }
> >  
> > +static int
> > +xfs_setup_dax(
> 
> /me wonders if this should be named xfs_setup_dax_always, since this
> doesn't handle the dax=inode mode?

Sure, why not.

> The only reason I bring that up is that Eric reminded me a while ago
> that we don't actually print any kind of EXPERIMENTAL warning for the
> auto-detection behavior.

Yes, I actually noticed that as well when preparing this series.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

