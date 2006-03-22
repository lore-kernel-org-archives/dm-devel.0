From: Jens Axboe <axboe@suse.de>
Subject: Re: Re: dm: bio split bvec fix
Date: Wed, 22 Mar 2006 13:56:24 +0100
Message-ID: <20060322125624.GE4285@suse.de>
References: <20060320192155.GU4724@agk.surrey.redhat.com>
	<20060322113235.GC4285@suse.de>
	<20060322121941.GS26428@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060322121941.GS26428@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 22 2006, Alasdair G Kergon wrote:
> On Wed, Mar 22, 2006 at 12:32:35PM +0100, Jens Axboe wrote:
> > Why isn't this just handled in the merge callback? Can a single page bio
> > span > 2 targets?
>  
> Yes.  (Unit of size if the sector - and things don't have to
> be aligned nicely, just aligned to sector.)
> 
> IIRC the merge function assumes the number of bytes that can
> be added is only a function of the offset: but in our case
> it's also a function of time.  To make this work it should
> reserve those bytes with device-mapper, and guarantee either to 
> supply them to us subsequently (and preferably quickly) or to 
> cancel that reservation.  Device-mapper for its part would
> guarantee to accept the bio without needing to split it.
> Or dm could have a rejection mechanism that refuses bios
> that are too big (because the max number of bytes we accept
> got reduced between the initial call and the bio actually being 
> presented) and they go back and get processed again.

Ok, thanks for the followup explanation, I guess there's no way around
that then.

-- 
Jens Axboe
