Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C4EC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:20:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6590060F92
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6590060F92
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-9aSGUY1bNeiP9Fur_GCvgA-1; Fri, 10 Sep 2021 12:20:31 -0400
X-MC-Unique: 9aSGUY1bNeiP9Fur_GCvgA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA80C80006E;
	Fri, 10 Sep 2021 16:19:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE1E119C79;
	Fri, 10 Sep 2021 16:19:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 656C54E58F;
	Fri, 10 Sep 2021 16:19:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18AGHw2x005453 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 12:17:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5481328B045; Fri, 10 Sep 2021 16:17:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EB1224F0DF
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 16:17:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56E71800C00
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 16:17:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-405-F55aZ1KFPlWH24mCEh6TvQ-1; Fri, 10 Sep 2021 12:17:52 -0400
X-MC-Unique: F55aZ1KFPlWH24mCEh6TvQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 222D61FD5B;
	Fri, 10 Sep 2021 16:17:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D12BA139F0;
	Fri, 10 Sep 2021 16:17:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id PUs8MS6FO2GMDAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 16:17:50 +0000
Message-ID: <421bf852fdf9298bb5c0fd41e53adc1bff4e4050.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Fri, 10 Sep 2021 18:17:50 +0200
In-Reply-To: <298ae89f-6d47-546d-a87e-42e6563a17f2@huawei.com>
References: <298ae89f-6d47-546d-a87e-42e6563a17f2@huawei.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18AGHw2x005453
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH] multipathd: fix missing persistent
 reseravtion for active path
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello lixiaokeng,

thanks for your patch.

On Fri, 2021-09-10 at 20:31 +0800, lixiaokeng wrote:
> There are two paths(sucu as sda and adb) for one LUN. The two
> paths log in, but before the two uevents have been processed
> (for example there are many uevent), users use multipathd add
> path /dev/sda to cause mpatha and use mpathpersist -o -I to
> register prkey for mpatha. The add map uevent is after add path
> uevent, the the uevent(add sdb) will delay and missing persistent
> reseravtion check.
>=20
> Here, we add persistent reseravtion check in ev_add_map if
> mpp->wait_for_udev > 1.
>=20
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
> =A0multipathd/main.c | 9 +++++++++
> =A01 file changed, 9 insertions(+)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 3aff241d..ef456c34 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -706,6 +706,8 @@ ev_add_map (char * dev, const char * alias,
> struct vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> =A0=A0=A0=A0=A0=A0=A0=A0int delayed_reconfig, reassign_maps;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +=A0=A0=A0=A0=A0=A0=A0int i;
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0if (dm_is_mpath(alias) !=3D 1) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: not a mul=
tipath map", alias);
> @@ -721,6 +723,13 @@ ev_add_map (char * dev, const char * alias,
> struct vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (update_map(mpp, vecs, 0))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* setup multipathd removed the map
> */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 1;

Should you make this conditional on mpp->prflag, perhaps?
After all, sda has already been added, sp prflag should should be set
if that was successful.

I think this should rather be added to update_map(). Ben?


> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vec=
tor_foreach_slot(mpp->paths, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if ((pp->state =3D=3D PATH_UP)=A0 || (pp-
> >state =3D=3D PATH_GHOST)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* persistent reseravtion
> check*/

Typo above.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpath_pr_event_handle(pp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_co=
nfig();
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0delayed_reconfig =3D conf=
->delayed_reconfig;


Thanks,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

