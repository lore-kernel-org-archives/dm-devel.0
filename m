From: Christoph Hellwig <hch@infradead.org>
Subject: Re: shutting down logical volumes once an underlying
 device fails?
Date: Fri, 28 Sep 2012 09:05:05 -0400
Message-ID: <20120928130505.GA16549@infradead.org>
References: <20120926161106.GA12653@infradead.org>
	<20120926201116.GD7882@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120926201116.GD7882@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Wed, Sep 26, 2012 at 04:11:17PM -0400, Mike Snitzer wrote:
> 
> Don't think any shutdown should be initiated by the kernel.
> 
> But events that userspace could respond to by deactivating (an
> arbitrarily complex) lvm device would be the way forward IMHO.

Deactivating is maybe a bit of a too strong word.  But I'd expect we'll
get EIO from al sectors not just those on the failed device.

> Could this tie back to needing better UA handling/notification between
> kernel<->userspace?

That current proposed solution we have internally is to simply poll
the status output for the PVs and handle it all in userspace.  To me
this seems a bit clumsy, but at least it's easily doable in short time.
