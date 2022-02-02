Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6584FC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 18:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643826974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LuzccCfl0yuVYrA6OGYJ7upUiDus50Ql6ufwFSYucU8=;
	b=JdNYPfeMbs6MIZX7pwQ4ppKkizIbGj4qC3y6eOB+YvlxU3nt6xow1jCJADKVLIt6oATEVj
	NQFIsCcwxgTYqN57o3Q08o7I47aJeoTVscWFkoKXDmk5BlU+fFPSQdNEUZBRG940nk/nST
	mMjDJ/sF6aJL8Olrveo0eANYoOPEXcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-NSjG93LQNQWXlJmC7neDLw-1; Wed, 02 Feb 2022 13:36:12 -0500
X-MC-Unique: NSjG93LQNQWXlJmC7neDLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74921193F594;
	Wed,  2 Feb 2022 18:35:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0375957F0D;
	Wed,  2 Feb 2022 18:35:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8C1CD1809CB8;
	Wed,  2 Feb 2022 18:35:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212IZq4s006106 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 13:35:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C1E451F439; Wed,  2 Feb 2022 18:35:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6679B9A32D;
	Wed,  2 Feb 2022 18:35:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 212IZoEa016257; 
	Wed, 2 Feb 2022 12:35:50 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 212IZnFm016254;
	Wed, 2 Feb 2022 12:35:49 -0600
Date: Wed, 2 Feb 2022 12:35:49 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20220202183549.GO24684@octiron.msp.redhat.com>
References: <20220123231325.21126-1-muneendra.kumar@broadcom.com>
	<09831bccc70c0b093b9d7128f3d198bc73cec66a.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <09831bccc70c0b093b9d7128f3d198bc73cec66a.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: "muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 02, 2022 at 03:31:54PM +0000, Martin Wilck wrote:
