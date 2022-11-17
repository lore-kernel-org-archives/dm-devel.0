Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C1D9C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 17 Nov 2022 20:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668717656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Iy+lde7WVqPdWe657DnS8IA5jh0j5UbE+3GJSvc4idA=;
	b=M3MTwU8GpF9sny5JkiPbSLTuUFUzPaitlBzvjtoi4+3h7+oVCK0a0WmUylZkG3g+HLZoJN
	08CrjknpY6XO8okADOKRJYY300iPqBPjS1zgplymaz8LL1naL3lBmkj/nHMZ3p42wHadkW
	MOfBeRZXI7eQ9x8fYV9fbqbPZKXjIYM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-tlIxwhqvPP6Ib_yjnxNrzA-1; Thu, 17 Nov 2022 15:40:52 -0500
X-MC-Unique: tlIxwhqvPP6Ib_yjnxNrzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FBCA8027EB;
	Thu, 17 Nov 2022 20:40:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 903EBC0297B;
	Thu, 17 Nov 2022 20:40:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C61319465A2;
	Thu, 17 Nov 2022 20:40:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 744821946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 17 Nov 2022 20:40:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1EB50111E403; Thu, 17 Nov 2022 20:40:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 15FCB111E3FF
 for <dm-devel@redhat.com>; Thu, 17 Nov 2022 20:40:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E416D29AA38B
 for <dm-devel@redhat.com>; Thu, 17 Nov 2022 20:40:32 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-61-lyvABomKMEquMBuO2H3EcQ-1; Thu,
 17 Nov 2022 15:40:29 -0500
X-MC-Unique: lyvABomKMEquMBuO2H3EcQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 97B6A1F8F2;
 Thu, 17 Nov 2022 20:40:27 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69A2813A12;
 Thu, 17 Nov 2022 20:40:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id v58vGDucdmMKFQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 17 Nov 2022 20:40:27 +0000
Message-ID: <32a8240e11ad76fa6d2f4547916a81d594200b1a.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 17 Nov 2022 21:40:26 +0100
In-Reply-To: <20221117185333.GT19568@octiron.msp.redhat.com>
References: <20221109211007.389-1-mwilck@suse.com>
 <20221117185333.GT19568@octiron.msp.redhat.com>
User-Agent: Evolution 3.46.0
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH] libmultipath: is_path_valid(): check if
 device is in use
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
Cc: fbui@suse.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-11-17 at 12:53 -0600, Benjamin Marzinski wrote:
> On Wed, Nov 09, 2022 at 10:10:07PM +0100, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > To check whether we will be able to add a given device can be part
> > of a multipath map, we have two tests in check_path_valid():
> > released_to_systemd() and the O_EXCL test. The former isn't helpful
> > if "multipath -u" is called for the first time for a given device,
> > and the latter is only used in the "find_multipaths smart" case,
> > because
> > actively opening the device with O_EXCL, even for a very short
> > time, is prone
> > to races with other processes.
> >=20
> > It turns out that this may cause issues in some scenarios. We saw
> > problems in
> > once case where "find_multipaths greedy" was used with a single
> > non-multipahted root disk and a very large number of multipath
> > LUNs.
> > The root disk would first be classified as multipath device.
> > multipathd
> > would try to create a map, fail (because the disk was mounted) and
> > trigger another uevent. But because of the very large number of
> > multipath
> > devices, this event was queued up behind thousands of other events,
> > and
> > the root device timed out eventually.
> >=20
> > While a simple workaround for the given problem would be proper
> > blacklisting
> > or using a different find_multipaths mode, I am proposing a
> > different
> > solution here. An additional test is added in is_path_valid() which
> > checks whether the given device is currently in use by 1. sysfs
> > holders,
> > 2. mounts (from /proc/self/mountinfo) or 3. swaps (from
> > /proc/swaps). 2.
> > and 3. are similar to systemd's device detection after switching
> > root.
> > This must not only be done for the device itself, but also for all
> > its
> > partitions. For mountinfo and swaps, libmount is utilized.
> >=20
> > With this patch, "multipath -u" will make devices with mounted or
> > otherwise
> > used partitions available to systemd early, without waiting for
> > multipathd
> > to fail setting up the map and re-triggering an uevent. This should
> > avoid
> > the issue described above even without blacklisting. The downside
> > of it
> > is a longer runtime of "multipath -u" for almost all devices, in
> > particular
> > for real multipath devices. The runtime required for the new checks
> > was in the
> > order of 0.1ms-1ms in my tests. Moreover, there is a certain risk
> > that devices may
> > wrongly classified as non-multipath because of transient mounts or
> > holders
> > created by other processes.
> >=20
>=20
> With greedy, we expect that the blacklists must be correctly set up,
> so
> we're just slowing things down to deal with people not configuring
> multipath correctly.=A0

