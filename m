From: Arthur Bergman <sky@nanisky.com>
Subject: crash in multipathd
Date: Sun, 30 Jan 2005 20:30:36 +0000
Message-ID: <CC9E49E3-72FD-11D9-8EBB-000A95A2734C@nanisky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: multipart/mixed; boundary="===============0904042207=="
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
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids


--===============0904042207==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=pgp-sha1; boundary="Apple-Mail-18--39181875"
Content-Transfer-Encoding: 7bit


--Apple-Mail-18--39181875
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; format=flowed

Trying to get multipath-tools working on a debian system, multipath the 
tool works but multipathd segfaults.

getrlimit(RLIMIT_STACK, {rlim_cur=RLIM_INFINITY, 
rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_STACK, {rlim_cur=2044*1024, rlim_max=RLIM_INFINITY}) = 
0
getpid()                                = 3700
rt_sigaction(SIGRTMIN, {0x40024030, [], 0}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x40024080, [], 0}, NULL, 8) = 0
rt_sigaction(SIGRT_2, {0x40024150, [], 0}, NULL, 8) = 0
rt_sigprocmask(SIG_BLOCK, [RTMIN], NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RT_1], NULL, 8) = 0
_sysctl({{CTL_KERN, KERN_VERSION}, 2, 0xbffffa74, 31, (nil), 0}) = 0
brk(0)                                  = 0x8052000
brk(0x8073000)                          = 0x8073000
brk(0)                                  = 0x8073000
clone(Process 3701 attached
child_stack=0x8056038, flags=CLONE_NEWNS) = 3701
[pid  3700] exit_group(0)               = ?
[pid  3701] --- SIGSEGV (Segmentation fault) @ 0 (0) ---
Process 3701 detached

please advice, should I try to compile my own version?

Cheers
Arthur

-----
CTO @ Fotango Ltd
+447834716919
http://www.fotango.com/

--Apple-Mail-18--39181875
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD4DBQFB/UP13rfT7xAQCIQRAu9xAJd1u+H7GFBpYlcZx0Kg786IwJr/AJ9m8JlN
964cvoe/wGlqrNFUUXJMhA==
=yRsj
-----END PGP SIGNATURE-----

--Apple-Mail-18--39181875--


--===============0904042207==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============0904042207==--
