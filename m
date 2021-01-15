Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD69C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 12:55:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3FD1922473
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 12:55:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FD1922473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-QYnsnnvZMC22TIkDfwE4Pw-1; Fri, 15 Jan 2021 07:55:13 -0500
X-MC-Unique: QYnsnnvZMC22TIkDfwE4Pw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94C9C8066E0;
	Fri, 15 Jan 2021 12:55:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE6821349A;
	Fri, 15 Jan 2021 12:55:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 80FC94A7C6;
	Fri, 15 Jan 2021 12:55:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10FCsxGo018342 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Jan 2021 07:55:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B17622166B2A; Fri, 15 Jan 2021 12:54:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB83B2166B2D
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 12:54:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E74E803C9F
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 12:54:57 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-594-XyECUTs0NHeofzj7fL9ViA-1; Fri, 15 Jan 2021 07:54:53 -0500
X-MC-Unique: XyECUTs0NHeofzj7fL9ViA-1
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	10FChTZ3068640; Fri, 15 Jan 2021 07:54:52 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 363ba808u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 15 Jan 2021 07:54:52 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCspkk150385;
	Fri, 15 Jan 2021 07:54:51 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com
	[149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 363ba808t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 15 Jan 2021 07:54:51 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	10FCrcRI016803; Fri, 15 Jan 2021 12:54:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma05fra.de.ibm.com with ESMTP id 35y448c04e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 15 Jan 2021 12:54:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
	[9.149.105.232])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 10FCsfKd27656698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Fri, 15 Jan 2021 12:54:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C723C5204F;
	Fri, 15 Jan 2021 12:54:46 +0000 (GMT)
Received: from sig-9-65-220-78.ibm.com (unknown [9.65.220.78])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7B1D05204E;
	Fri, 15 Jan 2021 12:54:43 +0000 (GMT)
Message-ID: <5189c15054885863b1b5cb86a43bec09725d8650.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 15 Jan 2021 07:54:42 -0500
In-Reply-To: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
References: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2021-01-15_07:2021-01-15,
	2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	lowpriorityscore=0
	malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0
	adultscore=0
	clxscore=1015 mlxscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101150077
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
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v10 0/8] IMA: support for measuring kernel
 integrity critical data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-01-07 at 20:07 -0800, Tushar Sugandhi wrote:
> IMA measures files and buffer data such as keys, command-line arguments
> passed to the kernel on kexec system call, etc.  While these measurements
> are necessary for monitoring and validating the integrity of the system,
> they are not sufficient.  Various data structures, policies, and states
> stored in kernel memory also impact the integrity of the system.
> Several kernel subsystems contain such integrity critical data -
> e.g.  LSMs like SELinux, AppArmor etc.  or device-mapper targets like
> dm-crypt, dm-verity, dm-integrity etc.  These kernel subsystems help
> protect the integrity of a system.  Their integrity critical data is not
> expected to change frequently during run-time.  Some of these structures
> cannot be defined as __ro_after_init, because they are initialized later.
> 
> For a given system, various external services/infrastructure tools
> (including the attestation service) interact with it - both during the
> setup and during rest of the system run-time.  They share sensitive data
> and/or execute critical workload on that system.  The external services
> may want to verify the current run-time state of the relevant kernel
> subsystems before fully trusting the system with business critical
> data/workload.  For instance, verifying that SELinux is in "enforce" mode
> along with the expected policy, disks are encrypted with a certain
> configuration, secure boot is enabled etc.
> 
> This series provides the necessary IMA functionality for kernel
> subsystems to ensure their configuration can be measured:
>   - by kernel subsystems themselves,
>   - in a tamper resistant way,
>   - and re-measured - triggered on state/configuration change.
> 
> This patch set:
>   - defines a new IMA hook ima_measure_critical_data() to measure
>     integrity critical data,
>   - limits the critical data being measured based on a label,
>   - defines a builtin critical data measurement policy,
>   - and includes an SELinux consumer of the new IMA critical data hook.

Thanks Tushar, Lakshmi.  This patch set is queued in the next-
integrity-testing branch.

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

