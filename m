Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDEEC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26DBF206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26DBF206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-YfERQ_6PPNajs0tIJAC_tw-1; Mon, 04 Jan 2021 14:04:11 -0500
X-MC-Unique: YfERQ_6PPNajs0tIJAC_tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E5BB8144F3;
	Mon,  4 Jan 2021 19:04:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 311E062665;
	Mon,  4 Jan 2021 19:04:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 074121809CBB;
	Mon,  4 Jan 2021 19:04:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BOD6NBk032286 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Dec 2020 08:06:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2B3871004C77; Thu, 24 Dec 2020 13:06:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2752F10FFE7F
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 13:06:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6B958007DF
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 13:06:20 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-432-uj18ynPXOtmhfOeaZzOCEw-1; Thu, 24 Dec 2020 08:06:18 -0500
X-MC-Unique: uj18ynPXOtmhfOeaZzOCEw-1
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0BOD3DUa176948; Thu, 24 Dec 2020 08:06:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 35mu1a8psb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 24 Dec 2020 08:06:16 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BOD3YCs179407;
	Thu, 24 Dec 2020 08:06:16 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 35mu1a8prh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 24 Dec 2020 08:06:16 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0BOD2jaa027488; Thu, 24 Dec 2020 13:06:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma06ams.nl.ibm.com with ESMTP id 35h8sh4xme-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 24 Dec 2020 13:06:13 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com
	[9.149.105.60])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0BOD6B8O43581744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 24 Dec 2020 13:06:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3325342042;
	Thu, 24 Dec 2020 13:06:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07B7E4203F;
	Thu, 24 Dec 2020 13:06:08 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.1.132]) by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 24 Dec 2020 13:06:07 +0000 (GMT)
Message-ID: <5ae72a76664ce7011d3041689efbfe1a2c67d44f.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Thu, 24 Dec 2020 08:04:40 -0500
In-Reply-To: <20201212180251.9943-4-tusharsu@linux.microsoft.com>
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-4-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2020-12-24_08:2020-12-24,
	2020-12-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	priorityscore=1501
	mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0 clxscore=1015
	suspectscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
	mlxscore=0
	bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012240081
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 3/8] IMA: define a hook to measure kernel
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 2020-12-12 at 10:02 -0800, Tushar Sugandhi wrote:
> IMA provides capabilities to measure file data, and in-memory buffer

No need for the comma here.

Up to this patch set, all the patches refer to "buffer data", not "in-
memory buffer data".  This patch introduces the concept of measuring
"in-memory buffer data".   Please remove "in-memory" above.

> data. However, various data structures, policies, and states

Here and everywhere else, there are two blanks after a period.

> stored in kernel memory also impact the integrity of the system.
> Several kernel subsystems contain such integrity critical data. These
> kernel subsystems help protect the integrity of a device. Currently,

^integrity of the system.

> IMA does not provide a generic function for kernel subsystems to measure
> their integrity critical data.

The emphasis should not be on "kernel subsystems".  Simplify to "for
measuring kernel integrity critical data".

>  
> Define a new IMA hook - ima_measure_critical_data to measure kernel
> integrity critical data.

Either "ima_measure_critical_data" is between hyphens or without any
hyphens.  If not hyphenated, then you could say "named
ima_measure_critical_data", but "named" isn't necessary.  Or reverse "a
new IMA hook" and "ima_measure_critical_data", adding comma's like: 
Define ima_measure_critical_data, a new IMA hook, to ...

Any of the above options work, just not a single hyphen.

> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---

<snip>

> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 0f8409d77602..dff4bce4fb09 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -922,6 +922,40 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>  	fdput(f);
>  }
>  
> +/**
> + * ima_measure_critical_data - measure kernel integrity critical data
> + * @event_name: event name to be used for the buffer entry

Why future tense?   By "buffer entry" do you mean a record in the IMA
measurement list?

> + * @buf: pointer to buffer containing data to measure

^pointer to buffer data

> + * @buf_len: length of buffer(in bytes)

^length of buffer data (in bytes)

> + * @measure_buf_hash: measure buffer hash

As requested in 2/8, please abbreviate the boolean name to "hash".  
Refer to section "4) Naming" in Documentation/process/coding-style.rst
for variable naming conventions.

^@hash: measure buffer data hash

> + *
> + * Measure the kernel subsystem data, critical to the integrity of the kernel,
> + * into the IMA log and extend the @pcr.
> + *
> + * Use @event_name to describe the state/buffer data change.
> + * Examples of critical data (@buf) could be various data structures,
> + * policies, and states stored in kernel memory that can impact the integrity
> + * of the system.
> + *
> + * If @measure_buf_hash is set to true - measure hash of the buffer data,
> + * else measure the buffer data itself.
> + * @measure_buf_hash can be used to save space, if the data being measured
> + * is too large.
> + *
> + * The data (@buf) can only be measured, not appraised.

The "/**" is the start of kernel-doc.  Have you seen anywhere else in
the kernel using the @<variable name> in the longer function
description?  Have you seen this style of longer   function
description?  Refer to Documentation/doc-guide/kernel-doc.rst and other
code for examples.

> + */
> +void ima_measure_critical_data(const char *event_name,
> +			       const void *buf, int buf_len,

As "buf_len" should always be >= 0, it should not be defined as a
signed variable.

> +			       bool measure_buf_hash)
> +{
> +	if (!event_name || !buf || !buf_len)
> +		return;
> +
> +	process_buffer_measurement(NULL, buf, buf_len, event_name,
> +				   CRITICAL_DATA, 0, NULL,
> +				   measure_buf_hash);

^hash

thanks,

Mimi

> +}
> +
>  static int __init init_ima(void)
>  {
>  	int error;


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

