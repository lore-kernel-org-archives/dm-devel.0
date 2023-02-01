Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C95C636D4
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 23:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675295445;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j2veBdmhAx6Ua7PQgL0qxAnjQyPd5rTanwv4ZffB+Cg=;
	b=KsHLHrO3gG5Py65LcnCTiMd7SOuYv6PfjwZxHPSLbIfOjpdgQIw5B5XHWR7mQ/FP8GqrZ6
	QUuuZQfiQna1O9t7/lrMMojjCsfZGHrOzt1DMc06pniVI+iz0ceaq/4xEHfteQU6BOIv8Y
	vZlTk7Ob39T2FmdZEhkdBWEIivuwMCg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-dKwVlKOXPJW8XSg-exoR0Q-1; Wed, 01 Feb 2023 18:50:44 -0500
X-MC-Unique: dKwVlKOXPJW8XSg-exoR0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 751FC3823A0C;
	Wed,  1 Feb 2023 23:50:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1D1E5C15BA0;
	Wed,  1 Feb 2023 23:50:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C82A619465B1;
	Wed,  1 Feb 2023 23:50:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 428F7194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 23:50:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 226F04047024; Wed,  1 Feb 2023 23:50:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A2364047022
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 23:50:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F31D33C025CD
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 23:50:39 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-80-Bz3GMnGCPnGJDTxjMBDWQQ-1; Wed,
 01 Feb 2023 18:50:33 -0500
X-MC-Unique: Bz3GMnGCPnGJDTxjMBDWQQ-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id BDF7320B74F7; Wed,  1 Feb 2023 15:50:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BDF7320B74F7
Date: Wed, 1 Feb 2023 15:50:31 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-ID: <20230201235031.GC9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
 <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH v9 13/16] ipe: enable support for
 fs-verity as a trust provider
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
 roberto.sassu@huawei.com, Deven Bowers <deven.desai@linux.microsoft.com>,
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 31, 2023 at 03:00:08PM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > +/**
> > + * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
> > + * @ctx: Supplies a pointer to the context being evaluated.
> > + * @p: Supplies a pointer to the property being evaluated.
> > + *
> > + * Return:
> > + * * true	- The current @ctx match the @p
> > + * * false	- The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> > +				   struct ipe_prop *p)
> > +{
> > +	return !ctx->ino ||
> > +	       !IS_VERITY(ctx->ino) ||
> > +	       !ctx->ipe_inode ||
> > +	       !ctx->ipe_inode->fs_verity_signed;
> > +}
> > +
> > +/**
> > + * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
> > + * @ctx: Supplies a pointer to the context being evaluated.
> > + * @p: Supplies a pointer to the property being evaluated.
> > + *
> > + * Return:
> > + * * true - The current @ctx match the @p
> > + * * false - The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> > +				  struct ipe_prop *p)
> > +{
> > +	return ctx->ino &&
> > +	       IS_VERITY(ctx->ino) &&
> > +	       ctx->ipe_inode &&
> > +	       ctx->ipe_inode->fs_verity_signed;
> > +}
> 
> Isn't better to just define one function and prepend a ! in
> evaluate_property()?
Yes that's a better way to do it, I will take this idea.

> 
> Not sure about the usefulness of the fsverity_signature= property as it
> is. I would at minimum allow to specify which keyring signatures are
> verified against, and ensure that the keyring has a restriction.
> 
> And maybe I would call fsverity_verify_signature() directly, after
> extending it to pass the desired keyring.
> 
Thanks for the suggestion.
For the initial version we only have the fsverity_signature property
to enable the policy can make decision based on the existence of the
signature. In the future we plan to add more properties to leverage
the remaining signature information so we can have the restrictions
you mentioned.

-Fan

> I would also split this patch in two, one for fsverity_digest= and one
> for fsverity_signature=.
> 
> Roberto

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

