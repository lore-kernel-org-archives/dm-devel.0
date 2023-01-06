Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0ECCC3DA7A
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 11:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673003001;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Yi/k/fBORssZ1hqMVbghQD2A7dmHO3pBJaewN0AFsFo=;
	b=MD2mC8xg3YfgJ0OpOoPGl3jck9+vhclYlG6YdEWD8j1soQc5pFKfbiAtldn106KSsHa55Q
	ViVifeM1h7d4pqhwS7FL90H3iFA8R+TYQKy34R7d/ZnRjsYwOe2FMLNXSyNBWoO579Yj3P
	kMpnTCGlq+yPPeOIvOsOVgqRjnnYEcE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-JIkZKJMrNZuZah40dReFqg-1; Fri, 06 Jan 2023 06:03:18 -0500
X-MC-Unique: JIkZKJMrNZuZah40dReFqg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 975593810788;
	Fri,  6 Jan 2023 11:03:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84189C15BAE;
	Fri,  6 Jan 2023 11:03:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5537419465B9;
	Fri,  6 Jan 2023 11:03:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DCFD1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 11:03:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68CEE492B01; Fri,  6 Jan 2023 11:03:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 617E4492B00
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:03:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46DA7882821
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:03:15 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-xjep76EjNnuzAmhe1wWqaQ-1; Fri, 06 Jan 2023 06:03:11 -0500
X-MC-Unique: xjep76EjNnuzAmhe1wWqaQ-1
X-IronPort-AV: E=Sophos;i="5.96,305,1665417600"; d="scan'208";a="324460525"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 06 Jan 2023 19:02:07 +0800
IronPort-SDR: /qna3FBLUmXXSED4B1FF4pdrTBgxko83613qc7ceXOAOBmuGE9dO+9I1QujmCOQtPnNli/KMmr
 mfw3xnTbJis8KTMCPoQDLibrJABDfHxDJLWmOfStTBgpKLq6u5JqIJNidr4AgfRa/aMAEN/8La
 bZ7kboXu7u+W6ttvJyCOllfmad/eVnoOxhCaR0Her1f09kygJnuk0TRsU5khJ6K1p0nIKkK49m
 wV+H1fzBZmK8ntkPW+oVsPvXAeZt1UlmXtDxfIgMJ6ZizczCfwat9mIEKHWfTKYpd1cG+FiPy6
 T7g=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 02:20:02 -0800
IronPort-SDR: xufME9N4Cjh70Ow+LSxETMIar7/FMg+BwxioZGE3JsfadyC2rnQGv/+v2kX16F+HVyko2fV9r0
 8Xjx/DflLYSe6h9g/Ads7PuoBhUMnEqCp3+qPyVEc0jIOHVvgiTtPEDIbtB45jT8dWNXYMJD/T
 hyqC3YXrL9nBTVT4KZmfZtX//UI0G4bA+VvlFly8/398bHEU06ARs5ovJYHMuR+PL/1rIkAVbO
 uCwYdBDj2dmKlXRvSk8Aeg+/HOK49ha6au3BkqS79/y7BKgRntlZxl9IK8RfQGf/bVlbnyzEdB
 9v8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 03:02:08 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NpL5B4VNKz1RvTp
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 03:02:06 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id b6z8pZbtjS00 for <dm-devel@redhat.com>;
 Fri,  6 Jan 2023 03:02:06 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NpL583jLFz1RvLy;
 Fri,  6 Jan 2023 03:02:04 -0800 (PST)
Message-ID: <e6216fe9-f77a-adb5-6ab4-2f86d6a86ef5@opensource.wdc.com>
Date: Fri, 6 Jan 2023 20:02:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083320eucas1p1d23de4ad21d0a7aecb74c549ebc7757c@eucas1p1.samsung.com>
 <20230106083317.93938-4-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230106083317.93938-4-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 3/7] nvmet: introduce bdev_zone_no helper
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
Cc: bvanassche@acm.org, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/6/23 17:33, Pankaj Raghav wrote:
> A generic bdev_zone_no() helper is added to calculate zone number for a
> given sector in a block device. This helper internally uses disk_zone_no()
> to find the zone number.
> 
> Use the helper bdev_zone_no() to calculate nr of zones. This let's us
> make modifications to the math if needed in one place.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

