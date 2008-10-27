From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/9] dm snapshot: shared exception store
Date: Mon, 27 Oct 2008 21:07:47 +0900
Message-ID: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is the third version of the shared exception store (based on
Zumastor code). You can find the first and second submission:

https://www.redhat.com/archives/dm-devel/2008-August/msg00003.html

https://www.redhat.com/archives/dm-devel/2008-August/msg00087.html


The major change since the second version is the snapshot deletion
support. When you delete a snapshot, you can reclaim the disk spaces
that it used.

I would appreciate it if I could get comments on user interface, the
changes to the existing code, etc though there are still several
things to fix; the major one is disk format endian (Zumastor simply
uses the CPU endian for the disk format).


There are 9 patches and #1-6 patches include the changes to the
existing code necessary to support the shared exception dm-snapshot.

There are not any major changes to #1-6 patches since the last submission.

The patches are available (against 2.6.28-rc2):

http://www.kernel.org/pub/linux/kernel/people/tomo/dm-snap/2008-10-27/

If you like a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git dm-snap

=
In this example, /dev/sda1 is used as an origin device and /dev/sdb1
is used as a cow device.

- first, set up an origin and a cow:

vine:/home/fujita# echo |dmesg create --notable work
vine:/home/fujita# echo 0 `blockdev --getsize /dev/sda1` s-snap-origin /dev/sda1 /dev/sdb1 S 16|dmsetup load work
vine:/home/fujita# dmsetup resume work


- confirm the current status:

vine:/home/fujita# dmsetup status
work: 0 268430022 s-snap-origin : no snapshot


- create one snapshot (the id is 0):

vine:/home/fujita# dmsetup message work 0 snapshot create 0


- see if the snapshot is created:

vine:/home/fujita# dmsetup status
work: 0 268430022 s-snap-origin 1 0


- create one more snapshot (the id is 5) and see the result:

vine:/home/fujita# dmsetup message work 0 snapshot create 5
vine:/home/fujita# dmsetup status
work: 0 268430022 s-snap-origin 2 0 5

Note that creating a snapshot just means that you store some
information on the cow device. You don't create a device for it yet.


- create a device to access to the snapshot #5

vine:/home/fujita# echo |dmsetup create --notable snap5
vine:/home/fujita# echo 0 `blockdev --getsize /dev/sda1` s-snap /dev/sda1 5|dmsetup load snap5
vine:/home/fujita# dmsetup resume snap5

- confirm the current status:

vine:/home/fujita# dmsetup status
snap5: 0 268430022 s-snap Unknown
work: 0 268430022 s-snap-origin 2 0 5


- remove the devices after you play with them:

vine:/home/fujita# dmsetup remove snap5
vine:/home/fujita# dmsetup remove work
vine:/home/fujita# dmsetup info
No devices found


- Again, setup the origin and the cow:

vine:/home/fujita# echo |dmsetup create --notable work
vine:/home/fujita# echo 0 `blockdev --getsize /dev/sda1` s-snap-origin /dev/sda1 /dev/sdb1 S 16|dmsetup load work
vine:/home/fujita# dmsetup resume work
vine:/home/fujita# dmsetup status
work: 0 268430022 s-snap-origin 2 0 5

Note that you have two snapshots that you created. You can play with
them again after creating devices for them.


- delete the 5th snapshot

vine:/home/fujita# dmsetup message work 0 snapshot delete 5
vine:/home/fujita# dmsetup status
work: 0 268430022 s-snap-origin 1 0


*) By default, dmsetup perfomrs multiple tasks. I uses dmsetup
commands that issue a single ioctl to make things clear.
