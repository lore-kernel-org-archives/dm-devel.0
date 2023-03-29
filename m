Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D083C6FD18
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 23:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680132673;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A39dsHUKacDSTLv/4Zw5f3MkDlWk3BJ1SkhCxV5Q9VQ=;
	b=ERt6vMb4+C+Aire9O+fxOx97kCCIByxSRnf1Or3ElI01XS9QDKQu+1uiEEgJNIFhobdKVW
	sna5DUzbFHYGs0sJ5Ob1oCDyK77tawJyIZSJ+R90RMpx16NjzTK9fdBRVHD0P5tEJ1xzta
	/D7gvUHzZAcItO3Wbj2t4p5rWY5Q2g8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-hBnzsGjQM7G_HIppJsxeNg-1; Wed, 29 Mar 2023 19:31:10 -0400
X-MC-Unique: hBnzsGjQM7G_HIppJsxeNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 521DC85A588;
	Wed, 29 Mar 2023 23:31:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3EF4E40BC798;
	Wed, 29 Mar 2023 23:31:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E367D1946588;
	Wed, 29 Mar 2023 23:31:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36EA51946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 23:31:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1A602440D7; Wed, 29 Mar 2023 23:31:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 124D618EC2
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:31:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5F91800B23
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 23:31:06 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-UZ6zbhisNpynV-pLenXyJA-2; Wed, 29 Mar 2023 19:31:05 -0400
X-MC-Unique: UZ6zbhisNpynV-pLenXyJA-2
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="225113379"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 07:30:00 +0800
IronPort-SDR: Frg5G/bHfaBOvAqsUUSNoPb1uM25qg/HB4kRp3WpxFSmtzGryMlcSY4P1Rph/IPu2q7DQWKgVf
 IGZkbozUDhVveYFitBJPG+9ZyJBArFyQFVQP6Le9IMsQYEpjE7gQCzpt2fhlxlDsskngavGbVi
 Ql7+U30WE+jPe2E+xMePz/OBvpaqhdTR+p4cFKAvPi/RHTUAJyj0ca0wqNsqEFXgzDQxUpIyre
 Vz2+oxFITr/e8i++dFxFn0z7II7ppi47DeLvWdXQAX5nn0y5aPWYhbSfXpcLT3ZFUQkjdhBMBt
 7KY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 15:46:09 -0700
IronPort-SDR: McTEBXQd+LK2qZHNJ1JA40yZO3jTPX/WpZYQHjV8iRN0j66Q2FXz119jTOR2UdpQYdgLhi2vFp
 +XuX7alHKIPO0CUZVN2ZWZuOeQ+B3DnoGzPt6XtOBDWtA9gkIklZFbgX4w9DRB+ZlOOdPgSawF
 x+QXwWi6VBApez3oEAHU1v602MWwSZuKrj6IR56BQPAZJyiayUxPHo6WPW9xwNPVVkE9r1RhgA
 g3pX7tjIWJtE2H/7Olk5ILG4ul7bh7hqvPzrukcuwX3324ikVNEmslU4mQaUcF2PfVzKNNfwxw
 47A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 16:30:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pn2pJ0fVhz1RtVp
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 16:30:00 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 2j-UrIsfLCjY for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 16:29:59 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pn2pD1Xt9z1RtVm;
 Wed, 29 Mar 2023 16:29:56 -0700 (PDT)
Message-ID: <ec7a0c67-a0b6-64d7-0f3e-dee9744daffc@opensource.wdc.com>
Date: Thu, 30 Mar 2023 08:29:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Jens Axboe <axboe@kernel.dk>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <87d0bf7d65cb7c64a0010524e5b39466f2b79870.1680108414.git.johannes.thumshirn@wdc.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <87d0bf7d65cb7c64a0010524e5b39466f2b79870.1680108414.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 02/19] drbd: use __bio_add_page to add page
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/30/23 02:05, Johannes Thumshirn wrote:
> The drbd code only adds a single page to a newly created bio. So use
> __bio_add_page() to add the page which is guaranteed to succeed in this
> case.
> 
> This brings us closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

With Matthew comment addressed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

