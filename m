Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60016C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 11:01:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-a0DvvGViO1KAreDZwTATjA-1; Tue, 01 Mar 2022 06:01:30 -0500
X-MC-Unique: a0DvvGViO1KAreDZwTATjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A4AB1091DA2;
	Tue,  1 Mar 2022 11:01:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 195FE8308F;
	Tue,  1 Mar 2022 11:01:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09CB51809C98;
	Tue,  1 Mar 2022 11:01:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 221B1LgU008222 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 06:01:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 746F8C50943; Tue,  1 Mar 2022 11:01:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70137C50941
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 11:01:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56FA6801585
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 11:01:21 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-468-ETXc-IBgNd-_2bEvD6nDXg-1; Tue, 01 Mar 2022 06:01:19 -0500
X-MC-Unique: ETXc-IBgNd-_2bEvD6nDXg-1
X-IronPort-AV: E=Sophos;i="5.90,145,1643644800"; d="scan'208";a="194193882"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2022 19:01:17 +0800
IronPort-SDR: wIpRh6nYl3UGvdEMBlTKtLh31SH8AkCXb9HZWIDR9+ovXUj4PODdfaoATN2zydt6d03zGWqSwR
	6uscfBuJ6ZzH12oc4l57ZNo6IQsN3FPKQ+OlUoVmNZdZXKoVPPTsXwDCRtOQsPdXbkU6nVG2KV
	ZlwVt7dbyQl7/C/GxtIgNK6l1AI4QKpFQdZAL2Kmdk0G8Ba9f+UnUnNSMPwlQQASBOHesvIwR+
	OERGnedcxUoSuaZ3fD1hI3bS0+q8wc2RzuZMC0RuRjdsDYosXCRzU9ZHoLekoAC6t7hhSpPuAG
	Rv5hWHTlmhPpRZWjSM427lnH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	01 Mar 2022 02:33:44 -0800
IronPort-SDR: NU8n43WN6srhfaxx2GZEqrgmR2JHBCMi+l2FV34r+D+gLqcb8xCS+9x1oP/IEKewcGplWd6Iu5
	9vrcm4sENKSP8K9GJxDQ5xBh0lPi3GKIka0nrzZf9zg5pynv4JSeiOTuCxqfsoq+uC2V5eHzcr
	B2N4X63H8QYD0wqCRUVCbwv3pu3kRSIs3/fjWD6Sk28HPRI+syBhGFJz7zI07pULdrumN6fp05
	fddMSUOmqGUj2IHnQCOP796TTkKcoLiGTfAbIp3dVsM+mujozRtH32n21M3Z93l/yXoV5kB4iW
	ido=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	01 Mar 2022 03:01:17 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K7Dnn1y8rz1SHwl
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 03:01:17 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id Oj1hR7KByL1c for <dm-devel@redhat.com>;
	Tue,  1 Mar 2022 03:01:16 -0800 (PST)
Received: from [10.112.1.94] (c02drav6md6t.wdc.com [10.112.1.94])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K7Dnl6r81z1Rvlx;
	Tue,  1 Mar 2022 03:01:15 -0800 (PST)
Message-ID: <59d27cf5-e474-d7c5-52fc-d5de515a9f97@opensource.wdc.com>
Date: Tue, 1 Mar 2022 13:01:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
	Gecko/20100101 Thunderbird/91.6.1
To: Christoph Hellwig <hch@lst.de>, snitzer@redhat.com
References: <20220301083815.879515-1-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220301083815.879515-1-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/2] dm-zoned: remove the ->name field in
	struct dmz_dev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/03/01 10:38, Christoph Hellwig wrote:
> Just use the %pg format specifier to print the block device name
> directly.
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

