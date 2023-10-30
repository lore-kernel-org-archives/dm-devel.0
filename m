Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F24CD273;
	Mon, 30 Oct 2023 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="AyrxhP58";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gLgLdkDV"
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 92E9B5C0183;
	Mon, 30 Oct 2023 09:30:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 30 Oct 2023 09:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1698672657; x=1698759057; bh=cxRdquET5IcWw6tJN9ZPpELfajRwqkrG2nY
	Gfkr+4Hk=; b=AyrxhP58SgXnAJRviF2S7+Jd605s72LJBD7KEbs4C2EFnKrbMME
	MZHVA5sPPVxerKbQZFiKX7/cR0FkiVIf0FCvu8SkOH9q5rP0YhcPNcYtKEYEKFO6
	4cug8Y7gBi8gc9SXg2fdmx+0HO7+4uO5SbQ1g4gN3L/nxIXCe6tJNyBRqHFceEJD
	v1GcRwrocn9CjtmirDbYi79iH3Pd4MoNjoEUgPbRPuKXtYGx7kL7QkV6vFM43vz1
	VLm8QrwW7VA2vVM+CjrgUfg9+G6w1zmlEaQyAact1FDs7Jtw0OYnlhLa2evUvBuz
	4Cy8zo3eYMw3OOOyuGRWAKAeI9EdnpmSn/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1698672657; x=1698759057; bh=cxRdquET5IcWw
	6tJN9ZPpELfajRwqkrG2nYGfkr+4Hk=; b=gLgLdkDVRsEsGX1QkLKfJjL7Q8+D1
	NXEthBj9qSdAS1saceUm75sOOxgxoMsmGbE/hC1HD+pXP1ptT2KzcBbEqleZzuQB
	edh2ZUDVpW4W/BkyhNerYamcvqfw3OldW47/MQSPVgqmb2jdN6ASNVdwfaE9Fl5+
	arpM1o+6Bif5F2aj1A+uQ7NPRKJeem7rox9EOlSGYIDr4419WEatBXpID3TfroP0
	mVSr56oXgImnHZgFyQiRbbOgcWee2BuAv+n/Frh7t1spCxW0RwO6MR9v2foX8e0k
	BH2GxQttZ0d6Z21WKVfaYjG9D4LN6F8UDZkpQ1P7aDP9xvOAvL3lhlfdg==
X-ME-Sender: <xms:EbA_Zaa-1PprS7Lt5tAfFNDqjdGSHW58QZOxP9uIWGy1jqRvbEcN-Q>
    <xme:EbA_ZdZs3OwJmkC0epjwPUl4D8QZjC98WEvWwOY0kSVv-rr7xz8kX2FVU6NfD1FWz
    rZMoPgVMw0vuA>
X-ME-Received: <xmr:EbA_ZU_zSsQqgwBxS6ZDjwRnBVesttB-KAyimjTI6pkmIIDe30fDvSWJ6YWNWEoc_-ZXtEJBxJsiavYNBLF8kO9YOKjH76K8qbk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedruddttddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfdu
    leetfeevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghk
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:EbA_Zcr-Of5eeZhFXtGKsXnPP-7wf8LQfK5ey4g73hxT8oj0WGt4AA>
    <xmx:EbA_ZVq8FqR9H3BYTt1ndk5Hj22kCH7JCmE7TJx_TuZHOIHthlR5zg>
    <xmx:EbA_ZaSqxXo5FBkDMIJE6jKX2dYM06XPrijA5xRnI-w3-JmIam68AQ>
    <xmx:EbA_ZQ1mVFF2I9Gl5X03OcGItfH35YMYKH823_YGTSmZXSKviNGTOQ>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Oct 2023 09:30:55 -0400 (EDT)
