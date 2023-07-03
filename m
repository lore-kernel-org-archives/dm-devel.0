Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E444AEB64DC
	for <dm-devel@archiver.kernel.org>; Mon,  3 Jul 2023 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688397324;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3Ut/mRo4XRbZ40lhuH58vOcTqQyPNbMAE7thmJlkMbk=;
	b=DCE8r8APwM2irlmrRrozxPZ3JPCbi+FAB+2RZHI7IIvxwSD6YY7/tsOAOaZEVIlDTD8N+B
	QalEr4NYqAUDIFirlLsVHHS/iKNpw/AXv40AtofFP9QVTzVAmkTxg4RXfJ3XKYh13ZTl/v
	7vPM9AOl8CaCCE1g7H5InkOLinoAqhM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-1Hviwa0gNsGQ8UgqbzotWA-1; Mon, 03 Jul 2023 11:15:21 -0400
X-MC-Unique: 1Hviwa0gNsGQ8UgqbzotWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68DEC380670E;
	Mon,  3 Jul 2023 15:15:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57DEFC00049;
	Mon,  3 Jul 2023 15:15:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1FF261946588;
	Mon,  3 Jul 2023 15:15:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D44881946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  3 Jul 2023 15:15:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AF1CD4087C6B; Mon,  3 Jul 2023 15:15:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A89D44087C6A
 for <dm-devel@redhat.com>; Mon,  3 Jul 2023 15:15:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B1B5101A529
 for <dm-devel@redhat.com>; Mon,  3 Jul 2023 15:15:17 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-rKJHI7E8M4m0xwiPfQbHSw-1; Mon,
 03 Jul 2023 11:15:14 -0400
X-MC-Unique: rKJHI7E8M4m0xwiPfQbHSw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id DC09C1FEE4;
 Mon,  3 Jul 2023 15:15:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BA2131358E;
 Mon,  3 Jul 2023 15:15:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id J4z0KwDmomTUVwAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 03 Jul 2023 15:15:12 +0000
Message-ID: <7a04a8f1517973886f7c37fdbb16373679baed40.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 03 Jul 2023 17:15:12 +0200
In-Reply-To: <20230630221652.GF7412@octiron.msp.redhat.com>
References: <20230630181407.14302-1-mwilck@suse.com>
 <20230630221652.GF7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.3
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] libmultipath: ignore nvme devices if nvme
 native multipath is enabled
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-06-30 at 17:16 -0500, Benjamin Marzinski wrote:
> On Fri, Jun 30, 2023 at 08:14:07PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > If the nvme native multipath driver is enabled, blacklist nvme
> > devices
> > for dm-multipath by default. This is particularly useful with
> > "find_multipaths greedy".
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
>=20
> This looks good. I have two small questions below.
>=20
> > ---
> > =A0libmultipath/blacklist.c | 35 ++++++++++++++++++++++++++++++++---
> > =A0tests/blacklist.c=A0=A0=A0=A0=A0=A0=A0 | 30 ++++++++++++++++++++++++=
++++--
> > =A02 files changed, 60 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> > index 8d15d2e..75100b2 100644
> > --- a/libmultipath/blacklist.c
> > +++ b/libmultipath/blacklist.c
> > @@ -2,6 +2,8 @@
> > =A0 * Copyright (c) 2004, 2005 Christophe Varoqui
> > =A0 */
> > =A0#include <stdio.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > =A0#include <libudev.h>
> > =A0
> > =A0#include "checkers.h"
> > @@ -191,6 +193,27 @@ find_blacklist_device (const struct _vector
> > *blist, const char *vendor,
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > +/*
> > + * Test if nvme native multipath is enabled. If the sysfs file
> > can't
> > + * be accessed, multipath is either disabled at compile time, or
> > no
> > + * nvme driver is loaded at all. Thus treat errors as "no".
> > + */
> > +static bool nvme_multipath_enabled(void)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0static const char fn[] =3D
> > "/sys/module/nvme_core/parameters/multipath";
>=20
> Is there some benefit that I don't understand to using "static
> const",
> instead of just "const"?=A0 Obviously, the amount of memory necessary
> to
> keep storing this string outside of the function is very small, but I
> don't see why we need to at all.

"static const" and "const" aren't the same thing. "static const" makes
sure the variable's life time is the run time of the program, hence the
compiler can place it in the .rodata section of the output. A "const"
variable in function scope without "static" has "automatic" storage
class, and is thus allocated and initialized on the stack.

https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf
(=A76.2.4 storage durations of objects)

https://stackoverflow.com/questions/3709207/c-semantics-of-static-const-vs-=
const


You can see this if you compile a program like this

int check(const char *);
int fn(void) {
=09/* static */ const char t[] =3D "0123456789abcdef";
=09return check(t);
}

with and without "static".

> > diff --git a/tests/blacklist.c b/tests/blacklist.c
> > index 882aa3a..65002eb 100644
> > --- a/tests/blacklist.c
> > +++ b/tests/blacklist.c
> > @@ -17,6 +17,8 @@
> > =A0 */
> > =A0#include <stdarg.h>
> > =A0#include <stddef.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > =A0#include <setjmp.h>
> > =A0#include <cmocka.h>
> > =A0#include "globals.c"
> > @@ -220,12 +222,36 @@ static void test_devnode_missing(void
> > **state)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 MATCH_NOTHING);
> > =A0}
>=20
> Perhaps we should just use #include "../libmultipath/blacklist.c"
> like
> we do for tests where we need get at a file's private
> variables/functions ("../libmultipath/alias.c" in alias.c for
> instance).

Ok.

Regards
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

