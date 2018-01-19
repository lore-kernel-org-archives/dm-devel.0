From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 11:47:22 -0500
Message-ID: <20180119164722.GA29449@redhat.com>
References: <20180119072623.GB25369@ming.t460p>
 <047f68ec-f51b-190f-2f89-f413325c2540@kernel.dk>
 <20180119154047.GB14827@ming.t460p>
 <540e1239-c415-766b-d4ff-bb0b7f3517a7@kernel.dk>
 <20180119160518.GC14827@ming.t460p>
 <4a5c049f-0fab-bbaf-bfe2-eb5bca73f2c8@kernel.dk>
 <20180119162618.GD14827@ming.t460p>
 <1f072086-533e-4b75-d0e3-9e621b2120d8@kernel.dk>
 <20180119163736.GE14827@ming.t460p>
 <26833249-cadf-ba9c-1128-0bcb70ceb9e1@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <26833249-cadf-ba9c-1128-0bcb70ceb9e1@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On Fri, Jan 19 2018 at 11:41am -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 1/19/18 9:37 AM, Ming Lei wrote:
> > On Fri, Jan 19, 2018 at 09:27:46AM -0700, Jens Axboe wrote:
> >> On 1/19/18 9:26 AM, Ming Lei wrote:
> >>> On Fri, Jan 19, 2018 at 09:19:24AM -0700, Jens Axboe wrote:
> >>
> >> There are no pending requests for this case, nothing to restart the
> >> queue. When you fail that blk_get_request(), you are idle, nothing
> >> is pending.
> > 
> > I think we needn't worry about that, once a device is attached to
> > dm-rq, it can't be mounted any more, and usually user don't use the device
> > directly and by dm-mpath at the same time.
> 
> Even if it doesn't happen for a normal dm setup, it is a case that
> needs to be handled. The request allocation is just one example of
> a wider scope resource that can be unavailable. If the driver returns
> NO_DEV_RESOURCE (or whatever name), it will be a possibility that
> the device itself is currently idle.

How would a driver's resources be exhausted yet the device is idle (so
as not to be able to benefit from RESTART)?
