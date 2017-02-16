From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2]
 Don't blacklist nvme]
Date: Thu, 16 Feb 2017 07:37:02 -0500
Message-ID: <20170216123702.GA12047@redhat.com>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
	<20170215145617.GA4241@infradead.org>
	<20170216025357.GA9241@redhat.com>
	<d1f39bbd-d5fe-06d7-34a7-484b723886c9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d1f39bbd-d5fe-06d7-34a7-484b723886c9@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

On Thu, Feb 16 2017 at 12:00am -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 02/15/17 18:53, Mike Snitzer wrote:
> >Nobody has interest in Linux multipathing becoming fragmented.
> >
> >If every transport implemented their own multipathing the end-user would
> >be amazingly screwed trying to keep track of all the
> >quirks/configuration/management of each.
> >
> >Not saying multipath-tools is great, nor that DM multipath is god's
> >gift.  But substantiating _why_ you need this "native NVMe
> >multipathing" would go a really long way to justifying your effort.
> >
> >For starters, how about you show just how much better than DM multipath
> >this native NVMe multipathing performs?  NOTE: it'd imply you put effort
> >to making DM multipath work with NVMe.. if you've sat on that code too
> >that'd be amazingly unfortunate/frustrating.
> 
> Another question is what your attitude is towards dm-mpath changes?
> Last time I posted a series of patches that significantly clean up
> and improve readability of the dm-mpath code you refused to take these upstream.

Weird.  I did push back on those changes initially (just felt like
churn) but I ultimately did take them:

$ git log --oneline --author=bart drivers/md/dm-mpath.c
6599c84 dm mpath: do not modify *__clone if blk_mq_alloc_request() fails
4813577 dm mpath: change return type of pg_init_all_paths() from int to void
9f4c3f8 dm: convert wait loops to use autoremove_wake_function()

Did I miss any?

But to be 100% clear, I'm very appreciative of any DM mpath (and
request-based DM core) changes.  I'll review them with a critical eye
but if they hold up they get included.

Mike