> Hello Muneendra,
>=20
> On Sun, 2022-01-23 at 15:13 -0800, Muneendra Kumar wrote:
> > This patch incorporates the functionality to handle
> > FPIN ELS events present as part of FCTransport daemon
> > (available in EPEL8) into the multipathd. This helps us to
> > reduce the response time to react and take the necessary actions
> > on receiving the FPIN events.
> >=20
> > This patch currently support FPIN-Li Events.
> >=20
> > It adds a new thread to listen for ELS frames from driver and on
> > receiving the frame payload, push the payload to a list and notify
> > the
> > fpin_els_li_consumer thread to process it.Once consumer thread is
> > notified, it returns to listen for more ELS frames from driver.
> >=20
> > The consumer thread process the ELS frames and moves the devices
> > paths
> > which are affected due to link integrity to marginal path groups.
> > This also sets the associated portstate to marginal.
> > The paths which are set to marginal path group will be unset
> > on receiving the RSCN events
> >=20
> > Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >=20
> > Notes:
> > =A0=A0=A0 V2:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Removed the newly added config option=
 and added a new
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 value "fpin" to the marginal_pathgrou=
ps option.
> > =A0=A0=A0=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Added support to handle the multipath=
d reconfigure case.
> > =A0=A0=A0=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Addressed the review comments from Ma=
rtin
> >=20
> > =A0Makefile.inc=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=A0 13 +
> > =A0libmultipath/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 5 =
+
> > =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 5=
6 ++-
> > =A0libmultipath/libmultipath.version |=A0=A0 1 +
> > =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 47 ++-
> > =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 7 +
> > =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 |=A0 19 +-
> > =A0multipathd/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1=
0 +
> > =A0multipathd/fpin.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 20 ++
> > =A0multipathd/fpin_handlers.c=A0=A0=A0=A0=A0=A0=A0 | 547
> > ++++++++++++++++++++++++++++++
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 43 ++-
> > =A011 files changed, 752 insertions(+), 16 deletions(-)
> > =A0create mode 100644 multipathd/fpin.h
> > =A0create mode 100644 multipathd/fpin_handlers.c
> >=20
>=20
>=20
> This looks good. I only have a few minor remarks, see below.
>=20
> Martin
>=20
> > +/*set/unset the path state to marginal*/
> > +static int fpin_set_pathstate(struct path *pp, bool set)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const char *action =3D set ? "set" : "unset";
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->mpp || !pp->mpp->alias)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0condlog(3, "\n%s: %s=A0 marginal path %s (fpin)",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action, pp->mpp->alias, p=
p->dev_t);
> > +=A0=A0=A0=A0=A0=A0=A0if (set)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->marginal =3D 1;
> > +=A0=A0=A0=A0=A0=A0=A0else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->marginal =3D 0;
>=20
> Nitpick: pp->marginal =3D set ?
>=20
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pp->mpp->fpin_must_reload =3D true;
> > +=A0=A0=A0=A0=A0=A0=A0return 0;
> > +
> > +}
> > +
> > +/* This will unset marginal state of a device*/
> > +static void fpin_path_unsetmarginal(char *devname, struct vectors
> > *vecs)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, devname);
> > +=A0=A0=A0=A0=A0=A0=A0if (!pp)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_devt(=
vecs->pathvec, devname);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0fpin_set_pathstate(pp, 0);
>=20
> Nitpick: as you use bool for "set", you should be using "false" and
> "true" when calling it.
>=20
> > +}
> > +
> > +/*This will set the marginal state of a device*/
> > +static int fpin_path_setmarginal(struct path *pp)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return fpin_set_pathstate(pp, 1);
> > +}
> > +
> > +/* Unsets all the devices in the list from marginal state */
> > +static void
> > +fpin_unset_marginal_dev(uint32_t host_num, struct vectors *vecs)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *tmp_marg =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0struct list_head *current_node =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0struct list_head *temp =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0struct multipath *mpp;
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0int i;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > +=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_marginal_dev_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_mutex,
> > &fpin_li_marginal_dev_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > +=A0=A0=A0=A0=A0=A0=A0if (list_empty(&fpin_li_marginal_dev_list_head)) =
{
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "Marginal List=
 is empty\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto empty;
> > +=A0=A0=A0=A0=A0=A0=A0}
>=20
> I don't think you need this. list_for_each_safe will be (almost) a noop
> in this case. Also, no need to log at level 3. that you aren't doing
> anything. Use level 4.
>=20
> > +=A0=A0=A0=A0=A0=A0=A0list_for_each_safe(current_node, temp,
> > &fpin_li_marginal_dev_list_head) {
>=20
> why not use list_for_each_entry_safe() here?
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tmp_marg =3D list_entry(c=
urrent_node,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0node);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (tmp_marg->host_num !=
=3D host_num)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, " unsetting ma=
rginal dev: is %s %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0tmp_marg->dev_t, tmp_marg->host_num);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpin_path_unsetmarginal(t=
mp_marg->dev_t, vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(current_node);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(tmp_marg);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +empty:
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_backwards(vecs->mpvec, mpp, i=
) {
>=20
> Any special reason why you walk the vector backwards?

reload_and_sync_map() can remove a item from vecs->mpvec.  Walking
backwards means we don't need to care.  The other option would be to
walk forwards but add "i--" whenver reload_and_sync_map() removes the
map.

-Ben

>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->fpin_must_reload=
) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D reload_and_sync_map(mpp, vecs, 0);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret =3D=3D 2)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "map removed during
> > reload");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0mpp->fpin_must_reload =3D false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +}
> > +
> > +/*
> > + * On Receiving the frame from HBA driver, insert the frame into
> > link
> > + * integrity frame list which will be picked up later by consumer
> > thread for
> > + * processing.
> > + */
> > +static int
> > +fpin_els_add_li_frame(struct fc_nl_event *fc_event)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_mrg =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (fc_event->event_datalen > FC_PAYLOAD_MAXLEN)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_mutex, &fpin_li_mute=
x);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > +=A0=A0=A0=A0=A0=A0=A0els_mrg =3D calloc(sizeof(struct els_marginal_lis=
t), 1);
>=20
> It doesn't matter much, but the struct size is the 2nd arg to calloc.
> I recommend "calloc(1, sizeof(*els_mrg))"
>=20
> > +=A0=A0=A0=A0=A0=A0=A0if (els_mrg !=3D NULL) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->host_num =3D fc_=
event->host_no;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->event_code =3D f=
c_event->event_code;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->length =3D fc_ev=
ent->event_datalen;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memcpy(els_mrg->payload, =
&(fc_event->event_data),
> > fc_event->event_datalen);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_add_tail(&els_mrg->n=
ode,
> > &els_marginal_list_head);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cond_signal(&fpin=
_li_cond);
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D -ENOMEM;
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0return ret;
> > +
> > +}
> > +
> > +/*Sets the rport port_state to marginal*/
> > +static void fpin_set_rport_marginal(struct udev_device *rport_dev)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(rport_dev, "port_state",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"Marginal", strlen("Marginal"));
> > +}
> > +
> > +/*Add the marginal devices info into the list*/
> > +static void
> > +fpin_add_marginal_dev_info(uint32_t host_num, char *devname)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *newdev =3D NULL;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0newdev =3D (struct marginal_dev_list *) calloc(1,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
izeof(struct marginal_dev_list));
>=20
> Nitpick: No need to cast here. Without the cast, the code fits on one
> line ;-)
>=20
> > +=A0=A0=A0=A0=A0=A0=A0if (newdev !=3D NULL) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0newdev->host_num =3D host=
_num;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strlcpy(newdev->dev_t, de=
vname, BLK_DEV_SIZE);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "\n%s hostno %=
d devname %s\n", __func__,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0host_num, newdev->dev_t);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_=
li_marginal_dev_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_add_tail(&(newdev->n=
ode),
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0&fpin_li_marginal_dev_list_head);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&fpi=
n_li_marginal_dev_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +}
> > +
> > +/*
> > + * This function goes through the vecs->pathvec, and for
> > + * each path, check that the host=A0 number,
> > + * the target WWPN associated with the path matches
> > + * with the els wwpn and sets the path and port state to
> > + * Marginal
> > + */
> > +static int=A0 fpin_chk_wwn_setpath_marginal(uint16_t host_num,=A0 stru=
ct
> > vectors *vecs,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uint64_t els_wwpn)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> > +=A0=A0=A0=A0=A0=A0=A0struct multipath *mpp;
> > +=A0=A0=A0=A0=A0=A0=A0int i, k;
> > +=A0=A0=A0=A0=A0=A0=A0char rport_id[42];
> > +=A0=A0=A0=A0=A0=A0=A0const char *value =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0struct udev_device *rport_dev =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0uint64_t wwpn;
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_lock, &vecs->lock);
> > +=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(vecs->pathvec, pp, k) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Checks the host number=
 and also for the SCSI FCP
