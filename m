Return-Path: <SRS0=JGfJ=E5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6722C63777
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E2CCE20729
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2CCE20729
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-7vaB3iCFMja_0OjYVcJQQg-1; Mon, 23 Nov 2020 03:40:26 -0500
X-MC-Unique: 7vaB3iCFMja_0OjYVcJQQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07D3F1922996;
	Mon, 23 Nov 2020 08:40:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA3385D6D7;
	Mon, 23 Nov 2020 08:40:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5B344E58E;
	Mon, 23 Nov 2020 08:40:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AKEUJ6x005573 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 09:30:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C60D310EB2A5; Fri, 20 Nov 2020 14:30:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFFED10EB2AA
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 14:30:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48EC5858EEC
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 14:30:17 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-534-MlgR6zZjMG6RjJP4yXyWuw-1; Fri, 20 Nov 2020 09:30:12 -0500
X-MC-Unique: MlgR6zZjMG6RjJP4yXyWuw-1
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0AKE3U9A040412; Fri, 20 Nov 2020 09:30:11 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34xe6b37f8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 20 Nov 2020 09:30:11 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AKE3mQt045247;
	Fri, 20 Nov 2020 09:30:11 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34xe6b37dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 20 Nov 2020 09:30:11 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0AKESVLD021127; Fri, 20 Nov 2020 14:30:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06fra.de.ibm.com with ESMTP id 34t6ghba1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 20 Nov 2020 14:30:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com
	[9.149.105.60])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0AKEU6sv44368354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Fri, 20 Nov 2020 14:30:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3414A42049;
	Fri, 20 Nov 2020 14:30:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D55F4204C;
	Fri, 20 Nov 2020 14:30:03 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.96.125])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri, 20 Nov 2020 14:30:03 +0000 (GMT)
Message-ID: <e151e67e0749766c1b501ecc54dbeb0450c0cea2.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 20 Nov 2020 09:30:02 -0500
In-Reply-To: <20201119232611.30114-8-tusharsu@linux.microsoft.com>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
	<20201119232611.30114-8-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-20_07:2020-11-20,
	2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxscore=0 mlxlogscore=999
	adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
	bulkscore=0
	suspectscore=0 clxscore=1015 malwarescore=0 impostorscore=0
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011200096
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
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:39:39 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v6 7/8] IMA: add a built-in policy rule for
 critical data measurement
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

Hi Lakshmi,

On Thu, 2020-11-19 at 15:26 -0800, Tushar Sugandhi wrote:
> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> 
> The IMA hook to measure kernel critical data, namely
> ima_measure_critical_data(), could be called before a custom IMA policy
> is loaded.
> Define a new critical data builtin policy to allow measuring
> early kernel integrity critical data before a custom IMA policy is
> loaded.

Everything needing to be said seems to be included in the second
sentence.  Does the first sentence add anything?  "Define a new
critical data builtin policy" makes for a good Subject line.

> 
> Add critical data to built-in IMA rules if the kernel command line
> contains "ima_policy=critical_data".

The boot command line parameters are defined in Documentation/admin-
guide/kernel-parameters.txt.  Please update "ima_policy".

> 
> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> ---
>  security/integrity/ima/ima_policy.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index c9e52dab0638..119604a3efa0 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -206,6 +206,10 @@ static struct ima_rule_entry secure_boot_rules[] __ro_after_init = {
>  	 .flags = IMA_FUNC | IMA_DIGSIG_REQUIRED},
>  };
> 
> +static struct ima_rule_entry critical_data_rules[] __ro_after_init = {
> +	{.action = MEASURE, .func = CRITICAL_DATA, .flags = IMA_FUNC},
> +};
> +
>  /* An array of architecture specific rules */
>  static struct ima_rule_entry *arch_policy_entry __ro_after_init;
>  
> @@ -228,6 +232,7 @@ __setup("ima_tcb", default_measure_policy_setup);
>  
>  static bool ima_use_appraise_tcb __initdata;
>  static bool ima_use_secure_boot __initdata;
> +static bool ima_use_critical_data __ro_after_init;

Unlike ima_fail_unverifiable_sigs, ima_use_critical_data is only used
during __init.  Please change "__ro_after_init" to "__initdata".  (The
critical data policy itself is defined properly as __ro_after_init.)

>  static bool ima_fail_unverifiable_sigs __ro_after_init;
>  static int __init policy_setup(char *str)
>  {
> @@ -242,6 +247,8 @@ static int __init policy_setup(char *str)
>  			ima_use_appraise_tcb = true;
>  		else if (strcmp(p, "secure_boot") == 0)
>  			ima_use_secure_boot = true;
> +		else if (strcmp(p, "critical_data") == 0)
> +			ima_use_critical_data = true;
>  		else if (strcmp(p, "fail_securely") == 0)
>  			ima_fail_unverifiable_sigs = true;
>  		else
> @@ -875,6 +882,11 @@ void __init ima_init_policy(void)
>  			  ARRAY_SIZE(default_appraise_rules),
>  			  IMA_DEFAULT_POLICY);
>  
> +	if (ima_use_critical_data)
> +		add_rules(critical_data_rules,
> +			  ARRAY_SIZE(critical_data_rules),
> +			  IMA_DEFAULT_POLICY);
> +
>  	ima_update_policy_flag();
>  }
>  


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

