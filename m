From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Newbie device mapper questions
Date: Mon, 15 Jun 2015 20:39:54 +0200
Message-ID: <557F1BFA.2080504@gmx.de>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi list,

so I've had this idea stuck in my head for a while and am finally not
intimidated enough my the dm API to actually give it a shot and play
around. I'm just getting used to the DM internals so please apologize if
I sound like an idiot, I'm just new to the DM.

Something that I would like to implement first is a device mapper target
that takes three block devices as input: Two equally sized devices (src1
and src2) and a separate metadata device (meta). I want to map chunks of
the src devices to bits of a bitmap in the meta device. If the bit is
set in the meta device decides whether src1 and src2 is returned.

Sounds pretty easy and I also got surprisingly far with my little kernel
module. I've so far implemented ctr, dtr, map and status.

In map() I actually do the switching operation. I've looked at how
dm-linear implements this and copied a lot of information. Currently I
do static switching (fixed block size, ingoring the meta device). Here
are my questions:

- How can I read within the kernel from the block device lc->meta->bdev?
If I call "read_dev_sector" from "map" this results in a deadlock, I'm
guessing this is now how it's supposed to work. The bcache module must
perform something similar (because it also reads and writes metadata,
only much more complex), but I'll be damned but couldn't find out where
the actual reading/writing is performed in the code. What are things
that I should look at?

- Is the ctr callback the appropriate place to fail if a logical error
occurs? For example, if two src devices of dissimilar size are passed to
dmsetup?

- Is i_size_read(lc->src1dev->bdev->bd_inode) the correct way of
determining the size of the underlying block device? If not, which
function is?

- Can I safely assume the logical sector size is fixed to be 512 bytes
in all cases?

- In the dm-linear example, bio_sectors(bio) is checked. This gives, if
I understand it correctly, the size in sectors of the BIO (usually this
is 8). What I don't understand is in which cases this can become zero
(dm-linear has a if that checks for bio_sectors(bio) != 0).

- Can I determine the size the bio in map() will have already in ctr()
somehow? Can I assume it will never change if it was once determined?
The reason is that for my example I need to make sure the chunk size is
a integer multiple of the bio size and I would only like to check this
once (in ctr) and not every time (in map).

Thank you very much for helping out a complete newbie :-)
Best regards,
Johannes
