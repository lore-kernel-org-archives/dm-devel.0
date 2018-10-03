From: Joe Thornber <thornber@redhat.com>
Subject: Re: extracting thin mappings in real time
Date: Wed, 3 Oct 2018 15:47:21 +0100
Message-ID: <20181003144720.GC20800@reti>
References: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
	<20181003130333.GA20800@reti>
	<CA+fs2JN0FHg_ZGawUACWbJPfCpna1fi7PAMzDem2viNZ-zSthQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+fs2JN0FHg_ZGawUACWbJPfCpna1fi7PAMzDem2viNZ-zSthQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@sunlight.io>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 03, 2018 at 03:13:36PM +0100, Thanos Makatos wrote:
> > Could you say more about why you want to do this?
> >
> 
> So that I can directly read the data block without having to pass through
> dm-thin, e.g. there might be a more direct datapath to the physical block
> device.
> 
> Mappings don't change if you're not using snapshots.  If you are, then any
> > write
> > to a shared block will trigger a copy on write operation, and subsequently
> > a new
> > mapping.
> 
> So for backups etc. I made the metadata snapshot available, which gives you
> > a
> > view of all the metadata frozen at a point in time.  If you're using the
> > metadata
> > snap you still need to guarantee the mappings for the devices that you're
> > interested
> > in are not changing.  eg, instead of backing up a live thin, take a
> > snapshot of the thin
> > and back this up instead.
> >
> 
> For now I can guarantee that these mappings don't change (no snapshots,
> backups, etc), so it's safe to extract the mapping(s) without having
> acquired the meradata snapshot, correct? If this is the case, then how can
> I extract individual mappins? (Either from kernel space or from user
> space.) Are there specific dm-thin kernel functions I should start looking
> at?

Why is this thin-specific?  What happens if there are two thin-pools under
your code?  Do you want the final physical location?  The whole dm stack?

Efficiently reading the metadata requires a cache of metadata blocks.  Thinp uses dm-bufio
to provide this.  It seems very wasteful for you to duplicate this.  So your options are:


i) querying the pool metadata object directly.  Currently there is no way to get hold of the
   metadata object, you would need to make any queries off the io path, since they can block.

ii) or examining the completed bios, you'd probably need to add some per bio data to give context.  

- Joe
