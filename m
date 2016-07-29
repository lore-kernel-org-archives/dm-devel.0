From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: To add, or not to add, a bio REQ_ROTATIONAL flag
Date: Fri, 29 Jul 2016 18:28:11 +0200
Message-ID: <20160729182811.27c0595c@jupiter.sol.kaishome.de>
References: <alpine.LRH.2.11.1607281603530.10662@mail.ewheeler.net>
	<579AABAA.2020200@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.orglinux-raid@vger.kernel.orglinux-block@vger.kernel.orgdm-devel@redhat.comlinux-raid@vger.kernel.orgdm-devel@redhat.comlinux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Am Fri, 29 Jul 2016 02:04:42 +0100
schrieb Wols Lists <antlists@youngman.org.uk>:

> On 29/07/16 01:50, Eric Wheeler wrote:
> > Hello all,
> > 
> > With the many SSD caching layers being developed (bcache, dm-cache, 
> > dm-writeboost, etc), how could we flag a bio from userspace to
> > indicate whether the bio is preferred to hit spinning disks instead
> > of an SSD?
> > 
> > Unnecessary promotions, evections, and writeback increase the write
> > burden on the caching layer and burns out SSDs too fast (TBW), thus
> > requring equipment replacement.  
> 
> What's the spec of these devices? How long are they expected to last?
> 
> Other recent posts on this (linux-raid) mailing list refer to tests on
> SSDs that indicates their typical life is way beyond their nominal
> life, and that in normal usage they are actually likely to outlive
> "spinning rust".

Well, using SSD as a caching layer is probably everything else but
normal usage. Caching involves writing a lot of data given the fact
that it usually backs huge storage pools and is there to eliminate/hide
inefficient usage patterns of rotational media. Caching layers like
bcache do its best to turn writes to the device into optimal write
patterns at best - but still, it writes a lot of data.

> http://techreport.com/review/24841/introducing-the-ssd-endurance-experiment
> 
> http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-all-dead/3
> 
> Looking at the results, the FIRST drives only started failing once
> they'd written some 700 Terabytes. How long is it going to take you to
> write that much data over a SATA3 link?

I had a Crucial MX100 128GB SSD as bcache (writeback mode) in the past.
It lasted exactly 12-13 months when I was forced to replace it: The
lifetime of the SSD reached around 95% according to smartctl. The specs
say, it has a lifetime guarantee of 85TB written. I guess it could have
lasted longer due to bcache's optimized access patterns - but I didn't
want to test it. Bigger SSDs usually last a lot longer, so now I'm
using a Samsung 850 Evo 500GB which has a guarantee of 150TBW.
According to tests, it probably goes a lot higher before failing (like
250TBW estimated) but I don't want to test this is writeback mode.

So the idea of reducing writes to the caching layer, or better
eliminate useless writes altogether, would be very welcome.

-- 
Regards,
Kai

Replies to list-only preferred.
