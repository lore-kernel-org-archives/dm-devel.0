Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EFEDC6FD1D
	for <dm-devel@archiver.kernel.org>; Fri, 17 Mar 2023 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679064416;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mudzSpnSNBqMDwnNDVC57Oq3ky2ETAAqxwm46QUbPFQ=;
	b=ZCVG0bcFvAvuYxO8tp8jIyyl5mpAeMxu3LdRehlG42KEzYOBGNx7vYfh4fqtMlyX7FtSWl
	eyU6TZy9DPbhmvxn5qZtcUxsj0Jsdzqp0ecdtkoBXnbKO+BkaSeuynhOilRovk5AbePW39
	xCpJMuWuTxzLuWk/bf9QuxYWVgcPLcs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-PZw7JR9ZN8iQ0LpZbZl8gg-1; Fri, 17 Mar 2023 10:46:52 -0400
X-MC-Unique: PZw7JR9ZN8iQ0LpZbZl8gg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AE8F800B23;
	Fri, 17 Mar 2023 14:46:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 180812027046;
	Fri, 17 Mar 2023 14:46:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EB1681946587;
	Fri, 17 Mar 2023 14:46:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28C9619465A3
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Mar 2023 10:04:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 003DB1121315; Wed, 15 Mar 2023 10:04:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ECED11121314
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 10:04:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD38185A5A3
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 10:04:32 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-v5MeulscOLCxPnh_5kejmQ-1; Wed, 15 Mar 2023 06:04:30 -0400
X-MC-Unique: v5MeulscOLCxPnh_5kejmQ-1
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32F9CaTM029657
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 10:04:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbb67hbx7-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 10:04:29 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32F9VHqW017522
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 10:04:28 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com
 [149.81.74.106])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbb67hbw0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 15 Mar 2023 10:04:28 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
 by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32F3UQXO008910;
 Wed, 15 Mar 2023 10:04:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
 by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pb29t0gh0-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 15 Mar 2023 10:04:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com
 [10.20.54.101])
 by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 32FA4Nsf46596788
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 15 Mar 2023 10:04:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 845BF2006B;
 Wed, 15 Mar 2023 10:04:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 24C1220063;
 Wed, 15 Mar 2023 10:04:23 +0000 (GMT)
Received: from [9.152.212.230] (unknown [9.152.212.230])
 by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
 Wed, 15 Mar 2023 10:04:23 +0000 (GMT)
Message-ID: <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
Date: Wed, 15 Mar 2023 11:04:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: Christoph Hellwig <hch@lst.de>, Mike Christie <michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
From: Stefan Haberland <sth@linux.ibm.com>
In-Reply-To: <20230314171119.GB6780@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Gm8knda4ABLDpRDHcHrrp25yIqxkZsPd
X-Proofpoint-GUID: tD-Hba-uZXxaHa5TOgqYS7XtmBNP81hc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_04,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150086
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 16 Mar 2023 07:16:13 +0000
Subject: Re: [dm-devel] [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, chaitanyak@nvidia.com,
 bvanassche@acm.org, martin.petersen@oracle.com, snitzer@kernel.org,
 Jan Hoeppner <hoeppner@linux.ibm.com>, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kbusch@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Am 14.03.23 um 18:11 schrieb Christoph Hellwig:
> On Fri, Feb 24, 2023 at 11:44:46AM -0600, Mike Christie wrote:
>> BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts or in dasd's
>> case something similar. This renames BLK_STS_NEXUS so it better reflects
>> this.
> I like this rename a lot.
>
>> diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
>> index a9c2a8d76c45..a2899d9690d4 100644
>> --- a/drivers/s390/block/dasd.c
>> +++ b/drivers/s390/block/dasd.c
>> @@ -2723,7 +2723,7 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
>>   	else if (status == 0) {
>>   		switch (cqr->intrc) {
>>   		case -EPERM:
>> -			error = BLK_STS_NEXUS;
>> +			error = BLK_STS_RESV_CONFLICT;
>>   			break;
> But is this really a reservation conflict?  Or should the DASD code
> maybe use a different error code here?
>

This also fits for the DASD case. We use this error code for a
reservation/locking conflict of the DASD device when the lock we
previously held was stolen.

Acked-by: Stefan Haberland <sth@linux.ibm.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

