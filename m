From: Joe Thornber <thornber@redhat.com>
Subject: Re: [NOTES] thinp zeroing
Date: Thu, 23 Feb 2012 15:43:35 +0000
Message-ID: <20120223154334.GA16341@ubuntu>
References: <20120222141442.GA28145@ubuntu>
 <4F45180C.8030801@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F45180C.8030801@shiftmail.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Spelic <spelic@shiftmail.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 22, 2012 at 05:30:04PM +0100, Spelic wrote:
> On 02/22/12 15:14, Joe Thornber wrote:
> >* Requirements
> >
> >   There are two distinct requirements for zeroing applicable to the
> >   thin-provisioning target:
> >
> >   - Avoid data leaks (DATA_LEAK)
> >
> >* Implementing DATA_LEAK
> >
> >
> >* Implementing ERASE
> >
> >** Erase on deallocation
> >
> >
> >** Erasing from userland.
> >
> >** Crash recovery
> >
> >** Discards
> >
> >
> 
> Hello
> thanks for all your hard work regarding thinp
> 
> I was thinking: why don't you implement a bitmap that takes care of
> emulating the discard functionality?
> 
> This would take care of all your issues above, and also be great for
> a lot of use cases even outside thinp (*).
> 
> Every read would first hit the bitmap; if the bitmap says that the
> region has been discarded, thinp would return zeroes to the
> requestor.

Already done, the first thing a discard bio does is remove mappings
from the btree.  It's then (optionally) handed down to the underlying
device.

> I suggest a bitmap of 4kbytes / bit, and then if a discard comes
> that is not 4K aligned (that would be a mistake of the above layers,
> at least a "performance" mistake), you set the bitmaps only for the
> bits which are completely covered by the discard, and then you are
> left with at most two misaligned edges one at the beginning and one
> at the end of the discard region, and for those you will need to
> write zeroes to the layers below. So in the worst case you need to
> set a few bits and then perform two small writes of zeroes, but in
> most cases you just set a few bits.

Things like SSDs that set the discard_zeroes_data flag are only saying
that they'll return zeroes if you read from this area.  This is
different from promising the data has been overwritten with zeroes on
the disk.  Hence the need in the ERASE case for real writes across the
discarded area.

- Joe
