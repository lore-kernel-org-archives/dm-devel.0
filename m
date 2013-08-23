From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Allow read IO during share block breaking in dm-thin
Date: Fri, 23 Aug 2013 16:45:58 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308231642110.17444@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAKTMprMVgxTDjs+4JEJLgb+1BpLCnY_mXHzvROqKCEiGe5Ekpw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAKTMprMVgxTDjs+4JEJLgb+1BpLCnY_mXHzvROqKCEiGe5Ekpw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Edward Thornber <thornber@redhat.com>, Teng-Feng Yang <shinrairis@gmail.com>
List-Id: dm-devel.ids



On Fri, 23 Aug 2013, Teng-Feng Yang wrote:

> Hi folks,
> 
> I have tried to perform some experiments and enhance dm-thin with some
> new features for couple of weeks.
> I notice that dm-thin uses a dm_deferred_set data structure to record
> all the share read IO and inserts new data mappings only when all
> share read IO are quiesced.
> This method is quite similar to the block tracking mechanism used by
> dm-snap, which tries to prevent write IO to the origin device from
> overwriting the block when some read IO from snap device has not yet
> completed
> Although it is reasonable to have something like this in dm-snap, it
> looks like an overkill to have the similar mechanism in dm-thin.
> Since the "redirect-on-write" nature of dm-thin makes all write IOs to
> a share block writes in a new allocated block instead, all preceding
> share read IO will still read the correct data even when there are
> multiple share write IO on-the-fly.
> So here is my question, do we really need to quiesce all share read
> IOs before adding a new data mapping, or the share read IO's deferred
> set is meant to deal with some other problems?
> 
> Any help would be grateful.
> Thanks
> 
> Dennis
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

The problem is this:
(1) you have a block with refcount 2, shared by two logical volumes
(2) you submit a read to the 1st logical volume to this block, the read
        waits in i/o queue
(3) you submit a write to the 1st logical volume to this block, this
        triggers reallocation - suppose that the i/o scheduler
        decides that this reallocation is performed before the
        previous read
(4) you submit a write to the 2nd logical volume to this block - reference
        count is 1 (because we dropped it at step(3)), so the write goes
        through and the data are written to the disk
(5) the i/o scheduler decides to perform the read request submitted in
        the step (2) => it incorrectly reads data written to the 2nd
        logical volume in step (4)

Original snapshot implementation had this bug and I fixed it in commit
a8d41b59f3f5a7ac19452ef442a7fc1b5fa17366.

As Joe said, if you want to avoid this scenario, you would have to wait 
for the read request to finish before doing comitting in step (3).

Mikulas
