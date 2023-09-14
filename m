Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED2BEE3F2F
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 06:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694760348;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FGVhh4N9R+3tBxWrDHJ5TgPMOoorXki5QrhCsN7htYU=;
	b=JFWzYGR8mOwUuMoI4EyIcN3PWH4gHmdCJHit9bePGtBbYePC+cG1D3w3QMtU/gz8vuA4Tq
	LHcURl0EmgBW5iZGUP/fO0sztQXXhGBjSEL9POx4kmVO6wAauunmWUYwF+3uRh0xdDUb8o
	MGH+rgIYQ0wqYzUsxP5BRBqQjre5JVA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-ZLTtht-NP86TC9qeCEtu6w-1; Fri, 15 Sep 2023 02:45:44 -0400
X-MC-Unique: ZLTtht-NP86TC9qeCEtu6w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7E06856501;
	Fri, 15 Sep 2023 06:45:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D253110EE6C9;
	Fri, 15 Sep 2023 06:45:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E082E19466EA;
	Fri, 15 Sep 2023 06:44:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36D8F19465B7
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 13:25:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23F1A10F1BE8; Thu, 14 Sep 2023 13:25:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BD3910F1BE7
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 13:25:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECE11800159
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 13:25:38 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-467-YB0eiGugN-emndYE_inRlA-1; Thu,
 14 Sep 2023 09:25:37 -0400
X-MC-Unique: YB0eiGugN-emndYE_inRlA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id D628C1F459;
 Thu, 14 Sep 2023 13:25:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B020613580;
 Thu, 14 Sep 2023 13:25:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id fL1WKc8JA2XXUQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Sep 2023 13:25:35 +0000
Message-ID: <e69bc16163de0f46d615649dcc3c97454fb39682.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Sep 2023 15:25:35 +0200
In-Reply-To: <20230913220727.GX7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-28-mwilck@suse.com>
 <20230913220727.GX7412@octiron.msp.redhat.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Fri, 15 Sep 2023 06:44:53 +0000
