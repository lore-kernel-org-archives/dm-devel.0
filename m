From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: problems getting ioband to work properly
Date: Tue, 1 Jul 2008 14:11:25 +0200
Message-ID: <20080701121125.GA2898@develbox.linuxbox.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
Cc: nikola.ciprich@linuxbox.cz
List-Id: dm-devel.ids

Hello all,
I'd like to try I/O shaping using ioband, but it doesn't seem to be working properly for some reason.
I have one disc partition used as LVM PV, VG on top of it. I created two 1GB LVs for tests: iob1, iob2

Then I setup ioband using following commands:

echo 0 2097152 ioband /dev/mapper/vg-iob1 iob 0 0 none weight 0 :40 | dmsetup create ioband-iob1
echo 0 2097152 ioband /dev/mapper/vg-iob2 iob 0 0 none weight 0 :10 | dmsetup create ioband-iob2

When I measure throughput using hdparm --direct -t on one of the ioband devices, i get ~61MBps.

If I measure it on both devices concurrently in loop, throughput settles on ~30MBps on every device, so it seems that it's divided equally.

What am I doing wrong?

thanks a lot in advance

nik

PS: I'm using 2.6.26-rc8+ioband-1.1.0 patch

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
