From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: CONFIG_DM_MQ_DEFAULT makes my kernel unhappy..
Date: Mon, 27 Apr 2015 15:03:19 -0400
Message-ID: <20150427190319.GB9976@redhat.com>
References: <20150425092358.GA15550@infradead.org>
	<20150425152856.GB28453@redhat.com>
	<20150425153732.GA10612@infradead.org>
	<20150426141628.GA7085@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150426141628.GA7085@infradead.org>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Apr 26 2015 at 10:16am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Apr 25, 2015 at 08:37:32AM -0700, Christoph Hellwig wrote:
> > I'll give it a spin.
> > 
> > > What were you actually testing when this happened?  Were you failing
> > > paths under IO load or something?
> > 
> > This happened on the initial udev-direct scan of the devices.
> > 
> > > Also, which upstream commit was your tree based on?  Did you have any
> > > non-upstream patches applied that I should be aware of?
> > 
> > Latest Linus tree as of this morning.
> 
> Seems like the first warning goes away without CONFIG_DEBUG_OBJECTS.
> Note that in either way I/O over dm-mpath actually works fine.

I'm not seeing any warnings with use_blk_mq=Y but I don't have
CONFIG_DEBUG_OBJECTS set.  I expected to still see the later errors you
saw though.  Unfortunately (or fortunately? ;) I'm not... with 4.1-rc1
on a pretty fast bare-metal system.

Since you can easily reproduce you might need to chase down the problem.

BTW, I'm liking LIO and these lio-utils for quick test setups.. much
more useful than scsi_debug!

For now I'll move on to reviewing/testing your v2 patch.