Subject: Re: [dm-devel] [PATCH v2 27/37] multipathd: watch bindings file
 with inotify + timestamp
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-09-13 at 17:07 -0500, Benjamin Marzinski wrote:
> On Mon, Sep 11, 2023 at 06:38:36PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Since "libmultipath: keep bindings in memory", we don't re-read the
> > bindings file after every modification. Add a notification
> > mechanism
> > that makes multipathd aware of changes to the bindings file.
> > Because
> > multipathd itself will change the bindings file, it must compare
> > timestamps in order to avoid reading the file repeatedly.
> >=20
> > Because select_alias() can be called from multiple thread contexts
> > (uxlsnr,
> > uevent handler), we need to add locking for the bindings file. The
> > timestamp must also be protected by a lock, because it can't be
> > read
> > or written atomically.
> >=20
> > Note: The notification mechanism expects the bindings file to be
> > atomically replaced by rename(2). Changes must be made in a
> > temporary file and
> > applied using rename(2), as in update_bindings_file(). The inotify
> > mechanism deliberately does not listen to close-after-write events
> > that would be generated by editing the bindings file directly. This
> >=20
> > Note also: new bindings will only be read from add_map_with_path(),
> > i.e. either during reconfigure(), or when a new map is created
> > during
> > runtime. Existing maps will not be renamed if the binding file
> > changes,
> > unless the user runs "multipathd reconfigure". This is not a change
> > wrt the previous code, but it should be mentioned anyway.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> >=20
> > libmultipath: protect global_bindings with a mutex
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> >=20
> > libmultipath: check timestamp of bindings file before reading it
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/alias.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 250 ++=
+++++++++++++++++++++++-
> > ----
> > =A0libmultipath/alias.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 =
3 +-
> > =A0libmultipath/libmultipath.version |=A0=A0 5 +
> > =A0multipathd/uxlsnr.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3=
6 ++++-
> > =A0tests/alias.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0=A0 3 +
> > =A05 files changed, 252 insertions(+), 45 deletions(-)
> >=20
> > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > index 66e34e3..76ed62d 100644
> > --- a/libmultipath/alias.c
> > +++ b/libmultipath/alias.c
> > @@ -10,6 +10,7 @@
> > =A0#include <stdio.h>
> > =A0#include <stdbool.h>
> > =A0#include <assert.h>
> > +#include <sys/inotify.h>
> > =A0
> > =A0#include "debug.h"
> > =A0#include "util.h"
> > @@ -22,6 +23,7 @@
> > =A0#include "config.h"
> > =A0#include "devmapper.h"
> > =A0#include "strbuf.h"
> > +#include "time-util.h"
> > =A0
> > =A0/*
> > =A0 * significant parts of this file were taken from iscsi-bindings.c
> > of the
> > @@ -50,6 +52,12 @@
> > =A0"# alias wwid\n" \
> > =A0"#\n"
> > =A0
> > +/* uatomic access only */
> > +static int bindings_file_changed =3D 1;
> > +
> > +static pthread_mutex_t timestamp_mutex =3D
> > PTHREAD_MUTEX_INITIALIZER;
> > +static struct timespec bindings_last_updated;
> > +
> > =A0struct binding {
> > =A0=A0=A0=A0=A0=A0=A0=A0char *alias;
> > =A0=A0=A0=A0=A0=A0=A0=A0char *wwid;
> > @@ -60,6 +68,9 @@ struct binding {
> > =A0 * an abstract type.
> > =A0 */
> > =A0typedef struct _vector Bindings;
>=20
> I'm pretty sure that the global_bindings is only ever accessed with
> the
> vecs lock held, so it doesn't really need it's own lock. On the
> otherhand, I understand the desire to not keep adding things that the
> vecs lock is protecting, so I'm fine with this.

I have to admit I didn't think about the vecs lock. I find it counter-
intuitive to think about the vecs lock as "global multipath lock", even
if it is in practice. In my mind, the vecs lock protects the pathvec
and the mpvec, and possibly their members, but no other data
structures. Implicitly relying on the vecs lock protecting unrelated
data structures seems unwise to me. Of course we have to consider the
possibility of deadlock, but that's avoided by holding the new lock
only in very short portions of the code, and not across any function
calls or the like.

>=20
> > +
> > +/* Protect global_bindings */
> > +static pthread_mutex_t bindings_mutex =3D PTHREAD_MUTEX_INITIALIZER;
> > =A0static Bindings global_bindings =3D { .allocated =3D 0 };
> > =A0
> > =A0enum {
> > @@ -78,6 +89,26 @@ static void _free_binding(struct binding *bdg)
> > =A0=A0=A0=A0=A0=A0=A0=A0free(bdg);
> > =A0}
> > =A0
> > +static void free_bindings(Bindings *bindings)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct binding *bdg;
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0_free_binding(bdg);
> > +=A0=A0=A0=A0=A0=A0=A0vector_reset(bindings);
> > +}
> > +
> > +static void set_global_bindings(Bindings *bindings)
> > +{
>=20
> However, if we are acting like the vecs lock isn't protecting
> global_bindings, then we should move this to inside the bindings
> mutex below.

> Otherwise, if it was possible for another thread to modify
> global_bindings after setting old_bindings but before grabbing the
> mutex, it could add a binding, making old_binding->allocated and
> old_binding->slot incorrect, so we'd be freeing random memory below.
>=20
Right, thanks.

> > +=09Bindings old_bindings =3D global_bindings;
> > +
> > +=09pthread_mutex_lock(&bindings_mutex);
> > +=09global_bindings =3D *bindings;
> > +=09pthread_mutex_unlock(&bindings_mutex);
> > +=09free_bindings(&old_bindings);
> > +}
> > +

> > +void handle_bindings_file_inotify(const struct inotify_event
> *event)
> > +{
> > +=09struct config *conf;
> > +=09const char *base;
> > +=09bool changed =3D false;
> > +=09struct stat st;
> > +=09struct timespec ts =3D { 0 };
> > +=09int ret;
> > +
> > +=09if (!(event->mask & IN_MOVED_TO))
> > +=09=09return;
> > +
> > +=09conf =3D get_multipath_config();
> > +=09base =3D strrchr(conf->bindings_file, '/');
> > +=09changed =3D base && base > conf->bindings_file &&
> > +=09=09!strcmp(base + 1, event->name);
> > +=09ret =3D stat(conf->bindings_file, &st);
> > +=09put_multipath_config(conf);
> > +
> > +=09if (!changed)
> > +=09=09return;
> > +
> > +=09pthread_mutex_lock(&timestamp_mutex);
> I'm not sure if we should assert that the file has changed if we
> can't stat() it.

I think it's better to (try to) reread the file than pretend that the
file hadn't changed ("if in doubt, reread").=A0Rationale:

In general, the most likely cause for stat() to fail would be that the
file (or the directory or file system containing it) had been removed.
Actually, almost every possible error documented in stat(2) (except
ENOMEM) indicates such a condition in one way or the other.=A0But in an
IN_MOVED_TO handler for just this file, that seems quite unlikely, so
we're really looking at a corner case situation here. A non-existing
file means no bindings; a "reconfigure" operation would cause existing
bindings to be preserved, newly probed maps would get a new alias
assigned.=A0Looking at it that way, "rereading" a non-existing file
doesn't do much harm. Our current bindings list may contain additional
bindings that might be lost by re-reading, but still I think we have to
assume that the file was intentionally deleted, and act accordingly.

> > +=09if (ret =3D=3D 0) {
> > +=09=09ts =3D st.st_mtim;
> > +=09=09changed =3D timespeccmp(&ts, &bindings_last_updated) >
> 0;
> > +=09}
>=20

> >=20
> > @@ -248,7 +328,7 @@ static int update_bindings_file(const Bindings
> > *bindings,
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0umask(old_umask);
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_fd_ptr, &fd);
> > -=A0=A0=A0=A0=A0=A0=A0rc =3D write_bindings_file(bindings, fd);
> > +=A0=A0=A0=A0=A0=A0=A0rc =3D write_bindings_file(bindings, fd, &ts);
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (rc =3D=3D -1) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "failed to w=
rite new bindings file");
> > @@ -257,8 +337,12 @@ static int update_bindings_file(const Bindings
> > *bindings,
> > =A0=A0=A0=A0=A0=A0=A0=A0}
>=20
> Isn't there a race where we rename the file and then update the
> timestamp.=A0 If we respond to the inotify event between when we rename
> and when we lock the timestamp_mutex, we will trigger a reread based
> on
> our own changes.=A0 Perhaps we should set the timestamp before renaming
> the file. If the rename fails, it's not clear what we want to do
> anyway,
> since we have bindings that didn't make it into the file, and if we
> reread the file, we lose them.

True, if the rename fails, we're in an awkward situation. But I think
it's important that, even then, we don't lie about the timestamp,
therefore it shouldn't be updated if the file was not.

Again, this follows the "if in doubt, re-read" mind set. There is no
completely race-free way to implement this using time stamps, in
particular if we consider a situation where multipathd's own update
races with some other process (multipath) updating the file.=20
Therefore believe it's correct to set the timestamp after the rename. I
must definitely move the timestamp update before the condlog(), though.

>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D rename(tempname, bindings_file)) =
=3D=3D -1)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: rename:=
 %m", __func__);
