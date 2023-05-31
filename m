Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12B23C77B7C
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 04:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685506838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Pm1z+kVqWbjaxGlwDeQFznjeaTJVp/p72ZnOnwk1vd4=;
	b=e5XS/N1v5QRdzQ9K8p7JdcIVqqkVQS5/Ule0SE7pGKtP98On9m8Wij5DHTLtMhn/c2smFd
	vz9iWRmqceMeiB/U7c03rJphebd7pHFmUkcy5aulI++yrzs4FxL7BSCh8Xx1TkhpBw0oSl
	NgMbfcHlJpya/jAfaW0KlCGftkZRuUU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-JH49zPNcN7uYs6dUPGXR4Q-1; Wed, 31 May 2023 00:20:37 -0400
X-MC-Unique: JH49zPNcN7uYs6dUPGXR4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 143131C01E9A;
	Wed, 31 May 2023 04:20:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCD2C20296C6;
	Wed, 31 May 2023 04:20:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9802519465A0;
	Wed, 31 May 2023 04:20:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B00B1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 04:20:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0747DC154D2; Wed, 31 May 2023 04:20:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F33C8C154D1
 for <dm-devel@redhat.com>; Wed, 31 May 2023 04:20:29 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCE5E802E58
 for <dm-devel@redhat.com>; Wed, 31 May 2023 04:20:29 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-EOSSwoM2ObGmUVcLYf6E_A-1; Wed, 31 May 2023 00:20:28 -0400
X-MC-Unique: EOSSwoM2ObGmUVcLYf6E_A-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 2D08668B05; Wed, 31 May 2023 06:20:23 +0200 (CEST)
Date: Wed, 31 May 2023 06:20:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Message-ID: <20230531042022.GA32705@lst.de>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <64f8ac179cc54aa316c75aaadd71e107ba12917d.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
In-Reply-To: <64f8ac179cc54aa316c75aaadd71e107ba12917d.1685461490.git.johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 01/20] swap: use __bio_add_page to add
 page to bio
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Matthew Wilcox <willy@infradead.org>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, gouhao@uniontech.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

