Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F055438BB4
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UINcbbw5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698356241;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MXajQCd4F/1lAfqXs9yFErTqS9iveL7bqi06E72Hzxw=;
	b=UINcbbw5xdBF4bZJPErjn2RMbpkKoDWxJYMOVz2Opfatg+Os12Fm3C7Zu9JkXp843c8kgH
	UbN5s67WkVN0tMp67JmflD9nBfVRd4Q5RqDVsgrlhzlOyDSiQi5XU+8Id8n0oXHc8yonsK
	qfZQePwA+GgZ3pcJszOQn6rU5jKvkXs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-CxJo3SRgM8yVwIxld8f-7A-1; Thu, 26 Oct 2023 17:37:20 -0400
X-MC-Unique: CxJo3SRgM8yVwIxld8f-7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3460080F927
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:37:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2B1FB40C6F79
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:37:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DBFB51946595
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 21:37:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 41F73194658C
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 Oct 2023 21:37:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EB2C81121319; Thu, 26 Oct 2023 21:37:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E318F1121320
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 21:37:17 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2FD428237CD
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 21:37:17 +0000 (UTC)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com
 [209.85.219.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-0Aci9yABO--DgUq9dR0JbA-1; Thu, 26 Oct 2023 17:37:10 -0400
X-MC-Unique: 0Aci9yABO--DgUq9dR0JbA-1
Received: by mail-yb1-f177.google.com with SMTP id
 3f1490d57ef6-d9a58f5f33dso1022765276.1
 for <dm-devel@redhat.com>; Thu, 26 Oct 2023 14:37:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1698356230; x=1698961030;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=MXajQCd4F/1lAfqXs9yFErTqS9iveL7bqi06E72Hzxw=;
 b=CZ9OdE/EZmv6+dhltOCOIKa3nzmEzazndvnRWTxW28f9PiFsrDYa+Mz/nhX0I5/Rbm
 AzKE44YRnVndPVsl+eVeLJ4bypsvCnXxF/LLhz1sav4kgthi6n2AmkIGsDHSsTGwYR/C
 vB+5VYLPdnkG9d82T/DxLGAnkqDZT+YSBbpcc4rS3aDyrnVLJ7wQkJo1qoKZve7sOTUI
 I9+HcJclXW0eduo50rKcpS6ULEBNeQgShCtYmcjrOYY+1KiMJUsN/3QihITqs7CfsNwC
 fl3GMjgl0HnjB3ediQ/VvJLOeFGHlw7p9HowV78KDxlcwLBiCwbXSpQVjp/xIiS3ZFod
 BFEQ==
X-Gm-Message-State: AOJu0Yzd5JI6tiJP9MWHZ3qiAEcyULWIIUUnwv7dyL9d+H2FflwY657W
 k7Xpdr1vsPXQFDuoPwPzuaXXTGM18PNDZuTMHc+Q
X-Google-Smtp-Source: AGHT+IGs3yVweOLen1m7MhCJB6RbgNFPe23s8osYedKaob9va7EUB7gQ3SlX41xgxocwXKE4pusvmi6cSAkHebq1bDk=
X-Received: by 2002:a25:238e:0:b0:da1:2a2b:4c5b with SMTP id
 j136-20020a25238e000000b00da12a2b4c5bmr342821ybj.41.1698356230039; Thu, 26
 Oct 2023 14:37:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
 <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com>
 <594923f6-6942-4b4b-8ca1-b9dcf74c9c1c@linux.microsoft.com>
In-Reply-To: <594923f6-6942-4b4b-8ca1-b9dcf74c9c1c@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 26 Oct 2023 17:36:59 -0400
Message-ID: <CAHC9VhQv5xBtG9zVk_rpNmQ=GLm9sitxeyqbwkw=LmHAN0Su3g@mail.gmail.com>
Subject: Re: [PATCH RFC v11 2/19] ipe: add policy parser
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 6:46=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On 10/23/2023 8:52 PM, Paul Moore wrote:
> > On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> >>
> >> IPE's interpretation of the what the user trusts is accomplished throu=
gh
> >> its policy. IPE's design is to not provide support for a single trust
> >> provider, but to support multiple providers to enable the end-user to
> >> choose the best one to seek their needs.
> >>
> >> This requires the policy to be rather flexible and modular so that
> >> integrity providers, like fs-verity, dm-verity, dm-integrity, or
> >> some other system, can plug into the policy with minimal code changes.
> >>
> >> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> >> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ...
> >> ---
> >>   security/ipe/Makefile        |   2 +
> >>   security/ipe/policy.c        | 101 ++++++++
> >>   security/ipe/policy.h        |  83 ++++++
> >>   security/ipe/policy_parser.c | 487 +++++++++++++++++++++++++++++++++=
++
> >>   security/ipe/policy_parser.h |  11 +
> >>   5 files changed, 684 insertions(+)
> >>   create mode 100644 security/ipe/policy.c
> >>   create mode 100644 security/ipe/policy.h
> >>   create mode 100644 security/ipe/policy_parser.c
> >>   create mode 100644 security/ipe/policy_parser.h
> >
> > ...
> >
> >> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> >> new file mode 100644
> >> index 000000000000..3a529c7950a1
> >> --- /dev/null
> >> +++ b/security/ipe/policy.c
> >> @@ -0,0 +1,101 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (C) Microsoft Corporation. All rights reserved.
> >> + */
> >
> > ...
> >
> >> +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> >> +                      size_t asn1hdrlen)
> >> +{
> >> +    struct ipe_policy *p =3D ctx;
> >> +
> >> +    p->text =3D (const char *)data;
> >> +    p->textlen =3D len;
> >> +
> >> +    return 0;
> >> +}
> >
> > The @asn1hdrlen parameter isn't used in this function, at least at this
> > point in the patchset, so you really should remove it.  If it is needed
> > later in the patchset you can always update the function.
>
> Although the @asn1hdrlen is not used, it's a required parameter for the
> pkcs7 callback. I guess adding a __always_unused might be the right
> solution?

