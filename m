Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371F3EB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 16:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687451613;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ChCL/FnrQO2h4jNbo0CXAnoxsnRSzD3O8p8yadJS6RI=;
	b=Jl/DQF0rRfvocD6KNEHs5MfuLzBD4ZvyoVYbdacE25BbN6kLiD3RkWVGk0w8dmgF1Ws9fm
	Y68OJdrQ3FOJsiJOZbyVnV4y5t6phzZeB4glPw5uJY7WpPard6HgG5Qj0HB/qY9Rh/lbee
	jmjhLQxzfXTnBjTtM+8UvS3L3MlmDe0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-sSo_YckyNFOLhH2Gr6YL5A-1; Thu, 22 Jun 2023 12:33:25 -0400
X-MC-Unique: sSo_YckyNFOLhH2Gr6YL5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15F551047C10;
	Thu, 22 Jun 2023 16:28:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CBBAA1402C06;
	Thu, 22 Jun 2023 16:28:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76225194658C;
	Thu, 22 Jun 2023 16:28:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F3241946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 16:28:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC7B9C00049; Thu, 22 Jun 2023 16:28:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E557CC1ED97
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 16:28:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9AF11958B56
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 16:20:57 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-hf90ZxEkMC2qYzrJXEnvvg-1; Thu, 22 Jun 2023 12:20:44 -0400
X-MC-Unique: hf90ZxEkMC2qYzrJXEnvvg-1
Received: by mail-qt1-f170.google.com with SMTP id
 d75a77b69052e-3fde1b83890so61764821cf.2
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 09:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687450842; x=1690042842;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=RU40QciyzSWhXtIKZMMI511TX+2RgRNyBLY22nx/h8U=;
 b=ZJcqpI7U+SlcWlGZL/3QPQ40Pgs7HBwU5hp7Ja/49vTP3Og4f8hIBQTwaW8gViSfRf
 t9K9rCTPGJSHKVGH+UaZMujcBplBY7oKg1n4fL4RD9AqarQuBW01gYgEWE3FyCPYRMbQ
 QuSUG704c8DQL2JcmxUDM6YZEJV9D3o9GRA4k5vqx/6KL6qjZF2O2lTG9gk8OU12FhTG
 aK6z2BKrMk8+ALaV4OG0cdbWSu66zOR7gdGtZMOAU9wmcOlM+I0AB5AHYqWv0w19kkOZ
 3wcYFnDWwFbw0rMoggqjJ931Bp+8HpfbAljMh2OkOJy91NOHjlTOA7C8U5+GJ3VR4A56
 XELA==
X-Gm-Message-State: AC+VfDyyvvyVdMe4oTLs2AkBNrSc/nAlaFnBqsUlCXlHA0bpjHWNQeHu
 2t5o7WHvOkG2OI/iZ7feT7Rxlt4=
X-Google-Smtp-Source: ACHHUZ5ba9c/IqHgawcehKYSiGCA8K/yuVg3Qdf3Vi4r9PxUvm1bIlutOvIe+Bf2i7ztBErrtMPs3A==
X-Received: by 2002:a05:6214:501b:b0:62f:ec06:6c93 with SMTP id
 jo27-20020a056214501b00b0062fec066c93mr12465499qvb.51.1687450842632; 
 Thu, 22 Jun 2023 09:20:42 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a14-20020a0cb34e000000b0062627f71b07sm3944698qvf.125.2023.06.22.09.20.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 09:20:41 -0700 (PDT)
Date: Thu, 22 Jun 2023 12:20:40 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZJR02A79ljoUjbFl@redhat.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-5-demi@invisiblethingslab.com>
MIME-Version: 1.0
In-Reply-To: <20230603145244.1538-5-demi@invisiblethingslab.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 4/6] device-mapper: Avoid double-fetch of
 version
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jun 03 2023 at 10:52P -0400,
Demi Marie Obenour <demi@invisiblethingslab.com> wrote:

