Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF7CC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:39:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC4EC64DFA
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:39:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4EC64DFA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-2wGgynmNNk26AUsksGOvUA-1; Fri, 29 Jan 2021 04:39:25 -0500
X-MC-Unique: 2wGgynmNNk26AUsksGOvUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 594FC9CC07;
	Fri, 29 Jan 2021 09:39:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CF326FEE2;
	Fri, 29 Jan 2021 09:39:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B97BE5002C;
	Fri, 29 Jan 2021 09:39:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SHM1UB014510 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 12:22:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DFCD0F49A6; Thu, 28 Jan 2021 17:22:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7261F49AB
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 17:21:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23CF010AF952
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 17:21:59 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-410-QENkp_YyMlKWjivssKGkTw-1;
	Thu, 28 Jan 2021 12:21:54 -0500
X-MC-Unique: QENkp_YyMlKWjivssKGkTw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14BA564E14;
	Thu, 28 Jan 2021 17:21:52 +0000 (UTC)
Date: Thu, 28 Jan 2021 09:21:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Message-ID: <20210128172151.GN7698@magnolia>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-28-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
In-Reply-To: <20210128071133.60335-28-chaitanya.kulkarni@wdc.com>
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
X-Mailman-Approved-At: Fri, 29 Jan 2021 04:33:26 -0500
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net,
	gustavoars@kernel.org, sergey.senozhatsky.work@gmail.com,
	snitzer@redhat.com, tiwai@suse.de,
	linux-nvme@lists.infradead.org, philipp.reisner@linbit.com,
	linux-mm@kvack.org, dm-devel@redhat.com,
	target-devel@vger.kernel.org, pavel@ucw.cz,
	alex.shi@linux.alibaba.com, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, linux-nilfs@vger.kernel.org,
	sagi@grimberg.me, linux-scsi@vger.kernel.org, mark@fasheh.com,
	konrad.wilk@oracle.com, osandov@fb.com, ebiggers@kernel.org,
	xen-devel@lists.xenproject.org, ngupta@vflare.org,
	len.brown@intel.com, linux-pm@vger.kernel.org,
	ming.lei@redhat.com, linux-block@vger.kernel.org, tj@kernel.org,
	linux-fscrypt@vger.kernel.org, viro@zeniv.linux.org.uk,
	drbd-dev@tron.linbit.com, jaegeuk@kernel.org, jlbec@evilplan.org,
	konishi.ryusuke@gmail.com, bvanassche@acm.org, axboe@kernel.dk,
	damien.lemoal@wdc.com, tytso@mit.edu, akpm@linux-foundation.org,
	martin.petersen@oracle.com, joseph.qi@linux.alibaba.com,
	rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, minchan@kernel.org,
	jefflexu@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	lars.ellenberg@linbit.com, jth@kernel.org,
	asml.silence@gmail.com, ocfs2-devel@oss.oracle.com, roger.pau@citrix.com
Subject: Re: [dm-devel] [RFC PATCH 27/34] xfs: use bio_new in
	xfs_buf_ioapply_map
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 27, 2021 at 11:11:26PM -0800, Chaitanya Kulkarni wrote:
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f8400bbd6473..3ff6235e4f94 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1507,12 +1507,10 @@ xfs_buf_ioapply_map(
>  	atomic_inc(&bp->b_io_remaining);
>  	nr_pages = min(total_nr_pages, BIO_MAX_PAGES);
>  
> -	bio = bio_alloc(GFP_NOIO, nr_pages);
> -	bio_set_dev(bio, bp->b_target->bt_bdev);
> -	bio->bi_iter.bi_sector = sector;
> +	bio = bio_new(bp->b_target->bt_bdev, sector, op, 0, nr_pages,
> +		      GFP_NOIO);
>  	bio->bi_end_io = xfs_buf_bio_end_io;
>  	bio->bi_private = bp;
> -	bio->bi_opf = op;
>  
>  	for (; size && nr_pages; nr_pages--, page_index++) {
>  		int	rbytes, nbytes = PAGE_SIZE - offset;
> -- 
> 2.22.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

