Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AF7CCA47C
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988099;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BI5iDVB+zwwQrwaak5qJPYX6UBkA7RfT9B7mhl4DAUA=;
	b=JE5U29wtoKYOQ8M+5Wn1uykjCJJf7zslfHntxCV62/LNPdWGFALjxGUI0MagqKq3EcxBdl
	GIiGkUFZSrLvI9yRG+2fgM67eC+eTKJZpXdNx90VG3u0qWqiDNSDNrTDKOuS3CQMnuov3T
	pvSEVPvk/MO65Vhs5oo+jYR7ORPlCck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-kyP33rOSOTm-Ra2K8C2PQA-1; Mon, 04 Jul 2022 22:28:18 -0400
X-MC-Unique: kyP33rOSOTm-Ra2K8C2PQA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BBBC185A79C;
	Tue,  5 Jul 2022 02:28:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 342392166B26;
	Tue,  5 Jul 2022 02:28:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 03C2F194704A;
	Tue,  5 Jul 2022 02:28:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A91D31947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:28:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9744B40C1241; Tue,  5 Jul 2022 02:28:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 933324010D28
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:28:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B37B81D9DA
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:28:15 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-lC2iHuDzPxi274ONjezAww-1; Mon, 04 Jul 2022 22:28:13 -0400
X-MC-Unique: lC2iHuDzPxi274ONjezAww-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="205518843"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:28:12 +0800
IronPort-SDR: eu0pVyj0a0yE8IXVrQqFraKFtENJZX9JLP5+5kd92tEjO4B50bQA8uf6siB9O0AFUlT1gQd92U
 zuOZtXLV70FXmUkGgdHURuKGAfKw9j4TpaC6F1ydGvCQKTMq76aUyplXTRHh9z5ocSnOw5FvdB
 GziLc5E1gGHW1CgLd4mb65dbye0YWU2hoQRKBPyguSXL78OjOWIm5fNYgNUtQb5ThT8CW9ITBK
 rtVpGCEnEPGIT7+FYJFJ0mFjnEAQcLhOfp+xzUhOAxAQtQ15mAAtYDU0NQ4l6fJHd0zr5qNLU7
 hs9kBCX7RKEutyl26frOQtRH
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:50:03 -0700
IronPort-SDR: sTLcWtjDEHjyWBGYdXfV6jMsieyzRq/OqwLtZujt1NPGT9CjGrs1rK3bOyoKTo4V7J+xa9cj/v
 A8XdSAUsxpVwKZkU3oQD/A2X8qhj1y6WDH6CYCZMCj1v1IjIhQiM0+n/vR52FG0OJgYI7/imYI
 sCEzqWBgqFh+GmP20NNLFt92pNMS46O9pEA4tEr4tLwYapOIloe5HiN21pYZx0pYZQohsHId4Z
 mXShLyaHeolgwyQIQWyza7S17Ba0dgUvjeHmhB8n8G9rD3BjBWvQwArMCEbi3lUWp9PkNPhhTc
 wys=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:28:13 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRRc1Zpcz1Rwnm
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:28:12 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id QCUh9ZUmOUC8 for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:28:11 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRRb080Dz1RtVk;
 Mon,  4 Jul 2022 19:28:10 -0700 (PDT)
Message-ID: <7424fcbe-ebca-96c4-0236-211e0e44894b@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:28:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-4-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 03/17] block: use bdev_is_zoned instead of
 open coding it
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Use bdev_is_zoned in all places where a block_device is available instead
> of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

