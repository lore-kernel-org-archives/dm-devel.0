From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: mmotm 2012-06-21-16-20 uploaded (dm-thin)
Date: Fri, 22 Jun 2012 10:26:06 -0700
Message-ID: <4FE4AAAE.3090803@xenotime.net>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-next@vger.kernel.org, Joe Thornber <dm-devel@redhat.com>dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/21/2012 04:21 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-06-21-16-20 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> It contains the following patches against 3.5-rc3:
> (patches marked "*" will be included in linux-next)



on i386:

Apparently from linux-next.patch:

drivers/built-in.o: In function `thin_iterate_devices':
dm-thin.c:(.text+0x206f07): undefined reference to `__udivdi3'
drivers/built-in.o: In function `pool_preresume':
dm-thin.c:(.text+0x207863): undefined reference to `__udivdi3'


-- 
~Randy
