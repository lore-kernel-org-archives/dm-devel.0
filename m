From: Dan Smith <danms@us.ibm.com>
Subject: Re: [RFC] dm-userspace
Date: Thu, 20 Apr 2006 13:06:33 -0700
Message-ID: <87d5fcc8qe.fsf@caffeine.beaverton.ibm.com>
References: <87lku18hy0.fsf@caffeine.beaverton.ibm.com>
	<a4e6962a0604201050h44d2e8e0r5a96d763f53328e7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0793032561=="
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

--===============0793032561==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

EVH> It seems like this would be really useful for prototyping and
EVH> debugging new device mapper modules (like the dm-cache ideas I
EVH> posted about a few weeks back).

Yes, I think that is a major benefit to going with the dm-userspace
idea over the cow-specific dm-cow.

EVH> 1) how would you handle permissions?  IIRC FUSE allows normal
EVH> users to bind their own FUSE userspace file systems, would
EVH> something similar happen for dm-userspace or would even binding a
EVH> userspace device-mapper module require root?

Hmm, I think that due to the way device-mapper works, this would be
difficult.  Without the ability to create a pseudo-device with a
dm-userspace target, I think you'd be out of luck.

EVH> 2) How close would the userspace API be to the kernel
EVH> device-mapper API?  It'd be nice to have something close so that
EVH> userspace code could easily be migrated into the kernel (for
EVH> performance reasons) as appropriate.

Well, currently I pass basically the same information to userspace.
You get the location of the access and whether it was a read or a
write.  The userspace module passes back a destination location,
device, and whether or not to copy the area from a source location
(which gives you an interface to kcopyd).

I think that we could easily add a layer to be able to run simple
device-mapper modules in userspace with it, similar to how nfsim
works, which may be very useful to people trying to write new
device-mapper targets.  What are people's thoughts on this?

Something I should mention here: to simplify things and reduce
communication, the current module blocks contiguous regions of the
disk together so that you can talk about whole chunks at a time,
instead of each individual bio request, which may be of varying size
and location.  Block sizes can be no smaller than 512 bytes.  I think
that most device-mapper work will be dealing with fixed blocks of some
size, so this shouldn't be a problem.

EVH> 3) When do you think you'll be able to post a patch for RFC?

I'm currently just cleaning some things up at the moment.  I would be
glad to post a patch and a sample userspace app if people would be
willing to take a look at it.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBER+nLwtEf7b4GJVQRAoUfAJ4wUh8qIKc+WcvK1c6jAQ/6s4JjVQCcCeTj
IImfNnoaYAJEABr8nvyxyBU=
=JoaK
-----END PGP SIGNATURE-----
--=-=-=--


--===============0793032561==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0793032561==--
