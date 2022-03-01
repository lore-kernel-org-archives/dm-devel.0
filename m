Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA56CC433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 11:02:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-BLe5inFeMtWkA-i1b7dHHg-1; Tue, 01 Mar 2022 06:02:46 -0500
X-MC-Unique: BLe5inFeMtWkA-i1b7dHHg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C157801AB2;
	Tue,  1 Mar 2022 11:02:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DB037C0C4;
	Tue,  1 Mar 2022 11:02:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0A7A14A701;
	Tue,  1 Mar 2022 11:02:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 221B2efO008309 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 06:02:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 37D281410F3B; Tue,  1 Mar 2022 11:02:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33D96140241F
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 11:02:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19DB0185A79C
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 11:02:40 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-522-3cxa8_GoPNWgbn_yE3NSnw-1; Tue, 01 Mar 2022 06:02:38 -0500
X-MC-Unique: 3cxa8_GoPNWgbn_yE3NSnw-1
X-IronPort-AV: E=Sophos;i="5.90,145,1643644800"; d="scan'208";a="306095781"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2022 19:02:37 +0800
IronPort-SDR: Srx8R1vtPAvjLx0IvGH2M7gTNyKeP1MB16UT+zJX01WQoMjq1Hg64/mqLoQMwyNF4UprvLvW0O
	QGBZA0lO1vUXc+LEiPSvyudl18vevJ8+hK4NTRGm8QD5RWr4+vX4f048dH4EE8eoKyonSetJuM
	td/33Hi222SLH5G9ELUTAsO/ZuJ3v6ccqUVb9U2C0h98UDjnjIZftfXkpq4eocAleorD1G2we5
	Sl9TYI9nwaGCKL09QNPEZ660piVGtavdc08wkJtXe7jed3AKrOAsrhpqQlHzvjwa/9U9TnD4uE
	vhYFsqiQp1cqBEaa1yfvVN+c
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	01 Mar 2022 02:34:01 -0800
IronPort-SDR: Ayh9JtJMLNZ8zzsuc0Vt0JQa0VSKaVPYxJ6mnOjVLRlVabWW+9w4U8wFNUUfyPwz9jF4ejHrJQ
	Y271RJf0A7Sb+cb36qIHH7LMgTy4dZxSeSrFhJjUEgapWO/3dgZBGSqBLR42Yzo4XrWW/rWxh6
	mSBKM+WSa4aDQ8b1JUTKNAojcrDrxi3Ia3rzGDdkCYcER1G1156mNxpa5eSwyV+U41BC4J0ct6
	3wwdb1X/CrUqUVnObT/U+7bfEDIEKS5aKltRSrQwmQnRD3IO0PjmZXlIEwemtyZS8onqGA2eeN
	L00=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	01 Mar 2022 03:02:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K7DqJ6lp8z1Rwrw
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 03:02:36 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id vS3SURztWsEa for <dm-devel@redhat.com>;
	Tue,  1 Mar 2022 03:02:36 -0800 (PST)
Received: from [10.112.1.94] (c02drav6md6t.wdc.com [10.112.1.94])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K7DqH5Z6Gz1Rvlx;
	Tue,  1 Mar 2022 03:02:35 -0800 (PST)
Message-ID: <978afff8-3522-467b-3d8c-d60bdc261c65@opensource.wdc.com>
Date: Tue, 1 Mar 2022 13:02:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
	Gecko/20100101 Thunderbird/91.6.1
To: Christoph Hellwig <hch@lst.de>, snitzer@redhat.com
References: <20220301083815.879515-1-hch@lst.de>
	<20220301083815.879515-2-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220301083815.879515-2-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 2/2] dm: stop using bdevname
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/03/01 10:38, Christoph Hellwig wrote:
> Just use the %pg format specifier instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

