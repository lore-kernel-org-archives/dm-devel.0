From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 24 Sep 2014 14:21:57 +1000
Message-ID: <20140924142157.33475baa@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0615941180657162881=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--===============0615941180657162881==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/cpy2N5AUK6w9uFD1EoSa.VT";
	protocol="application/pgp-signature"

--Sig_/cpy2N5AUK6w9uFD1EoSa.VT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sep 2014 23:05:51 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Sep 23, 2014, at 9:20 PM, Martin K. Petersen wrote:
>=20
> >>>>>> "Neil" =3D=3D NeilBrown  <neilb@suse.de> writes:
> >=20
> > Neil,
> >=20
> > Several people have pointed out the issues with the reliability of
> > discard_zeroes_data in the past. My objection with Heinz' patch is
> > purely that we are perpetuating an interface that we have come to learn
> > that we can't entirely trust.
> >=20
> > Neil> If it is a "hint", then why isn't it
> > Neil> "discard_sometimes_zeroes_data"?
> >=20
> > Because at the time we put it in it was expected to be a solid
> > guarantee. However, as it turns out the spec is vaguely worded and only
> > says that the device must return zeroes if a block has been successfully
> > discarded. But since discard itself is only a hint the device is free to
> > silently ignore all or parts of the request. *sigh*
> >=20
> > There were several approaches being entertained in both T10 and T13
> > about how to tighten this up, including a FORCE bit that would cause the
> > device to return an error if parts of the request were being ignored. I
> > was hoping that we would be able to use that. However, the consensus at
> > the T10 meeting this summer was that WRITE SAME is the only reliable way
> > to ensure that zeroed blocks are returned. And the spec was amended to
> > clarify that.
> >=20
> > Neil> If a read from a discarded region doesn't reliably return zeros,
> > Neil> then raid5 cannot support discard.  Should I turn of discard
> > Neil> support in raid5?
> >=20
> > I've been on the fence about this for a while.
> >=20
> > The good news is that while the spec has been vague and many battles
> > fought in the standards bodies, most vendors are reasonably sane when it
> > comes to implementing this. We haven't had any corruption horror stories
> > from the field that I'm aware of. The first couple of generations of
> > SSDs were a travesty in this department but current devices behave
> > reasonably well. Hardware RAID vendors generally solve the RAID5 SSD
> > problem by explicitly whitelisting drives that are known to do the right
> > thing. Sadly we don't have a good device list. And for most drives the
> > discards only get dropped in rare corner cases so it's not trivial to
> > write a test tool to generate such a list.
> >=20
> > I was really hoping we'd get better guarantees from the standards folks
> > this summer. But as the spec is currently written switching to a WRITE
> > SAME bias in our discard heuristics may have the opposite effect of what
> > we desire. That's because the spec mandates that if a device can not
> > discard the blocks in the request it must write zeroes to them. IOW, we
> > get the determinism at the expense of potentially ending up writing the
> > blocks in question, thus increasing write wear. Probably not what we
> > want for the discard use case.
> >=20
> > I am in the process of tweaking the discard code to adhere to the August
> > 27th T10 SBC-4 draft. The net takeaway is that if you depend on reading
> > zeroes back you should be using blkdev_issue_zeroout() and not
> > blkdev_issue_discard(). raid5.c effectively needs to translate discard
> > requests from above to zeroouts below.
> >=20
> > I am torn between making blkdev_issue_zeroout() unprovision if possible
> > or having an explicit allocate flag. Some users only care about getting
> > zeroes back but others use blkdev_issue_zeroout() to preallocate blocks
> > (which is the current behavior).
> >=20
> > Right now we have:
> >=20
> >  discard		Unprovision, may or may not return zeroes
> >  zeroout		Provision, return zeroes
> >=20
> > We'll have to move to a model where we have a third variant:
> >=20
> >  discard		Unprovision, may or may not return zeroes
> >  zeroout, deallocate	Unprovision if possible, return zeroes
> >  zeroout, allocate     Provision, return zeroes
> >=20
> > The zeroout, deallocate variant would be enabled if the device supports
> > WRITE SAME w/UNMAP and has the LBPRZ flag set (and is not our libata
> > SATL).
> >=20
> > Discard is the bane of my existence :(

Thanks for the detailed explanation Martin!!
It seems that "discard" still comes with a strong "Caveat Emptor"
Sad.

>=20
> It's not really so bad if it doesn't return zero's, is it?  As long as it=
 returns the previous contents.  You mentioned that the discard was a hint =
- the drive may or may not discard the entire portion.  If that means the p=
ortions that are discarded will always return zero and the portions that ar=
en't will always return their previous contents, is there any problem?  The=
 real issue is randomness, no?  Could this be why "we haven't had any corru=
ption horror stories", or is it because we got lucky with sane vendors?

For RAID5 it is not acceptable to return "zeros or the original content".
This is because of the possibility of RMW cycles to update the parity block.
As "discard" the doesn't treat all blocks in a stripe in an identical way
will cause the parity block to become incorrect, and it will stay incorrect
through multiple RMW cycles until an RCW corrects it.
A device failure while the parity block is incorrect will lead to data
corruption.

The only real solution I can think of is to maintain an 'allocated' bitmap
and clear bits when DISCARDing.  When a write happens to a location that is
not 'allocated' the whole  bit worth gets resynced (or maybe zeroed-out).

Grumble.

Thanks again,
NeilBrown

--Sig_/cpy2N5AUK6w9uFD1EoSa.VT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCJG5Tnsnt1WYoG5AQIepBAAnfWgJ7vc/kCKVCF4DKHF7kIYINn5vVoC
lo6Oj6H+rxDX0T5Y8N8LGpd0FzVPTfrja/U5yd5IFSgsYCiN1ly2B5U140rQH/Gz
3DmyROll1uOSrsDrY0beV/7dhAWESSIYUPKCcESu0R49kxQNUeyYVuNGLHwDeYPf
bxdR0yBhxyW92qH65plLJyV0T32dlKg9Nhfi1AgosIj4Z3+C2UxZbJ2aGUG1f5TS
ToNW5YeptZyXK1VVdMU3lLFTPKfQSi3filRLuu+8Ad704d7njw97yRHHPhr55nOI
ulQrJyjY8zXAvUBT8rxSKXW9E+drbRNNQFKHXJ2J7LjU3uwiHhVeJnWz69HWpnrL
clVwZrdDw2GOvD7NIULKzVMshE3i00ETSsleW/TBSuiLJbJf2CNmQ03tqBWdlhj8
zI37KRzNLIaUMbi9kMsuNyu7JH6s/FmBvRujXRuaqqOgAp7IGOcne7fS5IrBfcOi
X2k57C6crSGPr+a35PK451DzDa6iRAK3yfGr3lTdkLcBjlj0pS7KNDp4x0yxCMOO
33xcpz5CJYEDQFGjhb1739+LbTHTgcwFQO5bEkO6+K/UH4c43+5xB0axJ/yAkCrL
rR1HaqLiRDWldI8l0ocQuf8O+ZVMqEpVx+4/6wKzcO0AgILRq53rPbo/E57BAgCL
o+8qpnD2b/g=
=3W4X
-----END PGP SIGNATURE-----

--Sig_/cpy2N5AUK6w9uFD1EoSa.VT--


--===============0615941180657162881==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0615941180657162881==--
