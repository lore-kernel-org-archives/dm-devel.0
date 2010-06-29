From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 1/2] dm: prevent table type changes after
 initial table load
Date: Tue, 29 Jun 2010 11:07:21 -0400
Message-ID: <20100629150721.GC29894@redhat.com>
References: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
	<1274964469-22289-2-git-send-email-snitzer@redhat.com>
	<20100629114040.GE23989@agk-dp.fab.redhat.com>
	<20100629135217.GB28705@redhat.com>
	<20100629141920.GF23989@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100629141920.GF23989@agk-dp.fab.redhat.com>
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

On Tue, Jun 29 2010 at 10:19am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Tue, Jun 29, 2010 at 09:52:17AM -0400, Mike Snitzer wrote:
> > As we talked about on irc.  There is potential for do_resume() to
> > destage the "inactive" table slot, in the process of making the table
> > "live", and in parallel another table load can arrive to stage another
> > "inactive" table (which can have a conflicting type).  
> 
> But the type already got set earlier and, once set, is an immutable table
> property.  There cannot be conflicts with do_resume - it doesn't touch
> this.

Yes, do_resume doesn't operate with any concern for md->type or
md->queue changing because table_load safely sets these immutable
properties.

That safety comes at the expense of protecting a critical section in
table_load.  And that protection must span the access to both md->type
and md->queue.

Would you rather I ignore do_resume entirely?  I'm not understanding why
you keep going back to this notion that do_resume doesn't matter.  The
only reason it doesn't matter is because table_load takes care to make
it that way.

Without appropriate table_load serialization do_resume would be prone to
the races I explained above.  That's all I've been trying to convey.

Mike
