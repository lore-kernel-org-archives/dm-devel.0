From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Shared Memory Pages for Same Base Device
Date: Mon, 22 Sep 2014 10:26:27 -0400
Message-ID: <20140922142626.GB5698@redhat.com>
References: <541DA23F.6000003@treefrog.ca> <20140922130803.GA5343@redhat.com>
	<54202D4D.1030901@treefrog.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <54202D4D.1030901@treefrog.ca>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shao Miller <shao.miller@treefrog.ca>
Cc: clm@fb.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 22 2014 at 10:08am -0400,
Shao Miller <shao.miller@treefrog.ca> wrote:

> On 9/22/2014 9:08 AM, Mike Snitzer wrote:
> >
> >Unfortunately device-mapper thin provisioning doesn't offer shared
> >pagecache pages across snapshot volumes.  This is a block layer
> >limitation (the block layer doesn't allow pages to be shared across
> >block devices, and dm-thinp snapshot volumes are each a block device).
> >Modifying the VM, block and DM subsystems to provide this capability is
> >not an easy task and as such is really not a near-term priority.
> 
> I sincerely appreciate your response, Mike.  I figured as much, but
> hopefully this thread will be useful to future searchers.
> 
> >Interestingly BTRFS does _not_ offer this page sharing either.  I'm told
> >that the only emerging solution for this is overlayfs.
> This is very surprising.  I've just done some testing and
> /proc/PID/maps for the same binary from two different snapshots
> deriving from the same base do show the same block-device major and
> minor, with the same offset.  Do you happen to have a reference for
> that detail about BTRFS, or perhaps an idea for the right venue to
> learn more about that?  Unfortunately, I guess it's off-topic for
> device-mapper.

I learned as much from Chris Mason (cc'd) in a FB thread I started on
this very topic.  Chris said:

"It would be awesome if we had a way to share page cache pages cow style
across filesystem snapshots. Every file ends up with its own address
space, so we really need to just share the pages. It's complex though"
 
> Also unfortunately, it seems that overlayfs isn't mainline Linux nor
> out-of-the-box for some distributions.  (Like CentOS 7.)
> 
> I enjoy device-mapper for CoW iSCSI and AoE.  Keep up the great work, folks!

Thanks
