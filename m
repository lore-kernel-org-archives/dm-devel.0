Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFCAC4167B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:20:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 18C982389E
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:20:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18C982389E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-xt_pZ07nPfunF8oHdwRJuQ-1; Tue, 08 Dec 2020 23:20:21 -0500
X-MC-Unique: xt_pZ07nPfunF8oHdwRJuQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8DE21007487;
	Wed,  9 Dec 2020 04:20:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FD6A5D6AB;
	Wed,  9 Dec 2020 04:20:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1CB4C4BB7B;
	Wed,  9 Dec 2020 04:20:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B94K928026167 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 23:20:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 60DF22026D11; Wed,  9 Dec 2020 04:20:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B5A22026D5D
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 04:20:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E249B858284
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 04:20:04 +0000 (UTC)
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-221-S1ym0MRFNtyhnMk-_imSAg-1; Tue, 08 Dec 2020 23:20:02 -0500
X-MC-Unique: S1ym0MRFNtyhnMk-_imSAg-1
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
	by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0B949u0E131946; Wed, 9 Dec 2020 04:19:47 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by userp2130.oracle.com with ESMTP id 3581mqx3qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL); Wed, 09 Dec 2020 04:19:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0B94Anxw018646; Wed, 9 Dec 2020 04:19:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserp3030.oracle.com with ESMTP id 358ksphs6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Dec 2020 04:19:46 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B94Jh8Y005517;
	Wed, 9 Dec 2020 04:19:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Tue, 08 Dec 2020 20:19:43 -0800
To: SelvaKumar S <selvakuma.s1@samsung.com>
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blf3smcl.fsf@ca-mkp.ca.oracle.com>
References: <20201204094659.12732-1-selvakuma.s1@samsung.com>
	<CGME20201204094731epcas5p307fe5a0b9360c5057cd48e42c9300053@epcas5p3.samsung.com>
	<20201204094659.12732-2-selvakuma.s1@samsung.com>
Date: Tue, 08 Dec 2020 23:19:40 -0500
In-Reply-To: <20201204094659.12732-2-selvakuma.s1@samsung.com> (SelvaKumar
	S.'s message of "Fri, 4 Dec 2020 15:16:58 +0530")
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	suspectscore=1
	bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012090028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1
	mlxlogscore=999
	clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
	lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012090028
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, damien.lemoal@wdc.com, sagi@grimberg.me,
	snitzer@redhat.com, selvajove@gmail.com,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	hch@lst.de, linux-block@vger.kernel.org, kbusch@kernel.org,
	dm-devel@redhat.com, joshi.k@samsung.com,
	javier.gonz@samsung.com, nj.shetty@samsung.com
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] block: add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


SelvaKumar,

> Add new BLKCOPY ioctl that offloads copying of multiple sources
> to a destination to the device.

Your patches are limited in scope to what is currently possible with
NVMe. I.e. multiple source ranges to a single destination within the
same device. That's fine, I think the garbage collection use case is
valid and worth pursuing.

I just wanted to go over what the pain points were for the various
attempts in SCSI over the years.

The main headache was due the stacking situation with DM and MD.
Restricting offload to raw SCSI disks would have been simple but not
really a good fit for most real world developments that often use DM or
MD to provision the storage.

Things are simple for DM/MD with reads and writes because you have one
bio as parent that may get split into many clones that complete
individually prior to the parent being marked as completed.

In the copy offload scenario things quickly become complex once both
source and destination ranges have to be split into multiple commands
for potentially multiple devices. And these clones then need to be
correctly paired at the bottom of the stack. There's also no guarantee
that a 1MB source range maps to a single 1MB destination range. So you
could end up with an M:N relationship to resolve.

After a few failed attempts we focused on single source range/single
destination range. Just to simplify the slicing and dicing. That worked
reasonably well. However, then came along the token-based commands in
SCSI and those threw a wrench in the gears. Now the block layer plumbing
had to support two completely different semantic approaches.

Inspired by a combination of Mikulas' efforts with pointer matching and
the token-based approach in SCSI I switched the block layer
implementation from a single operation (REQ_COPY) to something similar
to the SCSI token approach with a REQ_COPY_IN and a REQ_COPY_OUT.

The premise being that you would send a command to the source device and
"get" the data. In the EXTENDED COPY scenario, the data wasn't really
anything but a confirmation from the SCSI disk driver that the I/O had
reached the bottom of the stack without being split by DM/MD. And once
completion of the REQ_COPY_IN reached blk-lib, a REQ_COPY_OUT would be
issued and, if that arrived unchanged in the disk driver, get turned
into an EXTENDED COPY sent to the destination.

In the token-based scenario the same thing happened except POPULATE
TOKEN was sent all the way out to the device to receive a cookie
representing the source block ranges. Upon completion, that cookie was
used by blk-lib to issue a REQ_COPY_OUT command which was then sent to
the destination device. Again only if the REQ_COPY_OUT I/O hadn't been
split traversing the stack.

The idea was to subsequently leverage the separation of REQ_COPY_IN and
REQ_COPY_OUT to permit a DM/MD iterative approach to both stages of the
operation. That seemed to me like the only reasonable way to approach
the M:N splitting problem (if at all)...

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

