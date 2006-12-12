From: Eckebrecht von Pappenheim <evp@heise.de>
Subject: 2tb-limit in dm-multipath?
Date: Tue, 12 Dec 2006 16:33:08 +0100
Message-ID: <786EB72C710DF5BB0694C505@sigh.heise.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

Hello,

I run a setup with 2 SAN-boxes attached to a server using the multipath-tools
version 0.4.7 and kernel 2.6.17 (the qlogic-drivers do not compile against
2.6.18 ff.).

I had no problems setting this up (despite some udev-trouble due to an older
dmsetup). But when I try to access volumes > 2tb I get something like

[root@backup]/var/log> fsck /dev/san/estor02lun0p1 
fsck 1.37 (21-Mar-2005)
e2fsck 1.37 (21-Mar-2005)
The filesystem size (according to the superblock) is 1202399223 blocks
The physical size of the device is 128657399 blocks
Either the superblock or the partition table is likely to be corrupt!

Without multipath the device is accessible and fsck'ble. I suspect a 32bit-wrap
because of

[root@backup]~> bc
bc 1.06
Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'. 
# 4k blocks to volume size
1202399223 * 4
4809596892
# wrap
4809596892 - (2^32)
514629596
# back to blocks
514629596 / 4
# qed...
128657399

My device map for this device is
[root@backup]/~> multipath -l 3600d0230000000000083591ea0567c00
3600d0230000000000083591ea0567c00dm-5 IFT,A24F-R2224-1
[size=4.5T][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 3:0:1:0 sdp 8:240 [active][undef]

(I don't have actually a multipath for this device, but I'd like to have...)

Any idea which part of the multipath puzzle is the 32bit bottleneck?

Regards,
Eckebrecht

-- 
Eckebrecht von Pappenheim, network administration 
Heise Zeitschriften Verlag GmbH & Co KG
Helstorferstr. 7, D-30625 Hannover, FRG
E-Mail: evp@heise.de  - Tel: +49 511 5352 242  -  FAX: +49 511 5352 479
http://www.heise.de/
