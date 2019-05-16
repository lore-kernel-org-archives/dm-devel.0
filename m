From: Erich Eckner <dm-devel@eckner.net>
Subject: Re: [PATCH 1/2] dm-crypt: print device name in integrity
 error message.
Date: Thu, 16 May 2019 11:04:37 +0200 (CEST)
Message-ID: <alpine.LNX.2.21.9999.1905161101060.2715@nlopc43.ioq.uni-jena.de>
References: <alpine.LNX.2.21.9999.1905141138180.19368@nlopc43.ioq.uni-jena.de>
	<20190515142231.30590-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="596483122-1063363029-1557997484=:2715"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190515142231.30590-1-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--596483122-1063363029-1557997484=:2715
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi,

thanks for the fast patch - I applied it on top of 5.1.2 and it has the 
desired result. (It took some time to trigger the read errors, though 
;-b):

[ 8834.156713] device-mapper: crypt: dm-17: INTEGRITY AEAD ERROR, sector 
1595877368
[ 9713.463619] device-mapper: crypt: dm-17: INTEGRITY AEAD ERROR, sector 
1595877040


regards,
Erich Eckner
Friedrich-Schiller-Universität Jena
Institut für Optik und Quantenelektronik
Helmholtzweg 4
07743 Jena

Tel. +49 3641 9-47238


On Wed, 15 May 2019, Milan Broz wrote:

> This message should better identify the device with the integrity failure.
>
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
> drivers/md/dm-crypt.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 7f6462f74ac8..36dfa36505ed 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1143,9 +1143,11 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
> 		r = crypto_aead_decrypt(req);
> 	}
>
> -	if (r == -EBADMSG)
> -		DMERR_LIMIT("INTEGRITY AEAD ERROR, sector %llu",
> +	if (r == -EBADMSG) {
> +		char b[BDEVNAME_SIZE];
> +		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu", bio_devname(ctx->bio_in, b),
> 			    (unsigned long long)le64_to_cpu(*sector));
> +	}
>
> 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
> 		r = cc->iv_gen_ops->post(cc, org_iv, dmreq);
> @@ -1788,7 +1790,8 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
> 		error = cc->iv_gen_ops->post(cc, org_iv_of_dmreq(cc, dmreq), dmreq);
>
> 	if (error == -EBADMSG) {
> -		DMERR_LIMIT("INTEGRITY AEAD ERROR, sector %llu",
> +		char b[BDEVNAME_SIZE];
> +		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu", bio_devname(ctx->bio_in, b),
> 			    (unsigned long long)le64_to_cpu(*org_sector_of_dmreq(cc, dmreq)));
> 		io->error = BLK_STS_PROTECTION;
> 	} else if (error < 0)
> -- 
> 2.20.1
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE3p92iMrPBP64GmxZCu7JB1Xae1oFAlzdJ6cACgkQCu7JB1Xa
e1raZQ/+PbM9H3gLyVYsUMw5uNA5galb88AD7vkHbSGRrERjZiDIDFvA35wLnBQt
/K+GKvFnPiM3qlceYCRYTEfPVO/8SRPDkGg8h55ArdmGpgWUfagvFCJYiJKe7gRu
SMjOXMYkA0187jB5YarEbCSYEDsrJr8wtBfwlHYgQ7pMbU6ua/l6KHGPG3abznZ9
PC6US1y6QX3lrMqZwKmdfijZGIlJ8Tf1KdagTMZbDs74MTpzLwOoNdQbNLv/yA3o
PLpXSrbPXZnVkL6VWpjBfCwgjFSqPlScwqwgDZJRbtiSmsOcTFtDke974KMoGMTe
MfnXe0YTMu4TvP1wAuDk3SztTw59RsAnTjS1JUkR11fjV1uZgTqkPtmm21XpI9Op
mMVCPjcCVq96uYT4CkY17B4Ukj4VT0rFb/47WKpcl66jvC4q3rIdnq9124IClnEw
eWZAz6KDLb6q3Z7/k3lSpSXmc9yQMBsOrzCMHv36N62RfoDFV8139gw5PjZNgnRm
KUX9SUSw+nPpUvcqajJwb7LJDf+jueCG6rhzQVGknvt693YQ49gWwgsheoT+d8fS
YBQgSq4ZNV5tGHBgfm6qOEi2/JTnyBl8b41IOarh/aYjLILyg6cTSU0FevT2eii+
JeRQtJCsoDl4FmhCXKd9+DHB+vTZ9h3ZRizIx6+Sm9uNcqDOVs0=
=lei7
-----END PGP SIGNATURE-----
--596483122-1063363029-1557997484=:2715
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--596483122-1063363029-1557997484=:2715--
