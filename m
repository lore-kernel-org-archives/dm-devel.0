From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 04/23] block: Abstract out bvec iterator
Date: Thu, 31 Oct 2013 14:29:36 +1100
Message-ID: <20131031142936.63727342@notabene.brown>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
	<1383077896-4132-5-git-send-email-kmo@daterainc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5234300970751444966=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383077896-4132-5-git-send-email-kmo@daterainc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kmo@daterainc.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>, Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>, Jan Beulich <jbeulich@suse.com>, "Ed L. Cashin" <ecashin@coraid.com>, "Michael S. Tsirkin" <mst@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Selvan Mani <smani@micron.com>, Namjae Jeon <namjae.jeon@samsung.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <chris.mason@fusionio.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Ian Campbell <Ian.Campbell@citrix.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Alasdair Kergon <agk@redhat.com>, Nick Piggin <npiggin@kernel.dk>, Roger Pau =?UTF-8?B?TW9ubsOp?= <roger.pau@citrix.com>
List-Id: dm-devel.ids

--===============5234300970751444966==
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/bF/+0261ZWlTgozZbA48+3r";
	protocol="application/pgp-signature"

--Sig_/bF/+0261ZWlTgozZbA48+3r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Oct 2013 13:17:57 -0700 Kent Overstreet <kmo@daterainc.com> wrot=
e:

> Immutable biovecs are going to require an explicit iterator. To
> implement immutable bvecs, a later patch is going to add a bi_bvec_done
> member to this struct; for now, this patch effectively just renames
> things.
>=20
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>


> diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.=
txt
> index 8df5e8e..2101e71 100644
> --- a/Documentation/block/biodoc.txt
> +++ b/Documentation/block/biodoc.txt
> @@ -447,14 +447,13 @@ struct bio_vec {
>   * main unit of I/O for the block layer and lower layers (ie drivers)
>   */
>  struct bio {
> -       sector_t            bi_sector;
>         struct bio          *bi_next;    /* request queue link */
>         struct block_device *bi_bdev;	/* target device */
>         unsigned long       bi_flags;    /* status, command, etc */
>         unsigned long       bi_rw;       /* low bits: r/w, high: priority=
 */
> =20
>         unsigned int	bi_vcnt;     /* how may bio_vec's */
> -       unsigned int	bi_idx;		/* current index into bio_vec array */
> +       struct bvec_iter	bi_iter;	/* current index into bio_vec array */
> =20
>         unsigned int	bi_size;     /* total size in bytes */
>         unsigned short 	bi_phys_segments; /* segments after physaddr coal=
esce*/
> @@ -480,7 +479,7 @@ With this multipage bio design:
>  - Code that traverses the req list can find all the segments of a bio
>    by using rq_for_each_segment.  This handles the fact that a request
>    has multiple bios, each of which can have multiple segments.
> -- Drivers which can't process a large bio in one shot can use the bi_idx
> +- Drivers which can't process a large bio in one shot can use the bi_iter
>    field to keep track of the next bio_vec entry to process.
>    (e.g a 1MB bio_vec needs to be handled in max 128kB chunks for IDE)
>    [TBD: Should preferably also have a bi_voffset and bi_vlen to avoid mo=
difying
> @@ -589,7 +588,7 @@ driver should not modify these values. The block laye=
r sets up the
>  nr_sectors and current_nr_sectors fields (based on the corresponding
>  hard_xxx values and the number of bytes transferred) and updates it on
>  every transfer that invokes end_that_request_first. It does the same for=
 the
> -buffer, bio, bio->bi_idx fields too.
> +buffer, bio, bio->bi_iter fields too.
> =20
>  The buffer field is just a virtual address mapping of the current segment
>  of the i/o buffer in cases where the buffer resides in low-memory. For h=
igh

Would it make sense to add some details of "bvec_iter" to this document?

Or will that come later?

NeilBrown

--Sig_/bF/+0261ZWlTgozZbA48+3r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnHOoDnsnt1WYoG5AQKAog//cNxNO7n4EheLQg3FVtX4edv6npapiTlQ
IuJ8LixK5hK5kx0hDsPaK78n6ZLs3DADc6/d3HtLc33L90l2WhWUMm8SiJowacKu
HemHPkt/dmUGvCWL1eaoPA2TVAvrIELUCKaMjQOe6s1eAamthbINelirjFtBpj/p
bX6KyU/eYMiBrS0QqpXE0oeOnUj1qrC0Too9qCGA9wKL8SIOXB8fZ4+kxi9qyYZk
bShLMjvvkouYMq4wSnz9ZdekQIA0XjS8S8ui4idKXzwrXq23aJbJT/JTQ+tprXhN
Wa2N4bwo/EI36xIvGsqx1eu1rmOqmYbJNi8rNt9Sbr5CM9tioeq3wkUKOiRMQznx
NJnhkvzEhGZ/0IYp19HOSHCQooAE2gOltCHvv24MXks0BUT62w1KS2CKTY5BAsxU
42aEqOXN5XW6hsl1GUz2csJn9/U03s+ifJZn9DlrNvSen7eQfFXXvJeE29JUVtuO
i+/ePbxEbLNNGFDLH8qzTTSW+ikV034OljYBXUGtyJAwVzXIsP2kg4tfDAiSRhFk
l8qYT8jWHfiknCbn4E0pZd3gcfqBpdk2zNlf7y6PhlDGumP6PCcb5hlSYM7TZK/g
Y/xFRdI889P4aEIcePPVKYBcBFdcrj6SDvqp3S+G8MZgcvsQAv20MxqKPpESUVrT
CTs9IhepD+0=
=7uUB
-----END PGP SIGNATURE-----

--Sig_/bF/+0261ZWlTgozZbA48+3r--


--===============5234300970751444966==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5234300970751444966==--
