Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54BEC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 07:01:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6434860F26
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 07:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6434860F26
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-Itf2S5yZPBSQ4oXNphaApg-1; Mon, 13 Sep 2021 03:01:31 -0400
X-MC-Unique: Itf2S5yZPBSQ4oXNphaApg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1153818414A2;
	Mon, 13 Sep 2021 07:01:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D11256D988;
	Mon, 13 Sep 2021 07:01:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 11E5F1800B8B;
	Mon, 13 Sep 2021 07:01:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18D71LVd030414 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Sep 2021 03:01:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 412242D475; Mon, 13 Sep 2021 07:01:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C16F5014A
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 07:01:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E763C101A52C
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 07:01:17 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-490-R2d7MnLANQiD9w1qeWkOqw-1; Mon, 13 Sep 2021 03:01:13 -0400
X-MC-Unique: R2d7MnLANQiD9w1qeWkOqw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 108131FD50;
	Mon, 13 Sep 2021 07:01:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BACCD13AE9;
	Mon, 13 Sep 2021 07:01:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id e5u4Kzf3PmE3KwAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 13 Sep 2021 07:01:11 +0000
Message-ID: <d8fa8e17f4ec92eba1e51c1054283688b294c9f0.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Mon, 13 Sep 2021 09:01:11 +0200
In-Reply-To: <c0ee4284-c2af-e7d4-29c0-fc800a8d2c94@huawei.com>
References: <c0ee4284-c2af-e7d4-29c0-fc800a8d2c94@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18D71LVd030414
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: Re: [dm-devel] [PATCH v2] multipathd: fix missing persistent
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello lixiaokeng,

On Mon, 2021-09-13 at 10:43 +0800, lixiaokeng wrote:
> There are two paths(sucu as sda and adb) for one LUN. The two
> paths log in, but before the two uevents have been processed
> (for example there are many uevent), users use multipathd add
> path /dev/sda to cause mpatha and use mpathpersist -o -I to
> register prkey for mpatha. The add map uevent is after add path
> uevent, the the uevent(add sdb) will delay and missing persistent
> reseravtion check.
>=20
> Here, we add persistent reseravtion check in update_map() which
> is called ev_add_map().
>=20
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>

Thank you, this looks ok to me. Have you tested it?

I'll wait for Ben's opinion nonetheless, because he's more exprerienced
with this part of the code than myself.

This said, I would like to have multipathd record which paths have
already registered the key, to avoid doing that repeatedly.

Additional question to Ben in this context: what's the reason that we
don't actively register keys (that we found in multipath.conf or
prkeys) during multipathd startup / reconfigure?

Regards
Martin



> ---
> =A0multipathd/main.c | 11 +++++++++++
> =A01 file changed, 11 insertions(+)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 3aff241d..1defeaf1 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -490,6 +490,8 @@ update_map (struct multipath *mpp, struct vectors
> *vecs, int new_map)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int retries =3D 3;
> =A0=A0=A0=A0=A0=A0=A0=A0char *params __attribute__((cleanup(cleanup_charp=
))) =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +=A0=A0=A0=A0=A0=A0=A0int i;
>=20
> =A0retry:
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: updating new map", mpp->alias);
> @@ -502,6 +504,15 @@ retry:
> =A0=A0=A0=A0=A0=A0=A0=A0verify_paths(mpp);
> =A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RELOAD;
>=20
> +=A0=A0=A0=A0=A0=A0=A0if (mpp->prflag) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->pa=
ths, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
((pp->state =3D=3D PATH_UP)=A0 || (pp->state =3D=3D
> PATH_GHOST)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0/* persistent reseravtion check*/
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0mpath_pr_event_handle(pp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0if (setup_map(mpp, &params, vecs)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: failed to=
 setup new map in update",
> mpp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retries =3D -1;



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

