From: Dan Smith <danms@us.ibm.com>
Subject: Thoughts on removing the remap cache
Date: Fri, 29 Sep 2006 14:36:58 -0700
Message-ID: <m3d59e1hj9.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1856279283=="
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
To: fujita.tomonori@lab.ntt.co.jp
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1856279283==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi Fujita,

I've been very pleased with the removal of the remap caching from
dm-userspace because performance seems to be good and complexity is
lower.

However, all of my tests up until now have been with dbench.  I think
that dbench works well in cases where latency is high, which is of
course the case since we're sending all requests to userspace.  When I
try to boot a Xen domU with root on dm-userspace (without the
caching), it is *painfully* slow.  I assume this is because the domU
boot is doing a lot of synchronous, sequential operations.

Since domU performance was good when I was caching mappings in the
kernel, I would assume that the difference in performance is related
to the caching.

What do you think?

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHZH8wtEf7b4GJVQRAkykAJ9cyDSZ6Ww8z4xXTGLgk7jvC8ZxewCeLW9E
EUal3qhDJ+dGKXf7YLsDAV4=
=6HWv
-----END PGP SIGNATURE-----
--=-=-=--


--===============1856279283==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1856279283==--