> > */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->sg_id.proto_id !=
=3D SCSI_PROTOCOL_FCP ||
> > host_num !=3D=A0 pp->sg_id.host_no)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sprintf(rport_id, "rport-=
%d:%d-%d",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->sg_id.host_no, pp->sg_id.channel,
> > pp->sg_id.transport_id);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rport_dev =3D
> > udev_device_new_from_subsystem_sysname(udev,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"fc_remote_ports", rport_id);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!rport_dev) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "%s: No fc_remote_port device for
> > '%s'", pp->dev,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rport_id);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(_ude=
v_device_unref, rport_dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0value =3D udev_device_get=
_sysattr_value(rport_dev,
> > "port_name");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!value)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto unref;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (value)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0w=
wpn =3D=A0 strtol(value, NULL, 16);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * If the port wwpn match=
es sets the path and port
> > state
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * to marginal
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (wwpn =3D=3D els_wwpn)=
 {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D fpin_path_setmarginal(pp);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto unref;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
pin_set_rport_marginal(rport_dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
pin_add_marginal_dev_info(host_num, pp-
> > >dev);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +unref:
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_backwards(vecs->mpvec, mpp, i=
) {
>=20
> Again, why backwards?
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->fpin_must_reload=
) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D reload_and_sync_map(mpp, vecs, 0);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret =3D=3D 2)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "map removed during
> > reload");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0mpp->fpin_must_reload =3D false;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0return ret;
> > +}
> > +
> > +/*
> > + * This function loops around all the impacted wwns received as part
> > of els
> > + * frame and sets the associated path and port states to marginal.
> > + */
> > +static int
> > +fpin_parse_li_els_setpath_marginal(uint16_t host_num, struct
> > fc_tlv_desc *tlv,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0uint32_t wwn_count =3D 0, iter =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0uint64_t wwpn;
> > +=A0=A0=A0=A0=A0=A0=A0struct fc_fn_li_desc *li_desc =3D (struct fc_fn_l=
i_desc *)tlv;
> > +=A0=A0=A0=A0=A0=A0=A0int count =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* Update the wwn to list */
> > +=A0=A0=A0=A0=A0=A0=A0wwn_count =3D be32_to_cpu(li_desc->pname_count);
> > +=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got wwn count as %d\n", wwn_count);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0for (iter =3D 0; iter < wwn_count; iter++) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0wwpn =3D be64_to_cpu(li_d=
esc->pname_list[iter]);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D fpin_chk_wwn_setp=
ath_marginal(host_num, vecs,
> > wwpn);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "failed to set the path marginal
> > associated with wwpn: 0x%lx\n", wwpn);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0count++;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0return count;
> > +}
> > +
> > +/*
> > + * This function process the ELS frame received from HBA driver,
> > + * and sets the path associated with the port wwn to marginal
> > + * and also set the port state to marginal.
> > + */
> > +static int
> > +fpin_process_els_frame(uint16_t host_num, char *fc_payload, struct
> > vectors *vecs)
> > +{
> > +
> > +=A0=A0=A0=A0=A0=A0=A0int count =3D -1;
> > +=A0=A0=A0=A0=A0=A0=A0struct fc_els_fpin *fpin =3D (struct fc_els_fpin =
*)fc_payload;
> > +=A0=A0=A0=A0=A0=A0=A0struct fc_tlv_desc *tlv;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0tlv =3D (struct fc_tlv_desc *)&fpin->fpin_desc[0]=
;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/*
> > +=A0=A0=A0=A0=A0=A0=A0 * Parse the els frame and set the affected paths=
 and port
> > +=A0=A0=A0=A0=A0=A0=A0 * state to marginal
> > +=A0=A0=A0=A0=A0=A0=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0count =3D fpin_parse_li_els_setpath_marginal(host=
_num, tlv,
> > vecs);
> > +=A0=A0=A0=A0=A0=A0=A0if (count <=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Could not fin=
d any WWNs, ret =3D %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0count);
> > +=A0=A0=A0=A0=A0=A0=A0return count;
> > +}
> > +
> > +/*
> > + * This function process the FPIN ELS frame received from HBA
> > driver,
> > + * and push the frame to appropriate frame list. Currently we have
> > only FPIN
> > + * LI frame list.
> > + */
> > +static int
> > +fpin_handle_els_frame(struct fc_nl_event *fc_event)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D -1;
> > +=A0=A0=A0=A0=A0=A0=A0uint32_t els_cmd;
> > +=A0=A0=A0=A0=A0=A0=A0struct fc_els_fpin *fpin =3D (struct fc_els_fpin =
*)&fc_event-
> > >event_data;
> > +=A0=A0=A0=A0=A0=A0=A0struct fc_tlv_desc *tlv;
> > +=A0=A0=A0=A0=A0=A0=A0uint32_t dtag;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0els_cmd =3D (uint32_t)fc_event->event_data;
> > +=A0=A0=A0=A0=A0=A0=A0tlv =3D (struct fc_tlv_desc *)&fpin->fpin_desc[0]=
;
> > +=A0=A0=A0=A0=A0=A0=A0dtag =3D be32_to_cpu(tlv->desc_tag);
> > +=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got CMD in add as 0x%x fpin_cmd 0x%x =
dtag
> > 0x%x\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
ls_cmd, fpin->fpin_cmd, dtag);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if ((fc_event->event_code =3D=3D FCH_EVT_LINK_FPI=
N) ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(=
fc_event->event_code =3D=3D FCH_EVT_LINKUP) ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(=
fc_event->event_code =3D=3D FCH_EVT_RSCN)) {
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (els_cmd =3D=3D ELS_FP=
IN) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* Check the type of fpin by checking the tag
> > info
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* At present we are supporting only LI
> > events
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
*/
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (dtag =3D=3D ELS_DTAG_LNK_INTEGRITY) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/*Push the Payload to FPIN frame
> > queue. */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0ret =3D
> > fpin_els_add_li_frame(fc_event);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (ret !=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "Failed to proce=
ss
> > LI frame with error %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0ret);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}=
 else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Unsupported FPIN received
