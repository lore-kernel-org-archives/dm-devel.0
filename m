From: Jim Meyering <jim@meyering.net>
Subject: blockdev --flushbufs required [was: parted
	issue/question
Date: Wed, 18 Jan 2012 14:44:42 +0100
Message-ID: <87haztruph.fsf_-_@rho.meyering.net>
References: <4F13ADB3.5070806@redhat.com> <87lip6t157.fsf@rho.meyering.net>
	<20120118003802.GA11769@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovirt-devel-bounces@redhat.com>
In-Reply-To: <20120118003802.GA11769@agk-dp.fab.redhat.com> (Alasdair
	G. Kergon's message of "Wed, 18 Jan 2012 00:38:02 +0000")
List-Unsubscribe: <https://www.redhat.com/mailman/options/ovirt-devel>,
	<mailto:ovirt-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ovirt-devel>
List-Post: <mailto:ovirt-devel@redhat.com>
List-Help: <mailto:ovirt-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ovirt-devel>,
	<mailto:ovirt-devel-request@redhat.com?subject=subscribe>
Sender: ovirt-devel-bounces@redhat.com
Errors-To: ovirt-devel-bounces@redhat.com
To: Joey Boggs <jboggs@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, oVirt Development List <ovirt-devel@redhat.com>
List-Id: dm-devel.ids

[Following up on this thread:
 http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/14999]

Alasdair G Kergon wrote:
> Try
>   blkdev --flushbufs
> after any cmd that writes to a dev to see if that makes any difference.

Thanks for the work-around.
Using "blockdev --flushbufs $dev" does indeed make parted
behave the same with dm-backed storage as with other devices.

Adjusting my small example,

  cd /tmp; truncate -s 10m g && loop=$(losetup --show -f g)
  echo 0 100 linear $loop 0 | dmsetup create zub
  dev=/dev/mapper/zub
  parted -s $dev \
    mklabel gpt \
    mkpart efi 34s 34s \
    mkpart root 35s 35s \
    mkpart roo2 36s 36s \
    u s p
  blockdev --flushbufs $dev # FIXME: required with device-mapper-1.02.65-5

  # write random bits to p1
  dd of=${dev}p1 if=/dev/urandom count=1
  dd if=${dev}p1 of=p1-copy.pre count=1
  parted -s $dev mkpart p4 37s 37s
  blockdev --flushbufs $dev # FIXME: required with device-mapper-1.02.65-5

  dd if=${dev}p1 of=p1-copy.post count=1
  cmp -l p1-copy.pre p1-copy.post

With that, the "cmp" show no differences.

Does this sound like a problem in device-mapper land,
or in how parted interacts with DM?
