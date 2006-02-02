From: =?ISO-8859-2?Q?Maciej_S=B3ojewski?= <mslonik@poczta.onet.pl>
Subject: Ubuntu distro with lvm2, raid 1, not booting anymore.
Date: Thu, 02 Feb 2006 20:18:11 +0100
Message-ID: <43E25AF3.5000700@poczta.onet.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Welcome!

I have the serious problem with booting of my machine. It is run on 
Ubuntu distro (5.10), with lvm2 raid 1 on two identical sata hard disks. 
Lilo bootloader. The problem is that after small change in lilo.conf and 
running /sbin/lilo my system is no longer bootable. I see 'kernel panic' 
message. When I try to run lilo again (from Ubuntu Live! cd) I see some 
comments somehow related to dev-mapper:

Warning: /proc/partitions does not match /dev directory structure
Name change: /dev/cloop 0 -> /tmp/dev.0
(...)
Fatal: is_primary: Not a valid device

I don't know how to handle these problesm. Looking over net didn't help 
me. So I decided to write on this mailing list. If you can help me anyway,
even just redirecting me to appropriate group / chanel where people will 
help me to deal with these problem, I will appreciate it. Thanks
in advance!

My lilo version is 22.6.1
dev-mapper version is 1.11.0
kernel (default of Ubuntu 5.10): 2.6.12-10-386

I will quote the kernel messages:
RAMDISK: ran out of compressed data
invalid compressed format (err=1)
VFS: Cannot open root device "fd02" or unknow-block (253,2)
Please append a correct "root=" root option
Kernel panic - not syncing: VFS: Unable to mount root fs
unknown-block (253,2)

That is all. It looks like kernel is doing some hardware recognition and 
then stops.

Kind regards,
Maciej Slojewski (mslonik)
