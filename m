From: Dan Smith <danms@us.ibm.com>
Subject: Re: Latest dm-userspace kernel code
Date: Fri, 29 Sep 2006 19:39:46 -0700
Message-ID: <m3zmciyt59.fsf@guaranine.beaverton.ibm.com>
References: <m3hcyr4sit.fsf@guaranine.beaverton.ibm.com>
	<200609300221.k8U2L7UU001919@r-dd.iij4u.or.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2099515703=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200609300221.k8U2L7UU001919@r-dd.iij4u.or.jp> (FUJITA Tomonori's
	message of "Sat, 30 Sep 2006 11:21:02 +0900")
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

--===============2099515703==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> - I think that you can use kernel threads for map_worker since
FT> dmu_map says that we might reorder I/Os.

Yes, I think you are probably right.  I disabled the kernel thread at
one point as a sanity check, but I think it might be ok to turn it
back on.  I'll do some testing.

FT> - What is the purpose of dmu_request->deps? I guess that it is for
FT> preventing I/O being reordered. if so, again, you don't need to do
FT> that.

Well, the problem is that a block copy would overwrite other requests.
I think that while a copy is happening, you have to be careful to not
write into that block so that your writes are not lost.

Am I over-thinking it?

FT> - Would be better to move non-transport functions (map_worker,
FT> copy_block, etc) to dm-userspace.c?

Yes.  You did a much better job of isolating those functions than I
did :) ...  I plan to revisit that soon.

FT> - How does the current kernel/user interface support multiple
FT> destination feature?

I'm not sure what you mean here.  Can you elaborate?

FT> - Needs some cosmetic fixes (removing needless whitespaces and
FT> braces, etc)

Indeed.  I made sure to mention in my post that it was not in "final
form" for this reason :)  I'll try to clean it up a little more before
I post it again.

Thanks for the feedback!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFHdjywtEf7b4GJVQRAnhrAJ9cAxfVUgG7diQ8ov8QWyu+28yfcgCfbmAz
yWWZ91fHGLCK73J4qoVMUSI=
=LyVy
-----END PGP SIGNATURE-----
--=-=-=--


--===============2099515703==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2099515703==--
