From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-snapshot: workaround for a lockdep warning
Date: Tue, 17 Sep 2013 20:08:16 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309172006001.24061@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1309171646050.550@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1309171920050.18335@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309171920050.18335@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@redhat.com, Stephen Boyd <sboyd@codeaurora.org>
List-Id: dm-devel.ids



On Tue, 17 Sep 2013, Mikulas Patocka wrote:

> BTW. this patch is no longer needed on 3.11 because md->io_lock was 
> removed there, so the false lockdep warning doesn't happen.
> 
> So we need to get this patch to stable trees 3.5 to 3.10, but not 
> upstream. How to push the patch there without pushing it upstream?
> 
> Mikulas

It's more complicated than that - the original Zdenek's report shows that 
the false warning happened on kernel "3.11.1-300.fc20.x86_64+debug". But I 
am not able to reproduce the bug on 3.11, I only reproduced it on 3.5-3.10 
kernels.

Zdenek, could you reproduce the bug on kernel 3.11?

Mikulas