> > -=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0else {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "updated bin=
dings file %s",
> > bindings_file);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&times=
tamp_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bindings_last_updated =3D=
 ts;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&tim=
estamp_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0return rc;
> > =A0}
> > =A0
> > ...
> > =A0
> > =A0int get_user_friendly_wwid(const char *alias, char *buff)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0const struct binding *bdg;
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D -1;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!alias || *alias =3D=3D '\0') {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "Cannot find=
 binding for empty alias");
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
>=20
> Don't we want to call read_bindings_file() here as well?

Good point, thanks.

>=20
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&bindings_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_mutex, &bindings_mut=
ex);
> > =A0=A0=A0=A0=A0=A0=A0=A0bdg =3D get_binding_for_alias(&global_bindings,=
 alias);
> > -=A0=A0=A0=A0=A0=A0=A0if (!bdg) {
> > +=A0=A0=A0=A0=A0=A0=A0if (bdg) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strlcpy(buff, bdg->wwid, =
WWID_SIZE);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*buff =3D '\0';
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0strlcpy(buff, bdg->wwid, WWID_SIZE);
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > -}
> > -
> > -static void free_bindings(Bindings *bindings)
> > -{
> > -=A0=A0=A0=A0=A0=A0=A0struct binding *bdg;
> > -=A0=A0=A0=A0=A0=A0=A0int i;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(bindings, bdg, i)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0_free_binding(bdg);
> > -=A0=A0=A0=A0=A0=A0=A0vector_reset(bindings);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0return rc;
> > =A0}
> > =A0
> > =A0void cleanup_bindings(void)
> > =A0{
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&bindings_mutex);
> > =A0=A0=A0=A0=A0=A0=A0=A0free_bindings(&global_bindings);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&bindings_mutex);
> > =A0}
> > =A0
> > =A0enum {
> > @@ -595,7 +707,21 @@ static int _check_bindings_file(const struct
> > config *conf, FILE *file,
> > =A0=A0=A0=A0=A0=A0=A0=A0char *line =3D NULL;
> > =A0=A0=A0=A0=A0=A0=A0=A0size_t line_len =3D 0;
> > =A0=A0=A0=A0=A0=A0=A0=A0ssize_t n;
> > +=A0=A0=A0=A0=A0=A0=A0char header[sizeof(BINDINGS_FILE_HEADER)];
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0header[sizeof(BINDINGS_FILE_HEADER) - 1] =3D '\0'=
;
> > +=A0=A0=A0=A0=A0=A0=A0if (fread(header, sizeof(BINDINGS_FILE_HEADER) - =
1, 1,
> > file)
>=20
> I'm pretty sure fread returns the number of items read, in this case
> 1.

Argh, thanks. I think this is the first time I've knowingly used this
API, and I got it wrong :-/

>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 < sizeof(BINDINGS_FILE_HEADER)=A0 - 1) =
{
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: failed to=
 read header from %s",
> > __func__,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onf->bindings_file);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fseek(file, 0, SEEK_SET);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -1;
> > +=A0=A0=A0=A0=A0=A0=A0} else if (strcmp(header, BINDINGS_FILE_HEADER)) =
{
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: invalid h=
eader in %s", __func__,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
onf->bindings_file);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fseek(file, 0, SEEK_SET);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =3D -1;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_free_ptr, &line);
> > =A0=A0=A0=A0=A0=A0=A0=A0while ((n =3D getline(&line, &line_len, file)) =
>=3D 0) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0char *alias, *wwid;
> > @@ -643,6 +769,68 @@ static int mp_alias_compar(const void *p1,
> > const void *p2)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &((*(struct mpentry * const *)p2)-
> > >alias));
> > =A0}
> > =A0
> > +static int _read_bindings_file(const struct config *conf, Bindings
> > *bindings,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 bool force)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int can_write;
> > +=A0=A0=A0=A0=A0=A0=A0int rc =3D 0, ret, fd;
> > +=A0=A0=A0=A0=A0=A0=A0FILE *file;
> > +=A0=A0=A0=A0=A0=A0=A0struct stat st;
> > +=A0=A0=A0=A0=A0=A0=A0int has_changed =3D uatomic_xchg(&bindings_file_c=
hanged, 0);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!force) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!has_changed) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(4, "%s: bindings are unchanged",
> > __func__);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn BINDINGS_FILE_UP2DATE;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0fd =3D open_file(conf->bindings_file, &can_write,
> > BINDINGS_FILE_HEADER);
> > +=A0=A0=A0=A0=A0=A0=A0if (fd =3D=3D -1)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return BINDINGS_FILE_ERRO=
R;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0file =3D fdopen(fd, "r");
> > +=A0=A0=A0=A0=A0=A0=A0if (file !=3D NULL) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: reading %=
s", __func__, conf-
> > >bindings_file);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(clea=
nup_fclose, file);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D _check_bindings_f=
ile(conf, file, bindings);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
truct timespec ts;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
c =3D BINDINGS_FILE_READ;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D fstat(fd, &st);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret =3D=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0ts =3D st.st_mtim;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: fstat failed (%m),
> > using current time", __func__);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0clock_gettime(CLOCK_REALTIME_COARSE
> > , &ts);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_mutex_lock(&timestamp_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
indings_last_updated =3D ts;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_mutex_unlock(&timestamp_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (ret =3D=3D -1 =
&& can_write && !conf-
> > >bindings_read_only) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D update_bindings_file(bindings, conf-
> > >bindings_file);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret =3D=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D BINDINGS_FILE_READ;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0rc =3D BINDINGS_FILE_BAD;
>=20
> I don't think _read_bindings_file() can return a value other than 0
> or
> -1, and we already know it didn't return 0 here.

You meant _check_bindings_file(). And yes, you're right.

Thanks,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

