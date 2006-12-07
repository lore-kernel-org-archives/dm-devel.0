From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 1/2] dm-userspace: use ring buffer instead
	of	system call
Date: Thu, 07 Dec 2006 14:53:50 -0800
Message-ID: <m3lklj2u81.fsf@guaranine.beaverton.ibm.com>
References: <20061025194412J.fujita.tomonori@lab.ntt.co.jp>
	<m31wotsvqy.fsf@guaranine.beaverton.ibm.com>
	<200610271436.k9REaVOC020547@r-dd.iij4u.or.jp>
	<20061129032635J.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1557524696=="
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

--===============1557524696==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

FT> Has there been any progress on this?

Ok, I just got around to testing your patch and running some tests.  I
merged your patch with my latest version of dm-userspace, which has
optional kernel caching of mappings (as pushed by userspace).  I also
updated the libdevmapper interface to support the ringbuffer
transport, and thus was able to test with my cow daemon.

I tested with dbench and disktest.  I'm not familiar with disktest, so
I'm not sure I was doing the right thing because the numbers are very
small.

I tested with the example program backed by an LVM (and then directly
against the LVM).  I used this command line:

  disktest -D30:70 -K2 -B4096 -T 180 -pR -PT -Ibd

which gave these results:

  Test       |  Read     |  Write
  -----------+-----------+-----------
  Ringbuffer | 0.79 MB/s | 0.79 MB/s
  Syscall    | 0.79 MB/s | 0.79 MB/s
  Direct     | 0.81 MB/s | 0.80 MB/s

I don't have dbench numbers to post when using the example because I'm
getting some strange behavior (native included).  I'll try to figure
out what is going on and post them later.

Next, I tested with my cow daemon.  Each test was done with and
without kernel caching enabled.  First with disktest:

  Test          |  Read     |  Write
  --------------+-----------+-----------
  Ring          | 0.20 MB/s | 0.19 MB/s
  Ring+Cache    | 0.09 MB/s | 0.09 MB/s
  Syscall       | 0.20 MB/s | 0.19 MB/s
  Syscall+Cache | 0.14 MB/s | 0.13 MB/s

Then with dbench:

  Test          |  Throughput
  --------------+--------------
  Ring          | 234 MB/s
  Ring+Cache    | 241 MB/s
  Syscall       | 244 MB/s
  Syscall+Cache | 258 MB/s

So, I think the disktest numbers are different than what you saw.  I'm
not sure why.  I'm also not sure why the kernel caching seems to hurt
performance for disktest, but improve it for dbench.  Kernel caching
makes tasks that are not disk-intensive much faster, such as a Xen
domU kernel boot.

Note that I did not spend a lot of time merging your code, so it's
possible that I did something to hurt performance a bit.  I also had
to fix a couple of issues introduced by your patch (related to proper
IRQ disabling of things like the ring lock that can be grabbed during
the end_io phase, but that don't appear with just the example
program).

I'd be happy to post a patch of my merged kernel changes as well as
the updated library interface if you're interested.  I tend to think
that the performance of the two is close enough that it's worth moving
to the ringbuffer version and working to improve performance from
that.

I would also still like to test the ringbuffer version in some other
environments, like a Xen domU boot to see if it reduces latency
further, which will help responsiveness.

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFeJuAwtEf7b4GJVQRAgwLAJ9Pscu0pewY10yhN1jf68JpamDkEQCeLEr0
5Sz0isFRgHsu0iPDKtxUROw=
=/ouO
-----END PGP SIGNATURE-----
--=-=-=--


--===============1557524696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1557524696==--
