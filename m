From: Martin Michlmayr <tbm@cyrius.com>
Subject: Bug#403426: kernel corrupts LUKS partition header on arm
Date: Wed, 20 Dec 2006 17:15:29 +0100
Message-ID: <20061220161529.GA10820@deprecation.cyrius.com>
References: <20061217022906.2434.60658.reportbug@LKG8A754B.example.org>
Reply-To: Martin Michlmayr <tbm@cyrius.com>, 403426@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-bugs-rc=glddbr-debian-bugs-rc=gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.403426.B403426.116663135531394@bugs.debian.org>
Content-Disposition: inline
In-Reply-To: <20061217022906.2434.60658.reportbug@LKG8A754B.example.org>
List-Post: <mailto:debian-bugs-rc@lists.debian.org>
List-Help: <mailto:debian-bugs-rc-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-rc-request@lists.debian.org?subject=unsubscribe>
To: dm-devel@redhat.com, Clemens Fruhwirth <clemens@endorphin.org>
Cc: Brian Brunswick <bdb-reportbug@forbidden.co.uk>, 403426@bugs.debian.org
List-Id: dm-devel.ids

We're seeing corruption of LUKS partition headers on ARM.  I've
confirmed this on two different ARM platforms (IXP4xx and IOP32x) and
with 2.6.17 and 2.6.18.

Basically, when you create a LUKS partition on a PC and then connect
it to an ARM box and open it, you get an "automatic header conversion
from 0.99 to 0.991 triggered" message and afterwards the LUKS
partition header is corrupted.

Here are steps to reproduce this:

On the PC:

27340:tbm@deprecation: ] sudo cryptsetup luksFormat /dev/sda6

WARNING!
========
This will overwrite data on /dev/sda6 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase:
Verify passphrase:
Command successful.
27348:tbm@deprecation: ~] sudo cryptsetup luksOpen /dev/sda6 x
Enter LUKS passphrase:
key slot 0 unlocked.
Command successful.
27351:tbm@deprecation: ~] sudo cryptsetup luksClose x
27352:tbm@deprecation: ~]

Connect the drive to the ARM box:

debian:~# cryptsetup luksOpen /dev/sdb6 x
Enter LUKS passphrase:
automatic header conversion from 0.99 to 0.991 triggered
[here it appears to hang; I press ctrl-c]
debian:~# cryptsetup luksOpen /dev/sdb6 x
Enter LUKS passphrase:
unknown hash spec in phdrEnter LUKS passphrase:
unknown hash spec in phdrEnter LUKS passphrase:
unknown hash spec in phdrCommand failed: No key available with this passphrase.

debian:~#

The original bug report with some more info:

* Brian Brunswick <bdb-reportbug@forbidden.co.uk> [2006-12-17 02:29]:
> Package: linux-image-2.6.18-3-ixp4xx
> Version: 2.6.18-8
> Severity: critical
> Justification: causes serious data loss
> 
> This is on an NSLU2, I wanted to use it to access some disks that I
> had used previously on another system that had encrypted partitons.
> However, when I tried cryptsetup luksOpen, I got a automatic header
> conversion from 0.99 to 0.991 triggered message, and then an infinite
> loop. Trying the same partition on the other system, now I get the
> same thing - its header is corrupted. Luckily, I'm paranoid and had a
> backup of the LUKS header! If I didn't have this, the whole
> partition's data would probably be lost.
> 
> Here's the result of some tests - and its stranger than you think...
> 
> Used cryptsetup luksFormat on another system to set up a partition..
> 
> LKG8A754B:~# uname -a
> Linux LKG8A754B 2.6.18-3-ixp4xx #1 Mon Dec 11 17:20:00 UTC 2006 armv5tel GNU/Linux
> 
> !!! ... after some experiments corrupting it... now I restore it again
> and decide to strace things... !!!
> 
> LKG8A754B:~# dd < sde4-luks-header-backup  > /dev/sde4
> 150+0 records in
> 150+0 records out
> 76800 bytes (77 kB) copied, 0.0148216 seconds, 5.2 MB/s
> LKG8A754B:~# strace 2>trace cryptsetup luksOpen /dev/sde4 sde4
> Enter LUKS passphrase: 
> key slot 0 unlocked.
> 
> !!! Hey, that just worked !!!
> 
> LKG8A754B:~# ls -l /dev/mapper/sde4
> brw-rw---- 1 root disk 254, 0 Dec 17 02:00 /dev/mapper/sde4
> LKG8A754B:~# cmp -l /dev/sde4 sde4-luks-header-backup 
> cmp: EOF on sde4-luks-header-backup
> 
> !!! But: !!!
> 
> LKG8A754B:~# cryptsetup remove sde4
> !!! no strace !!!
> LKG8A754B:~# cryptsetup luksOpen /dev/sde4 sde4
> Enter LUKS passphrase: 
> automatic header conversion from 0.99 to 0.991 triggered
> <ctrl-c>
> LKG8A754B:~# cmp -l /dev/sde4 sde4-luks-header-backup        
>   168   0  12
>   513 114   0
>   514 125   0
>   515 113   0
>   516 123   0
>   517 272   0
>   518 276   0
>   520   1   0
>   521 141   0
>   522 145   0
>   523 163   0
>   539   0   3
>   540   0  10
>   543   0  17
>   544   0 240
>   553 143   0
>   554 142   0
>   555 143   0
>   556  55   0
>   557 145   0
>   558 163   0
>   559 163   0
>   560 151   0
>   561 166   0
>   562  72   0
>   563 163   0
>   564 150   0
>   565 141   0
>   566  62   0
>   567  65   0
>   568  66   0
>   585 163   0
>   586 150   0
>   587 141   3
>   588  61 210
>   591   0  17
>   592   0 240
> cmp: EOF on sde4-luks-header-backup
> LKG8A754B:~# 
> 
> !!!
> 
> Its done something like overwrite the second sector of the header with
> the first one. I had a look at the cryptsetup code, and the conversion
> message is triggered by it finding the wrong state code for the
> passphrase slot - so the data has been overwritten by the time its got
> there.
> 
> This is reliable - it always seems to corrupt it without strace,
> always works with!???
> 
> Err....

According to the orignal bug reporter, cryptsetup hangs when it shows
"automatic header conversion from 0.99 to 0.991 triggered".  However,
I tried it with a small partition now (ca 90 MB) and it doesn't hang.
I got:

foobar:~# cryptsetup luksOpen /dev/sda5 x
Enter LUKS passphrase:
automatic header conversion from 0.99 to 0.991 triggereddevice-mapper: crypt: Device lookup failed
device-mapper: error adding target to table
device-mapper: device doesn't appear to be in the dev hash table.
Failed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-essiv:sha256 cipher spec and verify that /dev/sda5 contains at least 133 sectors.
Failed to read from key storage
Enter LUKS passphrase:
unknown hash spec in phdrEnter LUKS passphrase:

-- 
Martin Michlmayr
http://www.cyrius.com/
