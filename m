Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928C1C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 06:36:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-jNEjaEPRNYa6e0YKjYCy2Q-1; Wed, 24 Nov 2021 01:36:36 -0500
X-MC-Unique: jNEjaEPRNYa6e0YKjYCy2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADD4681CCB6;
	Wed, 24 Nov 2021 06:36:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CAA7F79459;
	Wed, 24 Nov 2021 06:36:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5535D1809C89;
	Wed, 24 Nov 2021 06:36:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO6aN6m002390 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 01:36:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F28822026D11; Wed, 24 Nov 2021 06:36:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDE0E2026D7F
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:36:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24D08811E7F
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:36:17 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-195-3akoU1-HMqKYU7iU9ymH9A-1; Wed, 24 Nov 2021 01:36:09 -0500
X-MC-Unique: 3akoU1-HMqKYU7iU9ymH9A-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id C659668AFE; Wed, 24 Nov 2021 07:36:05 +0100 (CET)
Date: Wed, 24 Nov 2021 07:36:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20211124063605.GA6889@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-7-hch@lst.de>
	<20211123222555.GE266024@magnolia>
MIME-Version: 1.0
In-Reply-To: <20211123222555.GE266024@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 06/29] dax: move the partition alignment
 check into fs_dax_get_by_bdev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 02:25:55PM -0800, Darrick J. Wong wrote:
> > +	if ((get_start_sect(bdev) * SECTOR_SIZE) % PAGE_SIZE ||
> > +	    (bdev_nr_sectors(bdev) * SECTOR_SIZE) % PAGE_SIZE) {
> 
> Do we have to be careful about 64-bit division here, or do we not
> support DAX on 32-bit?

I can't find anything in the Kconfig limiting DAX to 32-bit.  But
then again the existing code has divisions like this, so the compiler
is probably smart enough to turn them into shifts.

> > +		pr_info("%pg: error: unaligned partition for dax\n", bdev);
> 
> I also wonder if this should be ratelimited...?

This happens once (or maybe three times for XFS with rt and log devices)
at mount time, so I see no need for a ratelimit.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

