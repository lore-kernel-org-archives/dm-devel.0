Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED605C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 06:37:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-j_VXlVHTMEu_e6LmliG2dA-1; Wed, 24 Nov 2021 01:37:50 -0500
X-MC-Unique: j_VXlVHTMEu_e6LmliG2dA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04468100C682;
	Wed, 24 Nov 2021 06:37:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2A4019D9F;
	Wed, 24 Nov 2021 06:37:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86F191809C8A;
	Wed, 24 Nov 2021 06:37:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO6bhRU002471 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Nov 2021 01:37:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9A9A551E4; Wed, 24 Nov 2021 06:37:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9571C51E3
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:37:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DA5E805F5C
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 06:37:40 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-436-mR0MZS16NOO_-WZ5vo2WmA-1; Wed, 24 Nov 2021 01:37:38 -0500
X-MC-Unique: mR0MZS16NOO_-WZ5vo2WmA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4D2F768AFE; Wed, 24 Nov 2021 07:37:35 +0100 (CET)
Date: Wed, 24 Nov 2021 07:37:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Message-ID: <20211124063735.GB6889@lst.de>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-9-hch@lst.de>
	<20211123223123.GF266024@magnolia>
MIME-Version: 1.0
In-Reply-To: <20211123223123.GF266024@magnolia>
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 08/29] dax: remove dax_capable
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 02:31:23PM -0800, Darrick J. Wong wrote:
> > -	struct super_block	*sb = mp->m_super;
> > -
> > -	if (!xfs_buftarg_is_dax(sb, mp->m_ddev_targp) &&
> > -	   (!mp->m_rtdev_targp || !xfs_buftarg_is_dax(sb, mp->m_rtdev_targp))) {
> > +	if (!mp->m_ddev_targp->bt_daxdev &&
> > +	   (!mp->m_rtdev_targp || !mp->m_rtdev_targp->bt_daxdev)) {
> 
> Nit: This  ^ paren should be indented one more column because it's a
> sub-clause of the if() test.

Done.

> Nit: xfs_alert() already adds a newline to the end of the format string.

Already done in the current tree.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

