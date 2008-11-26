From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/9] dm snapshot: shared exception store (v4)
Date: Thu, 27 Nov 2008 01:17:30 +0900
Message-ID: <1227716259-31952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

This is the fourth version of the shared exception store (based on
Zumastor code). You can find the previous submissions:

https://www.redhat.com/archives/dm-devel/2008-August/msg00003.html

https://www.redhat.com/archives/dm-devel/2008-August/msg00087.html

https://www.redhat.com/archives/dm-devel/2008-October/msg00159.html

Except for bug fixes, the major change since the previous version is
fixing the disk endian (Zumastor simply uses the CPU endian for the
disk format). The current code uses little endian for the disk format
(I just slightly tested it with ppc64. It needs more tests, of
course). I also modified the snapshot disk initialization code to
reserve chunks for the journaling mechanism. I've not implemented the
journaling mechanism but there is no need to change the disk format
for that later.

There are 9 patches and I modified only 7th patch (Zumastor shared
snapshot code) since the last submission. IOW, I have not change the
way to refactor the existing code. I'll think about how to integrate
this with the existing code cleaner again but I think that the
user-interface is far more important than how to integrate this with
the existing in-kernel code. We don't want to change the
user-interface after mainline mering while we can evolve (or clean up)
the in-kernel structures any time (and it's not hard at all).

For example, a way to handle the snapshots looks oK?

- create one snapshot (the id is 0):

vine:/home/fujita# dmsetup message work 0 snapshot create 0

- get the list of snapshots:

vine:/home/fujita# dmsetup status
work: 0 268430022 s-snap-origin 2 0 5

(this means we have two snapshots, their IDs are 0 and 5).

With Zumastor code, the maximum number of snapshots is 64 so the above
interface to get the list would work, but it might not work well for
an shared-exception-snapshot implementation that support tons of
snapshots (which someone might implement in the future).

Any opinions?


The patches are available (against the latest Linus git tree):

http://www.kernel.org/pub/linux/kernel/people/tomo/dm-snap/2008-11-26/

If you like a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git dm-snap


The following is the same instruction as the previous submission.

=
In this example, /dev/sda1 is used as an origin device and
/dev/sdb1 is used as a cow device.

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
