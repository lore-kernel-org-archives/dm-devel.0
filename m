Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30FAC388F9
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:06:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7250F206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:06:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7250F206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-jdER5Gt_MZWAM8PLuiyHow-1; Sun, 08 Nov 2020 12:05:18 -0500
X-MC-Unique: jdER5Gt_MZWAM8PLuiyHow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20EB2185BDE3;
	Sun,  8 Nov 2020 17:05:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03DE65D9D2;
	Sun,  8 Nov 2020 17:05:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CD8A9922F7;
	Sun,  8 Nov 2020 17:05:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A6DOX4i019610 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 08:24:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 172D12144B54; Fri,  6 Nov 2020 13:24:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DDCE2166B28
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 13:24:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C2B803523
	for <dm-devel@redhat.com>; Fri,  6 Nov 2020 13:24:30 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-350-h6HJhJwePPyePOGLLKWLAg-1; Fri, 06 Nov 2020 08:24:28 -0500
X-MC-Unique: h6HJhJwePPyePOGLLKWLAg-1
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0A6D3CWg045101; Fri, 6 Nov 2020 08:24:28 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34n3qr7m4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 08:24:27 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A6DFnwT106475;
	Fri, 6 Nov 2020 08:24:27 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0b-001b2d01.pphosted.com with ESMTP id 34n3qr7m3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 08:24:27 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0A6DLxKn004773; Fri, 6 Nov 2020 13:24:25 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma03ams.nl.ibm.com with ESMTP id 34hm6hdskk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Fri, 06 Nov 2020 13:24:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com
	[9.149.105.62])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0A6DONFB64553234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Fri, 6 Nov 2020 13:24:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36A63AE056;
	Fri,  6 Nov 2020 13:24:23 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6192AE051;
	Fri,  6 Nov 2020 13:24:19 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.77.67]) by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Fri,  6 Nov 2020 13:24:19 +0000 (GMT)
Message-ID: <1f83ec246cb6356c340b379ab00e43f0b5bba0ae.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 06 Nov 2020 08:24:18 -0500
In-Reply-To: <20201101222626.6111-4-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
	<20201101222626.6111-4-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312, 18.0.737
	definitions=2020-11-06_04:2020-11-05,
	2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	bulkscore=0
	lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
	impostorscore=0 adultscore=0 phishscore=0 malwarescore=0 clxscore=1015
	mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
	scancount=1
	engine=8.12.0-2009150000 definitions=main-2011060090
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
Subject: Re: [dm-devel] [PATCH v5 3/7] IMA: add hook to measure critical data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Tushar,

On Sun, 2020-11-01 at 14:26 -0800, Tushar Sugandhi wrote:
> Currently, IMA does not provide a generic function for kernel subsystems
> to measure their critical data. Examples of critical data in this context
> could be kernel in-memory r/o structures, hash of the memory structures,
> or data that represents a linux kernel subsystem state change. The 
> critical data, if accidentally or maliciously altered, can compromise
> the integrity of the system.

Start out with what IMA does do (e.g. measures files and more recently
buffer data).  Afterwards continue with kernel integrity critical data
should also be measured.  Please include a definition of kernel
integrity critical data here, as well as in the cover letter.

> 
> A generic function provided by IMA to measure critical data would enable
> various subsystems with easier and faster on-boarding to use IMA
> infrastructure and would also avoid code duplication.

By definition LSM and IMA hooks are generic with callers in appropriate
places in the kernel.   This paragraph is redundant.

> 
> Add a new IMA func CRITICAL_DATA and a corresponding IMA hook
> ima_measure_critical_data() to support measuring critical data for 
> various kernel subsystems. 

Instead of using the word "add", it would be more appropriate to use
the word "define".   Define a new IMA hook named
ima_measure_critical_data to measure kernel integrity critical data.  
Please also update the Subject line as well.  "ima: define an IMA hook
to measure kernel integrity critical data".

> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> ---
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 4485d87c0aa5..6e1b11dcba53 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -921,6 +921,44 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>  	fdput(f);
>  }
>  
> +/**
> + * ima_measure_critical_data - measure kernel subsystem data
> + * critical to integrity of the kernel

Please change this to "measure kernel integrity critical data".

> + * @event_data_source: name of the data source being measured;
> + * typically it should be the name of the kernel subsystem that is sending
> + * the data for measurement

Including "data_source" here isn't quite right.  "data source" should
only be added in the first patch which uses it, not here.   When adding
it please shorten the field description to "kernel data source".   The
longer explanation can be included in the longer function description.

> + * @event_name: name of an event from the kernel subsystem that is sending
> + * the data for measurement

As this is being passed to process_buffer_measurement(), this should be
the same or similar to the existing definition.

> + * @buf: pointer to buffer containing data to measure
> + * @buf_len: length of buffer(in bytes)
> + * @measure_buf_hash: if set to true - will measure hash of the buf,
> + *                    instead of buf

 kernel doc requires a single line.  In this case, please shorten the
argument definition to "measure buffer data or buffer data hash".   The
details can be included in the longer function description.

> + *
> + * A given kernel subsystem (event_data_source) may send
> + * data (buf) to be measured when the data or the subsystem state changes.
> + * The state/data change can be described by event_name.
> + * Examples of critical data (buf) could be kernel in-memory r/o structures,
> + * hash of the memory structures, or data that represents subsystem
> + * state change.
> + * measure_buf_hash can be used to save space, if the data being measured
> + * is too large.
> + * The data (buf) can only be measured, not appraised.
> + */

Please remove this longer function description, replacing it something
more appropriate.  The subsequent patch that introduces the "data
source" parameter would expand the description.

thanks,

Mimi

> +void ima_measure_critical_data(const char *event_data_source,
> +			       const char *event_name,
> +			       const void *buf, int buf_len,
> +			       bool measure_buf_hash)
> +{
> +	if (!event_name || !event_data_source || !buf || !buf_len) {
> +		pr_err("Invalid arguments passed to %s().\n", __func__);
> +		return;
> +	}
> +
> +	process_buffer_measurement(NULL, buf, buf_len, event_name,
> +				   CRITICAL_DATA, 0, event_data_source,
> +				   measure_buf_hash);
> +}
> +
>  static int __init init_ima(void)
>  {
>  	int error;

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

