From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Nov 15 (drivers/md/dm-integrity)
Date: Fri, 15 Nov 2019 08:17:48 -0800
Message-ID: <f368f431-b741-d04f-440b-3d8c3c035537@infradead.org>
References: <20191115190525.77efdf6c@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191115190525.77efdf6c@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joe Thornber <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/15/19 12:05 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20191114:
> 

on i386:

ld: drivers/md/dm-integrity.o: in function `calculate_device_limits':
dm-integrity.c:(.text.unlikely+0x1e9): undefined reference to `__udivdi3'


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
