Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31BFC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 11:48:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B84F23DE3
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 11:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B84F23DE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-Do7W-ZFKMBuQIzcaLuAAyA-1; Fri, 11 Dec 2020 06:48:30 -0500
X-MC-Unique: Do7W-ZFKMBuQIzcaLuAAyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E4901934100;
	Fri, 11 Dec 2020 11:48:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F4D110023B3;
	Fri, 11 Dec 2020 11:48:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 50D234BB7B;
	Fri, 11 Dec 2020 11:48:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BANFIaq023336 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 18:15:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6C932E2A82; Thu, 10 Dec 2020 23:15:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 672AFE2A6C
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 23:15:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF0D1858287
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 23:15:15 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-363-30eWb4y0MPGQG7IGJIVBng-1;
	Thu, 10 Dec 2020 18:15:10 -0500
X-MC-Unique: 30eWb4y0MPGQG7IGJIVBng-1
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net
	[162.237.133.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id DA45220B717A;
	Thu, 10 Dec 2020 15:15:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DA45220B717A
Date: Thu, 10 Dec 2020 17:15:05 -0600
From: Tyler Hicks <tyhicks@linux.microsoft.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201210231505.GJ489768@sequoia>
References: <20201209194212.5131-1-tusharsu@linux.microsoft.com>
	<20201209194212.5131-6-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201209194212.5131-6-tusharsu@linux.microsoft.com>
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
X-Mailman-Approved-At: Fri, 11 Dec 2020 06:47:16 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v7 5/8] IMA: limit critical data measurement
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020-12-09 11:42:09, Tushar Sugandhi wrote:
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

This patch will look good once all the IMA_DATA_SOURCE stuff is moved
over from patch #4.

Tyler

> ---
>  Documentation/ABI/testing/ima_policy |  2 ++
>  security/integrity/ima/ima_policy.c  | 26 +++++++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
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
> index 9a8ee80a3128..7486d09a3f60 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -934,7 +934,7 @@ enum {
>  	Opt_uid_lt, Opt_euid_lt, Opt_fowner_lt,
>  	Opt_appraise_type, Opt_appraise_flag,
>  	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
> -	Opt_err
> +	Opt_data_source, Opt_err
>  };
>  
>  static const match_table_t policy_tokens = {
> @@ -971,6 +971,7 @@ static const match_table_t policy_tokens = {
>  	{Opt_pcr, "pcr=%s"},
>  	{Opt_template, "template=%s"},
>  	{Opt_keyrings, "keyrings=%s"},
> +	{Opt_data_source, "data_source=%s"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -1350,6 +1351,23 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
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
> @@ -1730,6 +1748,12 @@ int ima_policy_show(struct seq_file *m, void *v)
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

