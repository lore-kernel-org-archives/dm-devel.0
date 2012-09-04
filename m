From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath queues build invalid requests when all
	paths are lost
Date: Tue, 4 Sep 2012 10:58:43 -0400
Message-ID: <20120904145843.GA19388@redhat.com>
References: <20120831150428.GA31566@fury.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120831150428.GA31566@fury.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Jeffery <djeffery@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 31 2012 at 11:04am -0400,
David Jeffery <djeffery@redhat.com> wrote:

> 
> The DM module recalculates queue limits based only on devices which currently
> exist in the table.  This creates a problem in the event all devices are
> temporarily removed such as all fibre channel paths being lost in multipath.
> DM will reset the limits to the maximum permissible, which can then assemble
> requests which exceed the limits of the paths when the paths are restored.  The
> request will fail the blk_rq_check_limits() test when sent to a path with
> lower limits, and will be retried without end by multipath.
> 
> This becomes a much bigger issue after fe86cdcef73ba19a2246a124f0ddbd19b14fb549.
> Previously, most storage had max_sector limits which exceeded the default
> value used.  This meant most setups wouldn't trigger this issue as the default
> values used when there were no paths were still less than the limits of the
> underlying devices.  Now that the default stacking values are no longer
> constrained, any hardware setup can potentially hit this issue.
> 
> This proposed patch alters the DM limit behavior.  With the patch, DM queue
> limits only go one way: more restrictive.  As paths are removed, the queue's
> limits will maintain their current settings.  As paths are added, the queue's
> limits may become more restrictive.

With your proposed patch you could still hit the problem if the
initial multipath table load were to occur when no paths exist, e.g.:
echo "0 1024 multipath 0 0 0 0" | dmsetup create mpath_nodevs 

(granted, this shouldn't ever happen.. as is evidenced by the fact
that doing so will trigger an existing mpath bug; commit a490a07a67b
"dm mpath: allow table load with no priority groups" clearly wasn't
tested with the initial table load having no priority groups)

But ignoring all that, what I really don't like about your patch is the
limits from a previous table load will be used as the basis for
subsequent table loads.  This could result in incorrect limit stacking.

I don't have an immediate counter-proposal but I'll continue looking and
will let you know.  Thanks for pointing this issue out.

Mike
