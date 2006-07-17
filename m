From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: lockdep warning when nesting dm devices
Date: Mon, 17 Jul 2006 03:45:19 +0100
Message-ID: <20060717024519.GA26318@agk.surrey.redhat.com>
References: <m34pxj6rsm.fsf@telia.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <m34pxj6rsm.fsf@telia.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Osterlund <petero2@telia.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: dm-devel.ids

On Sat, Jul 15, 2006 at 01:17:29PM +0200, Peter Osterlund wrote:
> # echo "0 10000 linear /dev/loop0 0" | /sbin/dmsetup create test
> # echo "0 10000 linear /dev/mapper/test 0" | /sbin/dmsetup create test2
 
> I get the following warning from the lockdep validator.
> =============================================
> [ INFO: possible recursive locking detected ]
> ---------------------------------------------

Well at first sight the message is simply pointing out something expected - it
only say "INFO" after all - viz. recursive use of
	down_read(&md->io_lock);
something tied up with the split_bio horridness which needs to go away some
day.  The lock prevents any attempt to suspend the device from happening
while a bio is in the process of being split into other bios.

Of course it's always helpful to review code from different perspectives
like this to look out for any gotchas and we ought to re-check the use
of this lock.

> Btw, is there a limit on how many dm devices can be chained? I guess
> there will be a kernel stack overflow if you try to chain together too
> many devices.

There's a patch in -mm which tackles that, but it needs some changes to dm
(which Milan Broz has begun working on) before it will behave correctly in all
cases.
 
Alasdair
-- 
agk@redhat.com
