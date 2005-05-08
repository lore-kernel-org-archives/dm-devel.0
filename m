From: "Dott. Ing. Colombo Marco" <payback@meteorete.homelinux.org>
Subject: kpartx compile error
Date: Sun, 08 May 2005 14:23:39 +0200
Message-ID: <427E04CB.1040309@meteorete.homelinux.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
List-Id: dm-devel.ids

Hi... there is a compile error in kpartx of multipath tools with kernel
2.6.12-rc4

here is the output

make[1]: Entering directory `/backup/iSCSI/multipath-tools-0.4.5-pre2/kpartx'

rm -f core *.o *.gz

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o bsd.o bsd.c

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o dos.o dos.c

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o kpartx.o kpartx.c

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o solaris.o solaris.c

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o unixware.o unixware.c

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o gpt.o gpt.c

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o crc32.o crc32.c

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -I.   -c -o lopart.o lopart.c

In file included from lopart.c:29:

/usr/include/linux/loop.h:88:2: #error "Wrong dev_t in loop.h"

make[1]: *** [lopart.o] Error 1

make[1]: Leaving directory `/backup/iSCSI/multipath-tools-0.4.5-pre2/kpartx'

make: *** [recurse] Error 2
