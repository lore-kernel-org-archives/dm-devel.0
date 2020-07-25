From: Michael Tokarev <mjt@tls.msk.ru>
Subject: dm snapshots again: should they work?
Date: Sat, 25 Jul 2020 09:42:31 +0300
Message-ID: <4b9db271-503b-c89d-aacb-f0c2f82c9153@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
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

Hi!

Some time ago I had to use snapshots of a filesystem which was not on LVM,
so I decided to give dmsetup snapshot/snapshot-origin a try.  And discovered
that besides the very specific LVM-like scenario, this thing just does not
work, - it crashes the kernel after a very simple action. Also there's almost
no documentation about this.  Hence my question.

For a test, I made 2 loop devices of two files, loop0 of 1G and loop1 of 100M.
They're not used in any way, just losetup'ed. First to be used as a base image,
second is for snapshot/cow data.

Next I create snapshot-origin device on top of loop0. Documentation _only_
states I should create a linear mapping first and replace it with a snapshot-
origin target while I/O is suspended, and LVM does exactly this, but I
thought - since this device isn't used, I'd create snapshot-origin right
out of it.  Created snapshot-origin /dev/mapper/snaporig device, so far
so good. But now, any (write) access to this device instantly crashes the
kernel with either reboot or hard lockup, depending on the kernel version.

So here come first 2 questions.  Is this usage wrong somehow? As far as
I can see, this is normal usage (besides replacing the table vs creating
new table, and besides not locking I/O), and this is how the whole stack
looks like whithout an actual snapshot.  And if this usage is wrong,
shouldn't kernel forbid it somehow, instead of crashing?

As far as I understand, one snapshot-origin can be used for several
snapshots (again, this isn't exactly clear from the documentation), so
my idea was to create snapshot-origin and mount it mount it first,
so I'll be able to create snapshots later as needed. Is it okay to have
more than one snapshot out of snapshot-origin, or is it always a 1:1 pair,
one snapshot-origin and one snapshot? If it's the latter, again, maybe
kernel should refuse to have snapshot-origin without snapshot with
non-suspended I/O -- eg, when creating snapshot-origin we can have
I/O suspended initially, and refuse to resume it without exactly one
snapshot.

On the other hand, it seems I can remove snapshot table (after creating
and playing with it), and _mounted_ snapshot-origin device continues
to operate normally without kernel crashing. This is exactly the same
stack as I initially created, the only difference is the way it was
created - first time (when it crashes) I created only snapshot-origin
and mounted it, the second time I created both snapshot-origin and
snapshot on top of it, and removed snapshot later, leaving
snapshot-origin only. This works, or at least appears to work -
again, from the documentation it is unclear whenever this is
supposed to work or not.

Another question is about the usage of the original device being
snapshotted. In almost all examples it is another DM device,
and it is used for _both_ the snapshot and snapshot-origin.
For me as a end-user, a more logical would be to have the
original device as a base for snapshot-origin (which includes
the CoW functionality), and this snapshot-origin device being
a base for snapshot(s), - snapshots which receive the CoW data.
But it seems both snapshot-origin _and_ snapshot have the
original device as a base, - it is not exactly clear how the
two communicate with each other this way.  Can snapshot be
made out of snapshot-origin, or will kernel crash there too?

I haven't tested all other possible variants and scenarios, thought
I'd ask first how this whole thing is _supposed_ to work.

A very useful information about this stuff is found on this 2004 email:
https://www.redhat.com/archives/dm-devel/2004-July/msg00071.html

This and a few other, very scarce, references exists, but it is
difficult to get whole picture.. and it definitely is not clear
at all why kernel crashes. To me, dmsetup is a basic command like
ls or cp, - and running either of them with wrong argument (even
if it is not clear _why_ it's wrong) should not result in the
system crashing. Whole thing looks very fragile and untested,
after these experiments (in a virtual machine so I wont need to
reboot larger box 100 times a hour) I now have a conditioned
reflex - I expect the system crash on me after hitting <Enter>
on the next dmsetup command, so it is always a heart-breaking
thing to actually hit the damn Enter :)	

And BTW, I actually completed the origina task I had with
snapshots, but it took me quite some time and amount of
crashes/reboots to find the proper sequence of the commands,
and to replicate this sequence on a production system. It
worked flawlessly, but I knew that any step aside of this
is a sure way to lock up the system.

Thanks,

/mjt
