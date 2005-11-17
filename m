From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: git head multipathd core
Date: Thu, 17 Nov 2005 22:57:54 +0100
Message-ID: <1132264675.7463.191.camel@zezette>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Here is a tricky one.
Eyeballs wanted !

It happens upon :

# for i in 3 4 5 6;do for j in 1 2;do echo "scsi remove-single-device $i
0 0 $j">/proc/scsi/scsi;done;done
# multipathd -k"show paths"
# for i in 3 4 5 6;do for j in 1 2;do echo "scsi add-single-device $i 0
0 $j">/proc/scsi/scsi;done;done
# multipathd -k"show paths"
SEGV

(replace your HCIL in the above sample)

Here is the core backtrace :

(gdb) bt full
#0  0x00002aaaab37ca20 in strlen () from /lib/libc.so.6
No symbol table info available.
#1  0x00002aaaab34f158 in vfprintf () from /lib/libc.so.6
No symbol table info available.
#2  0x00002aaaab3546ba in printf () from /lib/libc.so.6
No symbol table info available.
#3  0x00000000004074fe in process_req (fd=3, inbuf=0x7fffffb8ec0b "show
paths") at uxclnt.c:62
        reply = 0x3004263f0 <Address 0x3004263f0 out of bounds>
        len = 140737483689696
#4  0x000000000040754f in uxclnt (inbuf=0x7fffffb8ec0b "show paths") at
uxclnt.c:80
        fd = 3
#5  0x0000000000406caa in main (argc=2, argv=0x7fffffb8cfb8) at
main.c:1648
        arg = 107
        err = 0

Regards,
cvaroqui
