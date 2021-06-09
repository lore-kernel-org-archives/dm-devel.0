Return-Path: <SRS0=zjfM=LD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70C1C47095
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7CFB761278
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CFB761278
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-BZMJtDWkPK-yL-kojqaFlw-1; Wed, 09 Jun 2021 02:03:39 -0400
X-MC-Unique: BZMJtDWkPK-yL-kojqaFlw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 828E61850609;
	Wed,  9 Jun 2021 06:03:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 680F0620DE;
	Wed,  9 Jun 2021 06:03:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E1E21800BB4;
	Wed,  9 Jun 2021 06:03:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1591xpxc018298 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 21:59:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 904C6200E679; Wed,  9 Jun 2021 01:59:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BFA92021477
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 01:59:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FD1D857D08
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 01:59:48 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-502-MIpv8mNCMJCIYi8Ck-ih5A-1;
	Tue, 08 Jun 2021 21:59:45 -0400
X-MC-Unique: MIpv8mNCMJCIYi8Ck-ih5A-1
IronPort-SDR: D0ZiB8xeYuWJfq7qC8IZCjPgxzQERQ/qh3jdwRDQF0J4osuvpRi9L8epnfVysuNwthfCfIR131
	pm7G153k+4jA==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="203131419"
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; d="scan'208";a="203131419"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
	by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	08 Jun 2021 18:59:44 -0700
IronPort-SDR: l5m0zsMDo0S/BY6flob2JC9Z0fcbfXs0snnKIkUOGNUZsN5SIUPiUFSjvaStBruug7QhFYdMqJ
	TyBwGFTSV0lA==
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; d="scan'208";a="482201365"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by orsmga001-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 18:59:44 -0700
Date: Tue, 8 Jun 2021 18:59:43 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210609015943.GV3697498@iweiny-DESK2.sc.intel.com>
References: <20210608160603.1535935-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210608160603.1535935-1-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 09 Jun 2021 02:03:13 -0400
Cc: Jens Axboe <axboe@kernel.dk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>,
	Geoff Levand <geoff@infradead.org>, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] switch the block layer to use kmap_local_page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 08, 2021 at 06:05:47PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series switches the core block layer code and all users of the
> existing bvec kmap helpers to use kmap_local_page.  Drivers that
> currently use open coded kmap_atomic calls will converted in a follow
> on series.

Other than the missing flush_dcache's.

For the series.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> 
> Diffstat:
>  arch/mips/include/asm/mach-rc32434/rb.h |    2 -
>  block/bio-integrity.c                   |   14 ++++------
>  block/bio.c                             |   37 +++++++---------------------
>  block/blk-map.c                         |    2 -
>  block/bounce.c                          |   35 ++++++--------------------
>  block/t10-pi.c                          |   16 ++++--------
>  drivers/block/ps3disk.c                 |   19 ++------------
>  drivers/block/rbd.c                     |   15 +----------
>  drivers/md/dm-writecache.c              |    5 +--
>  include/linux/bio.h                     |   42 --------------------------------
>  include/linux/bvec.h                    |   27 ++++++++++++++++++--
>  include/linux/highmem.h                 |    4 +--
>  12 files changed, 64 insertions(+), 154 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

