Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADB8C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 19:54:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-nI0iLRX3MhqCNpEgb65pEw-1; Tue, 22 Mar 2022 15:54:35 -0400
X-MC-Unique: nI0iLRX3MhqCNpEgb65pEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B6D31C0EDC2;
	Tue, 22 Mar 2022 19:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AF8C140241B;
	Tue, 22 Mar 2022 19:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 127321940340;
	Tue, 22 Mar 2022 19:54:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EBC2F1949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 19:54:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CDB02141ADA5; Tue, 22 Mar 2022 19:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA4601417201
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:54:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4236802E5B
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 19:54:31 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-qW-USPkXMHm3LtSNwNyWpw-1; Tue, 22 Mar 2022 15:54:25 -0400
X-MC-Unique: qW-USPkXMHm3LtSNwNyWpw-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id AD0EE68AFE; Tue, 22 Mar 2022 20:54:14 +0100 (CET)
Date: Tue, 22 Mar 2022 20:54:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20220322195414.GA8650@lst.de>
References: <20220322194927.42778-1-snitzer@kernel.org>
 <20220322194927.42778-2-snitzer@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220322194927.42778-2-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 1/3] block: allow BIOSET_PERCPU_CACHE use
 from bio_alloc_clone
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 hch@lst.de, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Mar 22, 2022 at 03:49:25PM -0400, Mike Snitzer wrote:
> -	bio = bio_alloc_bioset(bdev, 0, bio_src->bi_opf, gfp, bs);
> +	if (bs->cache && bio_src->bi_opf & REQ_POLLED)
> +		bio = bio_alloc_percpu_cache(bdev, 0, bio_src->bi_opf, gfp, bs);
> +	else

I don't think we can just unconditionally do this based on REQ_POLLED.
We'd either need a flag for bio_alloc_bioset or (probably better)
a separate interface.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

