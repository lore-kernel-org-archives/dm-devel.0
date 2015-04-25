From: Christoph Hellwig <hch@infradead.org>
Subject: Re: CONFIG_DM_MQ_DEFAULT makes my kernel unhappy..
Date: Sat, 25 Apr 2015 08:37:32 -0700
Message-ID: <20150425153732.GA10612@infradead.org>
References: <20150425092358.GA15550@infradead.org>
	<20150425152856.GB28453@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150425152856.GB28453@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 25, 2015 at 11:28:57AM -0400, Mike Snitzer wrote:
> On Sat, Apr 25 2015 at  5:23am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Running dm-mpath against a tcm_loop target with two ALUA paths makes
> > the kernel very unhappy when CONFIG_DM_MQ_DEFAULT is set.  Without it
> > it's perfectly happy.
> 
> Wonder if commit 63a4f065ec ("dm: fix add_disk() NULL pointer due to
> race with free_dev()") left something not quite right relative to
> blk-mq?  Or maybe this is a problem confined to blk-mq itself.

I'll give it a spin.

> What were you actually testing when this happened?  Were you failing
> paths under IO load or something?

This happened on the initial udev-direct scan of the devices.

> Also, which upstream commit was your tree based on?  Did you have any
> non-upstream patches applied that I should be aware of?

Latest Linus tree as of this morning.
