From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 2/2] dm-delay: add third flush class
Date: Tue, 17 Apr 2018 15:12:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804171509240.26973@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180416223312.122871155@debian.vm>
	<20180416223610.350132415@debian.vm>
	<20180417190820.GA29125@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180417190820.GA29125@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Tue, 17 Apr 2018, Mike Snitzer wrote:

> On Mon, Apr 16 2018 at  6:33pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > This patch adds a new class for dm-delay that delays flush requests.
> > Previously, flushes were delayed as writes, but it caused problems if the
> > user needed to create a device with one or few slow sectors for the
> > purpose of testing - all flushes would be forwarded to this device and
> > delayed, and that skews the test results. This patch allows to select 0
> > delay for flushes.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> The flush device shouldn't ever be allowed to be different than the
> write device should it?  Also, what does an offset even mean in the
> context of flush?

The flush device may be different if the user wants to suppress flushes 
(i.e. he could set the flush device to /dev/ram0, so that flushes are 
turned into nops).

> Pretty awkward really.  I get that you've factored out the ctr code and
> are just reusing it for flush; and that in practice these knobs won't
> get used (or flush_device won't be different than write_device).. but
> I'm just not following why we want to expose flush_offset and
> flush_device at all.
> 
> Mike

It's better to have the same arguments and same code paths for 
read/write/flush, then to invent new syntax just for flushes.

Mikulas
