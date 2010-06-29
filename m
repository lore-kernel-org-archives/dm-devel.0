From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v4 1/2] dm: prevent table type changes
	after	initial table load
Date: Tue, 29 Jun 2010 12:40:40 +0100
Message-ID: <20100629114040.GE23989@agk-dp.fab.redhat.com>
References: <1274964469-22289-1-git-send-email-snitzer@redhat.com>
	<1274964469-22289-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1274964469-22289-2-git-send-email-snitzer@redhat.com>
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

On Thu, May 27, 2010 at 08:47:48AM -0400, Mike Snitzer wrote:
> Introduce 'type_lock' in mapped_device structure and use it to protect
> md->type access.  table_load() sets md->type without concern for:

> - another table_load() racing to set conflicting md->type.
which leads to non-deterministic behaviour that is of no practical use and
so there is no need to support it.

> - do_resume() making a conflicting table live.
Any table being made live must already have passed through table_load so I
don't see how there can be conflicting types.

The mutex here seems to be overkill: instead of protecting one field to
cope with a useless race, we should be making the output of the race
deterministic (e.g. perhaps giving an error on the parallel table_load
attempt).

Anyway, I can take this patch for now and we can deal with the mutex/race
differently later.

Alasdair
 
