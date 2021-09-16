Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E338DC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 07:22:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B43B61186
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 07:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B43B61186
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-_elUzN75MpCACt3BdG5WHA-1; Thu, 16 Sep 2021 03:22:29 -0400
X-MC-Unique: _elUzN75MpCACt3BdG5WHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98F931023F4F;
	Thu, 16 Sep 2021 07:22:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0791E18649;
	Thu, 16 Sep 2021 07:22:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE2364EA2A;
	Thu, 16 Sep 2021 07:22:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G7MLMo018039 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 03:22:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 97BA1208DDBB; Thu, 16 Sep 2021 07:22:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93212208DD89
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 07:22:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13F85899EC4
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 07:22:19 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-413-eqfOTSHTM_a7Bw5HlMFvMw-1; Thu, 16 Sep 2021 03:22:15 -0400
X-MC-Unique: eqfOTSHTM_a7Bw5HlMFvMw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B103B22279;
	Thu, 16 Sep 2021 07:22:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 732E913CA4;
	Thu, 16 Sep 2021 07:22:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id p+wrGqXwQmFvDwAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Sep 2021 07:22:13 +0000
Message-ID: <b609638e46077cc7928a52399fa7e63a6b931209.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Sep 2021 09:22:12 +0200
In-Reply-To: <20210916000128.GX3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-13-mwilck@suse.com>
	<20210916000128.GX3087@octiron.msp.redhat.com>
User-Agent: Evolution 3.40.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18G7MLMo018039
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 12/35] multipathd: add and set cli_handlers
 in a single step
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-09-15 at 19:01 -0500, Benjamin Marzinski wrote:
> On Fri, Sep 10, 2021 at 01:40:57PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > Modify set_handler_callback() such that a missing slot is created
> > if no matching slot is found. This way, we can skip the
> > initialization
> > with NULL handlers on startup.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0multipathd/cli.c | 85 +++++++-------------------------------------
> > ----
> > =A0multipathd/cli.h |=A0 6 ++--
> > =A02 files changed, 15 insertions(+), 76 deletions(-)
> >=20
> > diff --git a/multipathd/cli.c b/multipathd/cli.c
> > index 5213813..7020d2b 100644
> > --- a/multipathd/cli.c
> > +++ b/multipathd/cli.c
> > @@ -100,26 +100,20 @@ find_handler (uint64_t fp)
> > =A0}
> > =A0
> > =A0int
> > -set_handler_callback (uint64_t fp, cli_handler *fn)
> > +__set_handler_callback (uint64_t fp, cli_handler *fn, bool locked)
> > =A0{
> > -=A0=A0=A0=A0=A0=A0=A0struct handler * h =3D find_handler(fp);
> > +=A0=A0=A0=A0=A0=A0=A0struct handler *h =3D find_handler(fp);
> > =A0
>=20
> Wouldn't it be a bug if we reset the handler? Is this really
> something
> we need to check for? Also, if add_handler() just returned a pointer
> to
> the handler, we wouldn't need to call fail_handler() immediately
> after
> creating it.

That makes sense. I'll resubmit.

Regards,
Martin

>=20
> -Ben
>=20
> > -=A0=A0=A0=A0=A0=A0=A0if (!h)
> > +=A0=A0=A0=A0=A0=A0=A0if (!h) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0add_handler(fp, fn);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0h =3D find_handler(fp);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0if (!h) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: failed to=
 set handler for code
> > %"PRIu64,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0_=
_func__, fp);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > -=A0=A0=A0=A0=A0=A0=A0h->fn =3D fn;
> > -=A0=A0=A0=A0=A0=A0=A0h->locked =3D 1;
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > -}
> > -
> > -int
> > -set_unlocked_handler_callback (uint64_t fp, cli_handler *fn)
> > -{
> > -=A0=A0=A0=A0=A0=A0=A0struct handler * h =3D find_handler(fp);
> > -
> > -=A0=A0=A0=A0=A0=A0=A0if (!h)
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > -=A0=A0=A0=A0=A0=A0=A0h->fn =3D fn;
> > -=A0=A0=A0=A0=A0=A0=A0h->locked =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0h->locked =3D locked;
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > @@ -513,63 +507,6 @@ cli_init (void) {
> > =A0=A0=A0=A0=A0=A0=A0=A0if (alloc_handlers())
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > =A0
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+PATHS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+PATHS+FMT, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+PATHS+RAW+FMT, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+PATH, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+STATUS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+DAEMON, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAPS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAPS+STATUS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAPS+STATS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAPS+FMT, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAPS+RAW+FMT, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAPS+TOPOLOGY, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAPS+JSON, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+TOPOLOGY, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAP+TOPOLOGY, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAP+JSON, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAP+FMT, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+MAP+RAW+FMT, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+CONFIG, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+CONFIG+LOCAL, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+BLACKLIST, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+DEVICES, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(LIST+WILDCARDS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESET+MAPS+STATS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESET+MAP+STATS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(ADD+PATH, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(DEL+PATH, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(ADD+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(DEL+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(DEL+MAPS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(SWITCH+MAP+GROUP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RECONFIGURE, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(SUSPEND+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESUME+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESIZE+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESET+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RELOAD+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(DISABLEQ+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESTOREQ+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(DISABLEQ+MAPS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESTOREQ+MAPS, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(REINSTATE+PATH, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(FAIL+PATH, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(QUIT, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(SHUTDOWN, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(GETPRSTATUS+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(SETPRSTATUS+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(UNSETPRSTATUS+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(GETPRKEY+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(SETPRKEY+MAP+KEY, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(UNSETPRKEY+MAP, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(FORCEQ+DAEMON, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(RESTOREQ+DAEMON, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(SETMARGINAL+PATH, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(UNSETMARGINAL+PATH, NULL);
> > -=A0=A0=A0=A0=A0=A0=A0add_handler(UNSETMARGINAL+MAP, NULL);
> > -
> > =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
> > =A0
> > diff --git a/multipathd/cli.h b/multipathd/cli.h
> > index 3dac1b4..dbb75be 100644
> > --- a/multipathd/cli.h
> > +++ b/multipathd/cli.h
> > @@ -134,8 +134,10 @@ struct handler {
> > =A0
> > =A0int alloc_handlers (void);
> > =A0int add_handler (uint64_t fp, cli_handler *fn);
> > -int set_handler_callback (uint64_t fp, cli_handler *fn);
> > -int set_unlocked_handler_callback (uint64_t fp, cli_handler *fn);
> > +int __set_handler_callback (uint64_t fp, cli_handler *fn, bool
> > locked);
> > +#define set_handler_callback(fp, fn) __set_handler_callback(fp,
> > fn, true)
> > +#define set_unlocked_handler_callback(fp, fn)
> > __set_handler_callback(fp, fn, false)
> > +
> > =A0int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
> > =A0int load_keys (void);
> > =A0char * get_keyparam (vector v, uint64_t code);
> > --=20
> > 2.33.0
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>=20



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