Only in theory. Because of the failed-wwids logic, "greedy" works quite
well actually, even if the blacklist is not correctly set up.
With this as a special exception.

> But since I rarely see greedy configurations, I
> don't really have strong feelings about this trade-off.

I've been wondering whether we could make this depend on a config
option (yes I know, I've said often that we have too many of them).
We could also have it depend on "greedy". But it might also be useful
with "smart" if we have a lot of LUNs.

>=20
> More suggestions below.
>=20
> [...]
>=20
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push_cast(free_scandir_result, &s=
r);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* parts[0] is the whole disk */
> > +=A0=A0=A0=A0=A0=A0=A0if (vector_alloc_slot(parts) &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (prop =3D strdup(strrchr(path, '/') + 1=
)) !=3D NULL)
>=20
> Since we always add 1, prop can never be NULL.

Oops. I should rather check for prop !=3D ONE then :-)

>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_set_slot(parts, pr=
op);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0last =3D path + strlen(path);
> > +=A0=A0=A0=A0=A0=A0=A0for (i =3D 0; i < sr.n; i++) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct stat st;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* only add dirs that hav=
e the "partition"
> > attribute */
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0snprintf(last, sizeof(pat=
h) - (last - path),
> > "/%s/partition",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
sr.di[i]->d_name);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (stat(path, &st) =3D=
=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
rop =3D strdup(sr.di[i]->d_name);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (vector_alloc_slot(parts) && prop !=3D
> > NULL)
>=20
> We should probably check "prop !=3D NULL" first, so that we don't
> allocate
> a slot if we aren't going to use it.

Sure.

>=20
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_table, tbl);
> > +=A0=A0=A0=A0=A0=A0=A0cache =3D mnt_new_cache();
> > +=A0=A0=A0=A0=A0=A0=A0if (cache) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(clea=
nup_cache, cache);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mnt_table_set_cache(t=
bl, cache) =3D=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
tream =3D fopen(mountinfo, "r");
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (stream !=3D NULL) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_fclose
> > , stream);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0ret =3D mnt_table_parse_stream(tbl,
> > stream, mountinfo);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D 0 &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (used =3D check_mnt_table(parts,
> > tbl, "mountinfo")))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
>=20
> instead of having a break here, shouldn't be just check ret and call
> check_mkt_table if it's 0?

Sure. I guess this "break" translates into a noop. Strange that the
compiler didn't complain.

Thanks for the review,
Martin


