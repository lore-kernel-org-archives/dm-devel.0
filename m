From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: compiling Multipath-tools on RHE4 .
Date: Wed, 23 Mar 2005 00:22:03 +0100
Message-ID: <1111533723.7024.24.camel@zezette>
References: <1111522135.29700.8.camel@localhost>
	<1111531414.7024.17.camel@zezette>
	<20050322225024.GQ19749@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050322225024.GQ19749@agk.surrey.redhat.com>
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

On mar, 2005-03-22 at 22:50 +0000, Alasdair G Kergon wrote:
> Patches I needed to build 4.2 attached.
> Pick the right one for your architecture.
> 
What problems does the Makefile patch tries to address ? is it redhat
specific ?

Also what would be to proper fix to the dev_t define ?
Why does it happen only on redhat systems ?

Would you say the problem is in the loop code or in the headers redhat
packages ? This code comes from util-linux, mostly unchanged ... how
redhat fixed that for util-linux ?

I may have to install a redhat system to debug this out, but quite
frankly, I would prefer others to propose the right fix and skip that
additional work :)

Regards,
cvaroqui
> 
> Patch0: old_dev_t_long.patch
> Patch1: old_dev_t_int.patch
> Patch2: old_dev_t_short.patch
> 
> 
> %ifarch ppc64 x86_64
> %patch0 -p1
> %endif
>  
> %ifarch ppc ia64
> %patch1 -p1
> %endif
>  
> %ifarch i386 s390 s390x
> %patch2 -p1
> %endif
> 
> 
> Alasdair
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
christophe varoqui <christophe.varoqui@free.fr>
