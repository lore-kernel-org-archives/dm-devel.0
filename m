Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3181FC2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91B3A20735
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:22:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91B3A20735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-SgujgMb0OXG6PyiZOuZyJg-1; Mon, 26 Oct 2020 03:22:23 -0400
X-MC-Unique: SgujgMb0OXG6PyiZOuZyJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A740CFF2E;
	Mon, 26 Oct 2020 07:22:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EB8C6EF46;
	Mon, 26 Oct 2020 07:22:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D2D101832FC2;
	Mon, 26 Oct 2020 07:22:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09MMZUOe025012 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Oct 2020 18:35:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 44DA82156A37; Thu, 22 Oct 2020 22:35:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F6A12156A36
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 22:35:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DDB2102F220
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 22:35:28 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-332-lnnJk7nzMUC-3UCZZu6xDQ-1; Thu, 22 Oct 2020 18:35:23 -0400
X-MC-Unique: lnnJk7nzMUC-3UCZZu6xDQ-1
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	09MMVYFg058448; Thu, 22 Oct 2020 18:35:22 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34be0u1n31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 18:35:22 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09MMZ8I0071182;
	Thu, 22 Oct 2020 18:35:21 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 34be0u1n29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 18:35:21 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	09MMWw6H011289; Thu, 22 Oct 2020 22:35:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com
	(b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
	by ppma06ams.nl.ibm.com with ESMTP id 347qvhdxw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 22 Oct 2020 22:35:19 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 09MMZHDD32571854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 22 Oct 2020 22:35:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 231B111C081;
	Thu, 22 Oct 2020 22:35:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5619311C080;
	Thu, 22 Oct 2020 22:35:13 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown
	[9.160.54.44]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2020 22:35:13 +0000 (GMT)
Message-ID: <dc22359475f0c233abdb9257d1ca745d4be3f9af.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com
Date: Thu, 22 Oct 2020 18:35:11 -0400
In-Reply-To: <20200923192011.5293-6-tusharsu@linux.microsoft.com>
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
	<20200923192011.5293-6-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235, 18.0.737
	definitions=2020-10-22_17:2020-10-20,
	2020-10-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxlogscore=999 mlxscore=0
	phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501
	lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
	impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
	scancount=1 engine=8.12.0-2009150000 definitions=main-2010220140
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
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:18 -0400
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v4 5/6] IMA: add hook to measure critical
 data from kernel components
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
> Currently, IMA does not provide a generic function for kernel components
> to measure their data. A generic function provided by IMA would
> enable various parts of the kernel with easier and faster on-boarding to
> use IMA infrastructure, would avoid code duplication, and consistent
> usage of IMA policy option "data_sources:=" across the kernel.
> 
> Add a new IMA func CRITICAL_DATA and a corresponding IMA hook
> ima_measure_critical_data() to support measuring various critical kernel
> components. Limit the measurement to the components that are specified
> in the IMA policy - CRITICAL_DATA+data_sources.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>

Normally the new LSM or IMA hook is defined before defining a method of
constraining that hook.  Please drop 2/6 (IMA: conditionally allow
empty rule data) and reverse the order of 4/6 and 5/6.   That will
allow each patch to update the Documentation appropriately, making the
change self contained.

> ---
>  Documentation/ABI/testing/ima_policy |  8 ++++++-
>  include/linux/ima.h                  |  8 +++++++
>  security/integrity/ima/ima.h         |  1 +
>  security/integrity/ima/ima_api.c     |  2 +-
>  security/integrity/ima/ima_main.c    | 26 +++++++++++++++++++++
>  security/integrity/ima/ima_policy.c  | 34 ++++++++++++++++++++++++----
>  6 files changed, 72 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index a81cf79fb255..d33bb51309fc 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -29,7 +29,7 @@ Description:
>  		base: 	func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
>  				[FIRMWARE_CHECK]
>  				[KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
> -				[KEXEC_CMDLINE] [KEY_CHECK]
> +				[KEXEC_CMDLINE] [KEY_CHECK] [CRITICAL_DATA]
>  			mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
>  			       [[^]MAY_EXEC]
>  			fsmagic:= hex value
> @@ -51,6 +51,8 @@ Description:
>  			data_sources:= list of kernel components
>  			(eg, selinux|apparmor|dm-crypt) that contain data critical
>  			to the security of the kernel.
> +			Only valid when action is "measure" and func is
> +			CRITICAL_DATA.
>  
>  		default policy:
>  			# PROC_SUPER_MAGIC
> @@ -128,3 +130,7 @@ Description:
>  		keys added to .builtin_trusted_keys or .ima keyring:
>  
>  			measure func=KEY_CHECK keyrings=.builtin_trusted_keys|.ima
> +
> +		Example of measure rule using CRITICAL_DATA to measure critical data
> +
> +			measure func=CRITICAL_DATA data_sources=selinux|apparmor|dm-crypt


As data sources are added, the documentation example should be updated
to reflect the new source.  Please do not include examples that don't
yet exist.


> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 6888fc372abf..d55896f28790 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -867,6 +867,32 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>  	fdput(f);
>  }
>  
> +/**
> + * ima_measure_critical_data - measure critical data
> + * @event_name: name for the given data
> + * @event_data_source: name of the event data source
> + * @buf: pointer to buffer containing data to measure
> + * @buf_len: length of buffer(in bytes)
> + * @measure_buf_hash: if set to true - will measure hash of the buf,
> + *                    instead of buf
> + *
> + * Buffers can only be measured, not appraised.
> + */

Perhaps the reason for defining both the event_name and
event_data_source will become clearer with an example.  At this point I
can only guess as to why both are needed (e.g. perhaps a data source
defines multiple events).

While "Buffers can only be measured, not appraised" is true, it was cut
& pasted from ima_kexec_cmdline.  Measuring the kexec boot cmdline is
self describing.  Here, a larger, more detailed IMA hook description
would be appropriate.

thanks,

Mimi

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

