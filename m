From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH V4 0/3] Introducing multipath C API
Date: Mon, 4 Jul 2016 17:27:27 +0800
Message-ID: <20160704092726.GA3198@redhat.com>
References: <20160704091146.GA3081@redhat.com>
	<20160704091704.119896-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0397546358002902594=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160704091704.119896-1-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============0397546358002902594==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2016 at 05:17:01PM +0800, Gris Ge wrote:
> Changes since V3:
>  * Replace limitation of MAX_REPLY_LEN with MAX_SEND_CMD_LEN.
>  * Treat IPC connection refuse error as DMMP_ERR_NO_DAEMON.
>
> Gris Ge (3):
>   multipath-tools: New way to limit the IPC command length.
>   multipath-tools: Set errno mpath_recv_reply() when failure
>   multipath-tools: Introducing multipath C API
No idea why patch 3/3 got discard by this mailing list.
Size limitation?

The patch could be found at:
https://github.com/cathay4t/multipath-tools/commit/1c083e37af8ce4aa626df086=
7e508b2b428f1c3a.patch


--=20
Gris Ge

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXeiv6AAoJEGzN5Y/kHij/UzEP/icZDiN+9JKsVdcOcHs1ehaU
/QTUas7o2Sf4zAiv8rdS/cZtSM0NvdkjuwS+Co4eWvkYeBS0mXOVzGreuRXp6PcG
qOgPcgI1n116jG8mLhUCubYlmWgii8TYux9FG05G2JHNWIxB1lQUgaGhQYNWA/da
gnbnzIeuXJBNLzvVOKuggB1Eh/HIe7lYdoxdUzOu4Ko7F2fjjyaJJ13ITQXTAcXV
w0Qphm2MMPmYI34DJodKZtnYsABUJhIsL3p3GWyK86f4t10P5SF20X3IH481G/ZI
yyCZDvbLFxMkPDu7u2S5rJA54rc29UuD6B0VwV4cbtWQrZ8K2hO2sb/+yGh6hapR
Q1atb28FKIyafLzAI0xPy4XTAmr6B0H2zXOhLQaOtui1T8uxdXMrIJ6fc9/YhvKa
KtUfPMleTzlUFJoQ7MB6fQesJ3TjjGvbHmQkBhpLMWiKSOAo3/44BujIWNjcbQU1
ItVjB4oSs9+XLUCHsg50rd4UQgIFUxQwKrZ2Pjqr/tDKv127oO/JDriPnJmQtShK
CbI074O8Al80D/b/RjFI/J/NCT6AMpRyB7qQDJACcwN82wIoisTR1zwmuGHaoztk
kKI7ffNY1B5h4gssmaBhLNVxmJ75FMV5alCVsxV4KI8PclPS5dAENyjuVrWTeb1y
5qtOl+zkI+IRcTNAXjdJ
=qf+i
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--


--===============0397546358002902594==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0397546358002902594==--
