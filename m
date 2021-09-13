Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5920EC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:23:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F05596103B
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:23:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F05596103B
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631546616;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hmCGxv6HD9cvmmDnIhDzHOErt20HdzwTRGRWyx+PcJE=;
	b=g7crgqN1X8kFWk9jdMukkTNjrBiNDTtACr+CF4a/SABMdT9tU8wSdawpoUcmbgP+pdaVfU
	xxKDg1n4yR/G8w5ObAfwbUPKO/B3F1kVdgxeOI/zIvtJenFA2MEqwjPIQoW5FIqFE9Draw
	jIwKEjHEzlC6KrL+Tbvw7JGIMkJPqig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-yknWtueyNE-QhjV7_zjtSg-1; Mon, 13 Sep 2021 11:23:34 -0400
X-MC-Unique: yknWtueyNE-QhjV7_zjtSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DB481808305;
	Mon, 13 Sep 2021 15:23:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72C176D98E;
	Mon, 13 Sep 2021 15:23:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 918E74E58F;
	Mon, 13 Sep 2021 15:23:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18DFNNTb025764 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Sep 2021 11:23:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 74FE76D986; Mon, 13 Sep 2021 15:23:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D44896D988;
	Mon, 13 Sep 2021 15:23:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18DFN6Nf022926; 
	Mon, 13 Sep 2021 10:23:06 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18DFN5Ik022925;
	Mon, 13 Sep 2021 10:23:05 -0500
Date: Mon, 13 Sep 2021 10:23:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20210913152305.GK3087@octiron.msp.redhat.com>
References: <298ae89f-6d47-546d-a87e-42e6563a17f2@huawei.com>
	<421bf852fdf9298bb5c0fd41e53adc1bff4e4050.camel@suse.com>
	<49a7d28b-697f-c862-1642-eac02adbaf42@huawei.com>
	<563ea01f3b28ff9b0d354a8159c20628ee882269.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <563ea01f3b28ff9b0d354a8159c20628ee882269.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: lixiaokeng <lixiaokeng@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>,
	linfeilong <linfeilong@huawei.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 11, 2021 at 09:13:27PM +0200, Martin Wilck wrote:
> On Sat, 2021-09-11 at 11:28 +0800, lixiaokeng wrote:
> >=20
> >=20
> > On 2021/9/11 0:17, Martin Wilck wrote:
> > > Hello lixiaokeng,
> > >=20
> > > thanks for your patch.
> > >=20
> > > On Fri, 2021-09-10 at 20:31 +0800, lixiaokeng wrote:
> > > > There are two paths(sucu as sda and adb) for one LUN. The two
> > > > paths log in, but before the two uevents have been processed
> > > > (for example there are many uevent), users use multipathd add
> > > > path /dev/sda to cause mpatha and use mpathpersist -o -I to
> > > > register prkey for mpatha. The add map uevent is after add path
> > > > uevent, the the uevent(add sdb) will delay and missing persistent
> > > > reseravtion check.
> > > >=20
> > > > Here, we add persistent reseravtion check in ev_add_map if
> > > > mpp->wait_for_udev > 1.
> > > >=20
> > > > Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> > > > ---
> > > > =A0multipathd/main.c | 9 +++++++++
> > > > =A01 file changed, 9 insertions(+)
> > > >=20
> > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > index 3aff241d..ef456c34 100644
> > > > --- a/multipathd/main.c
> > > > +++ b/multipathd/main.c
> > > > @@ -706,6 +706,8 @@ ev_add_map (char * dev, const char * alias,
> > > > struct vectors * vecs)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0int delayed_reconfig, reassign_maps;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> > > > +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > > > +=A0=A0=A0=A0=A0=A0=A0int i;
> > > >=20
> > > > =A0=A0=A0=A0=A0=A0=A0=A0if (dm_is_mpath(alias) !=3D 1) {
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: not=
 a multipath map", alias);
> > > > @@ -721,6 +723,13 @@ ev_add_map (char * dev, const char * alias,
> > > > struct vectors * vecs)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0if (update_map(mpp, vecs, 0))
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* setup multipathd removed the
> > > > map
> > > > */
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> > >=20
> > > Should you make this conditional on mpp->prflag, perhaps?
> > > After all, sda has already been added, sp prflag should should be
> > > set
> > > if that was successful.
> > >=20
> > Hi Martin:
> >=20
> > Thanks for your reply. I will add conditional on mpp->prflag.
> >=20
> > > I think this should rather be added to update_map(). Ben?
> >=20
> > I have considered putting it after adopt_paths() in update_map().
> > But I'm not sure which one is better. If you and Ben think adding
> > to update_map() is better, I will move it to there.
>=20
> update_map() is called from other places like missing_uev_wait_tick(),
> where it would also make sense to try and register PR keys. AFAICS this
> holds for all callers.
>=20
> We may want to set flags on the paths, to track whether a path is
> already registered, so that we don't have to repeat that operation for
> already registered paths.
>=20
> >=20
> > Here is anotherthing. If two new paths(sdc) for maptha
> > (with sda sdb path) log in. mpathpersist -o -I for mpatha, the
> > sda and sdb will be registered. Before update_prflag() and
> > update_prkey() in do_mpath_persistent_reserve_out, the uevent
> > (add sdc) is finshed, then sdc will missing registering.
> >=20
> > This is just my theoretical analysis. I'm not sure if this is
> > a real problem.
>=20
> I think this could happen, yes. It makes me wonder again why we
> we never try to register keys from multipathd itself, except when
> paths are added to an already registered map. IMO we could change
> the logic such that if a registration_key was specified for a given
> map, multipathd could register that key, even if it was not found
> already registered on the storage. Multipathd should of course not
> try to create a reservation.
>

Yeah. This is a real problem. I wonder if mpathpersist should try
delegating work to multipathd, like multipath does. I don't use
persistent reservations enough to know if it would be problematic to
have multipathd automatically register paths.  It would be different
from how persistent reservations work on scsi devices, and the original
idea for mpathpersist was to make persistent reservations on a multipath
device work just like they do on scsi devices (where devices appear with
no registrations, and you must register them).

-Ben
=20
> Martin
>=20
> >=20
> > >=20
> > >=20
> > > > +
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0vector_foreach_slot(mpp->paths, pp, i) {
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((pp->state =3D=3D PATH_UP)=A0 ||
> > > > (pp-
> > > > > state =3D=3D PATH_GHOST)) {
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* persistent reseravtio=
n
> > > > check*/
> > >=20
> > > Typo above.
> > >=20
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpath_pr_event_handle(pp=
)
> > > > ;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0}
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multip=
ath_config();
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0delayed_reconfig =
=3D conf->delayed_reconfig;
> > >=20
> > >=20
> > > Thanks,
> > > Martin
> > >=20
> > > .
> > >=20
> >=20
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

