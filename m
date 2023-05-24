Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36CA0C77B7A
	for <dm-devel@archiver.kernel.org>; Thu, 25 May 2023 07:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684998759;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MXU+DB4agVrJ+W4yex1LlSJOPmHRyeIUn76DYRrlGlE=;
	b=YG/ZZBZ2MTKdIpBBBYDzdoj11D1zteGVJ2+HrdDEOpeE8hDtE8Nnw38dvs3pkRXa/RxbMg
	mixpPHhb/RWIVdea9ETWWQ51LGG/WpilmnW5MGeFHd6rQu1BtSAeYj55na37J8mssi5I12
	8d9wYtWLsOHDmaIBan4vpk80/8lcQFw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-l7GEmQE7OaqJM7uNHpHDWg-1; Thu, 25 May 2023 03:12:35 -0400
X-MC-Unique: l7GEmQE7OaqJM7uNHpHDWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E20AC8039A9;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE69340CFD47;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C51AA19465BA;
	Thu, 25 May 2023 07:12:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 378F819465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 08:02:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1C389492B0B; Wed, 24 May 2023 08:02:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 150A8492B0A
 for <dm-devel@redhat.com>; Wed, 24 May 2023 08:02:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE7C23C17C65
 for <dm-devel@redhat.com>; Wed, 24 May 2023 08:02:08 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-Ij3a5l9JMzWMs-vTYgKpqg-1; Wed, 24 May 2023 04:02:05 -0400
X-MC-Unique: Ij3a5l9JMzWMs-vTYgKpqg-1
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 34O7e0AX013338; Wed, 24 May 2023 08:02:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qsde4t0rr-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 24 May 2023 08:02:04 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34O7gCE0021753;
 Wed, 24 May 2023 08:02:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.99])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qsde4t0qm-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 24 May 2023 08:02:03 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
 by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34O5u5Dm032628;
 Wed, 24 May 2023 08:02:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
 by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qppdk1u9u-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 24 May 2023 08:02:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com
 [10.20.54.101])
 by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 34O81v6137028370
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 24 May 2023 08:01:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 5FB962004F;
 Wed, 24 May 2023 08:01:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id E22542004B;
 Wed, 24 May 2023 08:01:56 +0000 (GMT)
Received: from [9.152.212.186] (unknown [9.152.212.186])
 by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
 Wed, 24 May 2023 08:01:56 +0000 (GMT)
Message-ID: <2ee323bd-1205-4d3e-1ef1-906e206f1c4e@linux.ibm.com>
Date: Wed, 24 May 2023 10:01:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
References: <20230522183845.354920-1-bvanassche@acm.org>
 <20230522183845.354920-8-bvanassche@acm.org>
From: Vineeth Vijayan <vneethv@linux.ibm.com>
In-Reply-To: <20230522183845.354920-8-bvanassche@acm.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ES7cL-B37BMHgQLCtlAxWJhnpPiNKtU1
X-Proofpoint-ORIG-GUID: UoYM_nZvpDLRKXMqOtRwRUNJZ6PInr_W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_03,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0 mlxlogscore=861
 clxscore=1011 bulkscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305240064
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 25 May 2023 07:12:27 +0000
Subject: Re: [dm-devel] [PATCH v3 7/7] block: Inline blk_mq_{,
 delay_}kick_requeue_list()
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
Cc: Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Mike Snitzer <snitzer@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Damien Le Moal <dlemoal@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Keith Busch <kbusch@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.ibm.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 5/22/23 20:38, Bart Van Assche wrote:
> Patch "block: Preserve the order of requeued requests" changed
> blk_mq_kick_requeue_list() and blk_mq_delay_kick_requeue_list() into
> blk_mq_run_hw_queues() and blk_mq_delay_run_hw_queues() calls
> respectively. Inline blk_mq_{,delay_}kick_requeue_list() because these
> functions are now too short to keep these as separate functions.
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   block/blk-flush.c            |  4 ++--
>   block/blk-mq-debugfs.c       |  2 +-
>   block/blk-mq.c               | 16 +---------------
>   drivers/block/ublk_drv.c     |  6 +++---
>   drivers/block/xen-blkfront.c |  1 -
>   drivers/md/dm-rq.c           |  6 +++---
>   drivers/nvme/host/core.c     |  2 +-
>   drivers/s390/block/scm_blk.c |  2 +-
>   drivers/scsi/scsi_lib.c      |  2 +-
>   include/linux/blk-mq.h       |  2 --
>   10 files changed, 13 insertions(+), 30 deletions(-)
The scm_blk.c changes looks good to me. thanks.

Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>

...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

