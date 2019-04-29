From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Apr 29 (drivers/md/dm-dust)
Date: Mon, 29 Apr 2019 07:52:00 -0700
Message-ID: <534f901f-c662-6216-c39a-addb545f614b@infradead.org>
References: <20190429190354.0d5e2e93@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429190354.0d5e2e93@canb.auug.org.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 4/29/19 2:03 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20190426:
> 

on i386:

ld: drivers/md/dm-dust.o: in function `dust_map':
dm-dust.c:(.text+0x28d): undefined reference to `__udivdi3'
ld: drivers/md/dm-dust.o: in function `dust_message':
dm-dust.c:(.text+0x9a4): undefined reference to `__udivdi3'



-- 
~Randy
