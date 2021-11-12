Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821F9C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 22:07:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DD1F61051
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 22:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1DD1F61051
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-zEy86dJeOi2kIgF1_bM_Eg-1; Fri, 12 Nov 2021 17:07:50 -0500
X-MC-Unique: zEy86dJeOi2kIgF1_bM_Eg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08B3A1006AA1;
	Fri, 12 Nov 2021 22:07:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D777100763D;
	Fri, 12 Nov 2021 22:07:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 352EB181A1CF;
	Fri, 12 Nov 2021 22:07:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACM7fZW021956 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 17:07:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 03BF551E5; Fri, 12 Nov 2021 22:07:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F016851E2
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 22:07:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01CBF10726A2
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 22:07:38 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-323-V5CpZWFUOTC0I3lQF6aZEQ-1; Fri, 12 Nov 2021 17:07:34 -0500
X-MC-Unique: V5CpZWFUOTC0I3lQF6aZEQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 545531FD5B;
	Fri, 12 Nov 2021 22:07:33 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 113A013C96;
	Fri, 12 Nov 2021 22:07:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id k6cUAqXljmGocQAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 12 Nov 2021 22:07:33 +0000
Message-ID: <fc37ce1590f9d649cd44fba68c98a275da1ae53e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Nov 2021 23:07:32 +0100
In-Reply-To: <20210916033237.GP3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-31-mwilck@suse.com>
	<20210916033237.GP3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.42.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ACM7fZW021956
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 30/35] multipathd: uxlsnr: merge
 uxsock_trigger() into state machine
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-09-15 at 22:32 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:41:15PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > This patch sets up the bulk of the state machine. The idea is to
> > fall through the case labels as long as possible (when steps
> > succeed)
> > and return to the caller if either an error occurs, or it becomes
> > necessary to wait for some pollable condition.
> >=20
> > While doing this, switch to negative error codes for the functions
> > in uxlsnr.c (e.g. parse_cmd()). Positive return codes are reserved
> > for the cli_handler functions themselves. This way we can clearly
> > distinguish the error source, and avoid confusion and misleading
> > error messages. No cli_handler returns negative values.
> >=20
> > Note: with this patch applied, clients may hang and time out if
> > the handler fails to acquire the vecs lock. This will be fixed in
> > the
> > follow-up patch "multipathd: uxlsnr: add idle notification".
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/uxlsnr.c | 145 ++++++++++++++++++++++++----------------
> > ----
> > =A01 file changed, 80 insertions(+), 65 deletions(-)
> >=20
> > diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> > index ff9604f..553274b 100644
> > --- a/multipathd/uxlsnr.c
> > +++ b/multipathd/uxlsnr.c
> > =A0
> > -static int uxsock_trigger(struct client *c, void *trigger_data)
> > +void default_reply(struct client *c, int r)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs;
> > -=A0=A0=A0=A0=A0=A0=A0int r =3D 1;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0vecs =3D (struct vectors *)trigger_data;
> > -
> > -=A0=A0=A0=A0=A0=A0=A0r =3D parse_cmd(c);
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D 0 && c->cmdvec && VECTOR_SIZE(c->cmd=
vec) > 0) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct key *kw =3D VECTOR=
_SLOT(c->cmdvec, 0);
> > -
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!c->is_root && kw->co=
de !=3D LIST)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
 =3D EPERM;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D 0 && c->handler)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D execute_handler(c, =
vecs, uxsock_timeout /
> > 1000);
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (c->cmdvec) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free_keys(c->cmdvec);
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c->cmdvec =3D NULL;
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (r > 0) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch(r) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case ETIMEDOUT:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
ppend_strbuf_str(&c->reply, "timeout\n");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0case EPERM:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
ppend_strbuf_str(&c->reply,
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "permission deny: need =
to
> > be root\n");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0default:
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0a=
ppend_strbuf_str(&c->reply, "fail\n");
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0}
> > -=A0=A0=A0=A0=A0=A0=A0else if (!r && get_strbuf_len(&c->reply) =3D=3D 0=
) {
> > +=A0=A0=A0=A0=A0=A0=A0switch(r) {
> > +=A0=A0=A0=A0=A0=A0=A0case -EINVAL:
> > +=A0=A0=A0=A0=A0=A0=A0case -ESRCH:
> > +=A0=A0=A0=A0=A0=A0=A0case -ENOMEM:
>=20
> get_cmdvec() returns positive errors and do_genhelp() expects
> positive
> errors, but this expects negative errors.

parse_cmd() already negates the return value of get_cmdvec().
But you're right wrt do_genhelp(). I'll fix it.

(FTR, when I worked on the patch series, I considered fixing up the
return codes of all cli_handler functions, but I gave up for now, it
was too much work for no real benefit).

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

