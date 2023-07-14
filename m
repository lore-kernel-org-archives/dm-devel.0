Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3ACEB64DC
	for <dm-devel@archiver.kernel.org>; Fri, 14 Jul 2023 23:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689379030;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E40AaAU3YpKOdQgtAENr7ymRuFaAjSabduFk9geStHY=;
	b=X9QFXqv9+afcm950AX/+zhwjq3sHvCrBOwESsj/Z5TkNoNJjkNMPKNebKwzVSZvuWEWX99
	MYvrFlu4nuH3keugGXj/U3HUaKNCdIdBPI4aj3B2hZhePBXTy/alS/Hp+EYtnn1C2Rnbn4
	b+d7TAe2AOp6pfL2dhbHegEhO0PeaJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-5zeOUR88NcaVTA1iNq0m0w-1; Fri, 14 Jul 2023 19:57:07 -0400
X-MC-Unique: 5zeOUR88NcaVTA1iNq0m0w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD8CE185A78B;
	Fri, 14 Jul 2023 23:57:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62F21200A7CA;
	Fri, 14 Jul 2023 23:57:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 24A75194658F;
	Fri, 14 Jul 2023 23:57:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F79C1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 14 Jul 2023 23:57:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CE675C2C857; Fri, 14 Jul 2023 23:57:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C57B1C2C856
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 23:57:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A958B3C0C4AC
 for <dm-devel@redhat.com>; Fri, 14 Jul 2023 23:57:01 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-56-7rj7PiwvMEuExUfPjQmgxg-1; Fri,
 14 Jul 2023 19:56:58 -0400
X-MC-Unique: 7rj7PiwvMEuExUfPjQmgxg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 7335221C4688; Fri, 14 Jul 2023 16:56:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7335221C4688
Date: Fri, 14 Jul 2023 16:56:56 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230714235656.GD15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-6-git-send-email-wufan@linux.microsoft.com>
 <7b0f16fd49fb3490af1018eba986d0e4.paul@paul-moore.com>
MIME-Version: 1.0
In-Reply-To: <7b0f16fd49fb3490af1018eba986d0e4.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH RFC v10 5/17] ipe: introduce 'boot_verified'
 as a trust provider
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
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 08, 2023 at 12:23:02AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE is designed to provide system level trust guarantees, this usually
> > implies that trust starts from bootup with a hardware root of trust,
> > which validates the bootloader. After this, the bootloader verifies the
> > kernel and the initramfs.
> > 
> > As there's no currently supported integrity method for initramfs, and
> > it's typically already verified by the bootloader, introduce a property
> > that causes the first superblock to have an execution to be "pinned",
> > which is typically initramfs.
> > 
> > When the "pinned" device is unmounted, it will be "unpinned" and
> > `boot_verified` property will always evaluate to false afterward.
> > 
> > We use a pointer with a spin_lock to "pin" the device instead of rcu
> > because rcu synchronization may sleep, which is not allowed when
> > unmounting a device.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
> >  security/ipe/eval.h          |  2 +
> >  security/ipe/hooks.c         | 12 ++++++
> >  security/ipe/hooks.h         |  2 +
> >  security/ipe/ipe.c           |  1 +
> >  security/ipe/policy.h        |  2 +
> >  security/ipe/policy_parser.c | 37 +++++++++++++++++-
> >  7 files changed, 126 insertions(+), 2 deletions(-)
> 
> The compilation errors continue into this patch.
> 
Sorry again for the header file problem.

> > diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> > index 27e5767480b0..28c14adfe6d2 100644
> > --- a/security/ipe/policy_parser.c
> > +++ b/security/ipe/policy_parser.c
> > @@ -265,6 +265,12 @@ static enum ipe_action_type parse_action(char *t)
> >  	return match_token(t, action_tokens, args);
> >  }
> >  
> > +static const match_table_t property_tokens = {
> > +	{__IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
> > +	{__IPE_PROP_BOOT_VERIFIED_TRUE,		"boot_verified=TRUE"},
> > +	{__IPE_PROP_INVALID,			NULL}
> > +};
> > +
> >  /**
> >   * parse_property - Parse the property type given a token string.
> >   * @t: Supplies the token string to be parsed.
> > @@ -277,7 +283,36 @@ static enum ipe_action_type parse_action(char *t)
> >   */
> >  static int parse_property(char *t, struct ipe_rule *r)
> >  {
> > -	return -EBADMSG;
> > +	substring_t args[MAX_OPT_ARGS];
> > +	struct ipe_prop *p = NULL;
> > +	int rc = 0;
> > +	int token;
> > +
> > +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> > +	if (!p)
> > +		return -ENOMEM;
> > +
> > +	token = match_token(t, property_tokens, args);
> > +
> > +	switch (token) {
> > +	case __IPE_PROP_BOOT_VERIFIED_FALSE:
> > +	case __IPE_PROP_BOOT_VERIFIED_TRUE:
> > +		p->type = token;
> > +		break;
> > +	case __IPE_PROP_INVALID:
> 
> You generally don't need to explicitly specify a case if the code
> immediately falls through to 'default'.
> 
Got it, I will remove this line.

> > +	default:
> > +		rc = -EBADMSG;
> > +		break;
> > +	}
> > +	if (rc)
> > +		goto err;
> > +	list_add_tail(&p->next, &r->props);
> > +
> > +out:
> > +	return rc;
> > +err:
> > +	kfree(p);
> > +	goto out;
> 
> Once again, don't use a goto when the jump destination simply does a
> return, do the return directly.
> 
Sure, I will replace the goto with return.

-Fan
> >  }
> >  
> >  /**
> > -- 
> > 2.25.1
> 
> --
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

