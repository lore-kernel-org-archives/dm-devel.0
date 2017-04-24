From: NeilBrown <neilb@suse.com>
Subject: Re: Autoload of DM kernel targets?
Date: Mon, 24 Apr 2017 14:05:58 +1000
Message-ID: <87zif6phzt.fsf@notabene.neil.brown.name>
References: <3474bd1a-7a81-29ba-3562-aaaaeca47cc7@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0339778937383091935=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3474bd1a-7a81-29ba-3562-aaaaeca47cc7@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrei Borzenkov <arvidjaar@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0339778937383091935==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

On Fri, Apr 21 2017, Andrei Borzenkov wrote:

> See as example https://bugzilla.opensuse.org/show_bug.cgi?id=983221
>
> "non-standard" DM targets do not appear to be autoloaded (the problem
> was hit with thin-pool, but it seems to apply to other targets as well).
> "Common" targets (like linear) are provided by dm-mod which seems to be
> autoloaded by virtue of /dev/mapper/control.
>
> Is it expected and intentional? Or are users required to manually load
> necessary modules on boot?
>
> TIA
>
> -andrei
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Does this patch fix it for you?

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 8f811dc8b3cc..d2c6a9a12d75 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4400,3 +4400,4 @@ MODULE_PARM_DESC(no_space_timeout, "Out of data space queue IO timeout in second
 MODULE_DESCRIPTION(DM_NAME " thin provisioning target");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-thin-pool");

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj9eaYACgkQOeye3VZi
gbnTPRAAtVSRt3+tLn+vHHrNCeOZ22xMhKZr6adPw6yww6KwdZgjOd0mmjJuXVzj
i/8x1iWh3+Hj8TV0qf8jUDkrP1wpsttruZ1DCEIf1PnBuemQ2IX7s5565lMrjOk9
KWYMpKPzRcGpxoNmMRTPPPTL2gKa+4o9baxq3mJ/LVZiU9AYEfSx1S0B691SR6w0
rv2XSUchgRpUXzJq/IppY6joftXMbSnZj/pJT4X3Lmn5RQb/DAqjofAzyGWTp3gZ
7oUpMH6OYWp6WZs6s5MAaRTtmUMzOCdQk1WcnaSEnACPpKgeASWZ5Ei5wety8YNL
+CXq8cZwaZNW4HQ7MHlqsDosF5GMxyDyQxCESLTusNNXPLyVn2R/g8DzsQWWuo6M
Ktn+By6ifhTdX5v13O32pfIosywLPdl0EAZVsyYk63/J0eVcsKk79oNObSQOYrHo
MZh5NgY/HljU3qMauZbFAjT77l8kutDblKDC9ekCo9PqnasOhSm5k4+De2dAdF3j
fXiDrP3/1wpFYpUx+WZwBs4KJ3dQywV/6q7OhShpwlYtFCKlL94hiA+vr2v9grWx
vVd87D3kzQLdpPg9muGlq9fc2fqnAwr6cDdgCisu6LNxaR8ZrvyzejSfuxtv9I8E
istvYMoySOM0Pl7B2TcntmEZHxMOfIv8Hpml7uDRr8m2Muy/x3I=
=cfGn
-----END PGP SIGNATURE-----
--=-=-=--


--===============0339778937383091935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0339778937383091935==--
