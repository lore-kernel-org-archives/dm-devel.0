From: Dan Smith <danms@us.ibm.com>
Subject: Re: [RFC] dm-userspace
Date: Wed, 26 Apr 2006 16:07:35 -0700
Message-ID: <87psj45420.fsf@caffeine.beaverton.ibm.com>
References: <87u08g553l.fsf@caffeine.beaverton.ibm.com>
	<1146092129.14129.333.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1782145068=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1146092129.14129.333.camel@localhost.localdomain> (Ming Zhang's
	message of "Wed, 26 Apr 2006 18:55:28 -0400")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mingz@ele.uri.edu
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============1782145068==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

MZ> just curious, will the speed be a problem here?=20

I'm glad you asked... :)

MZ> considering each time it needs to contact user space for mapping a
MZ> piece of data.=20

Actually, that's not the case.  The idea is for mappings to be cached
in the kernel module so that the communication with userspace only
needs to happen once per block.  The thought is to ask once for a
read, and then remember that mapping until a write happens, which
might change the story.  If so, we ask userspace again.

Right now, the kernel module expires mappings in a pretty brain-dead
way to make sure the list doesn't get too long.  An intelligent data
structure and expiration method would probably improve performance
quite a bit.

I don't have any benchmark data to post right now.  I did some quick
analysis a while back and found it to be not too bad.  When using loop
devices as a backing store, I achieved performance as high as a little
under 50% of native.

MZ> and the size unit is per sector in dm?

Well, for qcow it is a sector, yes.  The module itself, however, can
use any block size (as long as it is a multiple of a sector).  Before
I started work on qcow support, I wrote a test application that used
2MiB blocks, which is where I got the approximately 50% performance
value I described above.

Our thought is that this would mostly be used for the OS images of
virtual machines, which shouldn't change much, which would help to
prevent constantly asking userspace to map blocks.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBET/03wtEf7b4GJVQRAjriAKCEJYwRg30sBHBsR108iXXGS2cp0gCfWQXg
9/+VuCdkbTG4sDwHDQFUoNc=
=07tN
-----END PGP SIGNATURE-----
--=-=-=--


--===============1782145068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1782145068==--
