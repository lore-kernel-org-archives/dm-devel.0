Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B5BC7EE31
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 04:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685507226;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VX/ZC2aCv46tb/Hr2lUXd8rzrNZF2Oef2E/LtBV0IG0=;
	b=IlrQZ3x0X4szDLq3vySaSb3UKBAJeBvMiBqNgMPww2EGbzRVyMmUcPb3sJqio2R4V8jBeC
	kLJLFIF8EqN/GaHfVP7DMZQcnfPNCCtUMpZ4w1459Erqyenc04i7ehwPKyfL/gOUL5enen
	34oNyjopo903NsLhOI/eZAVX7Vq0Vfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-O5t5325BMueup47VOnaplg-1; Wed, 31 May 2023 00:27:05 -0400
X-MC-Unique: O5t5325BMueup47VOnaplg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AABB811E94;
	Wed, 31 May 2023 04:27:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 28ECB420A8;
	Wed, 31 May 2023 04:27:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B8EFC19465B7;
	Wed, 31 May 2023 04:27:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6298919465B7
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 04:26:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8780920296C8; Wed, 31 May 2023 04:26:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F99A200AE6F
 for <dm-devel@redhat.com>; Wed, 31 May 2023 04:26:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68A4C3855564
 for <dm-devel@redhat.com>; Wed, 31 May 2023 04:26:57 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-K89UuQL9PFSJYaw0GdLC4Q-1; Wed, 31 May 2023 00:26:55 -0400
X-MC-Unique: K89UuQL9PFSJYaw0GdLC4Q-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 89F1768B05; Wed, 31 May 2023 06:26:51 +0200 (CEST)
Date: Wed, 31 May 2023 06:26:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Message-ID: <20230531042651.GO32705@lst.de>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <5a142a7663a4beb2966d82f25708a9f22316117c.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
In-Reply-To: <5a142a7663a4beb2966d82f25708a9f22316117c.1685461490.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v6 18/20] block: add __bio_add_folio
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 gouhao@uniontech.com, Mike Snitzer <snitzer@kernel.org>,
 jfs-discussion@lists.sourceforge.net, Matthew Wilcox <willy@infradead.org>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 30, 2023 at 08:49:21AM -0700, Johannes Thumshirn wrote:
> Just like for bio_add_pages() add a no-fail variant for bio_add_folio().

Can we call this bio_add_folio_nofail?  I really regret the __ prefix for
bio_add_page these days - it wasn't really intended to be used as widely
originally..

> +void __bio_add_folio(struct bio *, struct folio *, size_t len, size_t off);

.. and please spell out the parameters.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

