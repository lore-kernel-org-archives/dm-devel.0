From: Shaohua Li <shli@kernel.org>
Subject: Re: md: rename some drivers/md/ files to have an "md-" prefix
Date: Wed, 11 Oct 2017 12:53:39 -0700
Message-ID: <20171011195339.7fmr64sc4dv7etdw@kernel.org>
References: <20171010210241.2332-1-snitzer@redhat.com>
 <20171010212918.fykwmts6y2kfll2i@kernel.org>
 <20171010235535.GA15061@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010235535.GA15061@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 10, 2017 at 07:55:35PM -0400, Mike Snitzer wrote:
> On Tue, Oct 10 2017 at  5:29pm -0400,
> Shaohua Li <shli@kernel.org> wrote:
> 
> > On Tue, Oct 10, 2017 at 05:02:41PM -0400, Mike Snitzer wrote:
> > > Motivated by the desire to illiminate the imprecise nature of
> > > DM-specific patches being unnecessarily sent to both the MD maintainer
> > > and mailing-list.  Which is born out of the fact that DM files also
> > > reside in drivers/md/
> > > 
> > > Now all MD-specific files in drivers/md/ start with either "raid" or
> > > "md-" and the MAINTAINERS file has been updated accordingly.
> > > 
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > Good idea! Assume I take this?
> 
> Yes, please do.

I'm going to fold this patch into your original one, we'd better not change the
module name.


commit 3c54b480012281ee1d605c93df3c2a71a2bd2c29
Author: Shaohua Li <shli@fb.com>
Date:   Wed Oct 11 12:46:46 2017 -0700

    MD: don't change module name
    
    Signed-off-by: Shaohua Li <shli@fb.com>

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index d8e5f9cdb3ad..693602ffdd38 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -21,19 +21,22 @@ dm-verity-y	+= dm-verity-target.o
 md-mod-y	+= md.o md-bitmap.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
+linear-y	+= md-linear.o
+multipath-y	+= md-multipath.o
+faulty-y	+= md-faulty.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
 # themselves, and md.o may use the personalities when it 
 # auto-initialised.
 
-obj-$(CONFIG_MD_LINEAR)		+= md-linear.o
+obj-$(CONFIG_MD_LINEAR)		+= linear.o
 obj-$(CONFIG_MD_RAID0)		+= raid0.o
 obj-$(CONFIG_MD_RAID1)		+= raid1.o
 obj-$(CONFIG_MD_RAID10)		+= raid10.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
-obj-$(CONFIG_MD_MULTIPATH)	+= md-multipath.o
-obj-$(CONFIG_MD_FAULTY)		+= md-faulty.o
+obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
+obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_MD_CLUSTER)	+= md-cluster.o
 obj-$(CONFIG_BCACHE)		+= bcache/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
