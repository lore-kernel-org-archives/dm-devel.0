Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5F0FA373D
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666372491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p+VnZsQCjrmChlMuz1jcwSXRI0n+2NpNqoNEUgq8D34=;
	b=TPDbYwUFBSsAJyHL7VUvI0p1g1anWk79LjAK4OX1pdGrR88AWtLO4EJdfyLAOIctyhaSe4
	YCFofu/gtGPcU5piae5FEP7+9XFS+YNQTvI9Xrbo+UPi2KGBmb+nCStqNPEWp+GHC4FdtQ
	DO8FlbDLojYV3g8Y9sDdvgloh8vGEJc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-4n4iKXelMMqIvS89-BiKyw-1; Fri, 21 Oct 2022 13:14:47 -0400
X-MC-Unique: 4n4iKXelMMqIvS89-BiKyw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34CEE185A794;
	Fri, 21 Oct 2022 17:14:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 83CDA40C2064;
	Fri, 21 Oct 2022 17:14:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5DA601946587;
	Fri, 21 Oct 2022 17:14:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6A3511946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 17:14:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3ECA62024CBF; Fri, 21 Oct 2022 17:14:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C5852024CBB;
 Fri, 21 Oct 2022 17:14:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29LHEdFQ025581;
 Fri, 21 Oct 2022 12:14:39 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29LHEcKp025580;
 Fri, 21 Oct 2022 12:14:38 -0500
Date: Fri, 21 Oct 2022 12:14:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20221021171438.GB19568@octiron.msp.redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-2-git-send-email-bmarzins@redhat.com>
 <9435d8ddc23ddc74bc5e39072ad80b9263963c53.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <9435d8ddc23ddc74bc5e39072ad80b9263963c53.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 1/8] libmultipath: cleanup remove_feature
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2022 at 02:58:23PM +0000, Martin Wilck wrote:
> On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> > remove_feature() didn't correctly handle feature strings that used
> > whitespace other than spaces, which the kernel allows. It also didn't
> > check if the feature string to be removed was part of a larger
> > feature
> > token. Finally, it did a lot of unnecessary work. By failing if the
> > feature string to be removed contains leading or trailing whitespace,
> > the function can be significanly simplified.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
>=20
> This is part of the code that always makes me think  we should clean it
> up more thoroughly. Therefore I've added some remarks below.
>=20
> As you've started working on this, perhaps you want to follow up?
> If not, fine with me for now.
>=20
> Martin
>=20
> > ---
> > =A0libmultipath/structs.c | 82 +++++++++++++++-------------------------
> > --
> > =A01 file changed, 29 insertions(+), 53 deletions(-)
> >=20
> > diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> > index 49621cb3..1f9945e0 100644
> > --- a/libmultipath/structs.c
> > +++ b/libmultipath/structs.c
> > @@ -6,6 +6,7 @@
> > =A0#include <unistd.h>
> > =A0#include <libdevmapper.h>
> > =A0#include <libudev.h>
> > +#include <ctype.h>
> > =A0
> > =A0#include "checkers.h"
> > =A0#include "vector.h"
> > @@ -663,7 +664,7 @@ int add_feature(char **f, const char *n)
> > =A0
> > =A0int remove_feature(char **f, const char *o)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0int c =3D 0, d, l;
> > +=A0=A0=A0=A0=A0=A0=A0int c =3D 0, d;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *e, *p, *n;
> > =A0=A0=A0=A0=A0=A0=A0=A0const char *q;
>=20
> I see you sticked to the conventions ;-) but the variable naming
> in this function could be improved.

