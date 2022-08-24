Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB1AC00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 07:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661324891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5tkt2JV5QLi872/eEA8HJOUAstpoFFeRsqV5Bzqh7I8=;
	b=Qd9qZYGmjYnlbNdrIjE5nCZi74AU8/7bNd0ul9ptCpweOHVhWB+vWAXYBrN0mf56qNuJ4A
	gts41i5e6g8wqm5hD/QJfefZVEe+/VrqrsK1AR6wxhAOjrfaRTmmEb2FiSoBhQ9tvlt0fD
	sPptCH/wOCRRcdblgu0Kfe61L4Lx85w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-kJAixglNNAeu8fuRCYUOtA-1; Wed, 24 Aug 2022 03:08:10 -0400
X-MC-Unique: kJAixglNNAeu8fuRCYUOtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 726F63806729;
	Wed, 24 Aug 2022 07:08:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5453B1121315;
	Wed, 24 Aug 2022 07:08:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 311EE1946A42;
	Wed, 24 Aug 2022 07:08:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28E731946A40
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 07:08:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B7421121319; Wed, 24 Aug 2022 07:08:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 076AD1121315
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 07:08:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0EF585A585
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 07:08:02 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-160-BjHGOST_O4Ws5XIKu8r0DA-1; Wed,
 24 Aug 2022 03:07:59 -0400
X-MC-Unique: BjHGOST_O4Ws5XIKu8r0DA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id AF4311FD9B;
 Wed, 24 Aug 2022 07:07:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F77D13780;
 Wed, 24 Aug 2022 07:07:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 5N5oHE3OBWPJQwAAMHmgww
 (envelope-from <mwilck@suse.com>); Wed, 24 Aug 2022 07:07:57 +0000
Message-ID: <a5018edd548f84cd7b49c97e3ae04b17ac2aaad4.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 24 Aug 2022 09:07:56 +0200
In-Reply-To: <20220823204803.GX10602@octiron.msp.redhat.com>
References: <20220818210630.19395-1-mwilck@suse.com>
 <20220818210630.19395-2-mwilck@suse.com>
 <20220823204803.GX10602@octiron.msp.redhat.com>
User-Agent: Evolution 3.44.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-08-23 at 15:48 -0500, Benjamin Marzinski wrote:
> On Thu, Aug 18, 2022 at 11:06:28PM +0200, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > If the mptable is very large (for example, in a configuration with
> > lots of maps assigned individual aliases), merge_mptable may get
> > very slow because it needs to make O(n^2) string comparisons (with
> > n being the number of mptable entries). WWID strings often differ
> > only in the last few bytes, causing a lot of CPU time spent in
> > strcmp().
> >=20
> > merge_mptable is executed whenever multipath or multipathd is
> > started, that
> > is, also for "multipath -u" and "multipath -U" invocations from
> > udev rules.
> > Optimize it by sorting the mptable before merging. This way we
> > don't need
> > to iterate towards the end of the vector searching for duplicates.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0libmultipath/config.c | 15 +++++++++++++--
> > =A0libmultipath/vector.c |=A0 8 ++++++++
> > =A0libmultipath/vector.h |=A0 1 +
> > =A03 files changed, 22 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/libmultipath/config.c b/libmultipath/config.c
> > index ab8b26e..a2c79a4 100644
> > --- a/libmultipath/config.c
> > +++ b/libmultipath/config.c
> > @@ -520,6 +520,14 @@ merge_mpe(struct mpentry *dst, struct mpentry
> > *src)
> > =A0=A0=A0=A0=A0=A0=A0=A0merge_num(mode);
> > =A0}
> > =A0
> > +static int wwid_compar(const void *p1, const void *p2)
> > +{
> > +=A0=A0=A0=A0=A0=A0=A0const char *wwid1 =3D (*(struct mpentry * const *=
)p1)->wwid;
> > +=A0=A0=A0=A0=A0=A0=A0const char *wwid2 =3D (*(struct mpentry * const *=
)p2)->wwid;
> > +
> > +=A0=A0=A0=A0=A0=A0=A0return strcmp(wwid1, wwid2);
> > +}
> > +
> > =A0void merge_mptable(vector mptable)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mpentry *mp1, *mp2;
> > @@ -533,10 +541,13 @@ void merge_mptable(vector mptable)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0free_mpe(mp1);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0continue;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0}
> > +=A0=A0=A0=A0=A0=A0=A0vector_sort(mptable, wwid_compar);
> > +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mptable, mp1, i) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0j =3D i + 1;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_aft=
er(mptable, mp2, j) {
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!mp2->wwid || strcmp(mp1->wwid, mp2-
> > >wwid))
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0continue;
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (strcmp(mp1->wwid, mp2->wwid))
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0break;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0condlog(1, "%s: duplicate multipath config
> > section for %s",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0__func__, mp1->wwid);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0merge_mpe(mp2, mp1);
>=20
> The way merge_mpe() works, values are only copied from mp1's
> variables
> if the corresponding variable is unset in mp2. This requires the
> original order of mp1 and mp2 to be unchanged by the sorting
> algorithm,
> but according to the qsort() man page "If two members compare as
> equal,
> their order in the sorted array is undefined."
>=20
> One quick and dirty way we could fix this is to add a variable to
> struct
> mptable called config_idx, which is its index in the config file.=A0 If
> the wwids are equal, you compare that.

Thanks for pointing this out. I believe it's easier than that: as we're
passed the offsets into the array (aka struct mpentry **), we can
simply compare p1 and p2 if the strings are equal.

Agree?

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

