Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60448C00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661364135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iEAddVM709A6Q7B6eFLL+Ra8Hhk6a1iyy723xwqdw1Q=;
	b=QM0HPoOrGrP8TsT1NDUkJQQfPAUOy4xirB8nLf4frBoCrVRNxACGK+d3kiSWxFusISprwT
	KLj8NIXT4LrFGkvsZHo7s4lUnuPJxpA+mnNAJRwnzcGreCee/GDkJBlvyFOTmLnE464RZG
	i2928TdItaaPSD30e2wInpw2ucxvLpA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-TNxNT8xON6SgTXphP0BLiQ-1; Wed, 24 Aug 2022 14:02:13 -0400
X-MC-Unique: TNxNT8xON6SgTXphP0BLiQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E43B218812CE;
	Wed, 24 Aug 2022 18:01:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8423C492CA6;
	Wed, 24 Aug 2022 18:01:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1AC4C1946A47;
	Wed, 24 Aug 2022 18:01:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7348E1946A42
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 17:02:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47DC32026D64; Wed, 24 Aug 2022 17:02:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4447E2026D4C
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 17:02:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 286F51010361
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 17:02:05 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-451-Mrk5VMZyMoSMduHnuFj4uw-1; Wed,
 24 Aug 2022 13:02:03 -0400
X-MC-Unique: Mrk5VMZyMoSMduHnuFj4uw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 0B854203F1;
 Wed, 24 Aug 2022 17:02:02 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C934313AE9;
 Wed, 24 Aug 2022 17:02:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id rLpxL4lZBmP2QgAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 24 Aug 2022 17:02:01 +0000
Message-ID: <652407ee47599cb45983890d20c07588743f2eaf.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 24 Aug 2022 19:02:01 +0200
In-Reply-To: <20220824161601.GB10602@octiron.msp.redhat.com>
References: <20220818210630.19395-1-mwilck@suse.com>
 <20220818210630.19395-2-mwilck@suse.com>
 <20220823204803.GX10602@octiron.msp.redhat.com>
 <a5018edd548f84cd7b49c97e3ae04b17ac2aaad4.camel@suse.com>
 <20220824161601.GB10602@octiron.msp.redhat.com>
