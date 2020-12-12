Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994BAC1B0D8
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FB7722CB1
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FB7722CB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-sE2EnLCEMUuhm8E73vETrQ-1; Mon, 14 Dec 2020 06:01:08 -0500
X-MC-Unique: sE2EnLCEMUuhm8E73vETrQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 094BA1926DAB;
	Mon, 14 Dec 2020 11:01:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D30771975F;
	Mon, 14 Dec 2020 11:01:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D4BC1809CA2;
	Mon, 14 Dec 2020 11:01:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BCJKwVp004806 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Dec 2020 14:20:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C9522026D48; Sat, 12 Dec 2020 19:20:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97BB52026D47
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 19:20:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40B93858284
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 19:20:56 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-465-ac1cFhm6Mb-hS31A65x-4Q-1;
	Sat, 12 Dec 2020 14:20:53 -0500
X-MC-Unique: ac1cFhm6Mb-hS31A65x-4Q-1
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net
	[162.237.133.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id D778E20B717B;
	Sat, 12 Dec 2020 11:20:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D778E20B717B
Date: Sat, 12 Dec 2020 13:20:49 -0600
From: Tyler Hicks <tyhicks@linux.microsoft.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201212192049.GJ4951@sequoia>
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-6-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201212180251.9943-6-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020-12-12 10:02:48, Tushar Sugandhi wrote:
> System administrators should be able to limit which kernel subsystems
> they want to measure the critical data for. To enable that, an IMA policy
> condition to choose specific kernel subsystems is needed. This policy
> condition would constrain the measurement of the critical data based on
> a label for the given subsystems.
> 
> Add a new IMA policy condition - "data_source:=" to the IMA func
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

Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

> ---
>  Documentation/ABI/testing/ima_policy |  2 ++
>  security/integrity/ima/ima_policy.c  | 37 +++++++++++++++++++++++++---
>  2 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index 6ec7daa87cba..0f4ee9e0a455 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -52,6 +52,8 @@ Description:
>  			template:= name of a defined IMA template type
>  			(eg, ima-ng). Only valid when action is "measure".
>  			pcr:= decimal value
> +			data_source:= [label]
> +			label:= a unique string used for grouping and limiting critical data.
>  
>  		  default policy:
>  			# PROC_SUPER_MAGIC
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index d45c2dbb6d45..fea996a9e26c 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -34,6 +34,7 @@
>  #define IMA_PCR		0x0100
>  #define IMA_FSNAME	0x0200
>  #define IMA_KEYRINGS	0x0400
> +#define IMA_DATA_SOURCE	0x0800
>  
>  #define UNKNOWN		0
>  #define MEASURE		0x0001	/* same as IMA_MEASURE */
> @@ -85,6 +86,7 @@ struct ima_rule_entry {
>  	} lsm[MAX_LSM_RULES];
>  	char *fsname;
>  	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
> +	struct ima_rule_opt_list *data_source; /* Measure data from this source */
>  	struct ima_template_desc *template;
>  };
>  
> @@ -480,7 +482,11 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
>  		opt_list = rule->keyrings;
>  		break;
>  	case CRITICAL_DATA:
> -		return true;
> +		if (!rule->data_source)
> +			return true;
> +
> +		opt_list = rule->data_source;
> +		break;
>  	default:
>  		return false;
>  	}
> @@ -925,7 +931,7 @@ enum {
>  	Opt_uid_lt, Opt_euid_lt, Opt_fowner_lt,
>  	Opt_appraise_type, Opt_appraise_flag,
>  	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
> -	Opt_err
> +	Opt_data_source, Opt_err
>  };
>  
>  static const match_table_t policy_tokens = {
> @@ -962,6 +968,7 @@ static const match_table_t policy_tokens = {
>  	{Opt_pcr, "pcr=%s"},
>  	{Opt_template, "template=%s"},
>  	{Opt_keyrings, "keyrings=%s"},
> +	{Opt_data_source, "data_source=%s"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -1129,7 +1136,8 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
>  		if (entry->action & ~(MEASURE | DONT_MEASURE))
>  			return false;
>  
> -		if (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR))
> +		if (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR |
> +				     IMA_DATA_SOURCE))
>  			return false;
>  
>  		if (ima_rule_contains_lsm_cond(entry))
> @@ -1339,6 +1347,23 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  
>  			entry->flags |= IMA_KEYRINGS;
>  			break;
> +		case Opt_data_source:
> +			ima_log_string(ab, "data_source", args[0].from);
> +
> +			if (entry->data_source) {
> +				result = -EINVAL;
> +				break;
> +			}
> +
> +			entry->data_source = ima_alloc_rule_opt_list(args);
> +			if (IS_ERR(entry->data_source)) {
> +				result = PTR_ERR(entry->data_source);
> +				entry->data_source = NULL;
> +				break;
> +			}
> +
> +			entry->flags |= IMA_DATA_SOURCE;
> +			break;
>  		case Opt_fsuuid:
>  			ima_log_string(ab, "fsuuid", args[0].from);
>  
> @@ -1719,6 +1744,12 @@ int ima_policy_show(struct seq_file *m, void *v)
>  		seq_puts(m, " ");
>  	}
>  
> +	if (entry->flags & IMA_DATA_SOURCE) {
> +		seq_puts(m, "data_source=");
> +		ima_show_rule_opt_list(m, entry->data_source);
> +		seq_puts(m, " ");
> +	}
> +
>  	if (entry->flags & IMA_PCR) {
>  		snprintf(tbuf, sizeof(tbuf), "%d", entry->pcr);
>  		seq_printf(m, pt(Opt_pcr), tbuf);
> -- 
> 2.17.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

