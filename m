From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-integrity: revert adc0daad366b to fix
	recalculation
Date: Wed, 22 Jul 2020 15:45:36 -0400
Message-ID: <20200722194536.GA28682@redhat.com>
References: <alpine.LRH.2.02.2007221444390.6426@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2007221444390.6426@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Marian Csontos <mcsontos@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 22 2020 at  2:46pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi Mike
> 
> Please submit this to Linus and to RHEL-8.
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The patch adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 broke recalculation on
> dm-integrity. The patch replaces a private variable "suspending" with a
> call to "dm_suspended".
> 
> The problem is that dm_suspended returns true not only during suspend, but
> also during resume. This race condition could occur:
> 1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
> 2. integrity_recalc (&ic->recalc_work) preempts the current thread
> 3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock_ret;
> 4. integrity_recalc exits and no recalculating is done.
> 
> In order to fix this race condition, we stop using dm_suspended and start
> using the variable "suspending" (that is only set during suspend, not
> during resume).
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: adc0daad366b ("dm: report suspended device during destroy")
> Cc: stable@vger.kernel.org	# v4.18+

OK, but why not add a dm_suspending() to DM core?  Could be other
future targets would like this same info right?  I don't see harm in
elevating it.

Mike
