From: Dan Smith <danms@us.ibm.com>
Subject: [RFC] dm-userspace
Date: Wed, 19 Apr 2006 12:48:55 -0700
Message-ID: <87lku18hy0.fsf@caffeine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1790988502=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============1790988502==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi List,

As you all know, I'm working on a userspace-controlled CoW
implementation using device-mapper.  The idea is to offer a pseudo
device through device-mapper that has CoW behavior, but where the
block allocation decisions are made from userspace.

My thoughts are that it might be best to abandon the concept of the
"dm-cow" target and instead work on a "dm-userspace" target.  The
userspace cow application I'm working on would remain mostly the
same.  Similarly, dm-userspace would look almost identical to my
dm-cow does right now, but more generic.  The target would simply
present the details of the data passed to the map() function to
userspace, which would respond with a target device and sector of
where to send the request.

A generic dm-userspace target would allow for testing of new
algorithms (RAID, CoW, etc) from a userspace application, as well as
some more interesting things involving distributed applications.  Just
like FUSE allows for some neat (although not necessarily
high-performance) tricks, dm-userspace could allow the same thing for
block devices.

Would the device-mapper maintainers be interested in accepting
something like dm-userspace upstream?

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBERpQpwtEf7b4GJVQRAq4vAKCJsNr3LDUYUj6eTgWhx9GOz7sc6wCfTg8G
dMM+8HWXuEKdBdpcvhEgktI=
=XVr0
-----END PGP SIGNATURE-----
--=-=-=--


--===============1790988502==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1790988502==--
