From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Wed, 27 May 2015 09:06:40 +1000
Message-ID: <20150527090640.44c346e2@notabene.brown>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
	<20150526153414.GA31182@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cp2xcSEZDnlt4B7CsO6fyKB"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150526153414.GA31182@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: Ming Lin <mlin@kernel.org>, Mike Snitzer <snitzer@redhat.com>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Dave Chinner <dchinner@redhat.com>
List-Id: dm-devel.ids

--Sig_/cp2xcSEZDnlt4B7CsO6fyKB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2015 16:34:14 +0100 Alasdair G Kergon <agk@redhat.com> wrote:

> On Tue, May 26, 2015 at 08:02:08AM -0700, Ming Lin wrote:
> > Now bio_add_page() can build lager bios.
> > And blk_queue_split() can split the bios in ->make_request() if needed.
>=20
> But why not try to make the bio the right size in the first place so you
> don't have to incur the performance impact of splitting?

Because we don't know what the "right" size is.  And the "right" size can
change when array reconfiguration happens.

Splitting has to happen somewhere, if only in bio_addpage where it decides =
to
create a new bio rather than add another page to the current one.  So moving
the split to a different level of the stack shouldn't necessarily change the
performance profile.

Obviously testing is important to confirm that.

NeilBrown

>=20
> What performance testing have you yet done to demonstrate the *actual* im=
pact
> of this patchset in situations where merge_bvec_fn is currently a net ben=
efit?
>=20
> Alasdair
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/cp2xcSEZDnlt4B7CsO6fyKB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWT8gTnsnt1WYoG5AQLPchAAhrwL4XhtBInjN+nQIz3d88KQWPGzTZRx
5MEeBMrfDOHC4ZksJgdwcMb7x5SGz5Q86JOKuNfDP/f1njGWnhlgcuTcdhnHtMik
eJ0CtZ3X0asVh/1j+kdDYKD8Bz4oi9TYLIe5bA6mNAFhWtU5f4OhV3ahHNvwfery
ai99HYZORwf7/3LlwSvi8juWUK06iFqdowDkfnxmUnoHpXd8Enk0B7dcTHi9HBu6
z/xA3VSCcclEU8f7eSRn5/G+hV9626MPFknXhvAFfGSxDyLwSyWLdeVbbaqnbSDH
q3cZqtZk4whb5EobZVptZofTOna5q7/5u+FRPVESVeTSeov/c5eAvEndUaLxMNLQ
MsnOAk/KlVlSdU3CHPm0Rej7+5CpXaiLDia0zUo/vgOSAS7JzqHuYnSVvsH5yNQ2
Vkv7VZRr2WinZD5Z+l9SwE416A2POtvgTXrljIGcjon1ZUZQrUTk/zIUtVOIKflC
kmFOw+F1ApY3uio81hl3SZ4ABUqhlrRzRzJ/FP2hpYfnXV+QFo+lVXC0fODzyLS3
KS3ULL056oT1dMKf139INFGbgTLZXXYPzo4FQHr7d+rMlgB0p0f0zqh+kmEGdDhU
KBFt7pHcjKJWMV8kvlplLWfz9K/e3QtO5uScY3xJQTCJkqySxw+NRCQ4wGIdZOyw
DGnUcTRiXUo=
=YtUu
-----END PGP SIGNATURE-----

--Sig_/cp2xcSEZDnlt4B7CsO6fyKB--
