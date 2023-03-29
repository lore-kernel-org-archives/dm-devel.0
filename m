Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7DCC74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 23:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680132704;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yrhQcRqLTYAgcNqMWVzBW0S4Bbgp+rpuaQnkWYF30CA=;
	b=SSw1dTwdqAu7ruljWRs3i6Y2RdXUtXQyJyYgnJ/o2TPYF4pSMkKTbp9hGtqH5+AhfpPYmB
	r4usuDT2jqZP3OOO0GydVb2Rl975lQcI/bA00Zfi1hfvhpXzZRvleZaNf+jbO4a6zmi3Ov
	VghKxa+ygPGAKgoYfxrC+kPpXUUTLXU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-KiIeYOwfOZSM4v4GyBvWwA-1; Wed, 29 Mar 2023 19:31:41 -0400
X-MC-Unique: KiIeYOwfOZSM4v4GyBvWwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AF5785A588;
	Wed, 29 Mar 2023 23:31:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 590DE1121330;
	Wed, 29 Mar 2023 23:31:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 49DF91946588;
	Wed, 29 Mar 2023 23:31:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 936BE1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 23:31:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 83E7F2166B34; Wed, 29 Mar 2023 23:31:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C3D52166B33
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:31:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E8EC800B23
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:31:38 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-vpw9d1mvNzSQaNCNV4q7ww-1; Wed, 29 Mar 2023 19:31:36 -0400
X-MC-Unique: vpw9d1mvNzSQaNCNV4q7ww-1
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="225113432"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:30:33 +0800
IronPort-SDR: eBqhaqIcgueHbYUwNJ2m4D1oVSp9C/rMZUGazIZP7c7SzIQLhAxvlfoi271kvks4+SIhVHcU5U
 TSOpQsv/f67eZMzC5+KeA4MpDAguyj7AZRS7fjAGMC3pjXlwGBOWeP+iGKGPYN/0iYH5nZW6nM
 U1lunvyENfIFCXt+Qgw/KVMb8Xb5xg4S96Stp/QGsyGZ/ZnHZYd9o2AnQIjQs2Tcj9ErudyhX1
 SsimHrnAfEhwMaCqJJHlcDY6loaVrXXUTQFvnc5LNQ1Oo/yJVE/qD44ja+K3WE/7xbA8OLHJ4R
 Ipw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 15:46:42 -0700
IronPort-SDR: 2ETiD/rP7GA957yyHJhloU0sW1HzGbEsS7Ac69lbNynFT0PwcEpuRIoxi4ODotwdttRp7jnz02
 /EgfO+/5YSQOapYlheCh3yRs6MWKW7DFb4r5dMAwHP8MoQZrGiMyzKX9+GIwV4cEwviLFAGXkp
 CKc18MaG+mBXX+K9wEpXtzqczmQq3JEIyz0kGIRoAqSGFqkQ6d418aqUtcoNlfbl1tvXSoLbeL
 OR2/6FH/ryvdv5O8yG/zbxt7kQIbehIkLXwqaSA686m/ovSw0h7e7+qYi1htCoWQf4m9gDDebK
 fbk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:30:34 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2px3cNVz1RtVn
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 16:30:33 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id SNxwrVJwTbil for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 16:30:32 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2pt0C0hz1RtVm;
 Wed, 29 Mar 2023 16:30:29 -0700 (PDT)
Message-ID: <4e4aa0e7-f222-f269-1b5c-1abb3a7179e7@opensource.wdc.com>
Date: Thu, 30 Mar 2023 08:30:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <4a2c46dc0e217a9fb6b9f32d460498a5feb8b67b.1680108414.git.johannes.thumshirn@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <4a2c46dc0e217a9fb6b9f32d460498a5feb8b67b.1680108414.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 03/19] dm: dm-zoned: use __bio_add_page for
 adding single metadata page
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
> dm-zoned uses bio_add_page() for adding a single page to a freshly created
> metadata bio.
> 
> Use __bio_add_page() instead as adding a single page to a new bio is
> always guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() __must_check
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

