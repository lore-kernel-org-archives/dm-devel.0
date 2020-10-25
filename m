Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B493DC5517A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:42:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 367A3222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 367A3222EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-9fySozLrNM23NxgPUIkxlg-1; Mon, 26 Oct 2020 03:42:18 -0400
X-MC-Unique: 9fySozLrNM23NxgPUIkxlg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EE8F801F9B;
	Mon, 26 Oct 2020 07:42:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81EDA5D9CD;
	Mon, 26 Oct 2020 07:42:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4D1C21832FC2;
	Mon, 26 Oct 2020 07:42:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09P3a8cL025043 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 24 Oct 2020 23:36:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AE20547CF6; Sun, 25 Oct 2020 03:36:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A83A847CEF
	for <dm-devel@redhat.com>; Sun, 25 Oct 2020 03:36:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 871E7858280
	for <dm-devel@redhat.com>; Sun, 25 Oct 2020 03:36:06 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-228-0z9v7hZWOg60fZW002Lh1w-1; Sat, 24 Oct 2020 23:36:03 -0400
X-MC-Unique: 0z9v7hZWOg60fZW002Lh1w-1
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	09P3VgEA048446; Sat, 24 Oct 2020 23:36:02 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34d0xs8qmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sat, 24 Oct 2020 23:36:02 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09P3a2N9060532;
	Sat, 24 Oct 2020 23:36:02 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com
	[149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34d0xs8qmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sat, 24 Oct 2020 23:36:02 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	09P3UBRi027808; Sun, 25 Oct 2020 03:35:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com
	(d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma05fra.de.ibm.com with ESMTP id 34cbw88e5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sun, 25 Oct 2020 03:35:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com
	(b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 09P3ZvoH37159234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Sun, 25 Oct 2020 03:35:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86DDAA4065;
	Sun, 25 Oct 2020 03:35:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23FCEA405B;
	Sun, 25 Oct 2020 03:35:54 +0000 (GMT)
Received: from sig-9-65-192-162.ibm.com (unknown [9.65.192.162])
	by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Sun, 25 Oct 2020 03:35:53 +0000 (GMT)
Message-ID: <2c7da61fbeb17c577253b117829b3bd544d8cf44.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com
Date: Sat, 24 Oct 2020 23:35:53 -0400
In-Reply-To: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235, 18.0.737
	definitions=2020-10-25_01:2020-10-23,
	2020-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	phishscore=0 spamscore=0
	adultscore=0 suspectscore=3 impostorscore=0 mlxscore=0
	priorityscore=1501
	malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
	mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2010250022
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
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 0/6] IMA: Infrastructure for measurement
 of critical kernel data
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

On Wed, 2020-09-23 at 12:20 -0700, Tushar Sugandhi wrote:
> There are several kernel components that contain critical data which if
> accidentally or maliciously altered, can compromise the security of the
> kernel. Example of such components would include LSMs like SELinux, or
> AppArmor; or device-mapper targets like dm-crypt, dm-verity etc.

^"the integrity of the system."

This cover letter needs to be re-written from a higher perspective,
explaining what is meant by "critical data" (e.g. kernel subsystem
specific information only stored in kernel memory).

> 
> Many of these components do not use the capabilities provided by kernel
> integrity subsystem (IMA), and thus they don't use the benefits of
> extended TPM PCR quotes and ultimately the benefits of remote attestation.

True, up until recently IMA only measured files, nothing else.  Why is
this paragraph needed?  What new information is provided?

> This series bridges this gap, so that potential kernel components that
> contain data critical to the security of the kernel could take advantage
> of IMA's measuring and quoting abilities - thus ultimately enabling
> remote attestation for their specific data.

Perhaps, something more along the lines, "This patch set defines a new
IMA hook named ... to measure critical data."

> 
> System administrators may want to pick and choose which kernel
> components they would want to enable for measurements, quoting, and
> remote attestation. To enable that, a new IMA policy is introduced.

Reverse the order of this paragraph and the following one, describing
the new feature and only afterwards explaining how it may be
constrained.

> 
> And lastly, the functionality is exposed through a function
> ima_measure_critical_data(). The functionality is generic enough to
> measure the data of any kernel component at run-time. To ensure that
> only data from supported sources are measured, the kernel component
> needs to be added to a compile-time list of supported sources (an
> "allowed list of components"). IMA validates the source passed to
> ima_measure_critical_data() against this allowed list at run-time.

This patch set must include at least one example of measuring critical
data, before it can be upstreamed.  Tushar, please coordinate with
Lakshmi and Raphael.

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

