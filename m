From: Frans Pop <elendil@planet.nl>
Subject: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Date: Thu, 25 Jun 2009 09:04:56 +0200
Message-ID: <200906250904.57149.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759163AbZFYHFI@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

During boot of 2.6.31-rc1 on an arm EABI system I got the following errors:

device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
device-mapper: table: 254:0: target device sda6 is misaligned
device-mapper: table: 254:0: target device sda6 is misaligned
device-mapper: table: 254:1: target device sda6 is misaligned
device-mapper: table: 254:1: target device sda6 is misaligned

The boot did complete successfully. A boot with 2.6.30 just previously was
clean, and when I reboot back into 2.6.30 the messages are gone again.

The system has a single volume group with two logical volumes.

Please advise and let me know what additional info is needed.

Cheers,
FJP
