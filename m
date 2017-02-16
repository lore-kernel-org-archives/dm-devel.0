From: Mike Snitzer <snitzer@redhat.com>
Subject: hch's native NVMe multipathing [was: Re: [PATCH 1/2]
 Don't blacklist nvme]
Date: Wed, 15 Feb 2017 21:53:57 -0500
Message-ID: <20170216025357.GA9241@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<20170215145617.GA4241@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170215145617.GA4241@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Wed, Feb 15 2017 at  9:56am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Feb 14, 2017 at 04:19:13PM -0500, Keith Busch wrote:
> > These devices are mulitpath capable, and have been able to stack with
> > dm-mpath since kernel 4.2.
> 
> Can we make this conditional on something?  I have native NVMe
> multipathing almost ready for the next merge window which is a lot easier
> to use and faster than dm.  So I don't want us to be locked into this
> mode just before that.

You've avoided discussing this on any level (and I guess you aren't
going to LSF/MM?).  Yet you're expecting to just drop it into the tree
without a care in the world about the implications.

Nobody has interest in Linux multipathing becoming fragmented.

If every transport implemented their own multipathing the end-user would
be amazingly screwed trying to keep track of all the
quirks/configuration/management of each.

Not saying multipath-tools is great, nor that DM multipath is god's
gift.  But substantiating _why_ you need this "native NVMe
multipathing" would go a really long way to justifying your effort.

For starters, how about you show just how much better than DM multipath
this native NVMe multipathing performs?  NOTE: it'd imply you put effort
to making DM multipath work with NVMe.. if you've sat on that code too
that'd be amazingly unfortunate/frustrating.
