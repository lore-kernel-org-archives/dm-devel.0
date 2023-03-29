Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8B1C74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680132574;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UMfSx7jKbv6k1QfHxZjZaBAUtueka6bx9p7y0SoNZB4=;
	b=NOvGrbZKYjPl7ogitPZyCtkX8+90uhjf0JrC845d05zXHEnpsnU5EnLCq52XCeIoDaiUib
	gt8VerNqWqQ9CRUj/f4s76X/aUVzRIA9KsXaw6E+RKQgKpgk3tjEswEQW3+tV5rn72pVYM
	yKUy0WpGjGTttZQ2PFkRiLMtvLPAJ/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-dyfVz2YGNkSLHnkkEJU5ow-1; Wed, 29 Mar 2023 19:29:31 -0400
X-MC-Unique: dyfVz2YGNkSLHnkkEJU5ow-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA66B185A78F;
	Wed, 29 Mar 2023 23:29:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD8E0492B00;
	Wed, 29 Mar 2023 23:29:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7CE2D1946588;
	Wed, 29 Mar 2023 23:29:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3108D1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 23:29:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1433440BC798; Wed, 29 Mar 2023 23:29:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CB5C40BC797
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:29:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6653857F48
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:29:24 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-IzGwj-OBNCGhvd5VdFEzWA-3; Wed, 29 Mar 2023 19:29:23 -0400
X-MC-Unique: IzGwj-OBNCGhvd5VdFEzWA-3
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="226647943"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:29:20 +0800
IronPort-SDR: aCHvRaqS1Ek8sh4yEDRnt5tiAW5S9KWRLbM2pI/SEje4pi5jeDd5YJ0TWadjad0Yy9GPhFVnTl
 KGTUqgd503+i4Hdim5UTOqW6zGFdKGe/KJfxYrT4M2sObCzZ3qvz3yC59+NsWcEpvL7s31cV8l
 gfKeYiRrFjfZWi6Et1aYAdVl4fU5vuIS7dtYG4IC03LqCEj+bO4SemMUksIi54Kt0/1Ail77AJ
 tt/Ij5w3mQXtEozKGvRVGiVkxd4PrGIqVjiF/lE/kGjon5YjvcBirLIe+XpsCih4hLWUoGDfBg
 SAc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 15:39:49 -0700
IronPort-SDR: PKnyaE6lMbU1WItImtOkf5WYE1Q6yej6te/e4zmsDNShQFTZG+mklbyrk9GBwF+0f62dWdBMBN
 Qh29hYIZY4aqcTEEjZialp3k1pwBI2yfHzxJ6NuYi8GfYtXQouYE70QYE2xYconnexbfluFAMD
 8978rXoOPZLTrNFThUhR5qoYg3ltcECfPd/1Ze2Wg3yBX9AEc6h/ViH2d5sEUrvGSS5cmrkpeb
 JTu5VARYxl4rxPMhT+8CTSi7+hmNerCaqOuzZNJt9lzRbiv3XBPS6WOh2008e5SwVXxLv4fVZa
 wT4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:29:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2nX1rnNz1RtVy
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 16:29:20 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Ul4XdvRTHRzM for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 16:29:19 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2nR75BJz1RtVm;
 Wed, 29 Mar 2023 16:29:15 -0700 (PDT)
Message-ID: <a3e8f1cb-4d76-dcb0-41a7-43b015d25dd4@opensource.wdc.com>
Date: Thu, 30 Mar 2023 08:29:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <7849b142e073b20f033e5124a39080f59e5f19d2.1680108414.git.johannes.thumshirn@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7849b142e073b20f033e5124a39080f59e5f19d2.1680108414.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 01/19] swap: use __bio_add_page to add page
 to bio
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
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 jfs-discussion@lists.sourceforge.net, Matthew Wilcox <willy@infradead.org>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, dm-devel@redhat.com, David Sterba <dsterba@suse.com>,
 linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-btrfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The swap code only adds a single page to a newly created bio. So use
> __bio_add_page() to add the page which is guaranteed to succeed in this
> case.
> 
> This brings us closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

