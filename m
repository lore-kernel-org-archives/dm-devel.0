Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 695F7C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 13:44:27 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-oxCrvvEIO9m3ICH17DuRqg-1; Wed, 02 Feb 2022 08:44:22 -0500
X-MC-Unique: oxCrvvEIO9m3ICH17DuRqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 296871006AA4;
	Wed,  2 Feb 2022 13:44:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D75A708DB;
	Wed,  2 Feb 2022 13:44:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D3E591809CB8;
	Wed,  2 Feb 2022 13:44:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212DiF9R029389 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 08:44:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 82212492D46; Wed,  2 Feb 2022 13:44:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E4FF492D40
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:44:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63F2E811E81
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:44:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-25-H6S7Qab5My-te8yKD1cmcw-1; Wed, 02 Feb 2022 08:44:07 -0500
X-MC-Unique: H6S7Qab5My-te8yKD1cmcw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nFFvW-00FNmE-0j; Wed, 02 Feb 2022 13:44:02 +0000
Date: Wed, 2 Feb 2022 05:44:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YfqKoZ79CqvW8eLq@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-7-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220128213150.1333552-7-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	djwong@kernel.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	linux-xfs@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v5 6/7] dax: add recovery_write to
 dax_iomap_iter in failure path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 28, 2022 at 02:31:49PM -0700, Jane Chu wrote:
> +typedef size_t (*iter_func_t)(struct dax_device *dax_dev, pgoff_t pgoff,
> +		void *addr, size_t bytes, struct iov_iter *i);
>  static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  		struct iov_iter *iter)
>  {
> @@ -1210,6 +1212,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  	ssize_t ret = 0;
>  	size_t xfer;
>  	int id;
> +	iter_func_t write_func = dax_copy_from_iter;

This use of a function pointer causes indirect call overhead.  A simple
"bool in_recovery" or do_recovery does the trick in a way that is
both more readable and generates faster code.

> +		if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {

No need for the braces.

>  		if (iov_iter_rw(iter) == WRITE)
> -			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
> -					map_len, iter);
> +			xfer = write_func(dax_dev, pgoff, kaddr, map_len, iter);
>  		else
>  			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
>  					map_len, iter);

i.e.

		if (iov_iter_rw(iter) == READ)
			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
					map_len, iter);
		else if (unlikely(do_recovery))
			xfer = dax_recovery_write(dax_dev, pgoff, kaddr,
					map_len, iter);
		else
			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
					map_len, iter);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

