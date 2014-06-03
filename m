From: Rahul Nabar <rpnabar@gmail.com>
Subject: Persistent Overlay COW Full: Flipped the Invalid bit in
 a hexdump; how do I grow it now?
Date: Tue, 3 Jun 2014 18:50:50 +0530
Message-ID: <CAF5F7ZKGG-S1oouoUT+f_vitg_gpov=NHPRDjL7aLiOdbXf+uA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

I accidentally managed to fill up the persistent COW snapshot overlay
on my Fedora20 USB & it got flagged Invalid thus rendering the Live
USB unbootable since the root filesystem couldn't be mounted.

dmsetup status
live-rw 0 8388608 snapshot Invalid.

 Subsequently I used a 2011 thread(link below) on the dm-devel mailing
list ( Alasdair Kergon, Frederick Grose etc.) and flipped the invalid
bit in the overlay file by booting a different system and attaching
the USB stick to it.

Like so:  echo $'\x01' | dd
of=/run/media..../liveuser/LIVE.../overlay-LIVE-17F4-055A  bs=1
count=1 seek=4 conv=notrunc

hexdump of the file verified the flipped 5th byte. Now the LiveUSB
boots & I can successfully see my data but it's hard to do anything
more since it gets full almost immediately after I boot.

Is there a way to grow the overlay file? Would this work?

 dd if=/dev/zero of=overlay-LIVE-17F4-055A seek=overlay_size count=size_increase

How do I compute the number overlay_size? I suppose size_increase can
be some large number?

Or are more steps needed to expand the overlay?


http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/14644
