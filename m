From: NeilBrown <neilb@suse.com>
Subject: Re: WANTED new maintainer for Linux/md (and mdadm)
Date: Wed, 27 Jan 2016 10:01:16 +1100
Message-ID: <87powo2ber.fsf@notabene.neil.brown.name>
References: <87k2o849j5.fsf@notabene.neil.brown.name> <569F4505.6060308@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <569F4505.6060308@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain

On Wed, Jan 20 2016, Artur Paszkiewicz wrote:
>
> Hi Neil,
>
> Thank you for your work and time spent on maintaining MD/mdadm. I would also
> like to offer help for the emerging maintainership team. I've been working with
> MD RAID for more than 4 years, mostly testing and developing the IMSM-related
> parts on behalf of my employer - Intel. I realize that I was not very visible
> on this mailing list, but I think I have a pretty good knowledge about mdadm
> and the MD drivers. Now I have Intel's approval to take on maintaining MD RAID
> as part of my job, not focusing primarily on IMSM. I definitely feel more
> confident with maintaining mdadm, but I would certainly like to learn more
> about the kernel MD stack and help with it as much as I can.

Hi Arthur,
 thanks for all your IMSM work over the years!  It is great that you can
 continue contributing and do so more broadly.

 For the moment Jes Serensen will be co-ordinating mdadm (once I make a
 release ... tomorrow?) and Shaohua Li will be looking after the
 kernel/md side.  I'm sure there is plenty of room for you too though.
 Only one person (at a time) can queue patches, but several can
 collaborate at development and support and bug fixing and testing and
 ....
 I suggest you find ways to co-ordinate with them.

 This:
     https://bugzilla.kernel.org/show_bug.cgi?id=108741
 is currently most important in my mind, but there are other things to
 do.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWp/q8AAoJEDnsnt1WYoG5+jYQAIegWwNUoMDNm0oyXCWiiRXI
z8CxtFDteMlGutl2DjOwROS4HTdsasw1lAen9KSqRD5DeqyFqphsp+KrEjLBN/Yj
z9rYJ4oJZMDWQgNzBHyGrNwCzUStf8ntUHVS+AVFQN5+RV+IgRgd+4YhnsObSUn/
Pn/t9Vu5lnUK0fqXesEQ5gG9mqhkXnXeKSbrwPBw8GVMYrRO9ayDlIxmvyOkRGmc
a6gLpyIAij9+13CSmxq7eiL5FIbHv9QnOOUXM8cyUCVKNVCsWEJUr2RKl1MLGG3l
poMYfGb/pQwTvdD53lg/uy80grqoynQM0o+yfYH5b0BfIJ8ztgoOjquW7SL0x3xZ
AMHu6eJrhp35QZ9ILrdu0WWtxpzOHS40mYAUgJXeZWYBNNJrAlaGs4MCsWIpsLGg
SfIdzLDAcLXxHUr1dViNqP0lZTHbIj6d9glDMo1k8MWtWZWaAxWtA0v6obKZ1WOZ
LR4qYOntV80l0cHY5XoNibSUBDoa5e7OPMtZYpeMELOQnhushyJxWxUHx5up/2Of
/OM3hToNxOPI/BKbj+l/eNYQ6mlef1r78Tb5sG7LvVatrU9O1mPaRmDssrBIj+Ys
++376zd7fXygJ+5vD3V/bI1HnEhg3KfmD5d9Q1auiTozObNmA8ckWCMmF6DCB7BP
v3Ci3BOZ/U978TU3JsRu
=jxZ+
-----END PGP SIGNATURE-----
--=-=-=--
