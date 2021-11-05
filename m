Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFDFC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 17:38:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6A4E561252
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 17:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6A4E561252
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636133933;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mzMfjzbFefq/cUqmSmGdOBOC/POl+A33BGo8lCzW/tg=;
	b=gMFjcQsWwkSh/GCqsZfCFfZCzsAPurN3hNrJwJ/tk+Y4XiZ1D+b9cshwwr7sXUl7he+rOv
	sBOKHUbKR0N98csG+OJwYxR8ls0qqzBV8P28IjmFZsrnfuqQsoLHp9nzRgC0PN5fkk41PF
	gXMcudDyynMk6jUfJ/087HZ0Yhh6UvM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-3UF2f8vROv2_5ptTfRVYBw-1; Fri, 05 Nov 2021 13:38:49 -0400
X-MC-Unique: 3UF2f8vROv2_5ptTfRVYBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90846120B380;
	Fri,  5 Nov 2021 17:38:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 684F35D9DE;
	Fri,  5 Nov 2021 17:38:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AEA2B1818480;
	Fri,  5 Nov 2021 17:38:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5HchmO007114 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 13:38:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D439C5C23A; Fri,  5 Nov 2021 17:38:43 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50EA75C25D;
	Fri,  5 Nov 2021 17:38:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A5HccLW011777; 
	Fri, 5 Nov 2021 12:38:38 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A5HcbfV011776;
	Fri, 5 Nov 2021 12:38:37 -0500
