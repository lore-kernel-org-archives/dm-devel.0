From: Dan Smith <danms@us.ibm.com>
Subject: Re: DmUserspace and the device mapper.
Date: Wed, 18 Apr 2007 16:13:32 -0700
Message-ID: <m3wt09mg2r.fsf@guaranine.beaverton.ibm.com>
References: <31436f4a0703211016y46f1af17i15d0513f1dde98c4@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1908476046=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <31436f4a0703211016y46f1af17i15d0513f1dde98c4@mail.gmail.com>
	(David Shwatrz's message of "Wed, 21 Mar 2007 19:16:49 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1908476046==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

DS> My quesitons is: it seems that this is a good tool for utilization
DS> of CoW system images and also for native access to popular disk
DS> formats (like QEMU qcow and VMware vmdk).

That was the original idea (among other uses), although I have not
implemented vmdk, and qcow support is suffering from a bad case of bit
rot right now.

DS> My question is: are there intentions to integrate the DmUserspace in
DS> the device mapper ? are there reasons for not doing so ?

That's a good question.  It's /my/ intent to get it merged upstream :)

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGJqYewtEf7b4GJVQRAjNOAJ93boBA2Ox+WywEugqUHt5IUA5BwgCdGVNs
6ce0Ihpi6ueVh17UPn0icj8=
=6E5p
-----END PGP SIGNATURE-----
--=-=-=--


--===============1908476046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1908476046==--
