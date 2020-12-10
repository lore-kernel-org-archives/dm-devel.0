Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCA7C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 11:48:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7AA623DE3
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 11:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7AA623DE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-q8aUWUR2P6ikqrKjUZnU7g-1; Fri, 11 Dec 2020 06:48:31 -0500
X-MC-Unique: q8aUWUR2P6ikqrKjUZnU7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3958100C600;
	Fri, 11 Dec 2020 11:48:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85AC81F048;
	Fri, 11 Dec 2020 11:48:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5EA264E58E;
	Fri, 11 Dec 2020 11:48:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BANMRoL024383 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 18:22:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4E8BD10E60DC; Thu, 10 Dec 2020 23:22:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AA5910E60DB
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 23:22:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0CCC858284
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 23:22:23 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-203-lFHO6tFrM9KhqEHWhaJfTA-1;
	Thu, 10 Dec 2020 18:22:19 -0500
X-MC-Unique: lFHO6tFrM9KhqEHWhaJfTA-1
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net
	[162.237.133.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id BED1520B717A;
	Thu, 10 Dec 2020 15:22:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BED1520B717A
Date: Thu, 10 Dec 2020 17:22:14 -0600
From: Tyler Hicks <tyhicks@linux.microsoft.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201210232214.GL489768@sequoia>
References: <20201209194212.5131-1-tusharsu@linux.microsoft.com>
	<20201209194212.5131-8-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201209194212.5131-8-tusharsu@linux.microsoft.com>
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
X-Mailman-Approved-At: Fri, 11 Dec 2020 06:47:16 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v7 7/8] IMA: define a builtin critical data
 measurement policy
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020-12-09 11:42:11, Tushar Sugandhi wrote:
> From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
> 
> Define a new critical data builtin policy to allow measuring
> early kernel integrity critical data before a custom IMA policy
> is loaded.
> 
> Add critical data to built-in IMA rules if the kernel command line
> contains "ima_policy=critical_data".
> 
> Update the documentation on kernel parameters to document
> the new critical data builtin policy.
> 
> Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

> ---
>  Documentation/admin-guide/kernel-parameters.txt |  5 ++++-
>  security/integrity/ima/ima_policy.c             | 12 ++++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 526d65d8573a..6034d75c3ca0 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1746,7 +1746,7 @@
>  	ima_policy=	[IMA]
>  			The builtin policies to load during IMA setup.
>  			Format: "tcb | appraise_tcb | secure_boot |
> -				 fail_securely"
> +				 fail_securely | critical_data"
>  
>  			The "tcb" policy measures all programs exec'd, files
>  			mmap'd for exec, and all files opened with the read
> @@ -1765,6 +1765,9 @@
>  			filesystems with the SB_I_UNVERIFIABLE_SIGNATURE
>  			flag.
>  
> +			The "critical_data" policy measures kernel integrity
> +			critical data.
> +
>  	ima_tcb		[IMA] Deprecated.  Use ima_policy= instead.
>  			Load a policy which meets the needs of the Trusted
>  			Computing Base.  This means IMA will measure all
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 7486d09a3f60..37ca16a9e65f 100644
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
> +static bool ima_use_critical_data __initdata;
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
> -- 
> 2.17.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

