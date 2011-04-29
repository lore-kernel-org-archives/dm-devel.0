From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: do not disable ext4 discards on first discard
 failure? [was: Re: dm snapshot: ignore discards issued to the
 snapshot-origin target]
Date: Fri, 29 Apr 2011 09:55:57 -0400
Message-ID: <20110429135556.GB31165@redhat.com>
References: <20110412234706.GA11244@redhat.com>
	<20cf301cbef67d323104a0c2ff52@google.com>
	<20110413224025.GA18589@redhat.com>
	<20110413234854.GA19793@redhat.com>
	<20110426173213.GA19604@redhat.com>
	<20110428001912.GA14659@redhat.com>
	<20110428075355.GA2190@infradead.org>
	<20110428205935.GA24979@redhat.com>
	<1D2A9D06-CBD3-4DC8-B1D5-69DDCEB44238@dilger.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1D2A9D06-CBD3-4DC8-B1D5-69DDCEB44238@dilger.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, sandeen@redhat.com, "linux-ext4@vger.kernel.org device-mapper development" <dm-devel@redhat.com>, DarkNovaNick@gmail.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 28 2011 at  9:12pm -0400,
Andreas Dilger <adilger.kernel@dilger.ca> wrote:

> On Apr 28, 2011, at 14:59, Mike Snitzer wrote:
> > Eric and I think it is best to revert this commit:
> > a30eec2 ext4: stop issuing discards if not supported by device
> > 
> > (though ideally ext4 would still WARN_ONCE per superblock with something
> > like: "discard failed, please consider disabling discard support")
> > 
> > 1) The user asked for discards (with '-o discard' mount option)
> >   - what is the real harm in coninuing to issue them even if it _seems_
> >     they aren't supported?
> 
> Aren't discard operations considered barriers?  If there are needless
> discard operations being sent to the disk then it seems like this
> would have a non-zero performance penalty, just by virtue of blocking
> IO submissions at the block device layer.

The blkdev_issue_discard() interface is synchronous.  Given that, yes it
will cause jbd2 to block waiting for it to complete.

For DM, the discard would not actually be issued to the physical storage
there is still work that would be done to submit the bio only to have DM
return -EOPNOTSUPP.

But ext4 doesn't care if it is on DM or not; so I agree that cost of
continuing to issue discards would be higher on non-DM storage.

That said, the user asked for discards via -o discard.  Ext4 is taking
that to mean "no the user only _really_ asked for discards if they will
always work".

If ext4 is committed to that disable-on-first-failure hueristic then
Documentation/filesystems/ext4.txt should probably speak to it.
 
> > 2) assuming the entire block device uniformly supports discards can
> >   be flawed (a DM device's discard support can vary based on logical
> >   offset).
> 
> Hybrid storage is potentially an increasingly popular configuration.
> We've been looking at DM-mapped SSD RAID-1 + HDD RAID-6 arrays for
> ext4 to allow storing only the metadata on SSD.

Meaning you assemble a tailormade DM linear (concat) device that mixes
the two?  What are you using to assemble that device -- presummably some
code that is aware of ext4's metadata and data layout?  Code hooked off
of mkfs?

> That said, it may
> make sense to have the DM translation layer check the component
> devices of an LV to see if discard is supported on any of them, and
> only return -EOPNOTSUPP if none of them do.

That is what DM does.  DM will only return -EOPNOTSUPP if a particular
target doesn't support discards.  If only one device supports discards
then the entire logical DM device advertises discard support.

Mike