User-Agent: Evolution 3.44.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 1/3] libmultipath: merge_mptable(): sort
 table by wwid
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-08-24 at 11:16 -0500, Benjamin Marzinski wrote:
> On Wed, Aug 24, 2022 at 09:07:56AM +0200, Martin Wilck wrote:
> > On Tue, 2022-08-23 at 15:48 -0500, Benjamin Marzinski wrote:
> > > On Thu, Aug 18, 2022 at 11:06:28PM +0200, mwilck@suse.com=A0wrote:
> > > > From: Martin Wilck <mwilck@suse.com>
> > > >=20
> > > > If the mptable is very large (for example, in a configuration
> > > > with
> > > > lots of maps assigned individual aliases), merge_mptable may
> > > > get
> > > > very slow because it needs to make O(n^2) string comparisons
> > > > (with
> > > > n being the number of mptable entries). WWID strings often
> > > > differ
> > > > only in the last few bytes, causing a lot of CPU time spent in
> > > > strcmp().
> > > >=20
> > > > merge_mptable is executed whenever multipath or multipathd is
> > > > started, that
> > > > is, also for "multipath -u" and "multipath -U" invocations from
> > > > udev rules.
> > > > Optimize it by sorting the mptable before merging. This way we
> > > > don't need
> > > > to iterate towards the end of the vector searching for
> > > > duplicates.
> > > >=20
> > > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > > ---
> > > > =A0libmultipath/config.c | 15 +++++++++++++--
> > > > =A0libmultipath/vector.c |=A0 8 ++++++++
> > > > =A0libmultipath/vector.h |=A0 1 +
> > > > =A03 files changed, 22 insertions(+), 2 deletions(-)
> > > >=20
> > > > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > > > index ab8b26e..a2c79a4 100644
> > > > --- a/libmultipath/config.c
> > > > +++ b/libmultipath/config.c
> > > > @@ -520,6 +520,14 @@ merge_mpe(struct mpentry *dst, struct
> > > > mpentry
> > > > *src)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(mode);
> > > > =A0}
> > > > =A0
> > > > +static int wwid_compar(const void *p1, const void *p2)
> > > > +{
> > > > +=A0=A0=A0=A0=A0=A0=A0const char *wwid1 =3D (*(struct mpentry * con=
st *)p1)-
> > > > >wwid;
> > > > +=A0=A0=A0=A0=A0=A0=A0const char *wwid2 =3D (*(struct mpentry * con=
st *)p2)-
> > > > >wwid;
> > > > +
> > > > +=A0=A0=A0=A0=A0=A0=A0return strcmp(wwid1, wwid2);
> > > > +}
> > > > +
> > > > =A0void merge_mptable(vector mptable)
> > > > =A0{
> > > > =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry *mp1, *mp2;
> > > > @@ -533,10 +541,13 @@ void merge_mptable(vector mptable)
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0free_mpe(mp1);
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0continue;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > > +=A0=A0=A0=A0=A0=A0=A0}
> > > > +=A0=A0=A0=A0=A0=A0=A0vector_sort(mptable, wwid_compar);
> > > > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mptable, mp1, i) {
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0j =3D i + 1;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot=
_after(mptable, mp2, j) {
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (!mp2->wwid || strcmp(mp1->wwid,
> > > > mp2-
> > > > > wwid))
> > > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0continue;
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0if (strcmp(mp1->wwid, mp2->wwid))
> > > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0condlog(1, "%s: duplicate multipath
> > > > config
> > > > section for %s",
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__func__, mp1->wwid);
> > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0merge_mpe(mp2, mp1);
> > >=20
> > > The way merge_mpe() works, values are only copied from mp1's
> > > variables
> > > if the corresponding variable is unset in mp2. This requires the
> > > original order of mp1 and mp2 to be unchanged by the sorting
> > > algorithm,
> > > but according to the qsort() man page "If two members compare as
> > > equal,
> > > their order in the sorted array is undefined."
> > >=20
> > > One quick and dirty way we could fix this is to add a variable to
> > > struct
> > > mptable called config_idx, which is its index in the config
> > > file.=A0 If
> > > the wwids are equal, you compare that.
> >=20
> > Thanks for pointing this out. I believe it's easier than that: as
> > we're
> > passed the offsets into the array (aka struct mpentry **), we can
> > simply compare p1 and p2 if the strings are equal.
> >=20
> > Agree?
>=20
> I don't think so. Comparing the array offsets assumes that two
> mpentries
> are still ordered correctly when they are compared against each
> other.
> But the way quick sort works, array elements can get swapped around
> multiple times, based on whether they are larger or smaller than some
> pivot point. It's possible that the two mpentries already switched
> order
> before they were compared.
>=20
> Essentially, all comparing the offset does is force qsort to not
> switch
> the place of two otherwise equal entries. But for speed reasons
> alone,
> there is no reason why qsort would bother to swap the location of two
> equal entries.=A0=20
>=20
> Here's an example of what could go wrong:
>=20
> Say you start with the array (I'm also tracking the mpentry's
> original
> config index)
>=20
> array offset:=A0=A0=A00=A0=A0=A0=A0=A0=A0=A01=A0=A0=A0=A0=A0=A0=A02=A0=A0=
=A0=A0=A0=A0=A03=A0=A0=A0=A0=A0=A0=A04
> config_idx:=A0=A0=A0=A0=A00=A0=A0=A0=A0=A0=A0=A01=A0=A0=A0=A0=A0=A0=A02=
=A0=A0=A0=A0=A0=A0=A03=A0=A0=A0=A0=A0=A0=A04
> wwid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0D=A0=A0=A0=A0=A0=A0=A0B=A0=A0=A0=A0=
=A0=A0=A0C=A0=A0=A0=A0=A0=A0=A0D=A0=A0=A0=A0=A0=A0=A0A=A0=A0=A0=A0=A0=A0=A0
>=20
> Say qsort picks the element at array offset 2 (wwid "C") as the
> pivot.
> Usually quicksort works by walking towards the center of the array
> segment from both ends, swapping the positions of elements bigger
> than
> the pivot with the positions of ones smaller than or equal to the
> pivot.
> So after the first round you would swap the element at array offset 4
> (wwid "A") with the element at array offset 0 (wwid "D"). This would
> give you.
>=20
> array offset:=A0=A0=A00=A0=A0=A0=A0=A0=A0=A01=A0=A0=A0=A0=A0=A0=A02=A0=A0=
=A0=A0=A0=A0=A03=A0=A0=A0=A0=A0=A0=A04
> config_idx=A0=A0=A0=A0=A0=A04=A0=A0=A0=A0=A0=A0=A01=A0=A0=A0=A0=A0=A0=A02=
=A0=A0=A0=A0=A0=A0=A03=A0=A0=A0=A0=A0=A0=A00
> wwid:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0A=A0=A0=A0=A0=A0=A0=A0B=A0=A0=A0=A0=
=A0=A0=A0C=A0=A0=A0=A0=A0=A0=A0D=A0=A0=A0=A0=A0=A0=A0D
>=20
> After this no further swaps will happen using the original
> wwid_compar(). Adding a comparison to the array offset won't change
> anything. But the wwid "D" mpentry that was orinally earlier in the
> config (config_idx =3D 0) is now after the wwid "D" mpentry that was
> originally later (config_idx =3D 3).
>=20
> Comparing the config_idx will cause the elements at array offset 3
> and 4
> to switch places, restoring their original ordering.

Hm, too bad.=20

I don't like the idea of adding another field to the array just to
stabilize the sort. But a fast, stable sort algorithm in for strings in
C seems to be hard to find. So yes, let's add the sort index for now,
perhaps we'll find a more elegant solution later.


Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

