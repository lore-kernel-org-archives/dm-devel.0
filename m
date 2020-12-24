Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EDDC43381
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A382C2068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:03:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A382C2068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-MtadcD_xNUG-QkboT5v_EQ-1; Mon, 04 Jan 2021 14:03:44 -0500
X-MC-Unique: MtadcD_xNUG-QkboT5v_EQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 992A9100C60B;
	Mon,  4 Jan 2021 19:03:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F87062463;
	Mon,  4 Jan 2021 19:03:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 414C85002D;
	Mon,  4 Jan 2021 19:03:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BO03ZEJ021533 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Dec 2020 19:03:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 718AB2026D3B; Thu, 24 Dec 2020 00:03:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BC762026D3A
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 00:03:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF6BD811E76
	for <dm-devel@redhat.com>; Thu, 24 Dec 2020 00:03:32 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-343-QIWmcXhEOV2ZS7bERvMsMg-1; Wed, 23 Dec 2020 19:03:28 -0500
X-MC-Unique: QIWmcXhEOV2ZS7bERvMsMg-1
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id
	0BO02s9a170305; Wed, 23 Dec 2020 19:03:27 -0500
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 35mff78mde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 23 Dec 2020 19:03:27 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BO03RjG174558;
	Wed, 23 Dec 2020 19:03:27 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.102])
	by mx0b-001b2d01.pphosted.com with ESMTP id 35mff78mcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 23 Dec 2020 19:03:27 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id
	0BO02rW6029657; Thu, 24 Dec 2020 00:03:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma06ams.nl.ibm.com with ESMTP id 35h8sh4dhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Thu, 24 Dec 2020 00:03:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
	[9.149.105.232])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 0BO03NcW43712808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Thu, 24 Dec 2020 00:03:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3961652057;
	Thu, 24 Dec 2020 00:03:23 +0000 (GMT)
Received: from sig-9-65-213-118.ibm.com (unknown [9.65.213.118])
	by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 930335204E;
	Thu, 24 Dec 2020 00:03:19 +0000 (GMT)
Message-ID: <4e83480731b937cea479f688029560444b9cb66a.camel@linux.ibm.com>
From: Mimi Zohar <zohar@linux.ibm.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, 
	snitzer@redhat.com, gmazyland@gmail.com, paul@paul-moore.com
Date: Wed, 23 Dec 2020 19:03:18 -0500
In-Reply-To: <20201212180251.9943-3-tusharsu@linux.microsoft.com>
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-3-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2020-12-23_14:2020-12-23,
	2020-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	malwarescore=0 phishscore=0
	suspectscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
	mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1011 bulkscore=0
	impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012230164
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 2/8] IMA: add support to measure buffer
	data hash
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
> The original IMA buffer data measurement sizes were small (e.g. boot
> command line), but the new buffer data measurement use cases have data 
> sizes that are a lot larger.  Just as IMA measures the file data hash,
> not the file data, IMA should similarly support the option for measuring 
> the hash of the buffer data.
> 
> Measuring in-memory buffer-data/buffer-data-hash is different than
> measuring file-data/file-data-hash. For the file, IMA stores the
> measurements in both measurement log and the file's extended attribute -
> which can later be used for appraisal as well. For buffer, the
> measurements are only stored in the IMA log, since the buffer has no
> extended attributes associated with it.

By definition, buffer data is only measured.  Nothing new is added by
the above paragraph.  Please remove it.

> 
> Introduce a boolean parameter measure_buf_hash to support measuring
> hash of a buffer, which would be much smaller, instead of the buffer
> itself.

Like the patch Subject line use "the buffer data hash" instead of the
"hash of a buffer".

There's no need to include the boolean parameter name
"measure_buf_hash".  Please remove it.

> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
> Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
> ---
>  security/integrity/ima/ima.h                 |  3 +-
>  security/integrity/ima/ima_appraise.c        |  2 +-
>  security/integrity/ima/ima_asymmetric_keys.c |  2 +-
>  security/integrity/ima/ima_main.c            | 38 +++++++++++++++++---
>  security/integrity/ima/ima_queue_keys.c      |  3 +-
>  5 files changed, 39 insertions(+), 9 deletions(-)
> 
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index e5622ce8cbb1..fa3044a7539f 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -268,7 +268,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>  			   struct ima_template_desc *template_desc);
>  void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  				const char *eventname, enum ima_hooks func,
> -				int pcr, const char *func_data);
> +				int pcr, const char *func_data,
> +				bool measure_buf_hash);

Please abbreviate the boolean name to "hash".   The test would then be
"if (hash == true)" or "if (hash)".

