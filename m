From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: linear writes on read-only zero devices,
	any alternatives?
Date: Sun, 3 Mar 2013 11:36:23 +0000 (UTC)
Message-ID: <kgvcjn$l3e$3@ger.gmane.org>
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

Hello,

I'm trying to build a block device with a small writable area (a loopback
device) and a large read-only area full of zeroes.

Stacking a read-only zero device doesn't work, because linear writes to it
anyway (tested in 3.8.1, steps below).

It seems to be a bug, but in case it isn't or can't be fixed, could one 
of the dm targets (linear, error, or zero) get a read-only flag that 
ensures that writes do fail?

Test case:
sudo dmsetup create --readonly --table '0 1024 zero' rozero
sudo dmsetup create --table '0 1024 linear /dev/mapper/rozero 0' synthetic
sudo dd if=/dev/urandom of=/dev/mapper/synthetic bs=512 count=1024