>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0return used;
> > +}
> > +
> > +static int check_swaps(const struct _vector *parts)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0struct libmnt_table *tbl;
> > +=A0=A0=A0=A0=A0=A0=A0struct libmnt_cache *cache;
> > +=A0=A0=A0=A0=A0=A0=A0int used =3D 0, ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0tbl =3D mnt_new_table();
> > +=A0=A0=A0=A0=A0=A0=A0if (!tbl )
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -errno;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_table, tbl);
> > +=A0=A0=A0=A0=A0=A0=A0cache =3D mnt_new_cache();
> > +=A0=A0=A0=A0=A0=A0=A0if (cache) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(clea=
nup_cache, cache);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mnt_table_set_cache(t=
bl, cache) =3D=3D 0) {
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
et =3D mnt_table_parse_swaps(tbl, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (ret =3D=3D 0 &&
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 (used =3D check_mnt_table(parts, tbl,
> > "swaps")))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0break;
>=20
> Same break issue.
>=20
>=20
> -Ben
>=20
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +=A0=A0=A0=A0=A0=A0=A0return used;
> > +}
> > +
> > +/*
> > + * Given a block device, check if the device itself or any of its
> > + * partitions is in use
> > + * - by sysfs holders (e.g. LVM)
> > + * - mounted according to /proc/self/mountinfo
> > + * - used as swap
> > + */
> > +static int is_device_in_use(struct udev_device *udevice)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const char *syspath;
> > +=A0=A0=A0=A0=A0=A0=A0vector parts;
> > +=A0=A0=A0=A0=A0=A0=A0int used =3D 0, ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0syspath =3D udev_device_get_syspath(udevice);
> > +=A0=A0=A0=A0=A0=A0=A0if (!syspath)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ENOMEM;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0parts =3D vector_alloc();
> > +=A0=A0=A0=A0=A0=A0=A0if (!parts)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ENOMEM;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push_cast(free_strvec, parts);
> > +=A0=A0=A0=A0=A0=A0=A0if ((ret =3D read_partitions(syspath, parts)) =3D=
=3D 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0used =3D=A0 check_all_hol=
ders(parts) > 0 ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
heck_mountinfo(parts) > 0 ||
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
heck_swaps(parts) > 0;
> > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: %s is %sin use", __func__, syspat=
h, used ?
> > "" : "not ");
> > +=A0=A0=A0=A0=A0=A0=A0return used;
> > +}
> > +
> > =A0int
> > =A0is_path_valid(const char *name, struct config *conf, struct path
> > *pp,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool check_multipathd)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0int r;
> > =A0=A0=A0=A0=A0=A0=A0=A0int fd;
> > +=A0=A0=A0=A0=A0=A0=A0const char *prop;
> > =A0
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!pp || !name || !conf)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_ERROR;
> > @@ -80,6 +326,10 @@ is_path_valid(const char *name, struct config
> > *conf, struct path *pp,
> > =A0=A0=A0=A0=A0=A0=A0=A0if (!pp->udev)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_ERROR;
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0prop =3D udev_device_get_property_value(pp->udev,=
 "DEVTYPE");
> > +=A0=A0=A0=A0=A0=A0=A0if (prop =3D=3D NULL || strcmp(prop, "disk"))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_NOT_VALID;
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0r =3D pathinfo(pp, conf, DI_SYSFS | DI_WWID | D=
I_BLACKLIST);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D PATHINFO_SKIPPED)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_NOT_VALI=
D;
> > @@ -96,6 +346,9 @@ is_path_valid(const char *name, struct config
> > *conf, struct path *pp,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_ERROR;
> > =A0=A0=A0=A0=A0=A0=A0=A0}
> > =A0
> > +=A0=A0=A0=A0=A0=A0=A0if (is_device_in_use(pp->udev) > 0)
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_NOT_VALID;
> > +
>=20
> Can we make this only apply to "greedy"? For "strict", "no" and "yes"
> this makes the common case slower (you are running multipath on a
> machine with multipath devices that you've seen before) with no real
> benefit.
>=20
> It might also be useful to run this check before we return "maybe"
> for
> find_multipaths "smart", perhaps as an alternative to the O_EXCL test
> we
> currently use.
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0if (conf->find_multipaths =3D=3D FIND_MULTIPATH=
S_GREEDY)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_VALID;
> > =A0
> > diff --git a/tests/Makefile b/tests/Makefile
> > index 3a5b161..a0d3e1b 100644
> > --- a/tests/Makefile
> > +++ b/tests/Makefile
> > @@ -64,7 +64,7 @@ vpd-test_LIBDEPS :=3D -ludev -lpthread -ldl
> > =A0alias-test_TESTDEPS :=3D test-log.o
> > =A0alias-test_LIBDEPS :=3D -lpthread -ldl
> > =A0valid-test_OBJDEPS :=3D $(multipathdir)/valid.o
> > $(multipathdir)/discovery.o
> > -valid-test_LIBDEPS :=3D -ludev -lpthread -ldl
> > +valid-test_LIBDEPS :=3D -lmount -ludev -lpthread -ldl
> > =A0devt-test_LIBDEPS :=3D -ludev
> > =A0mpathvalid-test_LIBDEPS :=3D -ludev -lpthread -ldl
> > =A0mpathvalid-test_OBJDEPS :=3D $(mpathvaliddir)/mpath_valid.o
> > diff --git a/tests/valid.c b/tests/valid.c
> > index 398b771..9e7f719 100644
> > --- a/tests/valid.c
> > +++ b/tests/valid.c
> > @@ -83,6 +83,13 @@ struct udev_device
> > *__wrap_udev_device_new_from_subsystem_sysname(struct udev *u
> > =A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> > =A0}
> > =A0
> > +/* For devtype check */
> > +const char *__wrap_udev_device_get_property_value(struct
> > udev_device *udev_device, const char *property)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0check_expected(property);
> > +=A0=A0=A0=A0=A0=A0=A0return mock_ptr_type(char *);
> > +}
> > +
> > =A0/* For the "hidden" check in pathinfo() */
> > =A0const char *__wrap_udev_device_get_sysattr_value(struct
> > udev_device *udev_device,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *sysattr)
> > @@ -97,6 +104,12 @@ int __wrap_add_foreign(struct udev_device
> > *udev_device)
> > =A0=A0=A0=A0=A0=A0=A0=A0return mock_type(int);
> > =A0}
> > =A0
> > +/* For is_device_used() */
> > +const char *__wrap_udev_device_get_sysname(struct udev_device
> > *udev_device)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return mock_ptr_type(char *);
> > +}
> > +
> > =A0/* called from pathinfo() */
> > =A0int __wrap_filter_devnode(struct config *conf, const struct
> > _vector *elist,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 const char *vendor, const char * product,
> > const char *dev)
> > @@ -165,6 +178,11 @@ int __wrap_is_failed_wwid(const char *wwid)
> > =A0=A0=A0=A0=A0=A0=A0=A0return ret;
> > =A0}
> > =A0
> > +const char *__wrap_udev_device_get_syspath(struct udev_device
> > *udevice)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0return mock_ptr_type(char *);
> > +}
> > +
> > =A0int __wrap_check_wwids_file(char *wwid, int write_wwid)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0bool passed =3D mock_type(bool);
> > @@ -225,6 +243,8 @@ static void setup_passing(char *name, char
> > *wwid, unsigned int check_multipathd,
> > =A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_new_from_subsyst=
em_sysname,
> > true);
> > =A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_new_from_subsyst=
em_sysname,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 name);
> > +=A0=A0=A0=A0=A0=A0=A0expect_string(__wrap_udev_device_get_property_val=
ue,
> > property, "DEVTYPE");
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_get_property_value=
, "disk");
> > =A0=A0=A0=A0=A0=A0=A0=A0if (stage =3D=3D STAGE_GET_UDEV_DEVICE)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0if=A0 (stage =3D=3D STAGE_PATHINFO_REAL) {
> > @@ -250,6 +270,8 @@ static void setup_passing(char *name, char
> > *wwid, unsigned int check_multipathd,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_is_failed_wwid, WWID_IS_NOT_=
FAILED);
> > =A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_is_failed_wwid, wwid);
> > +=A0=A0=A0=A0=A0=A0=A0/* avoid real is_device_in_use() check */
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_get_syspath, NULL)=
;
> > =A0=A0=A0=A0=A0=A0=A0=A0if (stage =3D=3D STAGE_IS_FAILED)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> > =A0=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_check_wwids_file, false);
> > @@ -347,6 +369,30 @@ static void test_check_multipathd(void
> > **state)
> > =A0=A0=A0=A0=A0=A0=A0=A0assert_int_equal(is_path_valid(name, &conf, &pp=
, true),
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 PATH_IS_ERROR);
> > =A0=A0=A0=A0=A0=A0=A0=A0assert_string_equal(pp.dev, name);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* test pass because connect succeeded. succeed g=
etting
> > udev. Wrong DEVTYPE=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0memset(&pp, 0, sizeof(pp));
> > +=A0=A0=A0=A0=A0=A0=A0setup_passing(name, NULL, CHECK_MPATHD_RUNNING,
> > STAGE_CHECK_MULTIPATHD);
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_new_from_subsystem=
_sysname,
> > true);
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_new_from_subsystem=
_sysname,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 name);
> > +=A0=A0=A0=A0=A0=A0=A0expect_string(__wrap_udev_device_get_property_val=
ue,
> > property, "DEVTYPE");
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_get_property_value=
,
> > "partition");
> > +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(is_path_valid(name, &conf, &pp, =
true),
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
PATH_IS_NOT_VALID);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(pp.dev, name);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* test pass because connect succeeded. succeed g=
etting
> > udev. Bad DEVTYPE=A0 */
> > +=A0=A0=A0=A0=A0=A0=A0memset(&pp, 0, sizeof(pp));
> > +=A0=A0=A0=A0=A0=A0=A0setup_passing(name, NULL, CHECK_MPATHD_RUNNING,
> > STAGE_CHECK_MULTIPATHD);
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_new_from_subsystem=
_sysname,
> > true);
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_new_from_subsystem=
_sysname,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 name);
> > +=A0=A0=A0=A0=A0=A0=A0expect_string(__wrap_udev_device_get_property_val=
ue,
> > property, "DEVTYPE");
> > +=A0=A0=A0=A0=A0=A0=A0will_return(__wrap_udev_device_get_property_value=
, NULL);
> > +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(is_path_valid(name, &conf, &pp, =
true),
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
PATH_IS_NOT_VALID);
> > +=A0=A0=A0=A0=A0=A0=A0assert_string_equal(pp.dev, name);
> > =A0}
> > =A0
> > =A0static void test_pathinfo(void **state)
> > --=20
> > 2.38.0
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

