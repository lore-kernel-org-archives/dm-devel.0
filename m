Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53079C433FE
	for <dm-devel@archiver.kernel.org>; Tue, 29 Nov 2022 23:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669765587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wW7uzpKYBHimAacC5Ybgl3WYZnwsBtfcMWBetmXYltI=;
	b=eW10OwPfJ45h78eupYv3A9iSzBXwhWrrs6uMYDmSxWxWmEMvSG/F5yqqDdcELhvdzZgGAe
	BLKxpgCZo/oto4/50Kg2r4uOfET8ZHZ0CDXUXllF0C1SCM8oTW0ITeFWL5U5xA8KZd+tIY
	KJ613iowIt2lt0+zjX89J8dNGzHDs00=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-Dkmj90TZNcS_vKfC9olOnA-1; Tue, 29 Nov 2022 18:46:23 -0500
X-MC-Unique: Dkmj90TZNcS_vKfC9olOnA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 896E2101A5B3;
	Tue, 29 Nov 2022 23:46:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDA84492B0E;
	Tue, 29 Nov 2022 23:46:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9D71B1946594;
	Tue, 29 Nov 2022 23:46:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1440194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Nov 2022 23:46:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5A49A2166B33; Tue, 29 Nov 2022 23:46:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 531F02166B2D
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 23:46:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35BA5811E67
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 23:46:12 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-COrmcwdqMBubMSPFndECvw-2; Tue, 29 Nov 2022 18:46:10 -0500
X-MC-Unique: COrmcwdqMBubMSPFndECvw-2
X-IronPort-AV: E=Sophos;i="5.96,204,1665417600"; d="scan'208";a="222653238"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 07:46:02 +0800
IronPort-SDR: jeR5i/1mUQEQDYDVIuWWqjm6S0J+DXCW4Lo5n8rN9FtS2OFd0tUx+fddL/e9nzc9bCBw3d2vnq
 JJvlfVOsd1Vws4YAXanmq60YmIgEOjYRdtjTdVodOZrwh6Mqt6hKv7DZbP0kNnr/QvyNCPPeVs
 Z4TaOPUCcLnxlI4R/I06exSl8rmNHv5CcwvqlwHgEETGPENLhBL0RL67EwlPWSZyqMJ4SfI3O9
 atF4IzNRL3e6fe0qPaf4QPOlDnz4q0T/ui3x5JqEiL77LyC3EosztXcQuhUETohLOyrElHaYJJ
 27g=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Nov 2022 15:04:42 -0800
IronPort-SDR: TbAKErGc5rFk9MDsT0x0HbCHLVBMjzjUWS3P1vhh9sg/VjeyLKVPm1FfOWvFH7kD8kPLb5z3oT
 Hdlz+EVbcyutp+nxjr3xB8QQiL8/X0WAbNOfTqtP6jLDnUWZ6ZWEgmEeZOvRVSYNoqkkT0wJcn
 dMp3LUwqTZt02V/mHpwTc49earmdEwiBopbeVdMqzBfRE8WFqKw4sqQ9Jm6byjNbETkdKOxS8M
 sqqJJl4AUgKf/DmT3ZaTOo/6mb84vx5S878BAlQeQwXRNWsLTOpk/K6xHg01AilSYQFcQCNtpa
 Byc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Nov 2022 15:46:02 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NMJr959jRz1RwqL
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 15:46:01 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id bfl71YZMUotQ for <dm-devel@redhat.com>;
 Tue, 29 Nov 2022 15:46:00 -0800 (PST)
Received: from [10.225.163.66] (unknown [10.225.163.66])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NMJr51fc7z1RvLy;
 Tue, 29 Nov 2022 15:45:56 -0800 (PST)
Message-ID: <b22652ee-9cca-a5b1-e9f1-862ed8f0354d@opensource.wdc.com>
Date: Wed, 30 Nov 2022 08:45:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061044epcas5p2ac082a91fc8197821f29e84278b6203c@epcas5p2.samsung.com>
 <20221123055827.26996-11-nj.shetty@samsung.com>
 <729254f8-2468-e694-715e-72bcbef80ff3@opensource.wdc.com>
 <349a4d66-3a9f-a095-005c-1f180c5f3aac@opensource.wdc.com>
 <20221129122232.GC16802@test-zns>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221129122232.GC16802@test-zns>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v5 10/10] fs: add support for copy file range
 in zonefs
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
Cc: axboe@kernel.dk, naohiro.aota@wdc.com, kch@nvidia.com, sagi@grimberg.me,
 joshi.k@samsung.com, gost.dev@samsung.com, anuj20.g@samsung.com,
 snitzer@kernel.org, james.smart@broadcom.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk,
 nitheshshetty@gmail.com, kbusch@kernel.org, jth@kernel.org, hch@lst.de,
 agk@redhat.com, p.raghav@samsung.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/29/22 21:22, Nitesh Shetty wrote:
> Acked. I do see a gap in current zonefs cfr implementation. I will drop this

cfr ?

> implementation for next version. Once we finalize on block copy offload
> implementation, will re-pick this and send with above reviews fixed.
> 
> Thank you,
> Nitesh

Please trim your replies.


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