> > 0x%x\n", dtag);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*Push the Payload to FPIN frame queue. */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D fpin_els_add_li_frame(fc_event);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret !=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "Failed to process
> > Linkup/RSCN event with error %d evnt %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
, fc_event-
> > >event_code);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Invalid comma=
nd received: 0x%x\n",
> > els_cmd);
> > +=A0=A0=A0=A0=A0=A0=A0return ret;
> > +}
> > +
> > +/*cleans the global marginal dev list*/
> > +void fpin_clean_marginal_dev_list(__attribute__((unused)) void *arg)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *tmp_marg =3D NULL;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_marginal_dev_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0while (!list_empty(&fpin_li_marginal_dev_list_hea=
d)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tmp_marg=A0 =3D
> > list_first_entry(&fpin_li_marginal_dev_list_head,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list, node);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(&tmp_marg->node)=
;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(tmp_marg);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&fpin_li_marginal_dev_mutex)=
;
> > +}
> > +
> > +/* Cleans the global els=A0 marginal list */
> > +static void fpin_clean_els_marginal_list(void *arg)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct list_head *head =3D (struct list_head *)ar=
g;
> > +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_marg;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0while (!list_empty(head)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_marg=A0 =3D list_firs=
t_entry(head, struct
> > els_marginal_list,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 node);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(&els_marg->node)=
;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(els_marg);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +}
> > +
> > +static void rcu_unregister(__attribute__((unused)) void *param)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0rcu_unregister_thread();
> > +}
> > +/*
> > + * This is the FPIN ELS consumer thread. The thread sleeps on
> > pthread cond
> > + * variable unless notified by fpin_fabric_notification_receiver
> > thread.
> > + * This thread is only to process FPIN-LI ELS frames. A new thread
> > and frame
> > + * list will be added if any more ELS frames types are to be
> > supported.
> > + */
> > +void *fpin_els_li_consumer(void *data)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct list_head marginal_list_head;
> > +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> > +=A0=A0=A0=A0=A0=A0=A0uint16_t host_num;
> > +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_marg;
> > +=A0=A0=A0=A0=A0=A0=A0uint32_t event_code;
> > +=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs =3D (struct vectors *)data;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(rcu_unregister, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0rcu_register_thread();
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(fpin_clean_marginal_dev_list=
, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0INIT_LIST_HEAD(&marginal_list_head);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(fpin_clean_els_marginal_list=
,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0(void *)&marginal_list_head);
> > +=A0=A0=A0=A0=A0=A0=A0for ( ; ; ) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_=
li_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(clea=
nup_mutex, &fpin_li_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (list_empty(&els_margi=
nal_list_head))
>=20
> It is safer to use while (list_empty(...)) here, in case the wait is
> interrupted somehow.
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_cond_wait(&fpin_li_cond,
> > &fpin_li_mutex);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!list_empty(&els_marg=
inal_list_head)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(4, "Invoke List splice tail\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
ist_splice_tail_init(&els_marginal_list_head
> > , &marginal_list_head);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (!list_empty(&margi=
nal_list_head)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
ls_marg=A0 =3D
> > list_first_entry(&marginal_list_head,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0struct
> > els_marginal_list, node);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0h=
ost_num =3D els_marg->host_num;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
vent_code =3D els_marg->event_code;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* Now finally process FPIN LI ELS Frame */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(4, "Got a new Payload buffer,
> > processing it\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f ((event_code =3D=3D=A0 FCH_EVT_LINKUP) ||
> > (event_code =3D=3D FCH_EVT_RSCN))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 fpin_unset_marginal_dev(host_num,
> > vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0ret =3D
> > fpin_process_els_frame(host_num, els_marg->payload, vecs);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (ret <=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ELS frame
> > processing failed with ret %d\n", ret);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
ist_del(&els_marg->node);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
ree(els_marg);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +}
> > +
> > +static void receiver_cleanup_list(__attribute__((unused)) void *arg)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_mutex);
> > +=A0=A0=A0=A0=A0=A0=A0fpin_clean_els_marginal_list(&els_marginal_list_h=
ead);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&fpin_li_mutex);
> > +}
> > +
> > +/*
> > + * Listen for ELS frames from driver. on receiving the frame
> > payload,
> > + * push the payload to a list, and notify the fpin_els_li_consumer
> > thread to
> > + * process it. Once consumer thread is notified, return to listen
> > for more ELS
> > + * frames from driver.
> > + */
> > +void *fpin_fabric_notification_receiver(__attribute__((unused))void
> > *unused)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0int ret;
> > +=A0=A0=A0=A0=A0=A0=A0long fd;
> > +=A0=A0=A0=A0=A0=A0=A0uint32_t els_cmd;
> > +=A0=A0=A0=A0=A0=A0=A0struct fc_nl_event *fc_event =3D NULL;
> > +=A0=A0=A0=A0=A0=A0=A0struct sockaddr_nl fc_local;
> > +=A0=A0=A0=A0=A0=A0=A0unsigned char buf[DEF_RX_BUF_SIZE]
> > __attribute__((aligned(sizeof(uint64_t))));
> > +=A0=A0=A0=A0=A0=A0=A0size_t plen =3D 0;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(rcu_unregister, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0rcu_register_thread();
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(receiver_cleanup_list, NULL)=
;
> > +=A0=A0=A0=A0=A0=A0=A0fd =3D socket(PF_NETLINK, SOCK_DGRAM, NETLINK_SCS=
ITRANSPORT);
> > +=A0=A0=A0=A0=A0=A0=A0if (fd < 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "fc socket err=
or %ld", fd);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(close_fd, (void *)fd);
> > +=A0=A0=A0=A0=A0=A0=A0memset(&fc_local, 0, sizeof(fc_local));
> > +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_family =3D AF_NETLINK;
> > +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_groups =3D ~0;
> > +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_pid =3D getpid();
> > +=A0=A0=A0=A0=A0=A0=A0ret =3D bind(fd, (struct sockaddr *)&fc_local,
> > sizeof(fc_local));
> > +=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D -1) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "fc socket bin=
d error %d\n", ret);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0for ( ; ; ) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Waiting for E=
LS...\n");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D read(fd, buf, DEF=
_RX_BUF_SIZE);
>=20
> You should check the return value of read().
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got a new req=
uest %d\n", ret);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!NLMSG_OK((struct nlm=
sghdr *)buf, ret)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "bad els frame read (%d)", ret);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Push the frame to appr=
opriate frame list */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0plen =3D NLMSG_PAYLOAD((s=
truct nlmsghdr *)buf, 0);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fc_event =3D (struct fc_n=
l_event *)NLMSG_DATA(buf);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (plen < sizeof(*fc_eve=
nt)) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "too short (%d) to be an FC
> > event", ret);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_cmd =3D (uint32_t)fc_=
event->event_data;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got host no a=
s %d, event 0x%x, len %d
> > evntnum %d evntcode %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0fc_event->host_no, els_cmd, fc_event-
> > >event_datalen,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0fc_event->event_num, fc_event-
> > >event_code);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpin_handle_els_frame(fc_=
event);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +out:
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0return NULL;
> > +}
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 44ca5b12..6bc5178d 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -16,6 +16,7 @@
> > =A0#include <linux/oom.h>
> > =A0#include <libudev.h>
> > =A0#include <urcu.h>
> > +#include "fpin.h"
> > =A0#ifdef USE_SYSTEMD
> > =A0#include <systemd/sd-daemon.h>
> > =A0#endif
> > @@ -132,9 +133,11 @@ static bool __delayed_reconfig;
> > =A0pid_t daemon_pid;
> > =A0static pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;
> > =A0static pthread_cond_t config_cond;
> > -static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> > dmevent_thr;
> > +static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> > dmevent_thr,
> > +=A0=A0=A0=A0=A0=A0=A0fpin_thr, fpin_consumer_thr;
> > =A0static bool check_thr_started, uevent_thr_started,
> > uxlsnr_thr_started,
> > -=A0=A0=A0=A0=A0=A0=A0uevq_thr_started, dmevent_thr_started;
> > +=A0=A0=A0=A0=A0=A0=A0uevq_thr_started, dmevent_thr_started, fpin_thr_s=
tarted,
> > +=A0=A0=A0=A0=A0=A0=A0fpin_consumer_thr_started;
> > =A0static int pid_fd =3D -1;
> > =A0
> > =A0static inline enum daemon_status get_running_state(void)
> > @@ -2879,7 +2882,9 @@ reconfigure (struct vectors * vecs)
> > =A0=A0=A0=A0=A0=A0=A0=A0conf->sequence_nr =3D old->sequence_nr + 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0rcu_assign_pointer(multipath_conf, conf);
> > =A0=A0=A0=A0=A0=A0=A0=A0call_rcu(&old->rcu, rcu_free_config);
> > -
> > +#ifdef FPIN_EVENT_HANDLER
> > +=A0=A0=A0=A0=A0=A0=A0fpin_clean_marginal_dev_list(NULL);
> > +#endif
> > =A0=A0=A0=A0=A0=A0=A0=A0configure(vecs);
> > =A0
> > =A0
> > @@ -3098,6 +3103,11 @@ static void cleanup_threads(void)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(uevq_thr=
);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (dmevent_thr_started)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(dmevent_=
thr);
> > +=A0=A0=A0=A0=A0=A0=A0if (fpin_thr_started)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(fpin_thr);
> > +=A0=A0=A0=A0=A0=A0=A0if (fpin_consumer_thr_started)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(fpin_consu=
mer_thr);
> > +
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (check_thr_started)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(check_thr,=
 NULL);
