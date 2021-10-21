Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8987BC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 03:44:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B2EF610CB
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 03:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B2EF610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-JTZ-gkNEMV-vKKfEAPQ6dw-1; Wed, 20 Oct 2021 23:44:04 -0400
X-MC-Unique: JTZ-gkNEMV-vKKfEAPQ6dw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A46D7362F8;
	Thu, 21 Oct 2021 03:43:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69C31ADD9;
	Thu, 21 Oct 2021 03:43:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F27824A703;
	Thu, 21 Oct 2021 03:43:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19L3hqX0007758 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 23:43:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 666F5406D89D; Thu, 21 Oct 2021 03:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6288140149B2
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 03:43:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AE9618A01BD
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 03:43:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
	[205.220.165.32]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-141-DDfmh6JMNxalVwsXMqICEA-1; Wed, 20 Oct 2021 23:43:48 -0400
X-MC-Unique: DDfmh6JMNxalVwsXMqICEA-1
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	19L345vU029738; Thu, 21 Oct 2021 03:43:10 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3wvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 03:43:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3etve078225;
	Thu, 21 Oct 2021 03:43:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by aserp3030.oracle.com with ESMTP id 3bqmshem6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Oct 2021 03:43:08 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8A082116;
	Thu, 21 Oct 2021 03:43:07 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
	by aserp3030.oracle.com with ESMTP id 3bqmshekyd-13;
	Thu, 21 Oct 2021 03:43:07 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: zhuyifei1999@gmail.com, thehajime@gmail.com, hare@suse.de,
	jinpu.wang@ionos.com, jgross@suse.com, johannes.berg@intel.com,
	geert@linux-m68k.org, linux-mtd@lists.infradead.org,
	miquel.raynal@bootlin.com, axboe@kernel.dk,
	Luis Chamberlain <mcgrof@kernel.org>, jdike@addtoit.com,
	kent.overstreet@gmail.com, richard@nod.at, colyli@suse.de,
	agk@redhat.com, haris.iqbal@ionos.com, krisman@collabora.com,
	roger.pau@citrix.com, anton.ivanov@cambridgegreys.com,
	sstabellini@kernel.org, ulf.hansson@linaro.org, vigneshr@ti.com,
	chris.obbard@collabora.com, jejb@linux.ibm.com,
	boris.ostrovsky@oracle.com, tj@kernel.org, snitzer@redhat.com
Date: Wed, 20 Oct 2021 23:42:44 -0400
Message-Id: <163478764105.7011.9400354892813636458.b4-ty@oracle.com>
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Proofpoint-ORIG-GUID: BAR8nzodBeKYX4DEPTjC7SU079lshTb2
X-Proofpoint-GUID: BAR8nzodBeKYX4DEPTjC7SU079lshTb2
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-m68k@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, xen-devel@lists.xenproject.org
Subject: Re: [dm-devel] [PATCH 0/9] block: reviewed add_disk() error
	handling set
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 15 Oct 2021 16:30:19 -0700, Luis Chamberlain wrote:

> Jens,
> 
> I had last split up patches into 7 groups, but at this point now
> most changes are merged except a few more drivers. Instead of creating
> a new patch set for each of the 7 groups I'm creating 3 new groups of
> patches now:
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/9] scsi/sd: add error handling support for add_disk()
      https://git.kernel.org/mkp/scsi/c/2a7a891f4c40
[2/9] scsi/sr: add error handling support for add_disk()
      https://git.kernel.org/mkp/scsi/c/e9d658c2175b

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

