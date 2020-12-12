Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B018AC1B0D8
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 20EFE22BEF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20EFE22BEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Ygni4Ss9MU6AGDjBO5hwkA-1; Mon, 14 Dec 2020 06:01:06 -0500
X-MC-Unique: Ygni4Ss9MU6AGDjBO5hwkA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FDF9814415;
	Mon, 14 Dec 2020 11:00:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D7671975F;
	Mon, 14 Dec 2020 11:00:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4E6A55002E;
	Mon, 14 Dec 2020 11:00:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BC0DsON000850 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 19:13:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DFA5C1111A59; Sat, 12 Dec 2020 00:13:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB7E51111A51
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 00:13:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 823AB8007D9
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 00:13:52 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-413-DZamhoLANGyRU5fHQG8XPQ-1;
	Fri, 11 Dec 2020 19:13:50 -0500
X-MC-Unique: DZamhoLANGyRU5fHQG8XPQ-1
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net
	[162.237.133.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5BFD120B717B;
	Fri, 11 Dec 2020 16:13:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5BFD120B717B
Date: Fri, 11 Dec 2020 18:13:43 -0600
From: Tyler Hicks <tyhicks@linux.microsoft.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201212001343.GE4951@sequoia>
References: <20201211235807.30815-1-tusharsu@linux.microsoft.com>
	<20201211235807.30815-4-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201211235807.30815-4-tusharsu@linux.microsoft.com>
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
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: sashal@kernel.org, paul@paul-moore.com, snitzer@redhat.com,
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com,
	jmorris@namei.org, zohar@linux.ibm.com,
	linux-kernel@vger.kernel.org, nramas@linux.microsoft.com,
	linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
	linux-integrity@vger.kernel.org, dm-devel@redhat.com,
	gmazyland@gmail.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v8 3/8] IMA: define a hook to measure kernel
 integrity critical data
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

On 2020-12-11 15:58:02, Tushar Sugandhi wrote:
> IMA provides capabilities to measure file data, and in-memory buffer
> data. However, various data structures, policies, and states
> stored in kernel memory also impact the integrity of the system.
> Several kernel subsystems contain such integrity critical data. These
> kernel subsystems help protect the integrity of a device. Currently,
> IMA does not provide a generic function for kernel subsystems to measure
> their integrity critical data.
>  
> Define a new IMA hook - ima_measure_critical_data to measure kernel
> integrity critical data.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>

Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

> ---
>  include/linux/ima.h               |  6 ++++++
>  security/integrity/ima/ima.h      |  1 +
>  security/integrity/ima/ima_api.c  |  2 +-
>  security/integrity/ima/ima_main.c | 34 +++++++++++++++++++++++++++++++
>  4 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index ac3d82f962f2..675f54db6264 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -30,6 +30,9 @@ extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
>  extern void ima_post_path_mknod(struct dentry *dentry);
>  extern int ima_file_hash(struct file *file, char *buf, size_t buf_size);
>  extern void ima_kexec_cmdline(int kernel_fd, const void *buf, int size);
> +extern void ima_measure_critical_data(const char *event_name,
> +				      const void *buf, int buf_len,
> +				      bool measure_buf_hash);
>  
>  #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
>  extern void ima_appraise_parse_cmdline(void);
> @@ -122,6 +125,9 @@ static inline int ima_file_hash(struct file *file, char *buf, size_t buf_size)
>  }
>  
>  static inline void ima_kexec_cmdline(int kernel_fd, const void *buf, int size) {}
> +static inline void ima_measure_critical_data(const char *event_name,
> +					     const void *buf, int buf_len,
> +					     bool measure_buf_hash) {}
>  #endif /* CONFIG_IMA */
>  
>  #ifndef CONFIG_IMA_KEXEC
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index fa3044a7539f..7d9deda6a8b3 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -201,6 +201,7 @@ static inline unsigned int ima_hash_key(u8 *digest)
>  	hook(POLICY_CHECK, policy)			\
>  	hook(KEXEC_CMDLINE, kexec_cmdline)		\
>  	hook(KEY_CHECK, key)				\
> +	hook(CRITICAL_DATA, critical_data)		\
>  	hook(MAX_CHECK, none)
>  
>  #define __ima_hook_enumify(ENUM, str)	ENUM,
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index af218babd198..9917e1730cb6 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -176,7 +176,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
>   *		subj=, obj=, type=, func=, mask=, fsmagic=
>   *	subj,obj, and type: are LSM specific.
>   *	func: FILE_CHECK | BPRM_CHECK | CREDS_CHECK | MMAP_CHECK | MODULE_CHECK
> - *	| KEXEC_CMDLINE | KEY_CHECK
> + *	| KEXEC_CMDLINE | KEY_CHECK | CRITICAL_DATA
>   *	mask: contains the permission mask
>   *	fsmagic: hex value
>   *
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 0f8409d77602..dff4bce4fb09 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -922,6 +922,40 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>  	fdput(f);
>  }
>  
> +/**
> + * ima_measure_critical_data - measure kernel integrity critical data
> + * @event_name: event name to be used for the buffer entry
> + * @buf: pointer to buffer containing data to measure
> + * @buf_len: length of buffer(in bytes)
> + * @measure_buf_hash: measure buffer hash
> + *
> + * Measure the kernel subsystem data, critical to the integrity of the kernel,
> + * into the IMA log and extend the @pcr.
> + *
> + * Use @event_name to describe the state/buffer data change.
> + * Examples of critical data (@buf) could be various data structures,
> + * policies, and states stored in kernel memory that can impact the integrity
> + * of the system.
> + *
> + * If @measure_buf_hash is set to true - measure hash of the buffer data,
> + * else measure the buffer data itself.
> + * @measure_buf_hash can be used to save space, if the data being measured
> + * is too large.
> + *
> + * The data (@buf) can only be measured, not appraised.
> + */
> +void ima_measure_critical_data(const char *event_name,
> +			       const void *buf, int buf_len,
> +			       bool measure_buf_hash)
> +{
> +	if (!event_name || !buf || !buf_len)
> +		return;
> +
> +	process_buffer_measurement(NULL, buf, buf_len, event_name,
> +				   CRITICAL_DATA, 0, NULL,
> +				   measure_buf_hash);
> +}
> +
>  static int __init init_ima(void)
>  {
>  	int error;
> -- 
> 2.17.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