> > @@ -3109,6 +3119,11 @@ static void cleanup_threads(void)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(uevq_thr, =
NULL);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (dmevent_thr_started)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(dmevent_th=
r, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0if (fpin_thr_started)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(fpin_thr, NU=
LL);
> > +=A0=A0=A0=A0=A0=A0=A0if (fpin_consumer_thr_started)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(fpin_consume=
r_thr, NULL);
> > +
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0 * As all threads are joined now, and we're in
> > DAEMON_SHUTDOWN
> > @@ -3202,6 +3217,7 @@ child (__attribute__((unused)) void *param)
> > =A0=A0=A0=A0=A0=A0=A0=A0char *envp;
> > =A0=A0=A0=A0=A0=A0=A0=A0enum daemon_status state;
> > =A0=A0=A0=A0=A0=A0=A0=A0int exit_code =3D 1;
> > +=A0=A0=A0=A0=A0=A0=A0int fpin_marginal_paths =3D 0;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0init_unwinder();
> > =A0=A0=A0=A0=A0=A0=A0=A0mlockall(MCL_CURRENT | MCL_FUTURE);
> > @@ -3280,7 +3296,10 @@ child (__attribute__((unused)) void *param)
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0setscheduler();
> > =A0=A0=A0=A0=A0=A0=A0=A0set_oom_adj();
> > -
> > +#ifdef FPIN_EVENT_HANDLER
> > +=A0=A0=A0=A0=A0=A0=A0if (conf->marginal_pathgroups =3D=3D MARGINAL_PAT=
HGROUP_FPIN)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpin_marginal_paths =3D 1=
;
> > +#endif
> > =A0=A0=A0=A0=A0=A0=A0=A0/*
> > =A0=A0=A0=A0=A0=A0=A0=A0 * Startup done, invalidate configuration
> > =A0=A0=A0=A0=A0=A0=A0=A0 */
> > @@ -3348,6 +3367,22 @@ child (__attribute__((unused)) void *param)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto failed;
> > =A0=A0=A0=A0=A0=A0=A0=A0} else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uevq_thr_started =3D tr=
ue;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (fpin_marginal_paths) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D pthread_creat=
e(&fpin_thr, &misc_attr,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
pin_fabric_notification_receiver, NULL))) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "failed to create the fpin
> > receiver thread: %d", rc);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto failed;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
pin_thr_started =3D true;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D pthread_creat=
e(&fpin_consumer_thr,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&=
misc_attr, fpin_els_li_consumer, vecs))) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "failed to create the fpin
> > consumer thread thread: %d", rc);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto failed;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0f=
pin_consumer_thr_started =3D true;
> > +=A0=A0=A0=A0=A0=A0=A0}
> > =A0=A0=A0=A0=A0=A0=A0=A0pthread_attr_destroy(&misc_attr);
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0while (1) {
>=20
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

