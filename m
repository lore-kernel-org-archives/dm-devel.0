From: Dan Smith <danms@us.ibm.com>
Subject: Help with a BUG()
Date: Tue, 11 Apr 2006 14:37:05 -0700
Message-ID: <87vetfkd4u.fsf@caffeine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1508446305=="
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

--===============1508446305==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi All,

I continue to work on my userspace-controlled CoW target for
device-mapper and have almost completed qcow support.  Recently, I've
been hitting a BUG() when I do anything more than trivial reads and
writes to my target (bug output included at the end of this mail).  It
seems as though the loopback driver (which is one of the places I'm
sending bio's to) is calling bio_put() when the usage count is already
zero.  I'm not sure what I could be doing in my target that could be
affecting the usage count on a bio.

I would _really_ appreciate it if a few people could take a look at my
kernel code (module/dm-cow.c) and see if anything pops out at them as
incorrect:

  http://static.danplanet.com/dm-cow/dm_cow_04112006.tar.gz

Anyone that wants to run it and see the issue for themselves can try
running the 'copyusr' test, which might work with a healthy amount of
luck.=20

Thanks!

=2D-=20
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com

kernel BUG at fs/bio.c:220!
invalid opcode: 0000 [#1]
SMP
Modules linked in: loop dm_cow ipv6 parport_pc
acl rfcomm l2cap bluetooth sunrpc video button
i801 i2c_core shpchp tg3 dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod mpts=
pi mptscsih mptbase sd_mod scsi_mod
CPU:    2
EIP:    0060:[<c1067b31>]    Not tainted VLI
EFLAGS: 00010246   (2.6.16.1 #2)
EIP is at bio_put+0x24/0x2e
eax: 00000000   ebx: cce658f8   ecx: f7af3d80

esi: d3e07d80   edi: 00000000   ebp: 00000000

ds: 007b   es: 007b   ss: 0068
Process loop0 (pid: 14450, threadinfo=3Df6ea6000

Stack: <0>f8885606 00000078 f88b9080 cce643ec 00000000 d3e07d80 00000200 f8=
885567
       00000000 c10678b2 f6ea6f64 f8a58884 00000200 00000000 d3e07d80 f7fca=
fbc
       00000200 00000000 f8a585ff f8a58884 f6ea6fc0 c1005e96 00000001 cda73=
124
Call Trace:
 [<f8885606>] clone_endio+0x9f/0xd2 [dm_mod]
 [<f8885567>] clone_endio+0x0/0xd2 [dm_mod]
 [<c10678b2>] bio_endio+0x3e/0x69
 [<f8a58884>] lo_read_actor+0x0/0xe9 [loop]
 [<f8a585ff>] loop_thread+0x18e/0x413 [loop]
 [<f8a58884>] lo_read_actor+0x0/0xe9 [loop]
 [<c1005e96>] do_syscall_trace+0x196/0x1f5
 [<c1003906>] syscall_exit_work+0x16/0x1c
 [<f8a58471>] loop_thread+0x0/0x413 [loop]
 [<c1001ac5>] kernel_thread_helper+0x5/0xb
Code: c6 7c db 5b 5e 5f c3 89 c2 8b 40 38 85 c0 74 1b f0 ff 4a 38 0f 94 c0 =
84 c0 75 01 c3 c7 42 08 00 00 00 00 89 d0 ff 52 40 89 f6 c3 <0f> 0b dc 00 1=
7 5a 23 c1 eb db 55 57 56 53 89 c7 8b 40 30 0f b7

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)

iD8DBQBEPCGDwtEf7b4GJVQRAuZuAJ9h9+Ctc6eiaihgTN6evOY0vf6MJACeOpqp
uC4b20d6LXZkyj8qVomRqUM=
=2A68
-----END PGP SIGNATURE-----
--=-=-=--


--===============1508446305==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1508446305==--