Yeah. I didn't want to while I was chaning things, and then got lazy and
didn't do it in a separate patch, but these names certainly make harder
to follow the logic of the function. I send a patch that cleans this up.
=20
> > =A0
> > @@ -674,33 +675,35 @@ int remove_feature(char **f, const char *o)
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!o || *o =3D=3D '\0')
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0/* Check if not present */
> > -=A0=A0=A0=A0=A0=A0=A0if (!strstr(*f, o))
> > +=A0=A0=A0=A0=A0=A0=A0d =3D strlen(o);
> > +=A0=A0=A0=A0=A0=A0=A0if (isspace(*o) || isspace(*(o + d - 1))) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "internal erro=
r: feature \"%s\" has
> > leading or trailing spaces", o);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* Check if present and not part of a larger feat=
ure token*/
> > +=A0=A0=A0=A0=A0=A0=A0p =3D *f + 1; /* the size must be at the start of=
 the features
> > string */
> > +=A0=A0=A0=A0=A0=A0=A0while ((p =3D strstr(p, o)) !=3D NULL) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (isspace(*(p - 1)) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (isspace(*(p + =
d)) || *(p + d) =3D=3D '\0'))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D d;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (!p)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Get feature count */
> > =A0=A0=A0=A0=A0=A0=A0=A0c =3D strtoul(*f, &e, 10);
> > -=A0=A0=A0=A0=A0=A0=A0if (*f =3D=3D e)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* parse error */
> > +=A0=A0=A0=A0=A0=A0=A0if (*f =3D=3D e || !isspace(*e)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "parse error i=
n feature string \"%s\"",
> > *f);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0/* Normalize features */
> > -=A0=A0=A0=A0=A0=A0=A0while (*o =3D=3D ' ') {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0o++;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0/* Just spaces, return */
> > -=A0=A0=A0=A0=A0=A0=A0if (*o =3D=3D '\0')
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -=A0=A0=A0=A0=A0=A0=A0q =3D o + strlen(o);
> > -=A0=A0=A0=A0=A0=A0=A0while (*q =3D=3D ' ')
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0q--;
> > -=A0=A0=A0=A0=A0=A0=A0d =3D (int)(q - o);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Update feature count */
> > =A0=A0=A0=A0=A0=A0=A0=A0c--;
> > =A0=A0=A0=A0=A0=A0=A0=A0q =3D o;
> > -=A0=A0=A0=A0=A0=A0=A0while (q[0] !=3D '\0') {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (q[0] =3D=3D ' ' && q[=
1] !=3D ' ' && q[1] !=3D '\0')
> > +=A0=A0=A0=A0=A0=A0=A0while (*q !=3D '\0') {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (isspace(*q) && !isspa=
ce(*(q + 1)) && *(q + 1) !=3D
> > '\0')
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0c--;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0q++;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > @@ -714,15 +717,8 @@ int remove_feature(char **f, const char *o)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0/* Search feature to be removed */
> > -=A0=A0=A0=A0=A0=A0=A0e =3D strstr(*f, o);
> > -=A0=A0=A0=A0=A0=A0=A0if (!e)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Not found, return */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Update feature count space */
> > -=A0=A0=A0=A0=A0=A0=A0l =3D strlen(*f) - d;
> > -=A0=A0=A0=A0=A0=A0=A0n =3D=A0 malloc(l + 1);
> > +=A0=A0=A0=A0=A0=A0=A0n =3D=A0 malloc(strlen(*f) - d + 1);
>=20
> Given that this function never increases the length of the feature
> string, we might as well implement it without the allocating a new
> string.=20

A reason to do the malloc is so that we could free the larger chunk of
memory afterwards. But it's not like we're talking a significant
difference, so I'm fine will removing it for simplicity's sake.

-Ben

> > =A0=A0=A0=A0=A0=A0=A0=A0if (!n)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > @@ -732,36 +728,16 @@ int remove_feature(char **f, const char *o)
> > =A0=A0=A0=A0=A0=A0=A0=A0 * Copy existing features up to the feature
> > =A0=A0=A0=A0=A0=A0=A0=A0 * about to be removed
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > -=A0=A0=A0=A0=A0=A0=A0p =3D strchr(*f, ' ');
> > -=A0=A0=A0=A0=A0=A0=A0if (!p) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Internal error, featur=
e string inconsistent */
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(n);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0while (*p =3D=3D ' ')
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p++;
> > -=A0=A0=A0=A0=A0=A0=A0p--;
> > -=A0=A0=A0=A0=A0=A0=A0if (e !=3D p) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0do {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
--;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0d=
++;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} while (*e =3D=3D ' ');
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e++; d--;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strncat(n, p, (size_t)(e =
- p));
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p +=3D (size_t)(e - p);
> > -=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0strncat(n, e, (size_t)(p - e));
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Skip feature to be removed */
> > =A0=A0=A0=A0=A0=A0=A0=A0p +=3D d;
> > -
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Copy remaining features */
> > -=A0=A0=A0=A0=A0=A0=A0if (strlen(p)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (*p =3D=3D ' ')
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
++;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strlen(p)) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
--;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trcat(n, p);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0while (isspace(*p))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p++;
> > +=A0=A0=A0=A0=A0=A0=A0if (*p !=3D '\0')
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strcat(n, p);
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strchop(n);
> > =A0
> > =A0out:
> > =A0=A0=A0=A0=A0=A0=A0=A0free(*f);
>=20
>=20
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

