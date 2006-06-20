From: CaT <cat@zip.com.au>
Subject: Re: 2.6.16.20/dm: can't create more then one snapshot of an lv
Date: Tue, 20 Jun 2006 21:46:13 +1000
Message-ID: <20060620114613.GZ2059@zip.com.au>
References: <20060619020040.GX2059@zip.com.au> <20060620005405.GY2059@zip.com.au> <20060620100209.GA4566@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030212AbWFTLpW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060620100209.GA4566@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 20, 2006 at 12:02:09PM +0200, Heinz Mauelshagen wrote:
> How many snapshots active at once ?

1. I can start more then 1 premade snapshots just fine and use them
but the moment I add another one a freeze occurs.

> I guess this is a kcopyd scalability issue which needs addressing.

Well in the end I'm hoping to get at least 7. Hopefully that's not
insane. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
