Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCEFC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 06:37:15 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-StrSz8QAOfqCM9Huu8w4Tg-1; Fri, 04 Feb 2022 01:37:10 -0500
X-MC-Unique: StrSz8QAOfqCM9Huu8w4Tg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 189471091DA0;
	Fri,  4 Feb 2022 06:37:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DADC37A230;
	Fri,  4 Feb 2022 06:37:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4CB31809CB8;
	Fri,  4 Feb 2022 06:37:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2146SjC5028727 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 01:28:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3CEFC492D54; Fri,  4 Feb 2022 06:28:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38F89492CA8
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 06:28:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F92380B712
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 06:28:45 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-18-E5OsnITPOyeBoAMaChjWtQ-1; Fri, 04 Feb 2022 01:28:42 -0500
X-MC-Unique: E5OsnITPOyeBoAMaChjWtQ-1
X-IronPort-AV: E=Sophos;i="5.88,341,1635177600"; d="scan'208";a="191081417"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 14:28:41 +0800
IronPort-SDR: aUmxgd76dRD4e6kFFUM+jCbrlVVw5NfWBqPNDnYICiSrhqe7ozF15EWDElAD0xSLO8+LsPg5Cj
	GCf5l1sQLs/aASmM3x7sjpzKIWKG+cIdhVwI8qgELVrOZa4NluvG/pvInXidc3KSzmrHRI66s8
	57VwTkO1EPvLGR3Sb/9wOs4YUxlwvn3DwpPUgDLjI4xJvrLF3LKMIepJEButc2MQ6s7HHFqhZI
	9hLajzTIFqHTYUbJJh/Cdwd36AalH+88GWU0KemBREDsQZGOr9yK4lx6jgGETlV+v3y+knhO7U
	TJGvf/UgZ2mDfhiSRB+kOtDZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	03 Feb 2022 22:00:36 -0800
IronPort-SDR: tFeTqjKugeU2QKQSswhfF2Y92ZhsJUCuUTEN+nANQSzOpj2ajY0hfvITpfs9Kh9uhoTL66QVup
	e6aOui3DfZfAFaNcWOTspV2TPXuRhvICbj8kEx864fHZo9uMkZeGNKtF2xbRiFU8//94YKosXx
	KUmm2F4IJLSiIFjr+SveNChc5ZXbKxnlwBQ7vBov+V6I9M0uCY2cghSRAKM9MnJfoXAo78IAuC
	/DFL7DoOp0UXZOWdQnEbH/yJHb38gZg2RMx80alBbKiYbGOU1grZId/NcmIgP2yQ0pPE0gTuV3
	jaA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	03 Feb 2022 22:28:41 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jqlwl5s2Mz1SVp4
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 22:28:39 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id L_o3hdiOc0vJ for <dm-devel@redhat.com>;
	Thu,  3 Feb 2022 22:28:39 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jqlwf4v8pz1Rwrw;
	Thu,  3 Feb 2022 22:28:34 -0800 (PST)
Message-ID: <2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
Date: Fri, 4 Feb 2022 15:28:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Adam Manzanares <a.manzanares@samsung.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
	<20220203153843.szbd4n65ru4fx5hx@garbanzo>
	<CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
	<20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
	<20220203195155.GB249665@bgt-140510-bm01>
	<863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	=?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>,
	"jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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

On 2/4/22 12:12, Chaitanya Kulkarni wrote:
> 
>>>> One can instantiate scsi devices with qemu by using fake scsi devices,
>>>> but one can also just use scsi_debug to do the same. I see both efforts
>>>> as desirable, so long as someone mantains this.
>>>>
> 
> Why do you think both efforts are desirable ?

When testing code using the functionality, it is far easier to get said
functionality doing a simple "modprobe" rather than having to setup a
VM. C.f. running blktests or fstests.

So personally, I also think it would be great to have a kernel-based
emulation of copy offload. And that should be very easy to implement
with the fabric code. Then loopback onto a nullblk device and you get a
quick and easy to setup copy-offload device that can even be of the ZNS
variant if you want since nullblk supports zones.

> 
> NVMe ZNS QEMU implementation proved to be perfect and works just
> fine for testing, copy offload is not an exception.
> 
>>>> For instance, blktests uses scsi_debug for simplicity.
>>>>
>>>> In the end you decide what you want to use.
>>>
>>> Can we use the nvme-loop target instead?
>>
>> I am advocating for this approach as well. It presentas a virtual nvme
>> controller already.
>>
> 
> It does that assuming underlying block device such as null_blk or
> QEMU implementation supports required features not to bloat the the
> NVMeOF target.
> 
> -ck
> 
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

