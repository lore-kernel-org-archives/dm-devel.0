Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B43C61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 07:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675669121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/uQc3U6b9Jk9+aEn3WGsKyxG+xbiMvbDawSPfKH66d0=;
	b=LDdMSJCUF8jUtg4YmgSD+rPvCOjshyXqHF+RNDy1xYphIXVy3rQQMTIOkZigW0O0n6Piyt
	ExYsaA6bzGoN/sNez69F8KpiCGvAURsdlNhI/dkU9bqXHtphlb/OpO4kKz1L/Xkjz+/iTK
	6J7CEk4tHQy+oeEQetVfr/S1vIMCUQM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-dGTsBG1rMxq5FkL3g2DM1A-1; Mon, 06 Feb 2023 02:38:38 -0500
X-MC-Unique: dGTsBG1rMxq5FkL3g2DM1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CB75803D53;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 309461121315;
	Mon,  6 Feb 2023 07:38:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A7D319465A3;
	Mon,  6 Feb 2023 07:38:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 788911946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 09:52:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2B3391458890; Thu,  2 Feb 2023 09:52:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 231A9140EBF6
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 09:52:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07EAB1818E4B
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 09:52:48 +0000 (UTC)
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com
 [14.137.139.154]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-338-3xDXk8DgM5-i73nIfIBFGw-1; Thu, 02 Feb 2023 04:52:45 -0500
X-MC-Unique: 3xDXk8DgM5-i73nIfIBFGw-1
Received: from mail02.huawei.com (unknown [172.18.147.229])
 by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4P6v542HK8z9xGXP;
 Thu,  2 Feb 2023 17:44:24 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
 by APP1 (Coremail) with SMTP id LxC2BwDXVwPJh9tj+jnpAA--.15060S2;
 Thu, 02 Feb 2023 10:52:21 +0100 (CET)
Message-ID: <6ddfa7344d01b21a93d3909af9dac0ae5e2a79ee.camel@huaweicloud.com>
From: Roberto Sassu <roberto.sassu@huaweicloud.com>
To: Fan Wu <wufan@linux.microsoft.com>
Date: Thu, 02 Feb 2023 10:51:56 +0100
In-Reply-To: <20230201235031.GC9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
 <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
 <20230201235031.GC9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
User-Agent: Evolution 3.36.5-0ubuntu1
MIME-Version: 1.0
X-CM-TRANSID: LxC2BwDXVwPJh9tj+jnpAA--.15060S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF1Dtry3CFyxuFWkCr4fAFb_yoW5JryfpF
 WFkF48KrZ0qF17KF10y3W8Xw1akrWxKay7urn8uwn7Was5Zr9rtr1IyFWUWFn8CFy8ZryY
 qF42yF15Z3s8AFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
 AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
 x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
 0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
 64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
 8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
 2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
 xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
 c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAQBF1jj4hv0wAAsQ
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 06 Feb 2023 07:38:31 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2023-02-01 at 15:50 -0800, Fan Wu wrote:
> On Tue, Jan 31, 2023 at 03:00:08PM +0100, Roberto Sassu wrote:
> > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > +/**
> > > + * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
> > > + * @ctx: Supplies a pointer to the context being evaluated.
> > > + * @p: Supplies a pointer to the property being evaluated.
> > > + *
> > > + * Return:
> > > + * * true	- The current @ctx match the @p
> > > + * * false	- The current @ctx doesn't match the @p
> > > + */
> > > +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> > > +				   struct ipe_prop *p)
> > > +{
> > > +	return !ctx->ino ||
> > > +	       !IS_VERITY(ctx->ino) ||
> > > +	       !ctx->ipe_inode ||
> > > +	       !ctx->ipe_inode->fs_verity_signed;
> > > +}
> > > +
> > > +/**
> > > + * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
> > > + * @ctx: Supplies a pointer to the context being evaluated.
> > > + * @p: Supplies a pointer to the property being evaluated.
> > > + *
> > > + * Return:
> > > + * * true - The current @ctx match the @p
> > > + * * false - The current @ctx doesn't match the @p
> > > + */
> > > +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> > > +				  struct ipe_prop *p)
> > > +{
> > > +	return ctx->ino &&
> > > +	       IS_VERITY(ctx->ino) &&
> > > +	       ctx->ipe_inode &&
> > > +	       ctx->ipe_inode->fs_verity_signed;
> > > +}
> > 
> > Isn't better to just define one function and prepend a ! in
> > evaluate_property()?
> Yes that's a better way to do it, I will take this idea.
> 
> > Not sure about the usefulness of the fsverity_signature= property as it
> > is. I would at minimum allow to specify which keyring signatures are
> > verified against, and ensure that the keyring has a restriction.
> > 
> > And maybe I would call fsverity_verify_signature() directly, after
> > extending it to pass the desired keyring.
> > 
> Thanks for the suggestion.
> For the initial version we only have the fsverity_signature property
> to enable the policy can make decision based on the existence of the
> signature. In the future we plan to add more properties to leverage
> the remaining signature information so we can have the restrictions
> you mentioned.

Uhm, these boolean properties feel like something is missing. In my
opinion, one cannot accept just any signature, but should be able to
specify the approved signers.

Roberto

> -Fan
> 
> > I would also split this patch in two, one for fsverity_digest= and one
> > for fsverity_signature=.
> > 
> > Roberto

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

