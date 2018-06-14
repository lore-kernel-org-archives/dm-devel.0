From: NeilBrown <neilb@suse.com>
Subject: Re: why does __split_and_process_bio
	use	bio_clone_bioset?
Date: Fri, 15 Jun 2018 09:34:29 +1000
Message-ID: <87fu1pgcxm.fsf@notabene.neil.brown.name>
References: <20180614081947.GA23375@infradead.org>
	<20180614181245.GA1161@redhat.com>
	<20180614200808.GA46373@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6073598827545419823=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180614200808.GA46373@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

--===============6073598827545419823==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 14 2018, Mike Snitzer wrote:

> On Thu, Jun 14 2018 at  2:12P -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Thu, Jun 14 2018 at  4:19am -0400,
>> Christoph Hellwig <hch@infradead.org> wrote:
>>=20
>> > Hi Neil,
>> >=20
>> > In commit 18a25da8 ("dm: ensure bio submission follows a depth-first
>> > tree walk") you've added a call to bio_clone_bioset to
>> > __split_and_process_bio.  Unlike all other bio splitting code this
>> > actually allocates a new bio_vec array instead of just splitting the b=
io
>> > and the iterator.  I can't actually find a good reason for that either
>> > in a cursory review of the code, the commit or the comments.
>> >
>> > Do you remember why this can't just use bio_clone_fast?

Good question.  I don't remember having a good reason to choose it, and
if there was one I suspect I would have mentioned it in the commit
message.
So it was most likely an oversight.
Looking at the code now, I can see no justification for not using
bio_clone_fast() or similar.

Thanks for looking into this - I guess the next step is to get rid of
bio_clone_bioset() completely.  Nice.


>>=20
>> Your question caused me to revisit this code and it is suspect for a
>> couple reasons:
>>=20
>> 1) I'm also not seeing why we need bio_clone_bioset()
>
> The patch below seems to work fine (given quick testing).. It also has a
> side-effect of not breaking integrity support (which commit 18a25da8
> appears to do because it isn't accounting for any of the integrity stuff
> bio_split, or dm.c:clone_bio, does).
>
> FYI, my other concerns in my my previous reply were unfounded and due to
> misreading the existing code.
>
> Neil, please still feel free to have a look at this to see if you can
> recall why you used bio_clone_bioset().
>
> If in the end you agree that the following patch is fine please let me
> know and I'll get a proper fix staged.

I agree with the patch.
 Reviewed-by: NeilBrown <neilb@suse.com>

Thanks!

NeilBrown

>
> Thanks,
> Mike
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 20a8d63..dfb4783 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1582,10 +1582,9 @@ static blk_qc_t __split_and_process_bio(struct map=
ped_device *md,
>  				 * the usage of io->orig_bio in dm_remap_zone_report()
>  				 * won't be affected by this reassignment.
>  				 */
> -				struct bio *b =3D bio_clone_bioset(bio, GFP_NOIO,
> -								 &md->queue->bio_split);
> +				struct bio *b =3D bio_split(bio, bio_sectors(bio) - ci.sector_count,
> +							  GFP_NOIO, &md->queue->bio_split);
>  				ci.io->orig_bio =3D b;
> -				bio_advance(bio, (bio_sectors(bio) - ci.sector_count) << 9);
>  				bio_chain(b, bio);
>  				ret =3D generic_make_request(bio);
>  				break;
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlsi+4YACgkQOeye3VZi
gbn6Pg//QSvpTY4Y6BgFP30lddiAwEfVHguKDg3hhlMfVUIT1ZcnM2YUFbC4NTnS
4+m75vqjt4zslTr3bXYJP0+ysiBX3R7QZLhh/8xqxAk+TVFatCr5KdY90n9lcFt6
VqXsIxea7lvUw1b9xrq5GnWqr5xMHGFgCD3phSVeWAy49exWUFFUEBP/jc65iP7E
RL/oKGlkYO+SM0dxrTLU/whwcPb0O8SQ7hQkAIR0HHOYd6raWvy2NAV/KBqrvALm
adZwQHwfSj0XNcfrn7m9wmhbZ8cAqWbupOiRwsePNATg1WeaDpAbyd0cVA6C+jGk
VZOC0noVTvfp7DKWFIOP+CD/4H5LUE5z+YtJhY4yeBRZE29nqb6rd5ilfw+yoCn2
7KnZ4nHJEj2LF5mT2bnOu8v1jmQpdqq1Bqdhr946YVhZN0DnraohBQY+Lg7txpBU
Jf64oKxk5ZgZLCRNtcZhw8wtSRYt3IKcgRIeV4h9XLVU1P9WCZ2QocjztSBERqhi
E+mrzm/d8yolAhNOBzjZQOowdVDPnPQRkluCBbDPygK1Jn2rJJqWJTSO3QUUokXF
/QOGHIx1miezlXhPrPd2PYiGnNapdmt37M2CCL2mFYeFu9SJZoVFT8H7DJLBXnLh
83Ctw0iwVnoTbT23SzJO6Le70Gh0Uw9i51Jdcz3QF1EumF8sw/Y=
=e/LS
-----END PGP SIGNATURE-----
--=-=-=--


--===============6073598827545419823==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6073598827545419823==--
