From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Last path failure causes oops
Date: Mon, 18 Apr 2005 18:00:43 +0200
Message-ID: <20050418160043.GY8413@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi, I'm finally finding time to work and play with dm-mpath again. It wor=
ks,
unless there's a failure ;-)

(I've added a couple more log messages in places so that it's a little
bit more obvious. Right now, dm/dm-mpath rather keeps its troubles to
itself; if this was a relationship, I'd be sending it to a relationship
counselor that talking is much better than silently breaking...)

Anyway:

device-mapper: dm-multipath: IO error on path 8:0, sector 256
device-mapper: dm-multipath: no valid paths left.
Buffer I/O error on device dm-4, logical block 31
Unable to handle kernel NULL pointer dereference at virtual address 00000=
010
 printing eip:
f89cc8e0
*pde =3D 00102001
Oops: 0000 [#1]
SMP=20
CPU:    0
EIP:    0060:[<f89cc8e0>]    Tainted: G  U
EFLAGS: 00010282   (2.6.5-7.162-bigsmp SLES9_SP2_BRANCH-20050418132523000=
0)=20
EIP is at multipath_end_io+0x90/0x240 [dm_multipath]
eax: 00000000   ebx: f7f60b80   ecx: fffffffb   edx: 00000000
esi: f2dad1c0   edi: 00000000   ebp: f737c45c   esp: cde59eac
ds: 007b   es: 007b   ss: 0068
Process events/0 (pid: 18, threadinfo=3Dcde58000 task=3Dcde48000)
Stack: f2dadf00 00001000 00000008 00000000 00000001 f7f60b90 00000000 fff=
ffffb=20
       f6e153f0 f7dfb3f0 f2dad1c0 f89e1580 f6e153f8 f8914080 f89cc850 000=
00000=20
       f2dad1c0 00001000 f89e1510 fffffffb c017f078 00000001 00000296 000=
00296=20
Call Trace:
 [<f89e1580>] clone_endio+0x70/0x120 [dm_mod]
 [<f89cc850>] multipath_end_io+0x0/0x240 [dm_multipath]
 [<f89e1510>] clone_endio+0x0/0x120 [dm_mod]
 [<c017f078>] bio_endio+0x68/0xa0
 [<f89ccdac>] process_queued_ios+0x12c/0x140 [dm_multipath]
 [<c013c2a6>] worker_thread+0x186/0x230
 [<f89ccc80>] process_queued_ios+0x0/0x140 [dm_multipath]
 [<c0123910>] default_wake_function+0x0/0x10
 [<c0123910>] default_wake_function+0x0/0x10
 [<c013c120>] worker_thread+0x0/0x230
 [<c0140019>] kthread+0xf9/0x12d
 [<c013ff20>] kthread+0x0/0x12d
 [<c0107005>] kernel_thread_helper+0x5/0x10

Code: 8b 40 10 c7 04 24 e8 da 9c f8 83 c0 14 89 44 24 04 e8 ca f1=20
 Dumping to block device (104,5) on CPU 0 ...

Any ideas?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
