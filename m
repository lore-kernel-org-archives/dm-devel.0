From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH] Add dm-userspace target
Date: Thu, 15 Jun 2006 20:05:09 -0700
Message-ID: <m364j1x0ka.fsf@guaranine.beaverton.ibm.com>
References: <E8C532D801BE5B479B28B626184E8CDD093627A5@tayexc14.americas.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0588151786=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E8C532D801BE5B479B28B626184E8CDD093627A5@tayexc14.americas.cpqcorp.net>
	(Stephen Reilly's message of "Thu, 15 Jun 2006 22:36:32 -0400")
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
Cc: stsd-securelinux-hp <stsd-securelinux-hp@hp.com>, "Patterson,  Andrew D (Linux R&D)" <andrew.patterson@hp.com>
List-Id: dm-devel.ids

--===============0588151786==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

RS> Could you be more specific by the phrase of "block placement
RS> decisions" what placement are you referring too?

Sure.

So, take a complex format like qcow for example.  All of the data for
the disk is in the file, but clearly not in linear order, right?  Not
only is it non-linear, but it's in some form that requires some
understanding of a sophisticated set of metadata to linearize it.
But, since the data is just jumbled up, we can use device-mapper to
create a linear pseudo device that maps the linear blocks to their
correct location in the qcow file.  However, putting this logic in the
kernel is mildly ugly, and gets extremely ugly when you talk about
adding another format, such as vmdk, msvhd, etc.

With dm-userspace and the help of my userspace application (cowd), you
can mount these files as if they were normal disks in linux.

So, by giving a userspace application real-time control over the
mappings, we can push the complexity into userspace.  There are a lot
of other nifty things you can do from the comfort of userspace once
you have this generic enabler in the kernel to act on your behalf.
*Lots* :)

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEkh/owtEf7b4GJVQRAt9uAJ9QXVdrXmJr3CuSDuD5Od3ooE5CAgCdGsCw
YP7zyQHA/jfcqoHtWybdrGA=
=f6tP
-----END PGP SIGNATURE-----
--=-=-=--


--===============0588151786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0588151786==--
