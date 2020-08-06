From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] libmultipath: fix a memory leak in
 disassemble_status func
Date: Thu, 06 Aug 2020 18:01:05 +0200
Message-ID: <f6e1f272856631d9904a6b3fa069bfbbfa53cf07.camel@suse.com>
References: <9bc76686-747f-e85b-d25f-db5a056cf869@huawei.com>
	<20200728162000.GP11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200728162000.GP11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: Yanxiaodan <yanxiaodan@huawei.com>, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi Ben,

On Tue, 2020-07-28 at 11:20 -0500, Benjamin Marzinski wrote:
> On Tue, Jul 28, 2020 at 09:48:06PM +0800, Zhiqiang Liu wrote:
> > In disassemble_status func, for dealing with selector args,
> > word is allocated by get_word func. However, word is not freed.
> > Then a memory leak occurs.
> > 
> > Here, we call FREE(word) to free word.
> 
> Err... At the risk of sounding stupid, There is a least-pending
> selector?  Hannes, you added this code (commit 35ad40b4 "leastpending
> IO
> loadbalancing is not displayed properly"). Was this a Suse thing?  Is
> it
> still a Suse thing, or have queue-length and service-time replaced
> it?

Yes, it's a "SUSE thing" (originally developed by HP). SLE15 still
supports it; I don't know if it's actually used. 
It was discussed here last year, see:
https://patchwork.kernel.org/patch/10878905/

Regards,
Martin
