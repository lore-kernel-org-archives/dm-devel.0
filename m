Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EF0AC433F5
	for <dm-devel@archiver.kernel.org>; Sat, 16 Apr 2022 06:43:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-I3jqZ3kDN5CE9M02dSb4PQ-1; Sat, 16 Apr 2022 02:43:31 -0400
X-MC-Unique: I3jqZ3kDN5CE9M02dSb4PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB20580159B;
	Sat, 16 Apr 2022 06:43:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9838F20296AC;
	Sat, 16 Apr 2022 06:43:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4AFA119451F0;
	Sat, 16 Apr 2022 06:43:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1C90719451EF
 for <dm-devel@listman.corp.redhat.com>; Sat, 16 Apr 2022 06:43:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBFEA1121331; Sat, 16 Apr 2022 06:43:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E68E5111CA1A
 for <dm-devel@redhat.com>; Sat, 16 Apr 2022 06:43:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AC088564EF
 for <dm-devel@redhat.com>; Sat, 16 Apr 2022 06:43:17 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-DgtDlSqSOdqsKU7kzmoiZw-1; Sat, 16 Apr 2022 02:43:15 -0400
X-MC-Unique: DgtDlSqSOdqsKU7kzmoiZw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nfbR9-00CJbD-Vt; Sat, 16 Apr 2022 05:57:36 +0000
Date: Fri, 15 Apr 2022 22:57:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <Ylpaz2LpRcbPI5Lp@infradead.org>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-2-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220412085616.1409626-2-ming.lei@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 1/8] block: replace disk based account with
 bdev's
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12, 2022 at 04:56:09PM +0800, Ming Lei wrote:
> 'block device' is generic type for interface, and gendisk becomes more
> one block layer internal type, so replace disk based account interface
> with bdec's.

I can't parse this sentence.

> +unsigned long bdev_start_io_acct(struct block_device *bdev,
> +				 unsigned int sectors, unsigned int op,
> +				 unsigned long start_time)
>  {
> -	return __part_start_io_acct(disk->part0, sectors, op, jiffies);
> +	return __part_start_io_acct(bdev, sectors, op, start_time);
>  }
> -EXPORT_SYMBOL(disk_start_io_acct);
> +EXPORT_SYMBOL(bdev_start_io_acct);

Just rename __part_start_io_acct to bdev_start_io_acct instead.

> -void disk_end_io_acct(struct gendisk *disk, unsigned int op,
> +void bdev_end_io_acct(struct block_device *bdev, unsigned int op,
>  		      unsigned long start_time)
>  {
> -	__part_end_io_acct(disk->part0, op, start_time);
> +	__part_end_io_acct(bdev, op, start_time);
>  }
> -EXPORT_SYMBOL(disk_end_io_acct);
> +EXPORT_SYMBOL(bdev_end_io_acct);

Same here.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

