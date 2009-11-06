From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] a deadlock bug in the kernel-side device
	mapper code
Date: Fri, 6 Nov 2009 11:30:47 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911061126150.6499@hs20-bc2-1.build.redhat.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
	<20091106151504.GS13375@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091106151504.GS13375@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 6 Nov 2009, Alasdair G Kergon wrote:

> On Thu, Nov 05, 2009 at 09:58:26PM -0500, Mikulas Patocka wrote:
> > +static DEFINE_MUTEX(_name_read_lock);
> 
> Any reason for a mutex rather than a spinlock?

There can be both. I basically use the rule "if there can be either 
spinlock or mutex, use mutex". Because mutexes don't create scheduling 
latency --- i.e. you don't have to check them "how much time can it spend 
inside a mutex and how to break a long lock into few smaller locks".

Performance of mutex and spinlock in non-contended case is the same.

Mikulas
