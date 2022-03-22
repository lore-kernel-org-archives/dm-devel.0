Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BDAC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 08:36:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-A6dbjb5_P_mafROaaC1Ozg-1; Tue, 22 Mar 2022 04:36:00 -0400
X-MC-Unique: A6dbjb5_P_mafROaaC1Ozg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B64B85A5BE;
	Tue, 22 Mar 2022 08:35:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC4B22166B2D;
	Tue, 22 Mar 2022 08:35:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A83B91949762;
	Tue, 22 Mar 2022 08:35:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69D3F1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 08:35:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C3B540D0161; Tue, 22 Mar 2022 08:35:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 470C840D0160
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:35:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B4471044562
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:35:54 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-rMtVpdQRMi-K-Vt1zAsSAQ-1; Tue, 22 Mar 2022 04:35:50 -0400
X-MC-Unique: rMtVpdQRMi-K-Vt1zAsSAQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2B7EA210F3;
 Tue, 22 Mar 2022 08:35:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E458B133B6;
 Tue, 22 Mar 2022 08:35:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id +h6cNWSKOWIncAAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 22 Mar 2022 08:35:48 +0000
Message-ID: <e1064847c02559b157238ec104aa75b3568fd4f6.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Tue, 22 Mar 2022 09:35:48 +0100
In-Reply-To: <CAPt1nt4LU_pHJA2m9zWjPhn2i=WOaVnzgiKY+V5za=u2a6StUQ@mail.gmail.com>
References: <20220318223339.4226-1-mwilck@suse.com>
 <20220318223339.4226-7-mwilck@suse.com>
 <CAPt1nt4LU_pHJA2m9zWjPhn2i=WOaVnzgiKY+V5za=u2a6StUQ@mail.gmail.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 06/11] libmultipath: add callback for
 remove_map()
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
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-03-21 at 19:28 -0500, Benjamin Marzinski wrote:
> On Fri, Mar 18, 2022 at 5:33 PM <mwilck@suse.com> wrote:
> >=20
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > This callback is be used by multipathd to unblock pending
> > reconfigure requests if a map is removed that multipathd is
> > currently
> > waiting for.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/libmultipath.version | 3 ++-
> > =A0libmultipath/structs_vec.c=A0=A0=A0=A0=A0=A0=A0 | 6 ++++++
> > =A02 files changed, 8 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index 216f0ee..8132df7 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -31,7 +31,7 @@
> > =A0 *=A0=A0 The new version inherits the previous ones.
> > =A0 */
> >=20
> > -LIBMULTIPATH_14.0.0 {
> > +LIBMULTIPATH_14.1.0 {
> > =A0global:
> > =A0=A0=A0=A0=A0=A0=A0 /* symbols referenced by multipath and multipathd=
 */
> > =A0=A0=A0=A0=A0=A0=A0 add_foreign;
> > @@ -164,6 +164,7 @@ global:
> > =A0=A0=A0=A0=A0=A0=A0 remember_wwid;
> > =A0=A0=A0=A0=A0=A0=A0 remove_map;
> > =A0=A0=A0=A0=A0=A0=A0 remove_map_by_alias;
> > +=A0=A0=A0=A0=A0=A0 remove_map_callback;
> > =A0=A0=A0=A0=A0=A0=A0 remove_maps;
> > =A0=A0=A0=A0=A0=A0=A0 remove_wwid;
> > =A0=A0=A0=A0=A0=A0=A0 replace_wwids;
> > diff --git a/libmultipath/structs_vec.c
> > b/libmultipath/structs_vec.c
> > index 6c23df8..a69f064 100644
> > --- a/libmultipath/structs_vec.c
> > +++ b/libmultipath/structs_vec.c
> > @@ -336,11 +336,17 @@ void set_path_removed(struct path *pp)
> > =A0=A0=A0=A0=A0=A0=A0 pp->initialized =3D INIT_REMOVED;
> > =A0}
> >=20
> > +void remove_map_callback(struct multipath *mpp
> > __attribute__((unused)))
> > +{
> > +}
> > +
>=20
> Does this work? I thought that unless you specifically declared the
> symbol weak, the call in remove_map() would have already gotten
> resolved to point to the existing remove_map_callback() when the
> shared library was getting created.=A0 Is it because the function is
> empty? Am I just misunderstanding something?

This works because I added the symbol to libmultipath.version,
assigning it "global" visibility.=A0To be consistent, we could do the
same thing with get_multipath_config() et al., but I didn't want to
change that just now.

We (or actually, users and distro integrators) have to be somewhat
careful with adding linker flags. As discussed e.g. in
https://github.com/opensvc/multipath-tools/issues/26
flags like "-Bsymbolic-functions" would mess this up, because this flag
overrides the settings from our linker script. But declaring the symbol
"weak" wouldn't protect against -Bsymbolic mess-up, either.

I had a long discussion with our toolchain experts about this, which
lead to the conclusion above. I am pretty positive about it.=A0
Feel free to ask the RH experts, too ;-)

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

