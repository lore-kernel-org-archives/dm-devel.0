From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Shared Memory Pages for Same Base Device
Date: Mon, 22 Sep 2014 09:08:03 -0400
Message-ID: <20140922130803.GA5343@redhat.com>
References: <541DA23F.6000003@treefrog.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <541DA23F.6000003@treefrog.ca>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Sep 20 2014 at 11:50am -0400,
Shao Miller <shao.miller@treefrog.ca> wrote:

> Good day to all.
> 
> If I've some block device "base" and I've two derived device-mapper
> devices "derived1" and "derived2" that are copy-on-write layers over
> top of that base, and I mount the filesystems on those derived block
> devices and run the same program "foo" from both, does the "foo"
> running from "derived1" share any [read and execute] memory pages
> with the "foo" running from "derived2", since the underlying sectors
> are both from the same position on "base"?
> 
> The more general question would be about mmap, but I hope this
> example is clear.  "Docker"[1] uses device-mapper in scenarios like
> the above example and I'm curious if they benefit from shared pages.
> 
> [1] https://www.docker.com/

Unfortunately device-mapper thin provisioning doesn't offer shared
pagecache pages across snapshot volumes.  This is a block layer
limitation (the block layer doesn't allow pages to be shared across
block devices, and dm-thinp snapshot volumes are each a block device).
Modifying the VM, block and DM subsystems to provide this capability is
not an easy task and as such is really not a near-term priority.

Interestingly BTRFS does _not_ offer this page sharing either.  I'm told
that the only emerging solution for this is overlayfs.
