From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: unaligned access by multipathd logging
Date: Fri, 06 May 2005 00:23:35 +0200
Message-ID: <1115331816.2277.56.camel@zezette>
References: <427A9361.2040009@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <427A9361.2040009@ce.jp.nec.com>
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
List-Id: dm-devel.ids

Nice piece of brain work, thanks.

I applied this patch, and it will appear as commit
544bfcea0e63d32d4cf79abb97b6e78918fb5511 on kernel.org git repository.

Regards,
cvaroqui

On jeu, 2005-05-05 at 17:42 -0400, Jun'ichi Nomura wrote:
> Hi,
> 
> Logging code in multipathd cause unaligned access
> which, on ia64, yields logs on both console and syslog like:
> unaligned access to 0x60000000000141d1, ip=0x4000000000009d81
> 
> It's harmless except for the slight performance effect.
> However, it's annoying for users and better to fix.
> 
> Attached patch aligns the la->tail to pointer size.
> Patch is created on multipath-tools 0.4.4.
> Please consider to apply.
> 
