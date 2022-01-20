Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B052C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jan 2022 08:44:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-loa-bTpMMXil8867aF7LAA-1; Thu, 20 Jan 2022 03:44:49 -0500
X-MC-Unique: loa-bTpMMXil8867aF7LAA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCABC1006AA4;
	Thu, 20 Jan 2022 08:44:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C4AF1059161;
	Thu, 20 Jan 2022 08:44:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F109E4BB7C;
	Thu, 20 Jan 2022 08:44:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20K8efa8014767 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 Jan 2022 03:40:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 79E91401E87; Thu, 20 Jan 2022 08:40:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 767FC401E7E
	for <dm-devel@redhat.com>; Thu, 20 Jan 2022 08:40:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 629241044560
	for <dm-devel@redhat.com>; Thu, 20 Jan 2022 08:40:41 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-454-lAfe6rhSPiiWEsq8avNnbg-1; Thu, 20 Jan 2022 03:40:37 -0500
X-MC-Unique: lAfe6rhSPiiWEsq8avNnbg-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id E093568AA6; Thu, 20 Jan 2022 09:34:07 +0100 (CET)
Date: Thu, 20 Jan 2022 09:34:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20220120083407.GA5321@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
	<20220118071952.1243143-15-hch@lst.de>
	<245eaa0a-0796-0227-4abf-d1b78953557e@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <245eaa0a-0796-0227-4abf-d1b78953557e@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.co>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	"Md . Haris Iqbal" <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
	Jack Wang <jinpu.wang@ionos.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Subject: Re: [dm-devel] [PATCH 14/19] block: pass a block_device and opf to
 blk_next_bio
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

On Tue, Jan 18, 2022 at 10:11:06PM +0000, Chaitanya Kulkarni wrote:
> On 1/17/22 11:19 PM, Christoph Hellwig wrote:
> > All callers need to set the block_device and operation, so lift that into
> > the common code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> I sent out the exact patch for this one, anyways looks good.
> 
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

I'll switch attribution to you.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

