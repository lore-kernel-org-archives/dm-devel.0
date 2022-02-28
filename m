Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B62AC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 03:44:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-j5v5ObNZMi6stAkvL5ezRw-1; Sun, 27 Feb 2022 22:43:58 -0500
X-MC-Unique: j5v5ObNZMi6stAkvL5ezRw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEEFC51DF;
	Mon, 28 Feb 2022 03:43:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A2B5610F4;
	Mon, 28 Feb 2022 03:43:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BBB481809C98;
	Mon, 28 Feb 2022 03:43:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21S3hec9001090 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Feb 2022 22:43:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B79814428FA; Mon, 28 Feb 2022 03:43:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B36DC4428F9
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 03:43:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9994B3C11C62
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 03:43:40 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com
	[205.220.177.32]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-340-lNHiT80XPJWi6mvggfiVtw-1; Sun, 27 Feb 2022 22:43:38 -0500
X-MC-Unique: lNHiT80XPJWi6mvggfiVtw-1
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21RN6iMX030439; Mon, 28 Feb 2022 03:43:30 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3efamcb0p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Feb 2022 03:43:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21S3b93E157706;
	Mon, 28 Feb 2022 03:43:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3030.oracle.com with ESMTP id 3efa8bxnug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Feb 2022 03:43:29 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21S3hPvs165853;
	Mon, 28 Feb 2022 03:43:29 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
	by aserp3030.oracle.com with ESMTP id 3efa8bxnt3-5;
	Mon, 28 Feb 2022 03:43:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: mrochs@linux.ibm.com, ukrishn@linux.ibm.com, target-devel@vger.kernel.org, 
	manoj@linux.ibm.com, Christoph Hellwig <hch@lst.de>,
	haris.iqbal@ionos.com, jinpu.wang@ionos.com, axboe@kernel.dk,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Date: Sun, 27 Feb 2022 22:43:19 -0500
Message-Id: <164601967778.4503.10049578815707749914.b4-ty@oracle.com>
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
MIME-Version: 1.0
X-Proofpoint-ORIG-GUID: Hzm0aRNfu-eOe-59CsGUww_0uF29UVaY
X-Proofpoint-GUID: Hzm0aRNfu-eOe-59CsGUww_0uF29UVaY
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] remove REQ_OP_WRITE_SAME v2
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 9 Feb 2022 09:28:21 +0100, Christoph Hellwig wrote:

> Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
> kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
> have two callers left, and both just export optional protocol features
> to remote systems: DRBD and the target code.
> 
> For the target code the only real use case was zeroing offload, which
> is kept with this series, and for DRBD I suspect the same based on the
> usage.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/7] cxlflash: query write_zeroes limit for zeroing
      https://git.kernel.org/mkp/scsi/c/898cd34607eb
[2/7] drbd: drop REQ_OP_WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/a34592ff6b78
[3/7] rnbd: drop WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/ebd04737637b
[4/7] sd: remove write same support
      https://git.kernel.org/mkp/scsi/c/e383e16e84e9
[5/7] md: drop WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/10fa225c33a9
[6/7] dm: remove write same support
      https://git.kernel.org/mkp/scsi/c/a773187e37fa
[7/7] block: remove REQ_OP_WRITE_SAME support
      https://git.kernel.org/mkp/scsi/c/73bd66d9c834

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

