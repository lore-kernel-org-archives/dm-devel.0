From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] cfq-iosched: charge async IOs to the appropriate
 blkcg's instead of the root
Date: Tue, 9 Jun 2015 12:11:34 +0900
Message-ID: <20150609031134.GM21465@mtj.duckdns.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
 <1433753973-23684-9-git-send-email-tj@kernel.org>
 <20150608222904.GB20918@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150608222904.GB20918-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hey, Vivek.

On Mon, Jun 08, 2015 at 06:29:04PM -0400, Vivek Goyal wrote:
...
> But above is not true for buffered writes, we will not associate io
> context. Instead only cgroup information will be sent down and io
> context of submitter will be used. 
> 
> So any thread which is forced to submit buffered write for some other
> cgroup, will have its sync queue also reset (Because CFQ will think

Yeah, it'll usually be the writeback work items.

> that cgroup of submitter has changed). Not sure how often it will happen,
> but if it happens frequenty, this might show up in profiles. I had

They're unlikely to have sync queues associated with them to begin
with and even when the context gets reset each iteration should be big
enough to drown this sort of overhead.  Writeback operates in a fairly
sizable chunks.

> mentioned this in the past and IIUC you said we will have to carry
> writeback information all the way into lower layers. May be that's
> an optimzation for later. So nothing new here, just trying to understand
> the current situation.

I'm actually kinda doubtful about caching async queues on cic at all.
We already perform most of operations necessary to lookup the async
queue for check_blkcg_changed().  We might as well just look up and
pin each time.

> Also I am wondring if this cgroup and io context information is carried
> through dm layer or not. I guess it might be a separate discussion. It
> has come for discussion internally in the past. So this might be a good
> time to get attention of dm developers on these upcoming changes. (CC dm-devel).

Hmmm... it depends on what dm does with the bio.  It can surely
propagate the cgroup information through sub bios.

Thanks.

-- 
tejun