Ah gotcha, I'm sorry for the noise, I obviously didn't catch that.  As
for the __always_unused marking, yes, that's probably a good idea.

> >> +/**
> >> + * parse_rule - parse a policy rule line.
> >> + * @line: Supplies rule line to be parsed.
> >> + * @p: Supplies the partial parsed policy.
> >> + *
> >> + * Return:
> >> + * * !IS_ERR        - OK
> >> + * * -ENOMEM        - Out of memory
> >> + * * -EBADMSG       - Policy syntax error
> >> + */
> >> +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> >> +{
> >> +    int rc =3D 0;
> >> +    bool first_token =3D true, is_default_rule =3D false;
> >> +    bool op_parsed =3D false;
> >> +    enum ipe_op_type op =3D IPE_OP_INVALID;
> >> +    enum ipe_action_type action =3D IPE_ACTION_INVALID;
> >> +    struct ipe_rule *r =3D NULL;
> >> +    char *t;
> >> +
> >> +    r =3D kzalloc(sizeof(*r), GFP_KERNEL);
> >> +    if (!r)
> >> +            return -ENOMEM;
> >> +
> >> +    INIT_LIST_HEAD(&r->next);
> >> +    INIT_LIST_HEAD(&r->props);
> >> +
> >> +    while (t =3D strsep(&line, IPE_POLICY_DELIM), line) {
> >> +            if (*t =3D=3D '\0')
> >> +                    continue;
> >> +            if (first_token && token_default(t)) {
> >> +                    is_default_rule =3D true;
> >> +            } else {
> >> +                    if (!op_parsed) {
> >> +                            op =3D parse_operation(t);
> >> +                            if (op =3D=3D IPE_OP_INVALID)
> >> +                                    rc =3D -EBADMSG;
> >> +                            else
> >> +                                    op_parsed =3D true;
> >> +                    } else {
> >> +                            rc =3D parse_property(t, r);
> >> +                    }
> >> +            }
> >> +
> >> +            if (rc)
> >> +                    goto err;
> >> +            first_token =3D false;
> >> +    }
> >> +
> >> +    action =3D parse_action(t);
> >> +    if (action =3D=3D IPE_ACTION_INVALID) {
> >> +            rc =3D -EBADMSG;
> >> +            goto err;
> >> +    }
> >> +
> >> +    if (is_default_rule) {
> >> +            if (!list_empty(&r->props)) {
> >> +                    rc =3D -EBADMSG;
> >> +            } else if (op =3D=3D IPE_OP_INVALID) {
> >> +                    if (p->global_default_action !=3D IPE_ACTION_INVA=
LID)
> >> +                            rc =3D -EBADMSG;
> >> +                    else
> >> +                            p->global_default_action =3D action;
> >> +            } else {
> >> +                    if (p->rules[op].default_action !=3D IPE_ACTION_I=
NVALID)
> >> +                            rc =3D -EBADMSG;
> >> +                    else
> >> +                            p->rules[op].default_action =3D action;
> >> +            }
> >> +    } else if (op !=3D IPE_OP_INVALID && action !=3D IPE_ACTION_INVAL=
ID) {
> >> +            r->op =3D op;
> >> +            r->action =3D action;
> >> +    } else {
> >> +            rc =3D -EBADMSG;
> >> +    }
> >
> > I might be missing something important in the policy syntac, but could
> > this function, and perhaps the ipe_parsed_policy struct, be simplified
> > if the default action was an explicit rule?
> >
> >   "op=3DDEFAULT action=3DALLOW"
>
> The complexity here arises from our need for two types of default rules:
> one for global settings and another for operation-specific settings.
>
> To illustrate the flexibility of operation-specific default rules, users
> can set their policy to have a default rule of 'DENY' for execution,
> meaning all execution actions are prohibited by default. This let users
> to create an allow-list for execution. At the same time, the default
> rule for read can be set to 'ALLOW'.  This let users to create an
> deny-list for read.
>
> Adding explicit default rules can simplify ipe_parsed_policy struct, but
> that impose a burden on users that requires users always add the default
> rules the end of the policy. In contrast, our current design allows
> users to place the default rule anywhere in the policy. In practice, we
> often position the default rule at the beginning of the policy, which
> makes it more convenient for users to add new rules.

Okay, thanks for the explanation.

> >> +/**
> >> + * free_parsed_policy - free a parsed policy structure.
> >> + * @p: Supplies the parsed policy.
> >> + */
> >> +void free_parsed_policy(struct ipe_parsed_policy *p)
> >> +{
> >> +    size_t i =3D 0;
> >> +    struct ipe_rule *pp, *t;
> >> +
> >> +    if (IS_ERR_OR_NULL(p))
> >> +            return;
> >> +
> >> +    for (i =3D 0; i < ARRAY_SIZE(p->rules); ++i)
> >> +            list_for_each_entry_safe(pp, t, &p->rules[i].rules, next)=
 {
> >> +                    list_del(&pp->next);
> >> +                    free_rule(pp);
> >> +            }
> >> +
> >> +    kfree(p->name);
> >> +    kfree(p);
> >> +}
> >> +
> >> +/**
> >> + * validate_policy - validate a parsed policy.
> >> + * @p: Supplies the fully parsed policy.
> >> + *
> >> + * Given a policy structure that was just parsed, validate that all
> >> + * necessary fields are present, initialized correctly.
> >> + *
> >> + * A parsed policy can be in an invalid state for use (a default was
> >> + * undefined) by just parsing the policy.
> >> + *
> >> + * Return:
> >> + * * 0              - OK
> >> + * * -EBADMSG       - Policy is invalid
> >> + */
> >> +static int validate_policy(const struct ipe_parsed_policy *p)
> >> +{
> >> +    size_t i =3D 0;
> >> +
> >> +    if (p->global_default_action !=3D IPE_ACTION_INVALID)
> >> +            return 0;
> >
> > Should the if conditional above be "=3D=3D" and not "!=3D"?
>
> >No, "!=3D" is the correct one.
>
> The purpose of validation is to ensure that we have enough default rules
> to cover all cases. If the global default action not invalid, it means
> we have a global default rule in the policy to cover all cases, thus we
> simply return 0.
>
> However, if there is no global default rule, then we need to ensure that
> for each operation, there is a operation specific default rule, this is
> validated in the for loop below.

Makes sense, thanks.

--=20
paul-moore.com