>  void ima_audit_measurement(struct integrity_iint_cache *iint,
>  			   const unsigned char *filename);
>  int ima_alloc_init_template(struct ima_event_data *event_data,
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 8361941ee0a1..46ffa38bab12 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -352,7 +352,7 @@ int ima_check_blacklist(struct integrity_iint_cache *iint,
>  		if ((rc == -EPERM) && (iint->flags & IMA_MEASURE))
>  			process_buffer_measurement(NULL, digest, digestsize,
>  						   "blacklisted-hash", NONE,
> -						   pcr, NULL);
> +						   pcr, NULL, false);
>  	}
>  
>  	return rc;
> diff --git a/security/integrity/ima/ima_asymmetric_keys.c b/security/integrity/ima/ima_asymmetric_keys.c
> index 1c68c500c26f..a74095793936 100644
> --- a/security/integrity/ima/ima_asymmetric_keys.c
> +++ b/security/integrity/ima/ima_asymmetric_keys.c
> @@ -60,5 +60,5 @@ void ima_post_key_create_or_update(struct key *keyring, struct key *key,
>  	 */
>  	process_buffer_measurement(NULL, payload, payload_len,
>  				   keyring->description, KEY_CHECK, 0,
> -				   keyring->description);
> +				   keyring->description, false);
>  }
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index e76ef4bfd0f4..0f8409d77602 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -779,7 +779,7 @@ int ima_post_load_data(char *buf, loff_t size,
>  }
>  
>  /*
> - * process_buffer_measurement - Measure the buffer to ima log.
> + * process_buffer_measurement - Measure the buffer or the buffer data hash
>   * @inode: inode associated with the object being measured (NULL for KEY_CHECK)
>   * @buf: pointer to the buffer that needs to be added to the log.
>   * @size: size of buffer(in bytes).
> @@ -787,12 +787,23 @@ int ima_post_load_data(char *buf, loff_t size,
>   * @func: IMA hook
>   * @pcr: pcr to extend the measurement
>   * @func_data: private data specific to @func, can be NULL.
> + * @measure_buf_hash: measure buffer hash

^@hash: measure buffer data hash

>   *
> - * Based on policy, the buffer is measured into the ima log.
> + * Measure the buffer into the IMA log, and extend the @pcr.

IMA always measures/appraises files and measures buffer data based on
policy.  The above sentence succintly summarizes what
process_buffer_measurement() does.   This patch adds support for
measuring the "buffer data hash".   The following would be an
appropriate change.

* Based on policy, either the buffer data or buffer data hash is
measured

> + *
> + * Determine what buffers are allowed to be measured, based on the policy rules
> + * and the IMA hook passed using @func.
> + *
> + * Use @func_data, if provided, to match against the measurement policy rule
> + * data for @func.
> + *
> + * If @measure_buf_hash is set to true - measure hash of the buffer data,
> + * else measure the buffer data itself.

This patch should be limited to adding "buffer data hash" support. 
These changes don't belong in this patch.  Please remove.

>   */
>  void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  				const char *eventname, enum ima_hooks func,
> -				int pcr, const char *func_data)
> +				int pcr, const char *func_data,
> +				bool measure_buf_hash)
>  {
>  	int ret = 0;
>  	const char *audit_cause = "ENOMEM";
> @@ -807,6 +818,8 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  		struct ima_digest_data hdr;
>  		char digest[IMA_MAX_DIGEST_SIZE];
>  	} hash = {};
> +	char buf_hash[IMA_MAX_DIGEST_SIZE];
> +	int buf_hash_len = hash_digest_size[ima_hash_algo];
>  	int violation = 0;
>  	int action = 0;
>  	u32 secid;
> @@ -849,13 +862,27 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
>  		goto out;
>  	}
>  
> +	if (measure_buf_hash) {

^ if (hash) {
> +		memcpy(buf_hash, hash.hdr.digest, buf_hash_len);
> +
> +		ret = ima_calc_buffer_hash(buf_hash, buf_hash_len,
> +					   iint.ima_hash);
> +		if (ret < 0) {
> +			audit_cause = "measure_buf_hash_error";

I don't see a good no reason for defining a new audit cause.  Use the
existing "hashing_error".

thanks,

Mimi

> +			goto out;
> +		}
> +
> +		event_data.buf = buf_hash;
> +		event_data.buf_len = buf_hash_len;
> +	}
> +
>  	ret = ima_alloc_init_template(&event_data, &entry, template);
>  	if (ret < 0) {
>  		audit_cause = "alloc_entry";
>  		goto out;
>  	}
>  
> -	ret = ima_store_template(entry, violation, NULL, buf, pcr);
> +	ret = ima_store_template(entry, violation, NULL, event_data.buf, pcr);
>  	if (ret < 0) {
>  		audit_cause = "store_entry";
>  		ima_free_template_entry(entry);
> @@ -890,7 +917,8 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>  		return;
>  
>  	process_buffer_measurement(file_inode(f.file), buf, size,
> -				   "kexec-cmdline", KEXEC_CMDLINE, 0, NULL);
> +				   "kexec-cmdline", KEXEC_CMDLINE, 0, NULL,
> +				   false);
>  	fdput(f);
>  }
>  
> diff --git a/security/integrity/ima/ima_queue_keys.c b/security/integrity/ima/ima_queue_keys.c
> index 69a8626a35c0..c2f2ad34f9b7 100644
> --- a/security/integrity/ima/ima_queue_keys.c
> +++ b/security/integrity/ima/ima_queue_keys.c
> @@ -162,7 +162,8 @@ void ima_process_queued_keys(void)
>  						   entry->payload_len,
>  						   entry->keyring_name,
>  						   KEY_CHECK, 0,
> -						   entry->keyring_name);
> +						   entry->keyring_name,
> +						   false);
>  		list_del(&entry->list);
>  		ima_free_key_entry(entry);
>  	}


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

