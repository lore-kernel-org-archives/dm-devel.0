Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D2BEB64DA
	for <dm-devel@archiver.kernel.org>; Fri,  7 Jul 2023 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688741638;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B+SU9M/cr//g3YATaBbm8tnV90xQMMCki3TuSabtOhE=;
	b=OI0/jAeZw2aCh8+u68+t8qj6xuFi9N0IhdzMNRayU3OhApC6eBwf9fOj3nvnJr7vdDvcqX
	VQhD/kDzOEoKm+o3SbW4H4+PdE7+8JiK4LXMKwAuSbi8+3O+wseAl4vMOMOqHwz84IP/3b
	ZU94gshua9+IsYOCoagk1RLQKYGTSPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-GQFwh78QOCaFI5QWIZXXeg-1; Fri, 07 Jul 2023 10:53:54 -0400
X-MC-Unique: GQFwh78QOCaFI5QWIZXXeg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B0C8830F46;
	Fri,  7 Jul 2023 14:53:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8403200BA8B;
	Fri,  7 Jul 2023 14:53:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A521319465B3;
	Fri,  7 Jul 2023 14:53:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DA13F19465A2
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Jul 2023 14:53:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4511200BA8B; Fri,  7 Jul 2023 14:53:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD2A9200B402
 for <dm-devel@redhat.com>; Fri,  7 Jul 2023 14:53:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F44F873238
 for <dm-devel@redhat.com>; Fri,  7 Jul 2023 14:53:49 +0000 (UTC)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com
 [209.85.222.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-eBwBBgvWMpWjk7cHHuyPRg-1; Fri, 07 Jul 2023 10:53:48 -0400
X-MC-Unique: eBwBBgvWMpWjk7cHHuyPRg-1
Received: by mail-qk1-f171.google.com with SMTP id
 af79cd13be357-7659db6fb4bso151333985a.1
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 07:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688741627; x=1691333627;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=CPovcDx0Jp7p0rxc31G4K4rf+RSfD3YoQjrCZo8Rivs=;
 b=AJvFMVqlwKuCXHWJracgasb/BF+joUKB8ZmizntCsxp5CiYRC7U/SMcHf3iTkFdMHZ
 AAmKS+KodgbZyUL+zcleQxsnygSgAbiYgWyVWzltxSYjPFbOSCN2hCz2GQNSHI74FunI
 6xAMb9/VVTYuB9kTtte3+r0kY9AgE6oRiiZzmhcnzvaFPitDU5L4opYRRY68wB47s+rO
 KE6Fzpcsa0uMVfsy5XvElMMOCmxml4YlLjYSOETxLfrfUA4pGoaCEIksiy3msPgzP9KE
 NgWGEyciDd5w8mms70MLwHFxG0pj7yNpDGQdpM/+SfAJsX75+0irLzBnlf3py0EVBVGq
 ov4g==
X-Gm-Message-State: ABy/qLZH4ukQR+dCJabnxIhKj+WgVCZ/eKFRevToi4tBcBs9YwzMT9tB
 pviNlV6dce/M5zDhYG0KZtjn2UE=
X-Google-Smtp-Source: APBJJlEcjwiB2P+G5P63povz9uFukN13UGlV0N1GEkdF3fsvn89XgwLKb03K3Qu7uI65bbZcCd9ADQ==
X-Received: by 2002:a05:620a:3944:b0:765:44c2:826d with SMTP id
 qs4-20020a05620a394400b0076544c2826dmr6230550qkn.27.1688741627214; 
 Fri, 07 Jul 2023 07:53:47 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m21-20020a05620a13b500b0076219ec1fbesm1900772qki.42.2023.07.07.07.53.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 07:53:46 -0700 (PDT)
Date: Fri, 7 Jul 2023 10:53:45 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Fan Wu <wufan@linux.microsoft.com>
Message-ID: <ZKgm+ffQbdDTxrg9@redhat.com>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [RFC PATCH v10 11/17] dm-verity: consume root hash
 digest and signature data via LSM hook
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 paul@paul-moore.com, dm-devel@redhat.com, corbet@lwn.net,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 roberto.sassu@huawei.com, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 28 2023 at  5:09P -0400,
Fan Wu <wufan@linux.microsoft.com> wrote:

> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> dm-verity provides a strong guarantee of a block device's integrity. As
> a generic way to check the integrity of a block device, it provides
> those integrity guarantees to its higher layers, including the filesystem
> level.
> 
> An LSM that control access to a resource on the system based on the
> available integrity claims can use this transitive property of
> dm-verity, by querying the underlying block_device of a particular
> file.
> 
> The digest and signature information need to be stored in the block
> device to fulfill the next requirement of authorization via LSM policy.
> This will enable the LSM to perform revocation of devices that are still
> mounted, prohibiting execution of files that are no longer authorized
> by the LSM in question.
> 
> This patch added two security hook calls in dm-verity to save the
> dm-verity roothash and the roothash signature to LSM blobs.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---

> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 26adcfea0302..54d46b2f2723 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1440,6 +1453,15 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	ti->per_io_data_size = roundup(ti->per_io_data_size,
>  				       __alignof__(struct dm_verity_io));
>  
> +	root_digest.digest = v->root_digest;
> +	root_digest.digest_len = v->digest_size;
> +	root_digest.algo = v->alg_name;
> +
> +	r = security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME, &root_digest,
> +				      sizeof(root_digest));
> +	if (r)
> +		goto bad;
> +
>  	verity_verify_sig_opts_cleanup(&verify_args);
>  
>  	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> index 4836508ea50c..33165dd7470f 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -9,6 +9,9 @@
>  #include <linux/verification.h>
>  #include <keys/user-type.h>
>  #include <linux/module.h>
> +#include <linux/security.h>
> +#include <linux/dm-verity.h>
> +#include "dm-core.h"

