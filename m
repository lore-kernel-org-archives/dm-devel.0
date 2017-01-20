From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFC 0/4] dm thin: support blk-throttle on data and
 metadata device
Date: Fri, 20 Jan 2017 10:56:18 -0500
Message-ID: <20170120155618.GA13969@redhat.com>
References: <1484910952-29820-1-git-send-email-houtao1@huawei.com>
 <x49bmv192th.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49bmv192th.fsf@segfault.boston.devel.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Hou Tao <houtao1@huawei.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 20, 2017 at 10:19:22AM -0500, Jeff Moyer wrote:
> Hou Tao <houtao1@huawei.com> writes:
> 
> > Hi all,
> >
> > We need to throttle the O_DIRECT IO on data and metadata device
> > of a dm-thin pool and encounter some problems. If we set the
> > limitation on the root blkcg, the throttle works. If we set the
> > limitation on a child blkcg, the throttle doesn't work well.
> >
> > The reason why the throttle doesn't work is that dm-thin defers
> > the process of bio when the physical block of bio has not been
> > allocated. The bio will be submitted by the pool worker, and the
> > blkcg of the bio will be the blkcg of the pool worker, namely,
> > the root blkcg instead of the blkcg of the original IO thread.
> > We only set a limitation on the blkcg of the original IO thread,
> > so the blk-throttle doesn't work well.
> >
> > In order to handle the situation, we add a "keep_bio_blkcg" feature
> > to dm-thin. If the feature is enabled, the original blkcg of bio
> > will be saved at thin_map() and will be used during blk-throttle.
> 
> Why is this even an option?  I would think that you would always want
> this behavior.

Agreed that this should not be an optional feature.

One thing which always bothers me is that often we have dependencies
on finishing of these bios. So if we assign bios to their original
cgroups and if we create a cgroup with very low limit, then its
possible that everything slows down.

I guess answer to that is its a configuration issue and don't
create groups with too small a limits. And don't allow unprivileged
users to specify group limits.

Vivek
