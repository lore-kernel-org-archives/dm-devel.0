From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: A patchset to limit the number of outstanding bios
Date: Mon, 13 Oct 2014 12:20:26 -0400
Message-ID: <20141013162026.GA4631@redhat.com>
References: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 13 2014 at 11:27am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I'm announcing the release of a patchset that limits the number of 
> outstanding bios in the device mapper.
> 
> The patchset is at 
> http://people.redhat.com/~mpatocka/patches/kernel/dm-limit-outstanding-bios/

You should probably just send the patchset to the list (and cc Jens on
the block changes).

Patch 1 looks good as is.  But Jens suggested that Patch 2 should hook
off the on stack plugging rather than adding yet another hook to
kernel/sched/core.c

And I agree with Joe, we want this DM-only limit to be opt-in per-target
(so disabled by default).

Mike
