From: thornber@redhat.com
Subject: Re: [PATCH 8/8] [dm-cache] cache target
Date: Fri, 14 Dec 2012 10:09:59 +0000
Message-ID: <20121214100958.GA3022@raspberrypi>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-9-git-send-email-ejt@redhat.com>
	<20121214001753.GA9845@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121214001753.GA9845@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 13, 2012 at 04:17:53PM -0800, Darrick J. Wong wrote:
> Mmmm, another one!  I've been looking forward to this.... :)
> > +dm-cache is a device mapper target written by Joe Thornber, Heinz
> > +Maueslhagen, and Mike Snitzer.
> 
> Is this "Mauelshagen"?

y

> 
> > +- Migration -  Movement of a logical block from one device to the other.
> > +- Promotion -  Migration from slow device to fast device.
> > +- Demotion  -  Migration from fast device to slow device.
> 
> If a block is promoted to the fast device, is it always the case that the block
> still resides on the slow device?  The existence of WT mode implies this, but
> on the other hand you do say "move" here.
> 
> Or is this more like tiered storage where promoting a block moves it to the
> fast device and it's no longer on the slow device?
> 
> Put another way -- if I use my SSD as a writethrough cache for a disk and one
> day the SSD loses its brains, can I expect to still have a reasonably up to
> date copy on the disk?

The cached device is the same size as the origin (not origin + ssd).
If writethrough mode is selected then writes will not complete until
they've hit both the origin and the cache.  This makes it a relatively
safe way to try the cache out.

Here's the little test I use to demonstrate this:

  def test_writethrough
    size = gig(2)

    # wipe the origin to ensure we don't accidentally have the same
    # data on it.
    with_standard_linear(:data_size => size) do |origin|
      wipe_device(origin)
    end

    # format and set up a git repo on the cache
    with_standard_cache(:format => true,
                        :io_mode => :writethrough,
                        :data_size => size) do |cache|
      git_prepare(cache, :ext4)
    end

    # origin should have all data
    with_standard_linear(:data_size => size) do |origin|
      git_extract(origin, :ext4, TAGS[0..1])
    end
  end

> How do I calculate how big the metadata device has to be?

Metadata size will be proportional to the number of blocks in your
cache (ssd_size / block_size).  For each block we store:

 - The mapping and some flags (64bits)
 - Policy hint data (size determined by policy, 64bit for mq)

In addition we store a small bitset that records the discard state of
the origin.

A good rule of thumb would be: 4mb + (16bytes * nr_blocks)

> Is there any documentation for the message formats?
> 
> Or the policy parameters?

Not yet, I'll let Heinz handle this, he put the messaging stuff in.

- Joe
