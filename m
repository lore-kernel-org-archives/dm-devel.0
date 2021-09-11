Return-Path: <SRS0=gcKN=OB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A50C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 11 Sep 2021 19:13:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1F25E6108B
	for <dm-devel@archiver.kernel.org>; Sat, 11 Sep 2021 19:13:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1F25E6108B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-A7IJZUjUMwa_RLA69D7_-Q-1; Sat, 11 Sep 2021 15:13:52 -0400
X-MC-Unique: A7IJZUjUMwa_RLA69D7_-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2A45343CF;
	Sat, 11 Sep 2021 19:13:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 500405C1D0;
	Sat, 11 Sep 2021 19:13:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8DDB21801241;
	Sat, 11 Sep 2021 19:13:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18BJDb1g030899 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 11 Sep 2021 15:13:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1C940202A426; Sat, 11 Sep 2021 19:13:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 183582026D64
	for <dm-devel@redhat.com>; Sat, 11 Sep 2021 19:13:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6600101A529
	for <dm-devel@redhat.com>; Sat, 11 Sep 2021 19:13:33 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-259-V2JnvT9XNd61RkjRGluSMQ-1; Sat, 11 Sep 2021 15:13:30 -0400
X-MC-Unique: V2JnvT9XNd61RkjRGluSMQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 893D11FF24;
	Sat, 11 Sep 2021 19:13:28 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2FCAD12FF7;
	Sat, 11 Sep 2021 19:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +FVoCNj/PGFaagAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 11 Sep 2021 19:13:28 +0000
Message-ID: <563ea01f3b28ff9b0d354a8159c20628ee882269.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Sat, 11 Sep 2021 21:13:27 +0200
In-Reply-To: <49a7d28b-697f-c862-1642-eac02adbaf42@huawei.com>
References: <298ae89f-6d47-546d-a87e-42e6563a17f2@huawei.com>
	<421bf852fdf9298bb5c0fd41e53adc1bff4e4050.camel@suse.com>
	<49a7d28b-697f-c862-1642-eac02adbaf42@huawei.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18BJDb1g030899
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2021-09-11 at 11:28 +0800, lixiaokeng wrote:
>=20
>=20
> On 2021/9/11 0:17, Martin Wilck wrote:
> > Hello lixiaokeng,
> >=20
> > thanks for your patch.
> >=20
> > On Fri, 2021-09-10 at 20:31 +0800, lixiaokeng wrote:
> > > There are two paths(sucu as sda and adb) for one LUN. The two
> > > paths log in, but before the two uevents have been processed
> > > (for example there are many uevent), users use multipathd add
> > > path /dev/sda to cause mpatha and use mpathpersist -o -I to
> > > register prkey for mpatha. The add map uevent is after add path
> > > uevent, the the uevent(add sdb) will delay and missing persistent
> > > reseravtion check.
> > >=20
> > > Here, we add persistent reseravtion check in ev_add_map if
> > > mpp->wait_for_udev > 1.
> > >=20
> > > Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> > > ---
> > > =A0multipathd/main.c | 9 +++++++++
> > > =A01 file changed, 9 insertions(+)
> > >=20
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index 3aff241d..ef456c34 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -706,6 +706,8 @@ ev_add_map (char * dev, const char * alias,
> > > struct vectors * vecs)
> > > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > > =A0=A0=A0=A0=A0=A0=A0=A0int delayed_reconfig, reassign_maps;
> > > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > > +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > > +=A0=A0=A0=A0=A0=A0=A0int i;
> > >=20
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (dm_is_mpath(alias) !=3D 1) {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: not a=
 multipath map", alias);
> > > @@ -721,6 +723,13 @@ ev_add_map (char * dev, const char * alias,
> > > struct vectors * vecs)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (update_map(mpp, vecs, 0))
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0/* setup multipathd removed the
> > > map
> > > */
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> >=20
> > Should you make this conditional on mpp->prflag, perhaps?
> > After all, sda has already been added, sp prflag should should be
> > set
> > if that was successful.
> >=20
> Hi Martin:
>=20
> Thanks for your reply. I will add conditional on mpp->prflag.
>=20
> > I think this should rather be added to update_map(). Ben?
>=20
> I have considered putting it after adopt_paths() in update_map().
> But I'm not sure which one is better. If you and Ben think adding
> to update_map() is better, I will move it to there.

update_map() is called from other places like missing_uev_wait_tick(),
where it would also make sense to try and register PR keys. AFAICS this
holds for all callers.

We may want to set flags on the paths, to track whether a path is
already registered, so that we don't have to repeat that operation for
already registered paths.

>=20
> Here is anotherthing. If two new paths(sdc) for maptha
> (with sda sdb path) log in. mpathpersist -o -I for mpatha, the
> sda and sdb will be registered. Before update_prflag() and
> update_prkey() in do_mpath_persistent_reserve_out, the uevent
> (add sdc) is finshed, then sdc will missing registering.
>=20
> This is just my theoretical analysis. I'm not sure if this is
> a real problem.

I think this could happen, yes. It makes me wonder again why we
we never try to register keys from multipathd itself, except when
paths are added to an already registered map. IMO we could change
the logic such that if a registration_key was specified for a given
map, multipathd could register that key, even if it was not found
already registered on the storage. Multipathd should of course not
try to create a reservation.

Martin

>=20
> >=20
> >=20
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0vector_foreach_slot(mpp->paths, pp, i) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((pp->state =3D=3D PATH_UP)=A0 ||
> > > (pp-
> > > > state =3D=3D PATH_GHOST)) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* persistent reseravtio=
n
> > > check*/
> >=20
> > Typo above.
> >=20
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpath_pr_event_handle(pp=
)
> > > ;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipat=
h_config();
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0delayed_reconfig =3D =
conf->delayed_reconfig;
> >=20
> >=20
> > Thanks,
> > Martin
> >=20
> > .
> >=20
>=20



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

