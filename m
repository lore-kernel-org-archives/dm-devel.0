From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 2/4] swait: export the symbols
 __prepare_to_swait and __finish_swait
Date: Tue, 22 May 2018 14:52:54 -0400
Message-ID: <20180522185037.GB25826@redhat.com>
References: <20180519052503.325953342@debian.vm>
	<20180519052633.037700597@debian.vm>
	<20180522063425.GA7854@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180522063425.GA7854@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: peterz@infradead.org, wagi@monom.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, tglx@linutronix.de
List-Id: dm-devel.ids

On Tue, May 22 2018 at  2:34am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, May 19, 2018 at 07:25:05AM +0200, Mikulas Patocka wrote:
> > In order to reduce locking overhead, I use the spinlock in
> > swait_queue_head to protect not only the wait queue, but also the list of
> > events. Consequently, I need to use unlocked functions __prepare_to_swait
> > and __finish_swait. These functions are declared in the file
> > include/linux/swait.h, but they are not exported, and so they are not
> > useable from kernel modules.
> 
> Please CC the author and maintainers of the swait code.
> 
> My impression is that this is the wrong thing to do.  The swait code
> is supposed to be simple and self contained, and if you want to do
> anything else use normal waitqueues.

You said the same thing last time around.  I've since cc'd Peter and
Thomas and haven't heard back, see:
https://www.redhat.com/archives/dm-devel/2018-May/msg00048.html

The entire point of exporting these symbols is to allow use of the
"simple waitqueue" code to optimize -- without resorting to using normal
waitqueues.

Mike
