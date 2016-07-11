From: Matthias Dahl <ml_linux-kernel@binary-island.eu>
Subject: Re: [dm-devel] [4.7.0rc6] Page Allocation Failures with dm-crypt
Date: Mon, 11 Jul 2016 15:27:42 +0200
Message-ID: <fe0eb105b21013453bc3375e7026925b@mail.ud19.udmedia.de>
References: <28dc911645dce0b5741c369dd7650099@mail.ud19.udmedia.de>
 <e7af885e08e1ced4f75313bfdfda166d@mail.ud19.udmedia.de>
 <20160711131818.GA28102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160711131818.GA28102@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-mm@kvack.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello Mike...

On 2016-07-11 15:18, Mike Snitzer wrote:

> Something must explain the execessive nature of your leak but
> it isn't a known issue.

Since I am currently setting up the new machine, all tests were
performed w/ various live cd images (Fedora Rawhide, Gentoo, ...)
and I saw the exact same behavior everywhere.

> Have you tried running with kmemleak enabled?

I would have to check if that is enabled on the live images but even if
it is, how would that work? The default interval is 10min. If I fire up
a dd, the memory is full within two seconds or so... and after that, the
OOM killer kicks in and all hell breaks loose unfortunately.

I don't think this is a particular unique issue on my side. You could,
if I am right, easily try a Fedora Rawhide image and reproduce it there
yourself. The only unique point here is my RAID10 which is a Intel Rapid
Storage s/w RAID. I have no clue if this could indeed cause such a "bug"
and how.

Thanks,
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
  services: custom software [desktop, mobile, web], server administration

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
