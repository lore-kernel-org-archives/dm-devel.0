From: Adam Hamsik <haaaad@gmail.com>
Subject: libdevmapper patches
Date: Sat, 21 Jun 2008 14:57:17 +0200
Message-ID: <9F196958-3293-4669-9032-ABC0E1F1ADAE@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
Cc: blymn <blymn@internode.on.net>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi

*** Please keep me on CC I'm not currently subscribed to this list. ***

I have updated my version of libdevmapper and extracted all my changes  
from my local source tree.

I have produced 5 patches they are located here [1].

Small description of all patches:

a)netbsd_libdevmapper.diff
   Adds new netbsd protocol file, and glue to parse and create dm- 
ioctl structures from proplib dictionaries.

b)makefiles.diff
   Changes needed to libdevmapper build system to properly build on  
netbsd, linux.

c)dmeventd.diff
   Small dmeventd diff which adds signal.h to NetBSD build.

d)libdm-common-netbsd.diff
   Adds support for raw devices to device nodes manipulating routines.

e)libdm-deptree-netbsd.diff
   Remove check for IS_BLK when we build libdevmapper on netbsd.

[1]http://www.netbsd.org/~haad/libdevmapper/

Regards

Adam.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFIXPqtlIxPgX3Go0MRAoREAJ4ttr3o8J4N7X8QaSmcNUsgHEd49wCePYyQ
lffTklqVT5gsyQ1w5Su9n/U=
=EoJo
-----END PGP SIGNATURE-----
