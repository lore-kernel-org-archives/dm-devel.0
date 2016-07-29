From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: To add, or not to add, a bio REQ_ROTATIONAL flag
Date: Fri, 29 Jul 2016 02:04:42 +0100
Message-ID: <579AABAA.2020200@youngman.org.uk>
References: <alpine.LRH.2.11.1607281603530.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1607281603530.10662@mail.ewheeler.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>, linux-block@vger.kernel.org
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: dm-devel.ids

On 29/07/16 01:50, Eric Wheeler wrote:
> Hello all,
> 
> With the many SSD caching layers being developed (bcache, dm-cache, 
> dm-writeboost, etc), how could we flag a bio from userspace to indicate 
> whether the bio is preferred to hit spinning disks instead of an SSD?
> 
> Unnecessary promotions, evections, and writeback increase the write burden 
> on the caching layer and burns out SSDs too fast (TBW), thus requring 
> equipment replacement.

What's the spec of these devices? How long are they expected to last?

Other recent posts on this (linux-raid) mailing list refer to tests on
SSDs that indicates their typical life is way beyond their nominal life,
and that in normal usage they are actually likely to outlive "spinning
rust".

http://techreport.com/review/24841/introducing-the-ssd-endurance-experiment

http://techreport.com/review/27909/the-ssd-endurance-experiment-theyre-all-dead/3

Looking at the results, the FIRST drives only started failing once
they'd written some 700 Terabytes. How long is it going to take you to
write that much data over a SATA3 link?

Cheers,
Wol
