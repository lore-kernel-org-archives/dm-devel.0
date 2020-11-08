Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4ADC56201
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AC54B20731
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC54B20731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-8JHtJEZCMvupS2Aa2Gn_kA-1; Sun, 08 Nov 2020 12:05:28 -0500
X-MC-Unique: 8JHtJEZCMvupS2Aa2Gn_kA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 700FD809DE1;
	Sun,  8 Nov 2020 17:05:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50EE176648;
	Sun,  8 Nov 2020 17:05:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 24D1192305;
	Sun,  8 Nov 2020 17:05:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A8FksNm017164 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 8 Nov 2020 10:46:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9AC2A2166B44; Sun,  8 Nov 2020 15:46:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94ED52166B28
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 15:46:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68A94185A78B
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 15:46:52 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-515-Ym_mtX0zNkWQyMikjLTtUw-1; Sun, 08 Nov 2020 10:46:50 -0500
X-MC-Unique: Ym_mtX0zNkWQyMikjLTtUw-1
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0A8FWBaA195746; Sun, 8 Nov 2020 10:46:49 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34p9kc945p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sun, 08 Nov 2020 10:46:49 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A8Fcop5017260;
	Sun, 8 Nov 2020 10:46:49 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.72])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34p9kc945e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sun, 08 Nov 2020 10:46:49 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0A8FRdEA002374; Sun, 8 Nov 2020 15:46:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com
	(d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma06fra.de.ibm.com with ESMTP id 34njuh0kex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sun, 08 Nov 2020 15:46:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0A8Fkivm5308996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Sun, 8 Nov 2020 15:46:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97CC742045;
	Sun,  8 Nov 2020 15:46:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 539424203F;
	Sun,  8 Nov 2020 15:46:41 +0000 (GMT)
Received: from sig-9-65-237-19.ibm.com (unknown [9.65.237.19])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Sun,  8 Nov 2020 15:46:41 +0000 (GMT)
Message-ID: <c2c6efe8b2903949fb7118b56991988ba9c4f582.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Tushar Sugandhi
	<tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Sun, 08 Nov 2020 10:46:39 -0500
In-Reply-To: <d92869b5-7244-e29e-5d30-c0e06cf45be1@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-7-tusharsu@linux.microsoft.com>
	<7219f4404bc1bed6eb090b94363c283ec3266a17.camel@linux.ibm.com>
	<cdcd63f7-ce1f-4463-f886-c36832d7a706@linux.microsoft.com>
	<d92869b5-7244-e29e-5d30-c0e06cf45be1@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-08_06:2020-11-05,
	2020-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	phishscore=0
	priorityscore=1501 clxscore=1015 spamscore=0 lowpriorityscore=0
	malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=3
	adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
	scancount=1 engine=8.12.0-2009150000 definitions=main-2011080109
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
	linux-security-module@vger.kernel.org,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Lakshmi,

On Fri, 2020-11-06 at 15:51 -0800, Lakshmi Ramasubramanian wrote:
> 
> >>> diff --git a/security/integrity/ima/ima_policy.c 
> >>> b/security/integrity/ima/ima_policy.c
> >>> index ec99e0bb6c6f..dc8fe969d3fe 100644
> >>> --- a/security/integrity/ima/ima_policy.c
> >>> +++ b/security/integrity/ima/ima_policy.c
> >>
> >>> @@ -875,6 +884,29 @@ void __init ima_init_policy(void)
> >>>                 ARRAY_SIZE(default_appraise_rules),
> >>>                 IMA_DEFAULT_POLICY);
> >>> +    if (ima_use_critical_data) {
> >>> +        template = lookup_template_desc("ima-buf");
> >>> +        if (!template) {
> >>> +            ret = -EINVAL;
> >>> +            goto out;
> >>> +        }
> >>> +
> >>> +        ret = template_desc_init_fields(template->fmt,
> >>> +                        &(template->fields),
> >>> +                        &(template->num_fields));
> >>
> >> The default IMA template when measuring buffer data is "ima_buf".   Is
> >> there a reason for allocating and initializing it here and not
> >> deferring it until process_buffer_measurement()?
> >>
> > 
> > You are right - good catch.
> > I will remove the above and validate.
> > 
> 
> process_buffer_measurement() allocates and initializes "ima-buf" 
> template only when the parameter "func" is NONE. Currently, only 
> ima_check_blacklist() passes NONE for func when calling 
> process_buffer_measurement().
> 
> If "func" is anything other than NONE, ima_match_policy() picks
> the default IMA template if the IMA policy rule does not specify a template.
> 
> We need to add "ima-buf" in the built-in policy for critical_data so 
> that the default template is not used for buffer measurement.
> 
> Please let me know if I am missing something.
> 

Let's explain a bit further what is happening and why.   As you said
ima_get_action() returns the template format, which may be the default
IMA template or the specific IMA policy rule template format.  This
works properly for both the arch specific and custom policies, but not
for builtin policies, because the policy rules may contain a rule
specific .template field.   When the rules don't contain a rule
specific template field, they default to the IMA default template.  In
the case of builtin policies, the policy rules cannot contain the
.template field.

The default template field for process_buffer_measurement() should
always be "ima-buf", not the default IMA template format.   Let's fix
this prior to this patch.

Probably something like this:
- In addition to initializing the default IMA template, initialize the
"ima-buf" template.  Maybe something similiar to
ima_template_desc_current().
- Set the default in process_buffer_measurement() to "ima-buf", before
calling ima_get_action().
- modify ima_match_policy() so that the default policy isn't reset when
already specified.

thanks,

Mimi


> >>
> >>> +        if (ret)
> >>> +            goto out;
> >>> +
> >>> +        critical_data_rules[0].template = template;
> >>> +        add_rules(critical_data_rules,
> >>> +              ARRAY_SIZE(critical_data_rules),
> >>> +              IMA_DEFAULT_POLICY);
> >>> +    }
> >>> +
> >>> +out:
> >>> +    if (ret)
> >>> +        pr_err("%s failed, result: %d\n", __func__, ret);
> >>> +
> >>>       ima_update_policy_flag();
> >>>   }
> >>
> > 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

