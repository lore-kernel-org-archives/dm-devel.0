Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E5CAC4742C
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EB269206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:04:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB269206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-RbIYJTTFNUCqrDOpwOjSEQ-1; Sun, 08 Nov 2020 12:04:56 -0500
X-MC-Unique: RbIYJTTFNUCqrDOpwOjSEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53FFA8049EF;
	Sun,  8 Nov 2020 17:04:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AE0E5D9D2;
	Sun,  8 Nov 2020 17:04:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA42144A62;
	Sun,  8 Nov 2020 17:04:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A6DhLlc022501 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 08:43:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5F373F5AE3; Fri,  6 Nov 2020 13:43:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57388F5AE2
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 13:43:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E42E811E79
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 13:43:19 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-374-7cXICOgIP0KnkC9bVjUnww-1; Fri, 06 Nov 2020 08:43:17 -0500
X-MC-Unique: 7cXICOgIP0KnkC9bVjUnww-1
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0A6DWgst095739; Fri, 6 Nov 2020 08:43:16 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34m7teu97g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 08:43:15 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A6D4svP096378;
	Fri, 6 Nov 2020 08:43:14 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.70])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34m7teu93m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 08:43:14 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0A6Dh9jT015155; Fri, 6 Nov 2020 13:43:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
	(d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma01fra.de.ibm.com with ESMTP id 34jbyttffn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 13:43:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com
	(b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0A6Dh6YD6423102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Fri, 6 Nov 2020 13:43:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FE93A4060;
	Fri,  6 Nov 2020 13:43:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B31CAA405C;
	Fri,  6 Nov 2020 13:43:02 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.77.67])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri,  6 Nov 2020 13:43:02 +0000 (GMT)
Message-ID: <6d835878af2f11c837633510775742e57a1506eb.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 06 Nov 2020 08:43:01 -0500
In-Reply-To: <20201101222626.6111-5-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-5-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-06_04:2020-11-05,
	2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	phishscore=0 impostorscore=0
	clxscore=1015 mlxscore=0 malwarescore=0 mlxlogscore=999
	priorityscore=1501
	suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011060092
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 4/7] IMA: add policy to measure critical
	data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

On Sun, 2020-11-01 at 14:26 -0800, Tushar Sugandhi wrote:
> System administrators should be able to choose which kernel subsystems
> they want to measure the critical data for. To enable that, an IMA policy
> option to choose specific kernel subsystems is needed. This policy option
> would constrain the measurement of the critical data to the given kernel
> subsystems.

Measuring critical data should not be dependent on the source of the
critical data.   This patch needs to be split up.  The "data sources"
should be move to it's own separate patch.  This patch should be
limited to adding the policy code needed for measuring criticial data. 
Limiting critical data sources should be the last patch in this series.

thanks,

Mimi

> 
> Add a new IMA policy option - "data_sources:=" to the IMA func 
> CRITICAL_DATA to allow measurement of various kernel subsystems. This
> policy option would enable the system administrators to limit the
> measurement to the subsystems listed in "data_sources:=", if the 
> subsystem measures its data by calling ima_measure_critical_data().
> 
> Limit the measurement to the subsystems that are specified in the IMA
> policy - CRITICAL_DATA+"data_sources:=". If "data_sources:=" is not
> provided with the func CRITICAL_DATA, measure the data from all the
> supported kernel subsystems.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

