From: Hans van Kranenburg <hans@knorrie.org>
Subject: dm-integrity + mdadm + btrfs = no journal?
Date: Sun, 4 Nov 2018 23:55:55 +0100
Message-ID: <996277c4-90c0-8ab9-8a93-99f4ca3e487e@knorrie.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en_US
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

Hi dm-devel list,

I have a question, or actually want to share a thought experiment about
using the stuff mentioned in the title of the post, and I'm looking for
feedback on it that either sounds like "Yes, you got it right, you can
do this." or "Nope, don't do this, you're missing the fact that XYZ".

---- >8 ----

The use case here is running a linux server in the office of a
non-profit organization that I support in my free time. The hardware is
a donated HP z820 workstation (with ECC memory, yay) and 4x250G 10k SAS
disks.

The machine will run a bunch of Xen virtual machines. There are no
applications which demand particularly high disk write/read performance.

Encryption of storage is not a requirement. Well, the conflicting
requirement is that after power loss etc. the machine has to be able to
fully boot itself again without intervention from a sysadmin.

But, reliability is important. And that's why I was thinking about
starting to use dm-integrity in combination with mdadm raid to get some
self-healing bitrot repair capability.

The 4 disks would have a mdadm raid1 /boot on the first two disks and
then on each disk a partition and mdadm raid10 with dm-integrity
underneath it, separately for each disk. On top of the raid10 goes LVM,
with logical volumes for the Xen virtual machines.

---- >8 ----

Now, my question is:

  If I'm using btrfs as filesystem for all the disks in this lvm volume
group, can I then run dm-integrity without journal?

Btrfs never overwrites data in place. It writes changes to a new place,
and commits transactions while writing the btrfs superblock, switching
visiblity after crash to new metadata and data. Then only during the
following transaction it allows the disk blocks that were already freed
in the previous transaction to be overwritten again.

The only dangerous thing that remains here I guess is writing the btrfs
superblock to mdadm raid10. If this fails on every disk it's ending up
at with inconsistency between data and metadata on dm-integrity level, I
guess I'm screwed. So, a crash / power loss at exactly the moment
between both writes and for both disks...

So the question in this case is... is the chance of this happening lower
than the chance of some old sas disk presenting bitrot back to linux,
and having mdadm use that and slowly cause vague errors?

---- >8 ----

Or maybe I'm missing something else entirely. I'm here to learn. :)

---- >8 ----

Additional question:

Section 4.4 "Recovery on Write Failure" mentions:
  "A device must provide atomic updating of both data and metadata. A
situation in which one part is written to media while another part
failed must not occur. Furthermore, metadata sectors are packed with
tags for multiple sectors; thus, a write failure must not cause an
integrity validation failure for other sectors."

I don't fully understand the last part. Can non-journalled dm-integrity
result in 'integrity validation failure for other sectors'? Which
sectors are those other sectors? Are they sectors that were written
earlier and are not touched during the current write? Is this a similar
thing to the RAID56 write hole? From what I read and understand so far,
that seems to not be the case, since the lost dm-integrity metadata
write would only cause IO errors for the newly added data?

Thanks a lot in advance,
Hans
