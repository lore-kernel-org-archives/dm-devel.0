Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9D5C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 11:48:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE58923DE3
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 11:48:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE58923DE3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-MfRuA526MpuETp-aClLp4w-1; Fri, 11 Dec 2020 06:48:50 -0500
X-MC-Unique: MfRuA526MpuETp-aClLp4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C48541005504;
	Fri, 11 Dec 2020 11:48:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A90635F724;
	Fri, 11 Dec 2020 11:48:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7DF941809C9F;
	Fri, 11 Dec 2020 11:48:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BANJYah023920 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 18:19:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3237010E60D9; Thu, 10 Dec 2020 23:19:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BA0610E60DD
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 23:19:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF7A685828C
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 23:19:30 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-329-lGxV_GEqNxC-ifYTPFFAAg-1;
	Thu, 10 Dec 2020 18:19:26 -0500
X-MC-Unique: lGxV_GEqNxC-ifYTPFFAAg-1
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net
	[162.237.133.238])
	by linux.microsoft.com (Postfix) with ESMTPSA id 41A4820B717A;
	Thu, 10 Dec 2020 15:19:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 41A4820B717A
Date: Thu, 10 Dec 2020 17:19:22 -0600
From: Tyler Hicks <tyhicks@linux.microsoft.com>
To: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <20201210231922.GK489768@sequoia>
References: <20201209194212.5131-1-tusharsu@linux.microsoft.com>
	<20201209194212.5131-7-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <20201209194212.5131-7-tusharsu@linux.microsoft.com>
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
Subject: Re: [dm-devel] [PATCH v7 6/8] IMA: extend critical data hook to
 limit the measurement based on a label
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020-12-09 11:42:10, Tushar Sugandhi wrote:
> The IMA hook ima_measure_critical_data() does not support a way to
> specify the source of the critical data provider. Thus, the data
> measurement cannot be constrained based on the data source label
> in the IMA policy.
> 
> Extend the IMA hook ima_measure_critical_data() to support passing 
> the data source label as an input parameter, so that the policy rule can
> be used to limit the measurements based on the label.
> 
> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>

Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Tyler

> ---
>  include/linux/ima.h               |  6 ++++--
>  security/integrity/ima/ima_main.c | 11 ++++++++---
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 675f54db6264..6434287a81cd 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -30,7 +30,8 @@ extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
>  extern void ima_post_path_mknod(struct dentry *dentry);
>  extern int ima_file_hash(struct file *file, char *buf, size_t buf_size);
>  extern void ima_kexec_cmdline(int kernel_fd, const void *buf, int size);
> -extern void ima_measure_critical_data(const char *event_name,
> +extern void ima_measure_critical_data(const char *event_data_source,
> +				      const char *event_name,
>  				      const void *buf, int buf_len,
>  				      bool measure_buf_hash);
>  
> @@ -125,7 +126,8 @@ static inline int ima_file_hash(struct file *file, char *buf, size_t buf_size)
>  }
>  
>  static inline void ima_kexec_cmdline(int kernel_fd, const void *buf, int size) {}
> -static inline void ima_measure_critical_data(const char *event_name,
> +static inline void ima_measure_critical_data(const char *event_data_source,
> +					     const char *event_name,
>  					     const void *buf, int buf_len,
>  					     bool measure_buf_hash) {}
>  #endif /* CONFIG_IMA */
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index ae59f4a4dd70..7c633901f441 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -924,6 +924,7 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>  
>  /**
>   * ima_measure_critical_data - measure kernel integrity critical data
> + * @event_data_source: kernel data source being measured
>   * @event_name: event name to be used for the buffer entry
>   * @buf: pointer to buffer containing data to measure
>   * @buf_len: length of buffer(in bytes)
> @@ -932,6 +933,9 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>   * Measure the kernel subsystem data, critical to the integrity of the kernel,
>   * into the IMA log and extend the @pcr.
>   *
> + * Use @event_data_source to describe the kernel data source for the buffer
> + * being measured.
> + *
>   * Use @event_name to describe the state/buffer data change.
>   * Examples of critical data (buf) could be kernel in-memory r/o structures,
>   * hash of the memory structures, or data that represents subsystem state
> @@ -944,17 +948,18 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
>   *
>   * The data (buf) can only be measured, not appraised.
>   */
> -void ima_measure_critical_data(const char *event_name,
> +void ima_measure_critical_data(const char *event_data_source,
> +			       const char *event_name,
>  			       const void *buf, int buf_len,
>  			       bool measure_buf_hash)
>  {
> -	if (!event_name || !buf || !buf_len) {
> +	if (!event_name || !event_data_source || !buf || !buf_len) {
>  		pr_err("Invalid arguments passed to %s().\n", __func__);
>  		return;
>  	}
>  
>  	process_buffer_measurement(NULL, buf, buf_len, event_name,
> -				   CRITICAL_DATA, 0, NULL,
> +				   CRITICAL_DATA, 0, event_data_source,
>  				   measure_buf_hash);
>  }
>  
> -- 
> 2.17.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

