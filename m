Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781C4C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 16:04:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-O73ZOW0_MhGZiIUZbWQZlw-1; Wed, 23 Mar 2022 12:04:37 -0400
X-MC-Unique: O73ZOW0_MhGZiIUZbWQZlw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC457811E78;
	Wed, 23 Mar 2022 16:04:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41276401E36;
	Wed, 23 Mar 2022 16:04:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D61CB1949763;
	Wed, 23 Mar 2022 16:04:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C5411949761
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 16:03:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D7F840149AC; Wed, 23 Mar 2022 16:03:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 29606403D1D1
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 16:03:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1024F3C11A16
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 16:03:38 +0000 (UTC)
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com
 [192.185.64.36]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-kYxFsHqrMGGyfCzltkpB_Q-1; Wed, 23 Mar 2022 12:03:36 -0400
X-MC-Unique: kYxFsHqrMGGyfCzltkpB_Q-1
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
 by gateway20.websitewelcome.com (Postfix) with ESMTP id 3D236401719A1
 for <dm-devel@redhat.com>; Wed, 23 Mar 2022 10:43:22 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
 by cmsmtp with SMTP
 id X38rngfPBRnrrX38sn19qp; Wed, 23 Mar 2022 10:43:22 -0500
X-Authority-Reason: nr=8
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net
 ([108.223.40.66]:57638 helo=localhost)
 by bh-25.webhostbox.net with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <linux@roeck-us.net>)
 id 1nX38q-0034li-Mc; Wed, 23 Mar 2022 15:43:20 +0000
Date: Wed, 23 Mar 2022 08:43:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20220323154319.GA2268247@roeck-us.net>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse,
 please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - redhat.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nX38q-0034li-Mc
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost)
 [108.223.40.66]:57638
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 22
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 01/19] fs: remove mpage_alloc
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
Cc: Jens Axboe <axboe@kernel.dk>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 linux-nfs@vger.kernel.org, linux-nilfs <linux-nilfs@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Snitzer <snitzer@redhat.com>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.co>,
 device-mapper development <dm-devel@redhat.com>,
 "Md . Haris Iqbal" <haris.iqbal@ionos.com>, linux-fsdevel@vger.kernel.org,
 xen-devel@lists.xenproject.org, Lars Ellenberg <lars.ellenberg@linbit.com>,
 ntfs3@lists.linux.dev, Jack Wang <jinpu.wang@ionos.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, drbd-dev@lists.linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 23, 2022 at 07:42:48AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 23, 2022 at 06:38:22AM +0900, Ryusuke Konishi wrote:
> > This looks because the mask of GFP_KERNEL is removed along with
> > the removal of mpage_alloc().
> > 
> 
> > The default value of the gfp flag is set to GFP_HIGHUSER_MOVABLE by
> > inode_init_always().
> > So, __GFP_HIGHMEM hits the gfp warning at bio_alloc() that
> > do_mpage_readpage() calls.
> 
> Yeah.  Let's try this to match the iomap code:
> 
> diff --git a/fs/mpage.c b/fs/mpage.c
> index 9ed1e58e8d70b..d465883edf719 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -148,13 +148,11 @@ static struct bio *do_mpage_readpage(struct mpage_readpage_args *args)
>  	int op = REQ_OP_READ;
>  	unsigned nblocks;
>  	unsigned relative_block;
> -	gfp_t gfp;
> +	gfp_t gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
>  
>  	if (args->is_readahead) {
>  		op |= REQ_RAHEAD;
> -		gfp = readahead_gfp_mask(page->mapping);
> -	} else {
> -		gfp = mapping_gfp_constraint(page->mapping, GFP_KERNEL);
> +		gfp |= __GFP_NORETRY | __GFP_NOWARN;
>  	}
>  
>  	if (page_has_buffers(page))

That fixes the problem for me.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

