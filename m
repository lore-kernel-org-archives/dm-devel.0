Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B15C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:24:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D174E611C2
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:24:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D174E611C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-hBB3nlp-PJmrV2pRC6UThw-1; Wed, 13 Oct 2021 15:24:29 -0400
X-MC-Unique: hBB3nlp-PJmrV2pRC6UThw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2D281006AA5;
	Wed, 13 Oct 2021 19:24:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C5475F4F6;
	Wed, 13 Oct 2021 19:24:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E49704EA2A;
	Wed, 13 Oct 2021 19:24:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJOMKX019798 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:24:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1523D40CFD11; Wed, 13 Oct 2021 19:24:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FE4440CFD10
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:24:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E69E41066558
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:24:21 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-363-uHRsFnccMEaT6uBoy0VKPg-1;
	Wed, 13 Oct 2021 15:24:20 -0400
X-MC-Unique: uHRsFnccMEaT6uBoy0VKPg-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1509C61165;
	Wed, 13 Oct 2021 19:24:18 +0000 (UTC)
Date: Wed, 13 Oct 2021 12:24:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: deven.desai@linux.microsoft.com
Message-ID: <YWcyYBuNppjrVOe2@gmail.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-security-module@vger.kernel.org, tytso@mit.edu,
	paul@paul-moore.com, snitzer@redhat.com, corbet@lwn.net,
	jannh@google.com, linux-doc@vger.kernel.org, jmorris@namei.org,
	eparis@redhat.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-audit@redhat.com, linux-fscrypt@vger.kernel.org,
	agk@redhat.com, serge@hallyn.com
Subject: Re: [dm-devel] [RFC PATCH v7 12/16] fsverity|security: add security
 hooks to fsverity digest and signature
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 13, 2021 at 12:06:31PM -0700, deven.desai@linux.microsoft.com wrote:
> From: Fan Wu <wufan@linux.microsoft.com>
> 
> Add security_inode_setsecurity to fsverity signature verification.
> This can let LSMs save the signature data and digest hashes provided
> by fsverity.

Can you elaborate on why LSMs need this information?

> 
> Also changes the implementaion inside the hook function to let
> multiple LSMs can add hooks.

Please split fs/verity/ changes and security/ changes into separate patches, if
possible.

> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

> @@ -177,6 +178,17 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>  		fsverity_err(inode, "Error %d computing file digest", err);
>  		goto out;
>  	}
> +
> +	err = security_inode_setsecurity((struct inode *)inode,

If a non-const inode is needed, please propagate that into the callers rather
than randomly casting away the const.

> +					 FS_VERITY_DIGEST_SEC_NAME,
> +					 vi->file_digest,
> +					 vi->tree_params.hash_alg->digest_size,
> +					 0);

The digest isn't meaningful without knowing the hash algorithm it uses.
It's available here, but you aren't passing it to this function.

> @@ -84,7 +85,9 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
>  
>  	pr_debug("Valid signature for file digest %s:%*phN\n",
>  		 hash_alg->name, hash_alg->digest_size, vi->file_digest);
> -	return 0;
> +	return security_inode_setsecurity((struct inode *)inode,

Likewise, please don't cast away const.

> +					FS_VERITY_SIGNATURE_SEC_NAME,
> +					signature, sig_size, 0);

This is only for fs-verity built-in signatures which aren't the only way to do
signatures with fs-verity.  Are you sure this is what you're looking for?  Can
you elaborate on your use case for fs-verity built-in signatures, and what the
LSM hook will do with them?

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

