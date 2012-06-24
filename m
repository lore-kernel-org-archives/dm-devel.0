From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: mmotm 2012-06-21-16-20 uploaded (dm-thin)
Date: Sun, 24 Jun 2012 08:44:04 -0700
Message-ID: <4FE735C4.8000308@xenotime.net>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>	<4FE4AAAE.3090803@xenotime.net> <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-next@vger.kernel.org, Joe Thornber <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 06/24/2012 07:44 AM, Stephen Rothwell wrote:

> Hi Randy,
> 
> On Fri, 22 Jun 2012 10:26:06 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> on i386:
>>
>> Apparently from linux-next.patch:
>>
>> drivers/built-in.o: In function `thin_iterate_devices':
>> dm-thin.c:(.text+0x206f07): undefined reference to `__udivdi3'
>> drivers/built-in.o: In function `pool_preresume':
>> dm-thin.c:(.text+0x207863): undefined reference to `__udivdi3'
> 
> I assume that CONFIG_LDBAF is not set and I think this is caused by
> commit ebf5d9e0425c ("Non power of 2 blocksize support is needed to
> properly align thinp IO") from the device-mapper tree.
> 


Correct:
# CONFIG_LBDAF is not set


thanks,
-- 
~Randy