Date: Mon, 30 Oct 2023 14:30:52 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Jan Kara <jack@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZT+wDLwCBRB1O+vB@mail-itl>
References: <e427823c-e869-86a2-3549-61b3fdf29537@redhat.com>
 <ZTiHQDY54E7WAld+@mail-itl>
 <ZTiJ3CO8w0jauOzW@mail-itl>
 <a413efbf-7194-95ff-562b-f2eb766ca5c1@redhat.com>
 <89320668-67a2-2a41-e577-a2f561e3dfdd@suse.cz>
 <818a23f2-c242-1c51-232d-d479c3bcbb6@redhat.com>
 <18a38935-3031-1f35-bc36-40406e2e6fd2@suse.cz>
 <3514c87f-c87f-f91f-ca90-1616428f6317@redhat.com>
 <1a47fa28-3968-51df-5b0b-a19c675cc289@suse.cz>
 <20231030122513.6gds75hxd65gu747@quack3>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gCkAclEDVL+x2a5T"
Content-Disposition: inline
In-Reply-To: <20231030122513.6gds75hxd65gu747@quack3>


--gCkAclEDVL+x2a5T
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 30 Oct 2023 14:30:52 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Jan Kara <jack@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5

On Mon, Oct 30, 2023 at 01:25:13PM +0100, Jan Kara wrote:
> On Mon 30-10-23 12:30:23, Vlastimil Babka wrote:
> > On 10/30/23 12:22, Mikulas Patocka wrote:
> > > On Mon, 30 Oct 2023, Vlastimil Babka wrote:
> > >=20
> > >> Ah, missed that. And the traces don't show that we would be waiting =
for
> > >> that. I'm starting to think the allocation itself is really not the =
issue
> > >> here. Also I don't think it deprives something else of large order p=
ages, as
> > >> per the sysrq listing they still existed.
> > >>=20
> > >> What I rather suspect is what happens next to the allocated bio such=
 that it
> > >> works well with order-0 or up to costly_order pages, but there's some
> > >> problem causing a deadlock if the bio contains larger pages than tha=
t?
> > >=20
> > > Yes. There are many "if (order > PAGE_ALLOC_COSTLY_ORDER)" branches i=
n the=20
> > > memory allocation code and I suppose that one of them does something =
bad=20
> > > and triggers this bug. But I don't know which one.
> >=20
> > It's not what I meant. All the interesting branches for costly order in=
 page
> > allocator/compaction only apply with __GFP_DIRECT_RECLAIM, so we can't =
be
> > hitting those here.
> > The traces I've seen suggest the allocation of the bio suceeded, and
> > problems arised only after it was submitted.
> >=20
> > I wouldn't even be surprised if the threshold for hitting the bug was n=
ot
> > exactly order > PAGE_ALLOC_COSTLY_ORDER but order > PAGE_ALLOC_COSTLY_O=
RDER
> > + 1 or + 2 (has that been tested?) or rather that there's no exact
> > threshold, but probability increases with order.
>=20
> Well, it would be possible that larger pages in a bio would trip e.g. bio
> splitting due to maximum segment size the disk supports (which can be e.g.
> 0xffff) and that upsets something somewhere. But this is pure
> speculation. We definitely need more debug data to be able to tell more.

I can collect more info, but I need some guidance how :) Some patch
adding extra debug messages?
Note I collect those via serial console (writing to disk doesn't work
when it freezes), and that has some limits in the amount of data I can
extract especially when printed quickly. For example sysrq-t is too much.
Or maybe there is some trick to it, like increasing log_bug_len?

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--gCkAclEDVL+x2a5T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmU/sAwACgkQ24/THMrX
1yxwsQf/d2OZw7uGhOAxJWWKmU7V9KAdnggbSzQwtPgo0j2PibTD6nyiIUlSMHqG
JXktV2ILonlsP+UnnzJHAVTUqjb8gM7g4+uvvYttZzEptfYojM8l73qOuB1uVYkM
9KHx8i8312uOZqj+XfCVrGzB9zLXogEfcgS2JhS2jAerL9SHiBTIipQleevcaDCm
PhFfV6eVTP9vvfaFqPcG/MtfwmJ99gws4FOj42mOyFkBqmQak4fCYdOZjk00LycW
WXBWwpHofgFZAjpOgP0AawHbGIUUYYME5rjYhlxjod1zGogMYRMPF/e+UALTh9Jp
/hJMOu9WMivsU9IA+oMklZT0rsV8bQ==
=4/SH
-----END PGP SIGNATURE-----

--gCkAclEDVL+x2a5T--
