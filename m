From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID:  Add support for MD RAID10 personality
Date: Wed, 11 Jul 2012 10:08:10 +1000
Message-ID: <20120711100810.234a0d3e@notabene.brown>
References: <1340712231.19015.42.camel@f16>
	<20120704112159.36cdb42a@notabene.brown>
	<262AC9F3-56D9-48A8-8A03-32D6B81D4689@redhat.com>
	<20120704151537.7c91076d@notabene.brown>
	<5DAA9465-E7B1-4F61-A559-745D653048C2@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Y3ojl9/.bADm6IVO4=dKmAC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5DAA9465-E7B1-4F61-A559-745D653048C2@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/Y3ojl9/.bADm6IVO4=dKmAC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jul 2012 14:27:30 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Jul 4, 2012, at 12:15 AM, NeilBrown wrote:
>=20
> >>=20
> >> I like your suggestion of changing the parameter names.  I've found th=
e original names somewhat confusing.  ('far_offset' seems to imply to me th=
at the copy would not be the very next stripe, but _offset_ somehow - it se=
ems to have the reverse meaning to me.  I think this comes from the fact th=
at it acts as a modifier to 'far_copy'.)  I toyed with a couple different w=
ays of doing this but figured it was best to just go along.  Anyway, what y=
ou are suggesting seems to be:
> >> 	raid10_copies <number> (Default: 2)
> >> 	raid10_layout <string> (Default: "near"/"adjacent")
> >> Where <string> could be "near", "far", "offset" and "some-future-thing=
".  That seems nice to me and seems to clear up some of the confusion cause=
d by "far_offset" seeming to be a modifier to "far_copies".
> >=20
> > Yes, that is what I'm suggesting.
>=20
> One problem with this approach is that users can no longer mix and match.=
  They can't have 2 near copies and 2 far copies, for example.  Perhaps som=
eone might choose this layout for read balancing performance...

I came across a bit of code in raid10 recently which would not work properly
in at least some combinations of  near>1 and far>1.  It might have been only
when 'raid_disks' was not divisible by 'near' - I'd have to check.

Obviously I don't *know* that no-one ever uses a layout like this, but I've
never heard of one.  Only rarely do people have 3 copies.  Having 4 seems
excessive.
So while I cannot safely change mdadm to reject the combination I have no
concern about never allowing the combination with dm-raid.  (are there enou=
gh
double-negatives there?).

I think we should keep it simple.  Copies + layout.  Anything more complex
doesn't - in my opinion - bring any real value at all.

NeilBrown


>=20
> The original method didn't allow for two different simultaneous "far" alg=
orithms (because it would add no redundancy unless they were shifted from e=
ach other as well as the original), but this new way of specifying makes it=
 worse.
>=20
> Do you see this as a problem?  If so, we need to find a way to specify th=
e number of copies for each layout /and/ include the potential for "double-=
shift" vs "single-shift" or some further variant.  One idea I had before wa=
s:
> 	raid10_near_copies <#>
> 	raid10_far_copies <#>
> 	raid10_stripe_copies <#>  (similar to far+offset, but still allows for s=
imultaneous "far" w/o "offset")
> To allow for the different variants of "shifting", we could have differen=
t raid10 variants, like "raid10_2s" or "raid1e_2s" - similar to the extensi=
ons on RAID5 ("raid5_ls") that you don't like.  :)
>=20
>  brassow--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Y3ojl9/.bADm6IVO4=dKmAC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/zD6jnsnt1WYoG5AQKp2A/8C6Pak+8LCs+iwnawcofbGwmMYadOhuXI
qMMTnXO6vO//hFXy+xhjlkKBnDEh5vJ6WEqQNsdpB7IUrXOjTy7rxpdWiPlVvr1q
vnx2STkyvHxGpUbI958aJeC4qquEAj+O9CyMnEdlsLZAYrZWyYJmaacvAhksnAux
IvbVdV7rdi+SJOS2d1r5LCHxD88iVpM+T51olqyxrsZWE9xB/2mIVg+JP1lc41QP
yPSniSaOM33CBxP9vzkH/rhdNBSenOslLtcmXT7wK8qpjQtFIhcF0PSKxUuSqA6T
vU7KhFuG1qrk4QGTyENDM8C0S4wp/xbIgIOr2Shvlr7GcDUNPoLVlLgHETSACzdY
TXhc1rfl3VQVxBnU2jGQKrq9/P/+bRZ4du8UQAEF13t11+4jOVs66XCSO8xCWj0h
/htYAQUKOqLBhyCWIakxPWqUoHtTJNDPDCU0bIp1Pw2GZuilrCzdm/n+2eKSxiWN
dEi2qk2DabCyyn4X8ZStxYOwQ4C9gxFnHp/n+UKv30+9LMGno2z98wVEJUnm66AH
m9Fh6PiMbrZCjHb3viF6y8rdBapzcLTI09vrX8s9c8qGMLHYcU6EheaKNsIYSciy
O4qyLVsb7HbCQUAdf2UDHz79Y/BiE+HbapJMfj8wZgQM0uJgQeqxiHN1dADf1c9K
F1H6vV4iFt8=
=MdMi
-----END PGP SIGNATURE-----

--Sig_/Y3ojl9/.bADm6IVO4=dKmAC--
