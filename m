From: Dan Smith <danms@us.ibm.com>
Subject: Re: Latest dm-userspace kernel code
Date: Sat, 30 Sep 2006 08:46:10 -0700
Message-ID: <m3r6xtz7b1.fsf@guaranine.beaverton.ibm.com>
References: <m3hcyr4sit.fsf@guaranine.beaverton.ibm.com>
	<200609300221.k8U2L7UU001919@r-dd.iij4u.or.jp>
	<m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
	<200609300314.k8U3EvGF006445@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1977949996=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609300314.k8U3EvGF006445@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Sat, 30 Sep 2006 12:14:51 +0900")
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

--===============1977949996==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> I thought that dm-userpsace supports a feature to map a single
FT> request to multiple devices for kinda raid. For that, I guess that
FT> struct dmu_msg_map_response includes several sets of dst_maj and
FT> dst_min. Or you might use 'linked' dmu_msg_map_response, which
FT> enables a user-space daemon to send multiple dmu_msg_map_responses
FT> for one dmu_msg_map_request (if a dmu_msg_map_response is marked
FT> 'linked', dm-userspace module clones the bio and does not free
FT> struct the dmu_request).

Hmm, I had not planned to implement this kind of behavior, but I can
see the benefit.  I think it would be best to focus on performance for
now and add that capability later.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHpFCwtEf7b4GJVQRAjdYAJ985VPRGjvcKDRcRSJVk4JDV0GbcQCgg6zC
wM/r5h+veCjo6TRbnczCUYs=
=IjMn
-----END PGP SIGNATURE-----
--=-=-=--


--===============1977949996==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1977949996==--
