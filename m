Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D0E7C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 23:51:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 96A1361130
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 23:51:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 96A1361130
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Xo_UaYeWMQC7vzFjl9TNiA-1; Wed, 13 Oct 2021 19:51:48 -0400
X-MC-Unique: Xo_UaYeWMQC7vzFjl9TNiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1D0A10A8E00;
	Wed, 13 Oct 2021 23:51:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A2C35DA60;
	Wed, 13 Oct 2021 23:51:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A46EE180598A;
	Wed, 13 Oct 2021 23:51:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DNpa8G008593 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 19:51:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DDAC46D9F4; Wed, 13 Oct 2021 23:51:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D43D36E1AA
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 23:51:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A06C899EC1
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 23:51:34 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-455-XVaiJGDeNKa1qxzr64bB-Q-1; Wed, 13 Oct 2021 19:51:30 -0400
X-MC-Unique: XVaiJGDeNKa1qxzr64bB-Q-1
Received: from [2601:1c0:6280:3f0::aa0b]
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1man8o-000wgr-2f; Wed, 13 Oct 2021 22:54:30 +0000
To: deven.desai@linux.microsoft.com, corbet@lwn.net, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu, 
	paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
Date: Wed, 13 Oct 2021 15:54:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	jannh@google.com, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-audit@redhat.com
Subject: Re: [dm-devel] [RFC PATCH v7 07/16] ipe: add auditing support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi,

On 10/13/21 12:06 PM, deven.desai@linux.microsoft.com wrote:
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index c4503083e92d..ef556b66e674 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -17,3 +17,55 @@ menuconfig SECURITY_IPE
>   	  requirements on the fly.
>   
>   	  If unsure, answer N.
> +
> +if SECURITY_IPE
> +
> +choice
> +	prompt "Hash algorithm used in auditing policies"
> +	default IPE_AUDIT_HASH_SHA1
> +	depends on AUDIT
> +	help
> +		Specify the hash algorithm used when auditing policies.
> +		The hash is used to uniquely identify a policy from other
> +		policies on the system.
> +
> +		If unsure, leave default.
> +
> +	config IPE_AUDIT_HASH_SHA1
> +		bool "sha1"
> +		depends on CRYPTO_SHA1
> +		help
> +			Use the SHA128 algorithm to hash policies
> +			in the audit records.
> +
> +	config IPE_AUDIT_HASH_SHA256
> +		bool "sha256"
> +		depends on CRYPTO_SHA256
> +		help
> +			Use the SHA256 algorithm to hash policies
> +			in the audit records.
> +
> +	config IPE_AUDIT_HASH_SHA384
> +		bool "sha384"
> +		depends on CRYPTO_SHA512
> +		help
> +			Use the SHA384 algorithm to hash policies
> +			in the audit records
> +
> +	config IPE_AUDIT_HASH_SHA512
> +		bool "sha512"
> +		depends on CRYPTO_SHA512
> +		help
> +			Use the SHA512 algorithm to hash policies
> +			in the audit records
> +endchoice
> +
> +config IPE_AUDIT_HASH_ALG
> +	string
> +	depends on AUDIT
> +	default "sha1" if IPE_AUDIT_HASH_SHA1
> +	default "sha256" if IPE_AUDIT_HASH_SHA256
> +	default "sha384" if IPE_AUDIT_HASH_SHA384
> +	default "sha512" if IPE_AUDIT_HASH_SHA512
> +
> +endif

Please follow coding-style for Kconfig files:

(from Documentation/process/coding-style.rst, section 10):

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.


thanks.
-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