Date: Fri, 5 Nov 2021 12:38:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211105173837.GI19591@octiron.msp.redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-7-git-send-email-bmarzins@redhat.com>
	<5424c4163d1fee71af3f1126adc2a59d3069b09f.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <5424c4163d1fee71af3f1126adc2a59d3069b09f.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 6/8] libmultipath: improve checks for set_str
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2021 at 08:34:20PM +0000, Martin Wilck wrote:
> On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> > multipath always requires absolute pathnames, so make sure all file
> > and
> > directory names start with a slash.=A0 Also check that the directories
> > exist.=A0 Finally, some strings, like the alias, will be used in paths.
> > These must not contain the slash character '/', since it is a
> > forbidden
> > character in file/directory names. This patch adds seperate handlers
> > for
> > these three cases. If a config line is invalid, these handlers retain
> > the existing config string, if any.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> Mostly OK, see remarks below. I'm a bit wary that when we start this,
> we might need to do other checks as well. For example, as multipathd is
> running as root, we may want to check that the paths to files it writes
> to (bindings_file etc.) don't contain symlinks and have proper
> permissions... But that'd be another patch.
>=20
> Regards,
> Martin
>=20
>=20
> > ---
> > =A0libmultipath/dict.c | 88 +++++++++++++++++++++++++++++++++++++++----
> > --
> > =A01 file changed, 78 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index 1758bd26..91333068 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -5,6 +5,8 @@
> > =A0 * Copyright (c) 2005 Kiyoshi Ueda, NEC
> > =A0 */
> > =A0#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > =A0#include <pwd.h>
> > =A0#include <string.h>
> > =A0#include "checkers.h"
> > @@ -111,6 +113,72 @@ set_str(vector strvec, void *ptr, const char
> > *file, int line_nr)
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > +static int
> > +set_dir(vector strvec, void *ptr, const char *file, int line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> > +=A0=A0=A0=A0=A0=A0=A0struct stat sb;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if ((*str_ptr)[0] !=3D '/'){
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %=
s is not an absolute
> > directory path. Ignoring", file, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0} else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (stat(*str_ptr, &sb) =
=3D=3D 0 && S_ISDIR(sb.st_mode))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ree(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(1, "%s line %d, %s is not an existing
> > directory. Ignoring", file, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*=
str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > +static int
> > +set_path(vector strvec, void *ptr, const char *file, int line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if ((*str_ptr)[0] !=3D '/'){
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %=
s is not an absolute path.
> > Ignoring",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
>=20
> Once you go down this route, you might as well test that the dirname of
> the path is an existing directory.
>=20

But they don't need to exist, since the multipath code will create the
missing directories.
=20
>=20
> > +
> > +static int
> > +set_str_noslash(vector strvec, void *ptr, const char *file, int
> > line_nr)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0char **str_ptr =3D (char **)ptr;
> > +=A0=A0=A0=A0=A0=A0=A0char *old_str =3D *str_ptr;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D set_value(strvec);
> > +=A0=A0=A0=A0=A0=A0=A0if (!*str_ptr) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (strchr(*str_ptr, '/')) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, %=
s cannot contain a slash.
> > Ignoring",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ile, line_nr, *str_ptr);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*str_ptr =3D old_str;
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(old_str);
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +}
> > +
> > =A0static int
> > =A0set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
> > =A0{
> > @@ -353,13 +421,13 @@ declare_def_snprint(verbosity, print_int)
> > =A0declare_def_handler(reassign_maps, set_yes_no)
> > =A0declare_def_snprint(reassign_maps, print_yes_no)
> > =A0
> > -declare_def_handler(multipath_dir, set_str)
> > +declare_def_handler(multipath_dir, set_dir)
> > =A0declare_def_snprint(multipath_dir, print_str)
> > =A0
> > =A0static int def_partition_delim_handler(struct config *conf, vector
> > strvec,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *file, int line_nr=
)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str(strvec, &conf->partition_delim=
, file,
> > line_nr);
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D set_str_noslash(strvec, &conf->partiti=
on_delim,
> > file, line_nr);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (rc !=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> > @@ -490,11 +558,11 @@ declare_hw_snprint(prio_name, print_str)
> > =A0declare_mp_handler(prio_name, set_str)
> > =A0declare_mp_snprint(prio_name, print_str)
> > =A0
> > -declare_def_handler(alias_prefix, set_str)
> > +declare_def_handler(alias_prefix, set_str_noslash)
> > =A0declare_def_snprint_defstr(alias_prefix, print_str,
> > DEFAULT_ALIAS_PREFIX)
> > -declare_ovr_handler(alias_prefix, set_str)
> > +declare_ovr_handler(alias_prefix, set_str_noslash)
> > =A0declare_ovr_snprint(alias_prefix, print_str)
> > -declare_hw_handler(alias_prefix, set_str)
> > +declare_hw_handler(alias_prefix, set_str_noslash)
> > =A0declare_hw_snprint(alias_prefix, print_str)
> > =A0
> > =A0declare_def_handler(prio_args, set_str)
> > @@ -586,13 +654,13 @@ declare_hw_snprint(user_friendly_names,
> > print_yes_no_undef)
> > =A0declare_mp_handler(user_friendly_names, set_yes_no_undef)
> > =A0declare_mp_snprint(user_friendly_names, print_yes_no_undef)
> > =A0
> > -declare_def_handler(bindings_file, set_str)
> > +declare_def_handler(bindings_file, set_path)
> > =A0declare_def_snprint(bindings_file, print_str)
> > =A0
> > -declare_def_handler(wwids_file, set_str)
> > +declare_def_handler(wwids_file, set_path)
> > =A0declare_def_snprint(wwids_file, print_str)
> > =A0
> > -declare_def_handler(prkeys_file, set_str)
> > +declare_def_handler(prkeys_file, set_path)
> > =A0declare_def_snprint(prkeys_file, print_str)
> > =A0
> > =A0declare_def_handler(retain_hwhandler, set_yes_no_undef)
> > @@ -692,7 +760,7 @@ def_config_dir_handler(struct config *conf,
> > vector strvec, const char *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0/* this is only valid in the main config file *=
/
> > =A0=A0=A0=A0=A0=A0=A0=A0if (conf->processed_main_config)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > -=A0=A0=A0=A0=A0=A0=A0return set_str(strvec, &conf->config_dir, file, l=
ine_nr);
> > +=A0=A0=A0=A0=A0=A0=A0return set_path(strvec, &conf->config_dir, file, =
line_nr);
> > =A0}
>=20
> Why not set_dir() here?

It seems valid to set the directory to look in for extra multipath
configuration files, and not currently have that directory exist.
You may be setting things up for later, in case you happen to need
a drop-in config file.

-Ben
=20
> > =A0declare_def_snprint(config_dir, print_str)
> > =A0
> > @@ -1732,7 +1800,7 @@ multipath_handler(struct config *conf, vector
> > strvec, const char *file,
> > =A0declare_mp_handler(wwid, set_str)
> > =A0declare_mp_snprint(wwid, print_str)
> > =A0
> > -declare_mp_handler(alias, set_str)
> > +declare_mp_handler(alias, set_str_noslash)
> > =A0declare_mp_snprint(alias, print_str)
> > =A0
> > =A0/*

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

