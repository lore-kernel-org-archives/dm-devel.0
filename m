From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 0/2] Historical Service Time Path Selector
Date: Mon, 11 May 2020 13:31:55 -0400
Message-ID: <20200511173155.GA7892@redhat.com>
References: <20200511163910.3778467-1-krisman@collabora.com>
 <20200511170235.GA7719@redhat.com>
 <85ftc6l7lb.fsf@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <85ftc6l7lb.fsf@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, song@kernel.org, breeves@redhat.com, mpatocka@redhat.com, khazhy@google.com, kernel@collabora.com
List-Id: dm-devel.ids

On Mon, May 11 2020 at  1:11pm -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > On Mon, May 11 2020 at 12:39pm -0400,
> > Gabriel Krisman Bertazi <krisman@collabora.com> wrote:
> >
> >> Hi,
> >> 
> >> This fourth version of HST applies the suggestion from Mikulas Patocka
> >> to do the ktime_get_ns inside the mpath map_bio instead of generic
> >> device-mapper code. This means that struct dm_mpath_io gained another
> >> 64bit field.  For the request-based case, we continue to use the block
> >> layer start time information.
> >> 
> >> With this modification, I was able obtain similar performance on  BIO
> >> to request-based multipath with HST on the benchmarks shared in v1.
> >> 
> >> v3: https://www.redhat.com/archives/dm-devel/2020-April/msg00308.html
> >> v2: https://www.redhat.com/archives/dm-devel/2020-April/msg00270.html
> >> v1: https://www.redhat.com/archives/dm-devel/2020-April/msg00176.html
> >
> > I already staged your v3 in linux-next.  Please provide an incremental
> > patch that layers on this git branch:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.8
> >
> > I was hopeful for a flag to be set (e.g. in 'struct path_selector') to
> > reflect whether the path selector expects highres start_time.  Makes
> > little sense to incur that extra cost of providing the time if the path
> > selector doesn't even use it.
> >
> > Alternatively, could split out the setting of the time needed by .end_io
> > to a new path_selector_type method (e.g. .set_start_time).  And then
> > only use ktime_get_ns() for bio-based if .set_start_time is defined.
> > Would get a little fiddly needing to make sure a stale start_time isn't
> > used... also, makes more sense to conditionally call this
> > .set_start_time just after .start_io is.
> 
> Oh, my apologies, I hadn't noticed it was merged.  I will make the time fetch
> conditional and submit a new patch based on that branch.

I don't want to waste your time so please don't run with that idea just yet.

There is a possibility we really _do_ need higher resolution time.

I'm about to have a concall to discuss some disk IO stat issues with DM
disk stats vs NVMe disk stats (provided by block core).

I'll let you know the outcome and we can discuss further.

Thanks,
Mike
