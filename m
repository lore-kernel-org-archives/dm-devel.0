Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788F0C76195
	for <dm-devel@archiver.kernel.org>; Mon, 20 Mar 2023 05:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679289431;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/rDDLlIPNL6BoEysuO22csyLBZJflVL8ecNbIwZYecA=;
	b=KYU7IVjCAD0CkORvxIonPyOP21HtjU0vBqAGdFfSm7qJ1VBBbXWxIybzubt9KZs2Urenim
	U20tKF6RjPvgA51JDdoW3Bjncc58jvkbWDFYOUk6xCJXec+3Q5WFOfsvUODAYYUnPXOhS6
	Qrprs44GpA/f+KeKHE/VRI4K5tS3Vhw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-IS9Jl4y6MNeJvPaLG1qyvg-1; Mon, 20 Mar 2023 01:17:08 -0400
X-MC-Unique: IS9Jl4y6MNeJvPaLG1qyvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F0363C0F22A;
	Mon, 20 Mar 2023 05:17:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9547740CFD40;
	Mon, 20 Mar 2023 05:17:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CEBF1946A63;
	Mon, 20 Mar 2023 05:16:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 56CF91946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Mar 2023 10:17:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 385A0202701F; Thu, 16 Mar 2023 10:17:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30A6D202701E
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 10:17:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10892884342
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 10:17:15 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-sBGj5DYKNa-GnqnXhBaUdg-1; Thu, 16 Mar 2023 06:17:13 -0400
X-MC-Unique: sBGj5DYKNa-GnqnXhBaUdg-1
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 32G95FET036330
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 10:17:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbpx4x9bp-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 10:17:12 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32G9uM4v036034
 for <dm-devel@redhat.com>; Thu, 16 Mar 2023 10:17:12 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com
 [149.81.74.107])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pbpx4x9b6-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 16 Mar 2023 10:17:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
 by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32G230aA028037;
 Thu, 16 Mar 2023 10:17:10 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
 by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pbsyxrd8s-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Thu, 16 Mar 2023 10:17:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com
 [10.20.54.102])
 by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 32GAH7cl21561864
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Thu, 16 Mar 2023 10:17:07 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 8422F20040;
 Thu, 16 Mar 2023 10:17:07 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 224D820065;
 Thu, 16 Mar 2023 10:17:07 +0000 (GMT)
Received: from [9.152.212.230] (unknown [9.152.212.230])
 by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
 Thu, 16 Mar 2023 10:17:07 +0000 (GMT)
Message-ID: <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
Date: Thu, 16 Mar 2023 11:17:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To: Christoph Hellwig <hch@lst.de>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
 <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
 <20230315133039.GA24533@lst.de>
From: Stefan Haberland <sth@linux.ibm.com>
In-Reply-To: <20230315133039.GA24533@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X6tcHI4Y4hN2ulzv7a-zFDv3Old5pE6S
X-Proofpoint-ORIG-GUID: e5UmNwL8IYAtm8F-8DT0dsS5_CITZfXA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_06,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160081
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 20 Mar 2023 05:16:58 +0000
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
 bvanassche@acm.org, linux-scsi@vger.kernel.org, snitzer@kernel.org,
 Jan Hoeppner <hoeppner@linux.ibm.com>, linux-nvme@lists.infradead.org,
 james.bottomley@hansenpartnership.com, dm-devel@redhat.com,
 target-devel@vger.kernel.org, martin.petersen@oracle.com, kbusch@kernel.org,
 Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Am 15.03.23 um 14:30 schrieb Christoph Hellwig:
> On Wed, Mar 15, 2023 at 11:04:22AM +0100, Stefan Haberland wrote:
>> This also fits for the DASD case. We use this error code for a
>> reservation/locking conflict of the DASD device when the lock we
>> previously held was stolen.
> But that's not really a reservation conflict in the sense
> of the reservation API.  Given that DASD doesn't support it it
> might not matter.  Do you have applications that checks for
> the translated errno value?  We'll probably at least want
> a comment documenting this status code.

Well, I might completely misunderstand the use case for this error code.
Sorry if that is the case.

Beside that I thought that the return codes are generic blocklayer 
return codes
and not bound to a specific API. I am not familiar with the reservation 
API you
are talking about.

What I understood from the reservation in NVMe context is that a namespace
might be reserved to a host. If there is a conflict with this reservation
this error code is provided for the IO request.

For DASDs we have the possibility to reserve a disk for a host. If there 
is a
conflict with this platform specific reservation we would present this 
error
for an IO request.

This sounded quite similar for me.

I am completely open to using another return code and I am not aware of an
application checking for this specific return code.

Is there any that would fit better from your point of view?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

