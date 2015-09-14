From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: How do you force-close a dm device after a disk
 failure?
Date: Mon, 14 Sep 2015 08:43:23 +0200
Message-ID: <55F66C8B.7070603@redhat.com>
References: <20150914102917.3991920c@korath.teln.shikadi.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150914102917.3991920c@korath.teln.shikadi.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, a.nielsen@shikadi.net
List-Id: dm-devel.ids

Dne 14.9.2015 v 02:29 Adam Nielsen napsal(a):
> Hi all,
>
> I'm trying to work out how to force-remove a dm device after the
> underlying disks failed.  Because the kernel is still trying to write
> blocks to the failed devices, I can't unmount the filesystem, so I
> don't seem to be able to just drop the data, get some errors, then have
> everything unmounted and clean, ready to try again.
>
>    $ dmsetup remove backup
>    device-mapper: remove ioctl on backup failed: Device or resource busy
>    Command failed
>
> Using --force says it will replace the device with one that returns I/O
> errors which sounds perfect, but that just locks up:
>
>    $ dmsetup remove --force backup
>    ^C^C^\^\
>
> Running it through strace shows it getting stuck in the kernel:
>
>    $ strace dmsetup remove --force backup
>    [...]
>    access("/run/udev/control", F_OK)       = 0
>    open("/dev/urandom", O_RDONLY)          = 4
>    read(4, "\2\325", 2)                    = 2
>    semget(0xd4dd502, 1, IPC_CREAT|IPC_EXCL|0600) = 458754
>    semctl(458754, 0, SETVAL, 0x1)          = 0
>    semctl(458754, 0, GETVAL, 0x7f254875c47a) = 1
>    close(4)                                = 0
>    semop(458754, {{0, 1, 0}}, 1)           = 0
>    semctl(458754, 0, GETVAL, 0x7f254875c417) = 2
>    ioctl(3, DM_DEV_SUSPEND
>
> Is there any way to forcefully remove a dm device, or do you have to
> reboot to remove failed devices?
>
> I'm running kernel 4.1.4.


You need to show your 'broken' table first.
i.e. you can't replace some targets in some cases (I think suspended thin-pool
with broken metadata cannot be replaced with error target)

However for the 'standard' linear device - you could always replace  opened 
device with error target with '--force'.

What you can't expect is  'device deletion' - as long as device is opened,
it will be present (even if all read & writes will be errored).

As long as kernel structures are in use - device remains present.

Also note - dmsetup remove  supports --deferred removal (see man page).

Zdenek
