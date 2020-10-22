Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E9BC2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:38:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 84480222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:38:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84480222EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-YGg4Bcn1PpyBIAlmgOgeUg-1; Mon, 26 Oct 2020 03:38:33 -0400
X-MC-Unique: YGg4Bcn1PpyBIAlmgOgeUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C70BB6123D;
	Mon, 26 Oct 2020 07:38:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 70B0D6EF5F;
	Mon, 26 Oct 2020 07:38:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E27B8180B791;
	Mon, 26 Oct 2020 07:38:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09MJdfrW006152 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Oct 2020 15:39:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1F90220182A5; Thu, 22 Oct 2020 19:39:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18ADB2017F02
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 19:39:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D674185A78B
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 19:39:39 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-205-nkiEnJ7lOFaBfSWcNeyOqg-1; Thu, 22 Oct 2020 15:39:36 -0400
X-MC-Unique: nkiEnJ7lOFaBfSWcNeyOqg-1
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	09MJY32r062298; Thu, 22 Oct 2020 15:39:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34ba2gn35t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 15:39:34 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MJYf90070092;
	Thu, 22 Oct 2020 15:39:34 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34ba2gn350-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 15:39:34 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	09MJburW018547; Thu, 22 Oct 2020 19:39:32 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com
	(b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma06ams.nl.ibm.com with ESMTP id 347qvhdu03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 19:39:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 09MJdTpj32899428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 22 Oct 2020 19:39:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C4FA711C04A;
	Thu, 22 Oct 2020 19:39:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 676EA11C054;
	Thu, 22 Oct 2020 19:39:26 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.54.44]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2020 19:39:26 +0000 (GMT)
Message-ID: <45aae09df5c301497efc697c17921e9b2a3c8ae8.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com
Date: Thu, 22 Oct 2020 15:39:25 -0400
In-Reply-To: <20200923192011.5293-2-tusharsu@linux.microsoft.com>
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
	<20200923192011.5293-2-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235, 18.0.737
	definitions=2020-10-22_13:2020-10-20,
	2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	impostorscore=0
	mlxlogscore=999 clxscore=1011 bulkscore=0 priorityscore=1501
	adultscore=0
	malwarescore=0 lowpriorityscore=0 phishscore=0 spamscore=0
	suspectscore=0
	mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2010220123
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
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 1/6] IMA: generalize keyring specific
 measurement constructs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

On Wed, 2020-09-23 at 12:20 -0700, Tushar Sugandhi wrote:

> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index fe1df373c113..31a772d8a86b 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -451,15 +451,19 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
>  }
>  
>  /**
> - * ima_match_keyring - determine whether the keyring matches the measure rule
> - * @rule: a pointer to a rule
> - * @keyring: name of the keyring to match against the measure rule
> + * ima_match_rule_data - determine whether the given func_data matches
> + *			 the measure rule data
> + * @rule: IMA policy rule
> + * @opt_list: rule data to match func_data against
> + * @func_data: data to match against the measure rule data
>   * @cred: a pointer to a credentials structure for user validation
>   *
> - * Returns true if keyring matches one in the rule, false otherwise.
> + * Returns true if func_data matches one in the rule, false otherwise.
>   */
> -static bool ima_match_keyring(struct ima_rule_entry *rule,
> -			      const char *keyring, const struct cred *cred)
> +static bool ima_match_rule_data(struct ima_rule_entry *rule,
> +				const struct ima_rule_opt_list *opt_list,
> +				const char *func_data,
> +				const struct cred *cred)
>  {
>  	bool matched = false;
>  	size_t i;
> @@ -467,14 +471,14 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
>  	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
>  		return false;
>  
> -	if (!rule->keyrings)
> +	if (!opt_list)
>  		return true;

The opt_list should be based on rule->func.  There shouldn't be a need
to pass it as a variable.

Mimi

>  
> -	if (!keyring)
> +	if (!func_data)
>  		return false;
>  
> -	for (i = 0; i < rule->keyrings->count; i++) {
> -		if (!strcmp(rule->keyrings->items[i], keyring)) {
> +	for (i = 0; i < opt_list->count; i++) {
> +		if (!strcmp(opt_list->items[i], func_data)) {
>  			matched = true;
>  			break;
>  		}

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