Why are you including dm-core.h here?

>  #include "dm-verity.h"
>  #include "dm-verity-verify-sig.h"
>  
> @@ -97,14 +100,17 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
>   * verify_verify_roothash - Verify the root hash of the verity hash device
>   *			     using builtin trusted keys.
>   *
> + * @bdev: block_device representing the device-mapper created block device.
> + *	  Used by the security hook, to set information about the block_device.
>   * @root_hash: For verity, the roothash/data to be verified.
>   * @root_hash_len: Size of the roothash/data to be verified.
>   * @sig_data: The trusted signature that verifies the roothash/data.
>   * @sig_len: Size of the signature.
>   *
>   */
> -int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> -			    const void *sig_data, size_t sig_len)
> +int verity_verify_root_hash(struct block_device *bdev, const void *root_hash,
> +			    size_t root_hash_len, const void *sig_data,
> +			    size_t sig_len)
>  {
>  	int ret;
>  
> @@ -126,8 +132,12 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
>  				NULL,
>  #endif
>  				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> +	if (ret)
> +		return ret;
>  
> -	return ret;
> +	return security_bdev_setsecurity(bdev,
> +					 DM_VERITY_SIGNATURE_SEC_NAME,
> +					 sig_data, sig_len);
>  }
>  
>  void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)

Both of your calls to security_bdev_setsecurity() to set your blobs in
the bdev are suspect because you're doing so from the verity_ctr().
The mapped_device has 2 dm_table slots (active and inactive).  The
verity_ctr() becomes part of the inactive slot, there is an extra step
to bind the inactive table to the active table.

This leads to you changing the blobs in the global bdev _before_ the
table is actually active.  It is possible that the inactive table will
simply be removed and the DM verity device put back in service;
leaving your blob(s) in the bdev inconsistent.

This issue has parallels to how we need to defer changing the global
queue_limits associated with a request_queue until _after_ all table
loading is settled and then the update is done just before resuming
the DM device (mapped_device) -- see dm_table_set_restrictions().

Unfortunately, this feels like it may require a new hook in the
target_type struct (e.g. ->finalize())

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

