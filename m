Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D03C00A89
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:40:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DF0B72080D
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:40:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF0B72080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-RS0l5F6OOnaMuQpEzoQaYw-1; Thu, 05 Nov 2020 04:40:15 -0500
X-MC-Unique: RS0l5F6OOnaMuQpEzoQaYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6BAF8015AD;
	Thu,  5 Nov 2020 09:40:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79C3B1000239;
	Thu,  5 Nov 2020 09:40:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 15C2544A45;
	Thu,  5 Nov 2020 09:40:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A50VaUt023815 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 19:31:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2159BC54AD; Thu,  5 Nov 2020 00:31:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AFD1C6106
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 00:31:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7DAF185A790
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 00:31:33 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-42-Yfd6JJDDNuWGtbmOiYMNtQ-1; Wed, 04 Nov 2020 19:31:29 -0500
X-MC-Unique: Yfd6JJDDNuWGtbmOiYMNtQ-1
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0A502iN6158943; Wed, 4 Nov 2020 19:31:28 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34m5db1w16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 04 Nov 2020 19:31:28 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A50MOuj033654;
	Wed, 4 Nov 2020 19:31:28 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.99])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34m5db1w0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 04 Nov 2020 19:31:28 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0A50SmCG017451; Thu, 5 Nov 2020 00:31:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
	(d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma04ams.nl.ibm.com with ESMTP id 34h01ucnp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 05 Nov 2020 00:31:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com
	[9.149.105.58])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0A50VN499962206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 5 Nov 2020 00:31:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D44434C04A;
	Thu,  5 Nov 2020 00:31:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EAF34C04E;
	Thu,  5 Nov 2020 00:31:20 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.13.183])
	by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu,  5 Nov 2020 00:31:20 +0000 (GMT)
Message-ID: <c840953db2937296c8d77d5d3b4e1274bf990e46.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Wed, 04 Nov 2020 19:31:19 -0500
In-Reply-To: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-04_17:2020-11-04,
	2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	adultscore=0 mlxlogscore=999
	clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0
	spamscore=0
	priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011040171
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
X-Mailman-Approved-At: Thu, 05 Nov 2020 04:40:06 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 0/7] IMA: Infrastructure for measurement
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

Measuring "critical kernel data" is not a new infrastructure, simply a
new IMA hook.   Please update the above Subject line to "support for
measuring critical kernel data".

On Sun, 2020-11-01 at 14:26 -0800, Tushar Sugandhi wrote:
> There are several kernel subsystems that contain critical data which if
> accidentally or maliciously altered, can compromise the integrity of the
> system. Examples of such subsystems would include LSMs like SELinux, or
> AppArmor; or device-mapper targets like dm-crypt, dm-verity etc. 
> "critical data" in this context is kernel subsystem specific information
> that is stored in kernel memory. Examples of critical data could be
> kernel in-memory r/o structures, hash of the memory structures, or
> data that represents a linux kernel subsystem state.

This is a bit better, but needs to be much clearer.  Please define
"critical data", not by example, but by describing "what" critical
kernel data is.  "There are several kernel subsystems ...."  is an
example of "how" it would be used, not a definition.  Without a clear
definition it will become a dumping ground for measuring anything
anyone wants to measure.  As a result, it may be abused.

> 
> This patch set defines a new IMA hook namely CRITICAL_DATA, and a
> function ima_measure_critical_data() - to measure the critical data. 

The name of the IMA hook is ima_measure_critical_data.  This is similar
to the LSM hooks, which are prefixed with "security_".  (For a full
list of LSM hooks, refer to lsm_hook_defs.h.)

> Kernel subsystems can use this functionality, to take advantage of IMA's
> measuring and quoting abilities - thus ultimately enabling remote
> attestation for the subsystem specific information stored in the kernel
> memory.
> 
> The functionality is generic enough to measure the data of any kernel
> subsystem at run-time. To ensure that only data from supported sources
> are measured, the kernel subsystem needs to be added to a compile-time
> list of supported sources (an "allowed list of components"). IMA
> validates the source passed to ima_measure_critical_data() against this
> allowed list at run-time.

Yes, this new feature is generic, but one of the main goals of IMA is
to measure and attest to the integrity of the system, not to measure
and attest to random things.

> 
> System administrators may want to pick and choose which kernel
> subsystem information they would want to enable for measurements,
> quoting, and remote attestation. To enable that, a new IMA policy is
> introduced.

^may want to limit the critical data being measured, quoted and
attested.
^ a new IMA policy condition is defined.

> 
> This patch set also addresses the need for the kernel subsystems to
> measure their data before a custom IMA policy is loaded - by providing
> a builtin IMA policy.

^for measuring kernel critical data early, before a custom IMA policy
...

> 
> And lastly, the use of the overall functionality is demonstrated by
> measuring the kernel in-memory data for one such subsystem - SeLinux.

The purpose isn't to demonstrate the "overall functionality", but to
provide an initial caller of the new IMA hook.

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

