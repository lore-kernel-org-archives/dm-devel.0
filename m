From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] multipath-tools/kpartx - loop support
Date: Thu, 29 Sep 2005 14:52:16 +0100
Message-ID: <20050929135216.GX18976@agk.surrey.redhat.com>
References: <20050929131723.GA16105@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050929131723.GA16105@wavehammer.waldi.eu.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 29, 2005 at 03:17:23PM +0200, Bastian Blank wrote:
> Use kernel definition of __kernel_old_dev_t.

That only works if your glibc-kernheaders package defines it 
and not all do, which is why it's there.  The story seems 
to be that that package lags behind the kernel because people don't 
update glibc immediately every time something is added to the kernel.
So while it's OK to remove it for some distributions, you can't
remove it upstream.

Alasdair
-- 
agk@redhat.com
