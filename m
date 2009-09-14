From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: IO controller Mini-Summit 2009
Date: Sun, 13 Sep 2009 22:15:10 -0400
Message-ID: <20090914021509.GB4070@redhat.com>
References: <20090826.203251.260094379.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090826.203251.260094379.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, corsetproject@googlegroups.com, ioband-devel@lists.sourceforge.net, virtualization@lists.linux-foundation.org, kunai@linux-foundation.jp, osonoi@linux-foundation.jp
List-Id: dm-devel.ids

On Wed, Aug 26 2009 at  7:32am -0400,
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> Hi All,
> 
> As I have notified before, The 1st Linux IO controller Mini-Summit
> will be held in Tokyo Japan on Oct 17 -- day before the 9th Linux
> kernel summit. So I would like to propose the following topics for 
> the mini-summit and discuss about them.
> 
> - Multiple IO controller development projects
>   - There are two activities for the development of IO controller,
>     Vivek's io-controller and dm-ioband. Do we have to pick one of
>     them to put into the mainline? How to advance the development?

This has been said by others before but: there is no reason the above
line of discussion can't happen on LKML et. al. (preferably now).
Deferring the discussion until Oct 17 guarantees that no solution would
be merged into 2.6.32.  This would be quite unfortunate considering how
far Vivek's IO Controller has come.   Aren't there also doubts about
whether the appropriate upstream people will be able to attend this
mini-summit?

Mike
