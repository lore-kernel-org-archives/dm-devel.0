From: Allen Sanabria <asanabria@communityconnect.com>
Subject: compiling Multipath-tools on RHE4 .
Date: Tue, 22 Mar 2005 15:08:55 -0500
Message-ID: <1111522135.29700.8.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel- <dm-devel@redhat.com>
List-Id: dm-devel.ids

Our System!
2.6.9-5.ELsmp #1 SMP Wed Jan 5 19:29:47 EST 2005 x86_64 x86_64 x86_64
GNU/Linux
Red Hat Enterprise Linux ES release 4 (Nahant)

Packages installed
gcc-3.4.3-9.EL4
udev-039-10.8.EL4
device-mapper-1.00.19-2

This is the output I get when I run a make on
multipath-tools-0.4.3-pre9.

In file included from lopart.c:30:
loop.h:82: error: syntax error before "__kernel_old_dev_t"
loop.h:82: warning: no semicolon at end of struct or union
loop.h:84: error: syntax error before "lo_rdevice"
loop.h:84: warning: type defaults to `int' in declaration of
`lo_rdevice'
loop.h:84: warning: data definition has no type or storage class
loop.h:93: error: syntax error before '}' token
lopart.c: In function `find_loop_by_file':
lopart.c:100: error: storage size of 'loopinfo' isn't known
lopart.c:100: warning: unused variable `loopinfo'
lopart.c: In function `find_unused_loop_device':
lopart.c:144: error: storage size of 'loopinfo' isn't known
lopart.c:144: warning: unused variable `loopinfo'
lopart.c: In function `set_loop':
lopart.c:225: error: storage size of 'loopinfo' isn't known
lopart.c:225: warning: unused variable `loopinfo'
make[1]: *** [lopart.o] Error 1
make[1]: Leaving directory
`/root/Multipath/multipath-tools-0.4.3-pre9/kpartx'
make: *** [recurse] Error 2

If you anyone could please help me on getting this to work, This needs
to be implemented ASAP...
Allen Sanabria
Systems Administrator I
205 Hudson St 6th Floor
New York, New York 10013
