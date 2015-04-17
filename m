From: =?ISO-8859-1?Q?Murilo_Opsfelder_Ara=FAjo?= <mopsfelder@gmail.com>
Subject: Device mapper failed to open temporary keystore device
Date: Fri, 17 Apr 2015 17:11:51 -0300
Message-ID: <CA+LKeY6Vm=hWj+gaKxm5JqLqehu8557OX2101a8roKas6WcsFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello, everyone.

Right after I enter my passphrase to unlock my cryptsetup partition,
it displays the following error and asks for cryptsetup password again
(it got stuck on this loop).

This issue was introduced in next-20150413.  next-20150410 is working just fine.

Any hint on how to debug this?

Unlocking the disk /dev/disk/by-uuid/<uuid> (sda5_crypt)
Enter passphrase: *****
[  244.239821] device-mapper: table: 252:0: crypt: Error allocating crypto tfm
device-mapper: reload ioctl on  failed: No such file or directory
Failed to open temporary keystore device.
device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
such device or address
device-mapper: reload ioctl on temporary-cryptsetup-239 failed: No
such device or address
device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
such device or address
device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
such device or address
device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
such device or address
device-mapper: remove ioctl on temporary-cryptsetup-239 failed: No
such device or address

-- 
Murilo
