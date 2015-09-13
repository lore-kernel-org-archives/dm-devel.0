From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: How do you force-close a dm device?
Date: Sun, 13 Sep 2015 11:30:58 +1000
Message-ID: <20150913113058.0be0f799@korath.teln.shikadi.net>
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

Hi all,

I'm trying to work out how to force-remove a dm device after the
underlying disks failed.  Because the kernel is still trying to write
blocks to the failed devices, I can't unmount the filesystem, so I
don't seem to be able to just drop the data, get some errors, then have
everything unmounted and clean, ready to try again.

  $ dmsetup remove backup
  device-mapper: remove ioctl on backup failed: Device or resource busy
  Command failed

Using --force says it will replace the device with one that returns I/O
errors which sounds perfect, but that just locks up:

  $ dmsetup remove --force backup
  ^C^C^\^\

Running it through strace shows it getting stuck in the kernel:

  $ strace dmsetup remove --force backup
  [...]
  access("/run/udev/control", F_OK)       = 0
  open("/dev/urandom", O_RDONLY)          = 4
  read(4, "\2\325", 2)                    = 2
  semget(0xd4dd502, 1, IPC_CREAT|IPC_EXCL|0600) = 458754
  semctl(458754, 0, SETVAL, 0x1)          = 0
  semctl(458754, 0, GETVAL, 0x7f254875c47a) = 1
  close(4)                                = 0
  semop(458754, {{0, 1, 0}}, 1)           = 0
  semctl(458754, 0, GETVAL, 0x7f254875c417) = 2
  ioctl(3, DM_DEV_SUSPEND

Is there any way to forcefully remove a dm device, or do you have to
reboot to remove failed devices?

Many thanks,
Adam.
