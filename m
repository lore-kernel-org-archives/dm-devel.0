From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7] fs: allow per-device dax status checking for
 filesystems
Date: Fri, 25 May 2018 12:23:27 -0700
Message-ID: <20180525192327.GR12940@magnolia>
References: <20180525025518.11405-1-ross.zwisler@linux.intel.com>
 <20180525025518.11405-2-ross.zwisler@linux.intel.com>
 <20180525050218.GF4507@magnolia>
 <20180525154229.GA11044@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180525154229.GA11044-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Fri, May 25, 2018 at 09:42:29AM -0600, Ross Zwisler wrote:
> On Thu, May 24, 2018 at 10:02:18PM -0700, Darrick J. Wong wrote:
> > On Thu, May 24, 2018 at 08:55:12PM -0600, Ross Zwisler wrote:
> > > From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > 
> > > Remove __bdev_dax_supported and change to bdev_dax_supported that takes a
> > > bdev parameter.  This enables multi-device filesystems like xfs to check
> > > that a dax device can work for the particular filesystem.  Once that's
> > > in place, actually fix all the parts of XFS where we need to be able to
> > > distinguish between datadev and rtdev.
> > > 
> > > This patch fixes the problem where we screw up the dax support checking
> > > in xfs if the datadev and rtdev have different dax capabilities.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > Reviewed-by: Darr...oh, I'm not allowed to do that, am I?
> > 
> > Would you mind (re)sending this to the xfs list so that someone else can
> > review it?
> > 
> > --D
> 
> Thanks for the review, Darrick.
> 
> I think at one point Dave said that if you touch more than 1 filesystem with a
> series you should just CC linux-fsdevel and omit the individual filesystems?
> I realize that this series only touches ext2 and ext4 a little, but that's
> what I opted for.
> 
> Is that sufficient to get to the rest of the XFS developers, or would you like
> a resend adding linux-xfs?

For a patch by any other author I'd be fine with -fsdevel, but for this
specific one (because it's written by me and I'm not yet so bofh that I
review my own patches ;)) someone else from the xfs community has to
review it, so yes I'd like it to be sent to linux-xfs, please.

(And it's ok to note in the resend that this is the same as the -fsdevel
series, but posted here to attract the attention of the other xfs
developers.)

--D
