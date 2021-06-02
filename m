Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C574AC47082
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5ED77613DC
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 06:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ED77613DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-VZeD14pWOai88OhvfLfDgQ-1; Thu, 03 Jun 2021 02:33:00 -0400
X-MC-Unique: VZeD14pWOai88OhvfLfDgQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 921B3189C44A;
	Thu,  3 Jun 2021 06:32:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 413F910190AA;
	Thu,  3 Jun 2021 06:32:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE5914ED79;
	Thu,  3 Jun 2021 06:32:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 152C38nV015250 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 08:03:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 45186101F0DA; Wed,  2 Jun 2021 12:03:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 410E11020454
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 12:03:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 945168316F2
	for <dm-devel@redhat.com>; Wed,  2 Jun 2021 12:03:05 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-123-6_WJW5QZPzSWK5r2sZjGBg-1; Wed, 02 Jun 2021 08:03:01 -0400
X-MC-Unique: 6_WJW5QZPzSWK5r2sZjGBg-1
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	152C2ax2189188; Wed, 2 Jun 2021 08:03:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 38x7kr3h5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 02 Jun 2021 08:03:00 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 152C2cNX189527;
	Wed, 2 Jun 2021 08:02:59 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com
	[149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 38x7kr3h4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 02 Jun 2021 08:02:59 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 152BwHfr023191;
	Wed, 2 Jun 2021 12:02:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
	(d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma05fra.de.ibm.com with ESMTP id 38ud87s9cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 02 Jun 2021 12:02:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com
	[9.149.105.59])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 152C2r4H26280248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 2 Jun 2021 12:02:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0364A405F;
	Wed,  2 Jun 2021 12:02:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 479C3A4040;
	Wed,  2 Jun 2021 12:02:52 +0000 (GMT)
Received: from sig-9-145-17-43.uk.ibm.com (unknown [9.145.17.43])
	by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed,  2 Jun 2021 12:02:52 +0000 (GMT)
Message-ID: <e4891689c7651611020bdf3b4db9895819da345a.camel@linux.ibm.com>
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Date: Wed, 02 Jun 2021 14:02:51 +0200
In-Reply-To: <20210602065345.355274-28-hch@lst.de>
References: <20210602065345.355274-1-hch@lst.de>
	<20210602065345.355274-28-hch@lst.de>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Pcv3XnDBKNPlwPb9ZZaFSZf0pCPOpalO
X-Proofpoint-ORIG-GUID: -LAzjZA1VGIxMM3aVX5RPubiT3GLOjUz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391, 18.0.761
	definitions=2021-06-02_06:2021-06-02,
	2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 malwarescore=0
	priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
	mlxlogscore=999 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2104190000 definitions=main-2106020078
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Jun 2021 02:32:49 -0400
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	virtualization@lists.linux-foundation.org, Geoff, "Md.
	Haris Iqbal" <haris.iqbal@ionos.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	linux-s390@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>, Richard,
	Weinberger <richard@nod.at>, Borntraeger <borntraeger@de.ibm.com>,
	xen-devel@lists.xenproject.org, Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Christian, Alex Dubov <oakad@yahoo.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>, nbd@other.debian.org,
	linux-block@vger.kernel.org, Heiko, ceph-devel@vger.kernel.org,
	Levand <geoff@infradead.org>, linux-mmc@vger.kernel.org,
	dm-devel@redhat.com, Roger, linux-mtd@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	=?ISO-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 27/30] scm_blk: use blk_mq_alloc_disk and
 blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-06-02 at 09:53 +0300, Christoph Hellwig wrote:
> Use blk_mq_alloc_disk and blk_cleanup_disk to simplify the gendisk and
> request_queue allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/s390/block/scm_blk.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
> index a4f6f2e62b1d..88cba6212ee2 100644
> --- a/drivers/s390/block/scm_blk.c
> +++ b/drivers/s390/block/scm_blk.c
> @@ -462,12 +462,12 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
>  	if (ret)
>  		goto out;
>  
> -	rq = blk_mq_init_queue(&bdev->tag_set);
> -	if (IS_ERR(rq)) {
> -		ret = PTR_ERR(rq);
> +	bdev->gendisk = blk_mq_alloc_disk(&bdev->tag_set, scmdev);
> +	if (IS_ERR(bdev->gendisk)) {
> +		ret = PTR_ERR(bdev->gendisk);
>  		goto out_tag;
>  	}
> -	bdev->rq = rq;
> +	rq = bdev->rq = bdev->gendisk->queue;
>  	nr_max_blk = min(scmdev->nr_max_block,
>  			 (unsigned int) (PAGE_SIZE / sizeof(struct aidaw)));
>  
> @@ -477,17 +477,11 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, rq);
>  	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, rq);
>  
> -	bdev->gendisk = alloc_disk(SCM_NR_PARTS);
> -	if (!bdev->gendisk) {
> -		ret = -ENOMEM;
> -		goto out_queue;
> -	}
> -	rq->queuedata = scmdev;
>  	bdev->gendisk->private_data = scmdev;
>  	bdev->gendisk->fops = &scm_blk_devops;
> -	bdev->gendisk->queue = rq;
>  	bdev->gendisk->major = scm_major;
>  	bdev->gendisk->first_minor = devindex * SCM_NR_PARTS;
> +	bdev->gendisk->minors = SCM_NR_PARTS;
>  
>  	len = snprintf(bdev->gendisk->disk_name, DISK_NAME_LEN, "scm");
>  	if (devindex > 25) {
> @@ -504,8 +498,6 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
>  	device_add_disk(&scmdev->dev, bdev->gendisk, NULL);
>  	return 0;
>  
> -out_queue:
> -	blk_cleanup_queue(rq);
>  out_tag:
>  	blk_mq_free_tag_set(&bdev->tag_set);
>  out:
> @@ -516,9 +508,8 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
>  void scm_blk_dev_cleanup(struct scm_blk_dev *bdev)
>  {
>  	del_gendisk(bdev->gendisk);
> -	blk_cleanup_queue(bdev->gendisk->queue);
> +	blk_cleanup_disk(bdev->gendisk);
>  	blk_mq_free_tag_set(&bdev->tag_set);
> -	put_disk(bdev->gendisk);
>  }
>  
>  void scm_blk_set_available(struct scm_blk_dev *bdev)

Not an expert on SCM or this code but I gave this a quick test and it
seems to work fine.

Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