> The version is fetched once in check_version(), which then does some
> validation and then overwrites the version in userspace with the API
> version supported by the kernel.  copy_params() then fetches the version
> from userspace *again*, and this time no validation is done.  The result
> is that the kernel's version number is completely controllable by
> userspace, provided that userspace can win a race condition.
> 
> Fix this flaw by not copying the version back to the kernel the second
> time.  This is not exploitable as the version is not further used in the
> kernel.  However, it could become a problem if future patches start
> relying on the version field.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> ---
>  drivers/md/dm-ioctl.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index da6ca26b51d0953df380582bb3a51c2ec22c27cb..7510afe237d979a5ee71afe87a20d49f631de1aa 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1873,30 +1873,33 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
>   * As well as checking the version compatibility this always
>   * copies the kernel interface version out.
>   */
> -static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
> +static int check_version(unsigned int cmd, struct dm_ioctl __user *user,
> +			 struct dm_ioctl *kernel_params)
>  {
> -	uint32_t version[3];
>  	int r = 0;
>  
> -	if (copy_from_user(version, user->version, sizeof(version)))
> +	if (copy_from_user(kernel_params->version, user->version, sizeof(kernel_params->version)))
>  		return -EFAULT;
>  
> -	if ((version[0] != DM_VERSION_MAJOR) ||
> -	    (version[1] > DM_VERSION_MINOR)) {
> +	if ((kernel_params->version[0] != DM_VERSION_MAJOR) ||
> +	    (kernel_params->version[1] > DM_VERSION_MINOR)) {
>  		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
>  		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
>  		      DM_VERSION_PATCHLEVEL,
> -		      version[0], version[1], version[2], cmd);
> +		      kernel_params->version[0],
> +		      kernel_params->version[1],
> +		      kernel_params->version[2],
> +		      cmd);
>  		r = -EINVAL;
>  	}
>  
>  	/*
>  	 * Fill in the kernel version.
>  	 */
> -	version[0] = DM_VERSION_MAJOR;
> -	version[1] = DM_VERSION_MINOR;
> -	version[2] = DM_VERSION_PATCHLEVEL;
> -	if (copy_to_user(user->version, version, sizeof(version)))
> +	kernel_params->version[0] = DM_VERSION_MAJOR;
> +	kernel_params->version[1] = DM_VERSION_MINOR;
> +	kernel_params->version[2] = DM_VERSION_PATCHLEVEL;
> +	if (copy_to_user(user->version, kernel_params->version, sizeof(kernel_params->version)))
>  		return -EFAULT;
>  
>  	return r;
> @@ -1922,7 +1925,10 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
>  	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
>  	unsigned int noio_flag;
>  
> -	if (copy_from_user(param_kernel, user, minimum_data_size))
> +	/* Version has been copied from userspace already, avoid TOCTOU */
> +	if (copy_from_user((char *)param_kernel + sizeof(param_kernel->version),
> +			   (char __user *)user + sizeof(param_kernel->version),
> +			   minimum_data_size - sizeof(param_kernel->version)))
>  		return -EFAULT;
>  
>  	if (param_kernel->data_size < minimum_data_size) {
> @@ -2034,7 +2040,7 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
>  	 * Check the interface version passed in.  This also
>  	 * writes out the kernel's interface version.
>  	 */
> -	r = check_version(cmd, user);
> +	r = check_version(cmd, user, &param_kernel);
>  	if (r)
>  		return r;
>  

I picked this patch up for 6.5, please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.5&id=c71878e9982075eab2e9f6dc5a09ba7b60ac1e24

But FYI, I folded these changes in:

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 526464904fc1..b58a15e212a3 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1838,6 +1838,9 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user,
 {
 	int r = 0;
 
+	/* Make certain version is first member of dm_ioctl struct */
+	BUILD_BUG_ON(offsetof(struct dm_ioctl, version) != 0);
+
 	if (copy_from_user(kernel_params->version, user->version, sizeof(kernel_params->version)))
 		return -EFAULT;
 
@@ -1885,7 +1888,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	const size_t minimum_data_size = offsetof(struct dm_ioctl, data);
 	unsigned int noio_flag;
 
-	/* Version has been copied from userspace already, avoid TOCTOU */
+	/* check_version() already copied version from userspace, avoid TOCTOU */
 	if (copy_from_user((char *)param_kernel + sizeof(param_kernel->version),
 			   (char __user *)user + sizeof(param_kernel->version),
 			   minimum_data_size - sizeof(param_kernel->version)))

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

