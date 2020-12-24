Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC43C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CE5BA2068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE5BA2068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-EHFZ1O1NNaeIEvP09L_ObA-1; Mon, 04 Jan 2021 14:03:43 -0500
X-MC-Unique: EHFZ1O1NNaeIEvP09L_ObA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C782F100C614;
	Mon,  4 Jan 2021 19:03:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8215100239A;
	Mon,  4 Jan 2021 19:03:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7E8FD50032;
	Mon,  4 Jan 2021 19:03:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BOEU5xF007123 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Dec 2020 09:30:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1AB0E2166B2B; Thu, 24 Dec 2020 14:30:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 138402166B30
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 14:30:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFD53101A53F
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 14:30:02 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-78-Q3SO8LdbOz2EsZD27f6WyQ-1; Thu, 24 Dec 2020 09:30:00 -0500
X-MC-Unique: Q3SO8LdbOz2EsZD27f6WyQ-1
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0BOEQVAb109904; Thu, 24 Dec 2020 09:29:59 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 35mvqy82d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 24 Dec 2020 09:29:59 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BOEQVKx109853;
	Thu, 24 Dec 2020 09:29:59 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.72])
	by mx0b-001b2d01.pphosted.com with ESMTP id 35mvqy82cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 24 Dec 2020 09:29:58 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0BOERHuf019926; Thu, 24 Dec 2020 14:29:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06fra.de.ibm.com with ESMTP id 35kefjh33d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 24 Dec 2020 14:29:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com
	[9.149.105.59])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0BOETrVo25756090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 24 Dec 2020 14:29:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EBA3A4040;
	Thu, 24 Dec 2020 14:29:54 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E241A4059;
	Thu, 24 Dec 2020 14:29:51 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.1.132]) by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 24 Dec 2020 14:29:50 +0000 (GMT)
Message-ID: <56db41c08d625b8143454a2e0aaaef3ea2927442.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Thu, 24 Dec 2020 09:29:50 -0500
In-Reply-To: <20201212180251.9943-6-tusharsu@linux.microsoft.com>
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-6-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2020-12-24_08:2020-12-24,
	2020-12-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	suspectscore=0 bulkscore=0
	adultscore=0 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
	malwarescore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012240085
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 5/8] IMA: limit critical data measurement
 based on a label
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

On Sat, 2020-12-12 at 10:02 -0800, Tushar Sugandhi wrote:
> System administrators should be able to limit which kernel subsystems
> they want to measure the critical data for. To enable that, an IMA policy
> condition to choose specific kernel subsystems is needed. This policy
> condition would constrain the measurement of the critical data based on
> a label for the given subsystems.

Restricting which kernel integrity critical data is measured is not
only of interest to system administrators.   Why single them out?

Limiting which critical data is measured is based on a label, making it
flexible.  In your use case scenario, you're grouping the label based
on kernel subsystem, but is that really necessary?  In the broader
picture, there could be cross subsystem critical data being measured
based on a single label.

Please think about the broader picture and re-write the patch
descirption more generically.

> 
> Add a new IMA policy condition - "data_source:=" to the IMA func

What is with "add"?  You're "adding support for" or "defining" a new
policy condition.  Remove the single hyphen, as explained in 3/8.

Please replace "data_source" with something more generic (e.g. label).

thanks,

Mimi

> CRITICAL_DATA to allow measurement of various kernel subsystems. This
> policy condition would enable the system administrators to restrict the
> measurement to the labels listed in "data_source:=".
> 
> Limit the measurement to the labels that are specified in the IMA
> policy - CRITICAL_DATA+"data_source:=". If "data_sources:=" is not
> provided with the func CRITICAL_DATA, the data from all the
> supported kernel subsystems is measured.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

