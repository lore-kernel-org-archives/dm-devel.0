From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: dmsetup remove gives EBUSY (even though it shouldn't be
	busy)
Date: Mon, 25 May 2015 00:31:25 +0200
Message-ID: <5562513D.3080203@gmx.de>
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

Hi list,

apologies if I'm at the wrong place, but I think this is dm related
(even though in practice the device I'm talking about is using the
dm-crypt target).

This is my problem: I have a open dm-crypt mapping (LUKS) on which I do
perform some block operations (copying). There are no mounted file
systems on the copied device handles at any time. Let's say my device is
called under /dev/mapper/foobar and I'm writing to that block device.

The file descriptor that points to the /dev/mapper/foobar is then closed
via close(2). Then I call sync(2).

Afterwards I fork/exec the command "dmsetup remove foobar". This yields:

device-mapper: remove ioctl on foobar failed: Device or resource busy
Command failed

And results in return code 1. I'm only getting this behavior with slow
disks (i.e. cannot reproduce with a loop device that points to /dev/shm
as underlying block device). And I'm guessing there's some
buffers/caches still in use (i.e. pending writes) which is why dmsetup
returns EBUSY. What I don't understand is why the sync(2) call does not
block until all pending writes have been flushed.

If I do insert sleep(10) before my "dmsetup remove" call, it works
smoothly -- but this is hardly a solution.

Do you have any pointers on why this happens and how I can cleanly solve
this?

Thank you very much,
Cheers,
Johannes
