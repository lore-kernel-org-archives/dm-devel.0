From: Ben Collins <ben.c@servergy.com>
Subject: Re: [PATCH v2] dm crypt: fix deadlock when algo returns
	-EBUSY
Date: Tue, 7 Apr 2015 12:10:35 -0500
Message-ID: <BA6189A5-1C3D-4A43-B494-D6FEC7200E7D@servergy.com>
References: <1428077387-2292-1-git-send-email-ben.c@servergy.com>
	<20150407155501.GA29040@redhat.com>
	<20150407162842.GA54137@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: multipart/mixed; boundary="===============7745236767006083145=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150407162842.GA54137@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids


--===============7745236767006083145==
Content-Type: multipart/signed;
	boundary="Apple-Mail=_A289DC1D-61FB-4FD8-9702-AF4814B30701";
	protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_A289DC1D-61FB-4FD8-9702-AF4814B30701
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Apr 7, 2015, at 11:28 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>=20
> On Tue, Apr 07 2015 at 11:55P -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>=20
>> It looks like you're _always_ using the completion regardless of =
whether
>> crypt_convert() will be waiting (e.g. even if error is 0).
>>=20
>> I can see this "working" but it seems less than ideal.  Would it be
>> better to record the need to use the completion in ctx and then
>> conditionally call complete()?
>=20
> Actually, how about using !completion_done() before calling =
complete()?
> If you think this would be OK, any chance you could re-test with this?

I'll be able to test it before Friday (out of town). Thanks



> From: Ben Collins <ben.c@servergy.com>
> Date: Fri, 3 Apr 2015 16:09:46 +0000
> Subject: [PATCH] dm crypt: fix deadlock when algo returns -EBUSY
>=20
> I suspect this doesn't show up for most anyone because software
> algorithms typically don't have a sense of being too busy.  However,
> when working with the Freescale CAAM driver it will return -EBUSY on
> occasion under heavy -- which resulted in dm-crypt deadlock.
>=20
> After checking the logic in some other drivers, the scheme for
> crypt_convert() and it's callback, kcryptd_async_done(), were not
> correctly laid out to properly handle -EBUSY or -EINPROGRESS.
>=20
> Fix this by using the completion for both -EBUSY and -EINPROGRESS.
> Before this fix dm-crypt would lockup within 1-2 minutes running with
> the CAAM driver.  Fix was regression tested against software =
algorithms
> on PPC32 and x86_64, and things seem perfectly happy there as well.
>=20
> Signed-off-by: Ben Collins <ben.c@servergy.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> drivers/md/dm-crypt.c | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index ea09d54..cab96ca 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -925,11 +925,10 @@ static int crypt_convert(struct crypt_config =
*cc,
>=20
> 		switch (r) {
> 		/* async */
> +		case -EINPROGRESS:
> 		case -EBUSY:
> 			wait_for_completion(&ctx->restart);
> 			reinit_completion(&ctx->restart);
> -			/* fall through*/
> -		case -EINPROGRESS:
> 			ctx->req =3D NULL;
> 			ctx->cc_sector++;
> 			continue;
> @@ -1346,10 +1345,8 @@ static void kcryptd_async_done(struct =
crypto_async_request *async_req,
> 	struct dm_crypt_io *io =3D container_of(ctx, struct dm_crypt_io, =
ctx);
> 	struct crypt_config *cc =3D io->cc;
>=20
> -	if (error =3D=3D -EINPROGRESS) {
> -		complete(&ctx->restart);
> +	if (error =3D=3D -EINPROGRESS)
> 		return;
> -	}
>=20
> 	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
> 		error =3D cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, =
dmreq), dmreq);
> @@ -1360,12 +1357,15 @@ static void kcryptd_async_done(struct =
crypto_async_request *async_req,
> 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
>=20
> 	if (!atomic_dec_and_test(&ctx->cc_pending))
> -		return;
> +		goto done;
>=20
> 	if (bio_data_dir(io->base_bio) =3D=3D READ)
> 		kcryptd_crypt_read_done(io);
> 	else
> 		kcryptd_crypt_write_io_submit(io, 1);
> +done:
> +	if (!completion_done(&ctx->restart))
> +		complete(&ctx->restart);
> }
>=20
> static void kcryptd_crypt(struct work_struct *work)
> --
> 1.9.5 (Apple Git-50.3)
>=20

=E2=80=94=E2=80=94
Ben Collins
Cyphre Champion
=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=
=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94=E2=80=94
Principal Architect
Servergy, Inc.
469-919-5634 (O)
757-243-7557 (M)


--Apple-Mail=_A289DC1D-61FB-4FD8-9702-AF4814B30701
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJVJA+LAAoJEF1aV8ckKyLPLcEP/jAbxEQUQl8/YRx6cgJdU0BN
tVHCCuVuK37ebLBrfZUEBZUsTRgi6PXe6phVVzMG6Vw8BTvmqUisJa4tSeg9B8p+
KfZXMgNAiKXa7TQO+gfw9ZgWOptDVZyodgLFYefXrqhcdnONACvjPlAcSxStBvFu
MEsbKGP2rEXp8lhSVqRPaned/zpuKz5gGiPBbYV4pYSeNFxk0qWQMJsgiDg2tQ5/
evi1jPchdUxb5zgfKYFolDmfLcFBk0gsTF3w8onnSWORt9c+m47dGMlShH7Vng/1
byhV4fEQvfxwwFhP8GxWK9LeyIzA9Sfq3gqu10Y4JSgcvhXqbMiXokpAc2VkCEWv
jcJVrQJclT2Sx6O7gHjk1gxWnq5I5NUFYgFAPr60v4F74JkAaIQRg5mALhTv1jDU
WbAg2l1vCdw0Kv2dHPBZCY9VzTHH3igUOsSiMpI2XxguORQXGaMfFp3SOhNwH5AW
fSZASgUaWglD4xnaXx8aucvT0c3I9I8Im4vAVDoyExPRPqHGFFlbSEHnl1jv0+X7
rPRm+yxbqh2gSYjph5A4Hc9mEL5oKS4Eh2aNiIj3vY3HwN7jPhvW6N5VGYQTtUBs
Vma3VARM36LCGHXYNGTGkmvKE01o/0W51RmU9ztKNLY9VG2vdLCT82/SCB0mJ62o
WfSlhCDDacGGPpYhgd71
=23LL
-----END PGP SIGNATURE-----

--Apple-Mail=_A289DC1D-61FB-4FD8-9702-AF4814B30701--


--===============7745236767006083145==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7745236767006083145==--
