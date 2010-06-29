From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 1/2] dm: prevent table type changes after
 initial table load
Date: Tue, 29 Jun 2010 09:52:17 -0400
Message-ID: <20100629135217.GB28705@redhat.com>
References: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
	<1274964469-22289-2-git-send-email-snitzer@redhat.com>
	<20100629114040.GE23989@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100629114040.GE23989@agk-dp.fab.redhat.com>
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
List-Id: dm-devel.ids

On Tue, Jun 29 2010 at  7:40am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, May 27, 2010 at 08:47:48AM -0400, Mike Snitzer wrote:
> > Introduce 'type_lock' in mapped_device structure and use it to protect
> > md->type access.  table_load() sets md->type without concern for:
> 
> > - another table_load() racing to set conflicting md->type.
> which leads to non-deterministic behaviour that is of no practical use and
> so there is no need to support it.
> 
> > - do_resume() making a conflicting table live.
> Any table being made live must already have passed through table_load so I
> don't see how there can be conflicting types.

As we talked about on irc.  There is potential for do_resume() to
destage the "inactive" table slot, in the process of making the table
"live", and in parallel another table load can arrive to stage another
"inactive" table (which can have a conflicting type).  Without a
critical section there is room for this to occur.

And the critical section must span more than setting md->type; as
md->queue initialization may fail (elevator memory allocation fails
ENOMEM).  So competing table_load needs protection from concurrent queue
initialization.

(do understand that I know you're commenting on this patch header in
isolation; but I figured I'd give context for "why the mutex").  I have
an updated patch header too:

Before table_load() stages an inactive table check if its type
conflicts with a previously established device type (md->type).

Allowed md->type transitions:
DM_TYPE_NONE => DM_TYPE_BIO_BASED
DM_TYPE_NONE => DM_TYPE_REQUEST_BASED

Once a table load occurs the DM device's type is completely immutable.
This prevents a table reload from switching the inactive table directly
to a conflicting type (even if the table is explicitly cleared before
load).

Introduce 'type_lock' in mapped_device structure and use it to protect
md->type access.  Use of mutex prepares for follow-on DM device queue
initialization changes that will allocate memory while md->type_lock
is held.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>


> The mutex here seems to be overkill: instead of protecting one field to
> cope with a useless race, we should be making the output of the race
> deterministic (e.g. perhaps giving an error on the parallel table_load
> attempt).

We're protecting 2 fields in the end (md->type and md->queue): once 2/2
is applied.

I agree 100% on improving the DM core to be trained to error out on
competing table loads (at a higher level).. given the parallelism that
we have right now in DM operations (across devices) we get this awkward
inability to _know_ the state transitions of:
no table -> inactive table -> live table

As you pointed out that is an unwanted side-effect of supporting
operations we do want.

> Anyway, I can take this patch for now and we can deal with the mutex/race
> differently later.

OK, sounds good.

Mike
