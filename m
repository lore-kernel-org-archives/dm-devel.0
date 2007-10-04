From: Ritesh Raj Sarraf <rsarraf@netapp.com>
Subject: Re: [PATCH] Rename prio callout program mpath_prio_netapp
	to mpath_prio_ontap
Date: Thu, 4 Oct 2007 22:05:16 +0530
Message-ID: <200710042205.23145.rsarraf@netapp.com>
References: <200710041455.20037.rsarraf@netapp.com>
	<20071004110157.GR18444@agk.fab.redhat.com>
Reply-To: rsarraf@netapp.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1580689013=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071004110157.GR18444@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1580689013==
Content-Type: multipart/signed; boundary="nextPart4307958.yXj0GFRoDa";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4307958.yXj0GFRoDa
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Thursday 04 October 2007, Alasdair G Kergon wrote:
> On Thu, Oct 04, 2007 at 02:55:19PM +0530, Ritesh Raj Sarraf wrote:
> > Attached are 2 patches to rename the callout program from
> > mpath_prio_netapp to mpath_prio_ontap.
>
> We're unable to take such a patch into RHEL directly because it is removi=
ng
> a program that was there before and that breaks backwards compatibility,
> but how about maintaining a symlink from the old location?
>

We've been shipping the mpath_prio_ontap callout program for more than a ye=
ar=20
with our software kit (which is supposed to be installed on top of our=20
supported Linux operating systems). So customers who'd have followed our=20
setup guides should not be hit by any compatibility issues.

We're looking forward to using "mpath_prio_ontap" as the name because it is=
=20
more generic and serves our additional needs.

=46or RHEL5/4 series, is it okay to have "mpath_prio_netapp" as a link poin=
ting=20
to "mpath_prio_ontap" ?

As for RHEL6 and ahead, we could just remove "mpath_prio_netapp".


Thanks,
Ritesh

--nextPart4307958.yXj0GFRoDa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHBRZL4Rhi6gTxMLwRAnOdAKCsVIiYIcGyzQ+u66T/CvAqPiQK4gCaAnL+
0cUWW6o63DJi5Y9R9wgu1Q8=
=bl/x
-----END PGP SIGNATURE-----

--nextPart4307958.yXj0GFRoDa--


--===============1580689013==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1580689013==--
