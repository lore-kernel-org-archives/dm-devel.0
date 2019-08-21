From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 10/16] libmultipath: make pgpolicyfn take a
 paths vector
Date: Wed, 21 Aug 2019 10:28:04 +0000
Message-ID: <08669317ce4779147e37e1c6cf4f40b5e79c6b76.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-11-git-send-email-bmarzins@redhat.com>
	<1f9360e75494c4597d80a08677a34441159b3af4.camel@suse.com>
	<20190816212837.GK25414@octiron.msp.redhat.com>
	<20190820225504.GN25414@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190820225504.GN25414@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <6362BB2D880166439BC6D1B1B1531FDC@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On Tue, 2019-08-20 at 17:55 -0500, Benjamin Marzinski wrote:
> 
> So, I've looked at this, and I'd like to make the case that these
> patches don't put multipath into an inflexible method of dealing with
> path groups. In my mind, there are three issues with path grouping
> that
> my patches deal with
> 
> 1. How the paths are grouped together
> 2. How the pathgroups are ordered
> 3. How the best pathgroup is chosen
> 
> I'd argue that the only issue where my patches really adds some
> significant code is on 1. I think that my choice of groups for 1 is
> correct, and I have a suggestion for making issue 3 go away.
> 
> In regards to the first issue, how the paths are grouped together, my
> patch basically follows two rules:
> 
> 1. Marginal paths shouldn't be grouped with non-marginal paths.
> 
> Obviously, if you want the marginal paths to stay in the same group
> as
> they would normally be in, then you don't want marginal path
> detection
> at all.

Well, this is how multipathd used to behave - the "marginal" property
didn't have any influence on the path grouping. But this kind of
grouping can still be used by setting marginal_pathgroups to "no".
And if someone wants marginal path detection to be active and to affect
path grouping, indeed she doesn't want marginal and non-marginal paths
in one path group.

So yes, I think you are right here.


> >Further, I don't see a scenario where we would like the marginal
> paths to be grouped with non-marginal paths that they wouldn't
> normally
> be grouped with.

Right.

> 2. Marginal paths should be grouped with other marginal paths using
> the
> same rules as for non-marginal paths.
> 
> There are often very good reasons why paths are grouped the way they
> are.  For instance, if the marginal path is passive (I'm not even
> sure
> that we should keep paths in the marginal state if they are
> PATH_GHOST,
> but we currently do), we really don't want to put it in a pathgroup
> with
> active paths. There probably are cases where it is safe to put all,
> or
> some, of the marginal paths together, but it's not easy to know when
> that is, and I don't think there is much benefit from doing the work
> to
> figure it out, and it is always safe to group them like you would if
> they were non-marginal paths.
> 
> I don't see a better way to set up the groups than what my patch
> does,
> so I'm not particularly worried about all the code involved in making
> sure that the groups look like this.

Right. Note that your description of "marginal_pathgroups" in the man
page is a bit misleading, as it talks about "a separate pathgroup",
which could be read as "one separate pathgroup". The paragraph could be
understood such that all marginal paths are lumped together into one
PG, wich is not the case.

You have logically changed the path group vector into a 2-dimensional
Matrix. In the past, similar problems have been solved by simply
scaling the prio values (think ALUA with "exclusive_pref_bit" set), but
that obviously works for grouping only with "group_by_prio".
In fact, your new approach is more powerful, and we might consider
using it in a generalized form in the future.

> As for the second issue, how the pathgroups are ordered, I don't
> think
> my code locks us in at all.  The functions that order the pathgroups
> are
> path_group_prio_update() and sort_pathgroups().  If you wanted to
> make
> multipath just change the priority of marginal pathgroups, you would
> just need to set that priority in path_group_prio_update(), and if
> you
> only wanted to use the priority for sorting them, you would just
> change
> sort_pathgroups() to only sort by priority. If you wanted to change
> pgp->marginal from something binary to something that reflected how
> marginal a path was, and you want to have that to change how a path
> was
> sorted vs other paths with different marginal and priority values,
> you
> could do all of that by simply changing the values set in
> path_group_prio_update() and how those values are sorted in
> sort_pathgroups(). I don't think my code does anything to make this
> less
> flexible.

I guess you are right here, too. (*)

> As for the third issue, how the best pathgroup is chosen, this is
> also a
> case where changing things just involves changing how things are done
> in
> one function, select_path_group(), to match what's done in
> sort_pathgroups(). But since the pathgroups are already in order from
> the best one to use to the worst, the multipath userspace tools could
> just work how the kernel works, and pick the first usable pathgroup.
> This won't always give the same answer that multipath currently does,
> since the current code looks at the number of enabled paths. But the
> only times when it will be different is when there are multiple
> pathgroups with the same priority, and the first one has some failed
> paths.  Since we rarely have multiple pathgroups with the same
> priorty
> except when using the failover policy (group_by_serial and
> group_by_node_name being rarely used), and you will always have one
> path
> per pathgroup with failover, in practice this will almost never
> occur.

I don't see an inconsistency here. sort_pathgroups() also takes the
number of enabled paths into account; it's just not always called when
paths are failed or reinstated. The point is just that in the corner
case you describe, we run a lightweight "switch_group" ioctl rather
than reloading the map with a new PG ordering, which is good. (**) 

> Oh, I did notice a bug in my select_path_group() code. I should be
> calling path_group_prio_update() before checking if the pathgroup
> is marginal or not. I'll fix that.
> 
> So, I'm not against making this all work with priorities if there is
> a
> reason to do so, but doing that will just involve changes in 3
> straightforward functions, or 2 if we decide to simplify
> select_path_group() so it just uses the order from sort_pathgroups()
> as
> a guide.
> 
> If you feel strongly about doing this with priorities, I can add a
> patch
> that changes this. But if it gets us the same results, then I don't
> see
> much benefit. We can always change it laster if we want to change how
> the groups actually end up.

I had a discussion with Hannes, and it went rather the opposite way of
what I'd written in my previous post (consider multi-dimentional
priorities/grouping for the future). He strongly supported your notion
that "marginality" should be the most important grouping criterion /
priority factor, taking precedence over other factors.

So yes, you've mostly convinced me. Please re-post with the fixes you
mentioned, and I'll ack the series. I still have a number of open
issues with how we do prioritizing and grouping in general, but I agree
your series is a step in the right direction.

Cheers, Martin


(*) Note to self: It just occured to me that rather than using sorting,
we could use dm-multipaths's concept of "disabled" or "bypassed" path
groups to represent marginal groups. When switching PGs, the kernel
tries bypassed PGs only if all others have no valid paths, so this fits
your marginal model quite well. But then, we wouldn't have the
flexibility that PG sorting provides, as you argued. Moreover, PGs
can't start out bypassed when a map is reloaded, opening a short race
window where the kernel could try using these PGs. Finally, the kernel
sets the bypassed flag when a SCSI DH returns SCSI_DH_DEV_TEMP_BUSY,
which is used by the EMC and ALUA DHs, and at least by the latter in a 
questionable way (indicating unspecific errors). I find this whole
kernel logic weird - why disable the entire PG if a DH error occurs on
a single path? - but that's a different issue.

(**) In the corner-case-in-corner-case where all paths of this selected
PG (which is now not the first) fail, the kernel might come to a
different fallback conclusion as if we had re-sorted PGs. But I think
this can be ignored).
