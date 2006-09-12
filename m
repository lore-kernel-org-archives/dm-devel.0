From: Dan Smith <danms@us.ibm.com>
Subject: Re: dm-userspace (no in-kernel cache version)
Date: Tue, 12 Sep 2006 14:50:02 -0700
Message-ID: <m3lkoopxf9.fsf@guaranine.beaverton.ibm.com>
References: <20060912080748X.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1908841287=="
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

--===============1908841287==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> As explained, this removes rmap (in-kernel cache) and use mmaped
FT> buffer instead of read/write system calls for user/kernel
FT> communication.

Ok, I got your code to work, and I have run some benchmarks.  I'll cut
directly to the chase...

I used dbench with a single process, for 120 seconds on a dm-userspace
device mapping directly to an LVM device.  I used my example.c and the
example-rb.c provided with the ringbuffer version.  The results are:

  with cache, chardev:  251 MB/s
  no cache, ringbuffer: 243 MB/s
=20
I am very pleased with these results.  I assume that your code is not
tuned for performance yet, which means we should be able to squeeze at
least 8 MB/s more out to make it equal (or better).  Even still, the
amount of code it saves is worth the hit, IMHO.

I do have a couple of comments:

1. You said that the ringbuffer saves the need for syscalls on each
   batch read.  This is partially true, but you still use a write() to
   signal completion so that the kernel will read the u->k ringbuffer.
   So, at best, the number of syscalls made is half of my
   read()/write() method.  I think it's possible that another
   signaling mechanism could be used, which would eliminate this call.
   I do think eliminating the copying with the ringbuffer approach is
   very nice; I like it a lot.

2. I was unable to get your code to perform well with multiple threads
   of dbench.  While my code sustains performance with 16 threads, the
   non-cache/ringbuffer version slows to a crawl (~1MB/s with 16
   procs).  I noticed that the request list grows to over a 100,000
   entries at times, which means that the response from userspace
   requires searching that linearly, which may be the issue.

I am going to further study your changes, but I think in the end that
I will incorporate most or all of them.  Some work will need to be
done to incorporate support for some of the newer features (endio, for
example), but I'll start looking into that.

Thanks a lot!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFFByuNwtEf7b4GJVQRAollAJ9SeY02ZOxJ80TqJSwsdlbOYh5wnACfUh4Q
8FJtOqmSQs2AmVicyEdx9is=
=73N1
-----END PGP SIGNATURE-----
--=-=-=--


--===============1908841287==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1908841287==--
