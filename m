Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B3F3C6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 23:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680132852;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+dF/pGilwQzAQia+8u2PTHeRkikGXSaJl2Sfy674RLc=;
	b=fd0fyrin6aBTWNv5fu8bEnSrE4sqI/ZodO82k7gC9Uvecqg7htV72VtaxUt1BoVWSbN6R+
	0Nhiy/JLz2hhahJ7cMZM+JVg5Se2kCx7SBFW2eUtNTEeIx1krrGOGDCZKtdBDN/3ToQMaJ
	tBxQeEAVD6Cysp9nXLfUz98F6NrnTcc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-58hJVmAoNS2LQ9AkPwwrIQ-1; Wed, 29 Mar 2023 19:34:10 -0400
X-MC-Unique: 58hJVmAoNS2LQ9AkPwwrIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1070285A5A3;
	Wed, 29 Mar 2023 23:34:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F266C40BC798;
	Wed, 29 Mar 2023 23:34:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B96391946588;
	Wed, 29 Mar 2023 23:34:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE9221946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 23:34:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FC2640BC797; Wed, 29 Mar 2023 23:34:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 96FE140BC798
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:34:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A04E3C0C8B5
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:34:06 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-DAN4j31UOg20ay24FzkcIg-2; Wed, 29 Mar 2023 19:34:04 -0400
X-MC-Unique: DAN4j31UOg20ay24FzkcIg-2
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="226648257"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:34:02 +0800
IronPort-SDR: brIvEUHU2ImQ4KAvCe5os7mbFWqBiE2cojGJALngdkv4/0MP9puEBOWJW679hTdziCqpQb+p9G
 hDY2t+9QP7tHN1eU8ljkaKZr16LZ9DKXdSd6gTUyTXJAJx32Z80LgwiBaGEzLKC8V179L/twV+
 1mw6RD5vQ0OraoQvFV/v1zVVmwxCOH/71bEJxsSTvD7bycJnN9PBQXuiRjnpq1ZqMe38CP8TRa
 Gg4xBcS8bZmtkg+BeIIxc5v/pcYvvxJ2egHdrSdj4N0eGkKbvFX7UtrLdeVjObhWt0QkTPxLRv
 Q2A=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 15:50:10 -0700
IronPort-SDR: FbUcLuxgNXZwT1JVVohtbvbbvHkXt0FePsAiRBe//+BNHvkb2HvbDJue0Q1WwCbfsGZ0oEwKgZ
 t/A2mnJtXB3idG1LUPq7vIaxdhVCDt/X5UrP3sj/n2cONdyvDVVj77wzgw9i8SfQ8ULhqFOmBa
 UrgjUd19haI7N7CtyDbsIPy5Wgxc5YBAnK8sW5TKxNErsfJxNOa6IQZ3fAuHH8qYlfO/M7IPp5
 HO8nzYwJIzaDsF1CTZFEcKzgymFEWTvNKA8GHP+05wa5SXNSSbPs28TcJIR46DaJaTJkw7gE8r
 omI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:34:02 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2tx4rssz1RtW3
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 16:34:01 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id hLE8pHECZQwq for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 16:34:00 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2ts6Vtrz1RtVm;
 Wed, 29 Mar 2023 16:33:57 -0700 (PDT)
Message-ID: <3f1c6faf-b558-14ba-a2bc-ac12aad41ba9@opensource.wdc.com>
Date: Thu, 30 Mar 2023 08:33:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <5ce38530bc488f9d4f1692d701ca7ad5ea8ca3e9.1680108414.git.johannes.thumshirn@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <5ce38530bc488f9d4f1692d701ca7ad5ea8ca3e9.1680108414.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 09/19] btrfs: raid56: use __bio_add_page to
 add single page
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
Cc: linux-raid@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The btrfs raid58 sector submission code uses bio_add_page() to add a page
> to a newly created bio. bio_add_page() can fail, but the return value is
> never checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
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

