From: Joe Thornber <thornber@redhat.com>
Subject: Re: Multisnap / dm-thin
Date: Thu, 19 Jan 2012 09:33:45 +0000
Message-ID: <20120119093343.GB3942@ubuntu>
References: <4F16A07C.7040705@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F16A07C.7040705@shiftmail.org>
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

On Wed, Jan 18, 2012 at 11:35:40AM +0100, Spelic wrote:
> Hello all,
> I would need the multisnap feature, i.e., the ability to make many
> snapshots without high performance degradation...
> I saw it mentioned around, but it does not seem to be in the kernel
> yet. Is it planned to be introduced? Is there an ETA?
> 
> Note that I am not very fond of the new dm-thin which is planned to
> have a multisnap-equivalent feature, because of the fragmentation it
> will cause (I suppose a defragmenter is long way to come). Not
> having fragmentation is the reason for using blockdevices instead of
> loop mounted files after all isn't it?

The point of multisnap is that blocks of data are shared between
multiple snapshots (unlike the current single snap implementation).
Saving both disk space, and probably more importantly, redundant
copying.  As such I struggle to see why you think it's possible to do
this and keep all the data contiguous.  Both Mikulas' multisnap, and
my thinp, use btrees to store the metadata, and allocate data blocks
on a first come first served basis.

Fragmentation is a big concern; but until I have a good idea what real
world usage patterns for thinp are I'm a bit short of data to base any
improvements to the allocator on.  If you want to help I'd love to
know your usage scenario, and the slow down you're observing as the
pool ages.

As far as a defragmenter goes.  My first approach will be allowing
people to set a 'copy-on-read' flag on thin devices that they feel are
too fragmented.  This will then trigger the current machinery for
breaking sharing - but reallocating according to the _current_ io
usage pattern.  This should be a very small change, when I see
real world fragmentation, I'll implement it.

Maybe your requirement is for the origin to be a preexisting,
contiguous device?  In which case see the other discussion thread with
Ted Tso.

- Joe
