From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Re: [PATCH] dm-add-ioband.patch
Date: Mon, 06 Apr 2009 12:18:01 +0900 (JST)
Message-ID: <20090406.121801.193718314.ryov@valinux.co.jp>
References: <20090310.202029.193700185.ryov@valinux.co.jp>
	<20090403.185342.104044695.ryov@valinux.co.jp>
	<20090403140841.GA15631@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090403140841.GA15631@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, hch@infradead.org
Cc: agk@redhat.com
List-Id: dm-devel.ids

Hi Christoph,

> > I would appreciate it if you could take a look and review this patch
> > and advice me about merging dm-ioband to upstream.
> 
> Do we have any agreement on what io bandwith controller we want to
> merge?  Personally I don't think a dm target is a good idea, this seem
> like something we want to tie into the block layer directly, especially
> when using cfq so that it gets integrated into the scheduling decisions.

I don't think the IO bandwidth controller has to be integrated into
the IO scheduler, because I think there are many cases where people
only want bandwidth control, no need to classify IOs like CFQ.
I think a dm target is a very good idea for the following reasons:
- A user have a choice whether to use dm-ioband or not, and dm-ioband
  doesn't make any effects on the system if a user doesn't use it.
- The dm target is highly independent module, so we don't need to modify
  the existing kernel code including the IO schedulers. It can keep
  the IO scheduler and the IO bandwidth controller implementations
  simple.

Thanks,
Ryo Tsuruta
