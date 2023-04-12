Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E1A7C77B6C
	for <dm-devel@archiver.kernel.org>; Wed, 12 Apr 2023 23:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681342578;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=z25bQkw8tqCs83BT4qFNINmKXrIRP3h9vn+oy62TDeE=;
	b=cnwGbBFnlVDKV3VYPM27FrGctGMbzpQ9dokhdEdYDgfUEY2bTWlar2wpEN2puNwyKOhgok
	Gq6fxUY9RMSjqPFjIOp72a4KrI2RaCZiV15T945rsA0o6gIvAbtW6tyX9mqaNyI3UHZWiY
	5r5A14TkId1Yu5yRaavJDsZ0qkxuwtM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-V3pF5rI2PD2M1xoQgEcyeQ-1; Wed, 12 Apr 2023 19:36:16 -0400
X-MC-Unique: V3pF5rI2PD2M1xoQgEcyeQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 496B0185A791;
	Wed, 12 Apr 2023 23:36:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1CCB40C6E20;
	Wed, 12 Apr 2023 23:36:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8A3C519465A2;
	Wed, 12 Apr 2023 23:36:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A219A19465B3
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Apr 2023 23:36:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 84A542166B2A; Wed, 12 Apr 2023 23:36:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CD652166B29
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 23:36:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EE491010369
 for <dm-devel@redhat.com>; Wed, 12 Apr 2023 23:36:11 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-626-0FAOLYTSPnuUsTMetoyAug-1; Wed,
 12 Apr 2023 19:36:07 -0400
X-MC-Unique: 0FAOLYTSPnuUsTMetoyAug-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 7CD3D21779D8; Wed, 12 Apr 2023 16:36:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7CD3D21779D8
Date: Wed, 12 Apr 2023 16:36:06 -0700
From: Fan Wu <wufan@linux.microsoft.com>
To: Paul Moore <paul@paul-moore.com>
Message-ID: <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [RFC PATCH v9 05/16] ipe: add userspace interface
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
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 11, 2023 at 05:45:41PM -0400, Paul Moore wrote:
> On Mon, Apr 10, 2023 at 3:10???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > On Thu, Mar 02, 2023 at 02:04:42PM -0500, Paul Moore wrote:
> > > On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > > >
> > > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > > >
> > > > As is typical with LSMs, IPE uses securityfs as its interface with
> > > > userspace. for a complete list of the interfaces and the respective
> > > > inputs/outputs, please see the documentation under
> > > > admin-guide/LSM/ipe.rst
> > > >
> > > > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > > > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > >
> > > ...
> > >
> > > > ---
> > > >  security/ipe/Makefile    |   2 +
> > > >  security/ipe/fs.c        | 101 +++++++++
> > > >  security/ipe/fs.h        |  17 ++
> > > >  security/ipe/ipe.c       |   3 +
> > > >  security/ipe/ipe.h       |   2 +
> > > >  security/ipe/policy.c    | 135 ++++++++++++
> > > >  security/ipe/policy.h    |   7 +
> > > >  security/ipe/policy_fs.c | 459 +++++++++++++++++++++++++++++++++++++++
> > > >  8 files changed, 726 insertions(+)
> > > >  create mode 100644 security/ipe/fs.c
> > > >  create mode 100644 security/ipe/fs.h
> > > >  create mode 100644 security/ipe/policy_fs.c
> 
> ...
> 
> > > > +/**
> > > > + * ipe_update_policy - parse a new policy and replace @old with it.
> > > > + * @addr: Supplies a pointer to the i_private for saving policy.
> > > > + * @text: Supplies a pointer to the plain text policy.
> > > > + * @textlen: Supplies the length of @text.
> > > > + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> > > > + * @pkcs7len: Supplies the length of @pkcs7len.
> > > > + *
> > > > + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> > > > + * ipe_new_policy.
> > > > + *
> > > > + * Return:
> > > > + * * !IS_ERR   - OK
> > > > + * * -ENOENT   - Policy doesn't exist
> > > > + * * -EINVAL   - New policy is invalid
> > > > + */
> > > > +struct ipe_policy *ipe_update_policy(struct ipe_policy __rcu **addr,
> > > > +                                    const char *text, size_t textlen,
> > > > +                                    const char *pkcs7, size_t pkcs7len)
> > > > +{
> > > > +       int rc = 0;
> > > > +       struct ipe_policy *old, *new;
> > > > +
> > > > +       old = ipe_get_policy_rcu(*addr);
> > > > +       if (!old) {
> > > > +               rc = -ENOENT;
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> > > > +       if (IS_ERR(new)) {
> > > > +               rc = PTR_ERR(new);
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       if (strcmp(new->parsed->name, old->parsed->name)) {
> > > > +               rc = -EINVAL;
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       if (ver_to_u64(old) > ver_to_u64(new)) {
> > > > +               rc = -EINVAL;
> > > > +               goto err;
> > > > +       }
> > > > +
> > > > +       if (ipe_is_policy_active(old)) {
> > >
> > > I don't understand the is-active check, you want to make @new the new
> > > active policy regardless, right?  Could this is-active check ever be
> > > false?
> >
> > Actually this is needed. Policy updates can be applied to any deployed
> > policy, which may be saved in two places: the securityfs file node
> > and the ipe_active_policy pointer. To update a policy, this function first
> > checks if the policy saved in the securityfs file node is currently active.
> > If so, it updates the ipe_active_policy pointer to point to the new policy,
> > and finally updates the policy pointer in the securityfs to the new policy.
> 
> Ah, okay.  I must have forgotten, or not realized, that multiple
> policies could be loaded and not active.
> 
> I guess this does make me wonder about keeping a non-active policy
> loaded in the kernel, what purpose does that serve?
> 

The non-active policy doesn't serve anything unless it is activated. User can
even delete a policy if that is no longer needed. Non-active is just the default
state when a new policy is loaded.

If IPE supports namespace, there is another use case where different containers
can select different policies as the active policy from among multiple loaded
policies. Deven has presented a demo of this during LSS 2021. But this goes
beyond the scope of this version.

-Fan

> -- 
> paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

