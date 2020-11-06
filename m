Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07B0C4742C
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 572CC20731
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 572CC20731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-WjEiAssAOfG1EZFOYLN6cQ-1; Sun, 08 Nov 2020 12:05:09 -0500
X-MC-Unique: WjEiAssAOfG1EZFOYLN6cQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C5108049EF;
	Sun,  8 Nov 2020 17:05:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A5495C1D7;
	Sun,  8 Nov 2020 17:05:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E94D180C5A2;
	Sun,  8 Nov 2020 17:05:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A6FOeah001839 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 10:24:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 121BB2142F4A; Fri,  6 Nov 2020 15:24:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CC342142F48
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 15:24:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2FCC102F1E1
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 15:24:36 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-401-f5nX2zQOPkqtfsPyukn3Ag-1; Fri, 06 Nov 2020 10:24:34 -0500
X-MC-Unique: f5nX2zQOPkqtfsPyukn3Ag-1
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0A6F3N9L056192; Fri, 6 Nov 2020 10:24:33 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34n0vygnhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 10:24:33 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A6F3Sk7056743;
	Fri, 6 Nov 2020 10:24:32 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com
	[149.81.74.108])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34n0vygngs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 10:24:32 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
	by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0A6FCigg013609; Fri, 6 Nov 2020 15:24:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com
	(d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma05fra.de.ibm.com with ESMTP id 34h01quduh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 15:24:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
	[9.149.105.62])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0A6FORP05505684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Fri, 6 Nov 2020 15:24:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F92DAE051;
	Fri,  6 Nov 2020 15:24:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B4A4AE045;
	Fri,  6 Nov 2020 15:24:24 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.77.67]) by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri,  6 Nov 2020 15:24:23 +0000 (GMT)
Message-ID: <7219f4404bc1bed6eb090b94363c283ec3266a17.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 06 Nov 2020 10:24:23 -0500
In-Reply-To: <20201101222626.6111-7-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-7-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-06_06:2020-11-05,
	2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 impostorscore=0
	mlxlogscore=999 adultscore=0 lowpriorityscore=0 bulkscore=0
	phishscore=0
	priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0
	clxscore=1015
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011060109
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
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 6/7] IMA: add critical_data to the
 built-in policy rules
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Lakshmi, Tushar,

This patch defines a new critical_data builtin policy.  Please update
the Subject line.

On Sun, 2020-11-01 at 14:26 -0800, Tushar Sugandhi wrote:
> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> 
> The IMA hook to measure kernel critical data, namely
> ima_measure_critical_data(), could be called before a custom IMA policy
> is loaded. For example, SELinux calls ima_measure_critical_data() to
> measure its state and policy when they are initialized. This occurs
> before a custom IMA policy is loaded, and hence IMA hook will not
> measure the data. A built-in policy is therefore needed to measure
> critical data provided by callers before a custom IMA policy is loaded.

^Define a new critical data builtin policy to allow measuring early
kernel integrity critical data before a custom IMA policy is loaded.

Either remove the references to SELinux or move this patch after the
subsequent patch which measures SELinux critical data.

> 
> Add CRITICAL_DATA to built-in IMA rules if the kernel command line
> contains "ima_policy=critical_data". Set the IMA template for this rule
> to "ima-buf" since ima_measure_critical_data() measures a buffer.
> 
> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

> ---
>  security/integrity/ima/ima_policy.c | 32 +++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index ec99e0bb6c6f..dc8fe969d3fe 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c

> @@ -875,6 +884,29 @@ void __init ima_init_policy(void)
>  			  ARRAY_SIZE(default_appraise_rules),
>  			  IMA_DEFAULT_POLICY);
>  
> +	if (ima_use_critical_data) {
> +		template = lookup_template_desc("ima-buf");
> +		if (!template) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		ret = template_desc_init_fields(template->fmt,
> +						&(template->fields),
> +						&(template->num_fields));

The default IMA template when measuring buffer data is "ima_buf".   Is
there a reason for allocating and initializing it here and not
deferring it until process_buffer_measurement()?

thanks,

Mimi

> +		if (ret)
> +			goto out;
> +
> +		critical_data_rules[0].template = template;
> +		add_rules(critical_data_rules,
> +			  ARRAY_SIZE(critical_data_rules),
> +			  IMA_DEFAULT_POLICY);
> +	}
> +
> +out:
> +	if (ret)
> +		pr_err("%s failed, result: %d\n", __func__, ret);
> +
>  	ima_update_policy_flag();
>  }
>  


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

