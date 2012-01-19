From: Joe Thornber <thornber@redhat.com>
Subject: Re: About the thin provision function @ kernel 3.2 or
 later.
Date: Thu, 19 Jan 2012 09:14:41 +0000
Message-ID: <20120119091434.GA3942@ubuntu>
References: <CACaC9DzwWWdy3YBrs1KMx6RnwvU8wC2q_OrVTCzp2+rbEirBVQ@mail.gmail.com>
	<20120116143816.GA2184@ubuntu> <20120116155959.GC4667@thunk.org>
	<20120117101330.GA15182@ubuntu> <20120117155930.GA11903@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120117155930.GA11903@thunk.org>
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

On Tue, Jan 17, 2012 at 10:59:30AM -0500, Ted Ts'o wrote:
> On Tue, Jan 17, 2012 at 10:13:31AM +0000, Joe Thornber wrote:
> > iii) We add support to patch metadata changes into the running
> > metadata device.  This would allow us to map the origin directly into
> > the pools data device (eg, using a linear target).  And then introduce
> > a mapping for that origin.  This would mean the origin would appear as
> > a thin dev within the pool.
> 
> Have you considered just doing this part first?  If there's a way that
> an existing linear region could be considered a data source for a
> pool, then wouldn't you get full support of existing LVM2 volumes
> (read-only and read/write) for free, at one fell swoop?

Yes, this is the solution that I like best.  But I've only recently
thought of it whilst I coded up the thinp_dump and thin_restore tools.
Note that by using these tools and doing some manipulation of the
metadata you can do this today in an offline mode.

> Given that it's relatively rare that volume groups get moved, this
> could even be something which is done as a off-line conversion step so
> that existing LVM volumes are treated as "thin-provisioned voumes"
> that happened to be fully provisioned, with some flag so that a
> discard operation doesn't cause the blocks to be freed for use by some
> other thin-provisioned volume, but instead is propagated down to the
> hardware (for better SSD performance).

Certainly the discard support needs to do two things; release the
block and pass the discard down to the device.  Making the first part
optional sounds sensible to me.

- Joe
