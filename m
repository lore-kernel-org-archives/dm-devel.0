Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88325C74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 23:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680132951;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NpMR/9xvAQBPv8fxinmD775O8alX3TXj9cBF94Esjrc=;
	b=A+EeM8pGm88317CzAW02IkeJzqOvV6MG+64QEQ04BHui8Mr7S7P+tL42c69+euUKWVv1wY
	YjDR33JbWN7lgLzHV3f7CPVgDwTyCeKNbkcvip6s/aitNfqhNNYcTEg6MGNEdI4UM0nGgY
	xtkt0x3Yd27DY5U94rjh3G6DMDo6IXI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-uP8ERUoFPVaVTrs1mg45Aw-1; Wed, 29 Mar 2023 19:35:48 -0400
X-MC-Unique: uP8ERUoFPVaVTrs1mg45Aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75711800B23;
	Wed, 29 Mar 2023 23:35:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 642C01121330;
	Wed, 29 Mar 2023 23:35:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14D041946588;
	Wed, 29 Mar 2023 23:35:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 53EE41946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 23:35:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 41E5640BC79A; Wed, 29 Mar 2023 23:35:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38FFB40BC79D
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:35:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 120952814240
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:35:44 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-zDW1KNAfNHG82EAdlmzVaw-1; Wed, 29 Mar 2023 19:35:39 -0400
X-MC-Unique: zDW1KNAfNHG82EAdlmzVaw-1
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="225113750"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:35:38 +0800
IronPort-SDR: Poro64r2/PAfUvUAwK+EqE6HodaTciN+Gey7lZh9mKWf3nXYpASdlQeNZ9BQBu32bemGpxMIE3
 uyA2Aafvv/RJg1LoFZkCmIG60JzltLBWRma834To8acds3Hb8SD63caNe1qt7WJYfp4oJbCH7q
 cbwaSFmZly56+Gz6Xb/0aPNVP9iPgbtLieWSXsLlAMqQfWQlD8n30XFMBHZGo1+HrzfY6V27lO
 8irzjNyfWJo4lDRfpx2hO2OCbswYlrnvf/0IAwT7nN8bFdBLYZIS7HiJyM/aU2Il/6WfyR83ob
 Evs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 15:46:06 -0700
IronPort-SDR: 3zrIT7YL5G5P3qkNg2K4bexgD7gc15ZSbiPGNYQLzHOuyD2U8Hk4VfOMEvPrejaoMF4yGZ42w9
 iz+4CRdv+pyYwSele2s9kzPjpdYeZSTVf5g50fYmUIAGkf1/9pU9iYbUzYgS+mW47y7F063RmE
 iDdcPgeASH57rpgekIfrQIDyDw3avsVSme9WxVcO4eeUQ2SHi5+UWcWzkZH1CBZrosjUXLQB4V
 SF/4tYeDfsSjeauJJ7mA0sU3pHN7xicKfFkc0PNggVh843cXhtpGpikeXQgXK8RvAGsJJ28AsK
 ff8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:35:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2wp1Lfjz1RtVp
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 16:35:38 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 01Qs8j7lzMtT for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 16:35:37 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2wk4Fdnz1RtVm;
 Wed, 29 Mar 2023 16:35:34 -0700 (PDT)
Message-ID: <ce3889b4-8689-ac73-0761-fc35a78b8dbd@opensource.wdc.com>
Date: Thu, 30 Mar 2023 08:35:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <ef742ee32fd0623008114e929d9a3e688fd721f7.1680108414.git.johannes.thumshirn@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <ef742ee32fd0623008114e929d9a3e688fd721f7.1680108414.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 12/19] zonefs: use __bio_add_page for adding
 single page to bio
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The zonefs superblock reading code uses bio_add_page() to add a page to a
> newly created bio. bio_add_page() can fail, but the return value is
> never checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

