From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-writeboost: unusual refcount on Raspberry Pi
Date: Fri, 18 Oct 2013 22:30:24 +0900
Message-ID: <526137F0.2060307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi, all

I am trying to run writeboost on a tiny ARM machine, Raspberry Pi.
writeboost can compile without any error nor warning but
it doesn't even start ctr.

What I do before running `dmsetup create` is
# modprobe dm-mod
# insmod dm-writeboost.ko

After these two commands, lsmod looks insane.
I suppose dm_writeboost module's refcount should be 0, not -1 (2147483647).
Nonetheless, dmesg doesn't indicate anything at all.
If I try to make a writeboost device after this,
it hangs up the whole system.

I have no idea what is happening in my system.
If you know something about this, please help me.

root@raspberrypi:~/dm-writeboost# lsmod
Module                  Size  Used by
dm_writeboost          34473  2147483647
dm_mod                 72892  1 dm_writeboost
snd_bcm2835            16432  0
snd_pcm                77728  1 snd_bcm2835
snd_page_alloc          5169  1 snd_pcm
snd_seq                53482  0
snd_seq_device          6462  1 snd_seq
snd_timer              20110  2 snd_pcm,snd_seq
snd                    58744  5 snd_bcm2835,snd_timer,snd_pcm,snd_seq,snd_seq_device
arc4                    1684  2
rt2800usb              14948  0
rt2800lib              55431  1 rt2800usb
rt2x00usb              11240  1 rt2800usb
rt2x00lib              42342  3 rt2x00usb,rt2800lib,rt2800usb
mac80211              273979  3 rt2x00lib,rt2x00usb,rt2800lib
cfg80211              184390  2 mac80211,rt2x00lib
rfkill                 18298  2 cfg80211
crc_ccitt               1530  1 rt2800lib
leds_gpio               2243  0
led_class               3570  2 leds_gpio,rt2x00lib

Akira
