From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: dm-ioband: Test results.
Date: Tue, 14 Apr 2009 14:27:32 +0900 (JST)
Message-ID: <20090414.142732.193715176.ryov@valinux.co.jp>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	<20090413144626.GF18007@redhat.com>
	<20090414024943.GA976@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752464AbZDNF1o@vger.kernel.org>
In-Reply-To: <20090414024943.GA976@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Vivek,

> Also I wanted to test run your patches. How do I do that? I see that your
> patches are based on dm quilt tree. I downloaded the dm-patches and tried
> to apply on top of 2.6.30-rc1 but it failed. So can't apply your patches
> now.

> Applying patch dm-add-request-based-facility.patch

"dm-add-request-based-facility.patch" is not my patch. To apply my
patch, you need to edit the series file and comment out the patch
files after "mm" section and my patch like this:

  ############################################################
  # Marker corresponding to end of -mm tree.
  ############################################################
  
  #dm-table-fix-alignment-to-hw_sector.patch
  mm

  # An attempt to get UML to work with dm.
  uml-fixes.patch

  ############################################################
  # May need more work or testing, but close to being ready.
  ############################################################
  
  # Under review
  #dm-exception-store-generalize-table-args.patch
  #dm-snapshot-new-ctr-table-format.patch
  #dm-snapshot-cleanup.patch
  
  #dm-raid1-add-clustering.patch
  dm-add-ioband.patch

And then type "quilt push dm-add-ioband.patch" command.
However, the patch can be applied, but a compile error is caused
because the patch is against the previous dm-tree.

> So what's the simplest way of testing your changes on latest kernels?

So I've uploaded a patch against 2.6.30-rc1. Please use it if you
like. http://people.valinux.co.jp/~ryov/dm-ioband/
The bio-cgroup patch against 2.6.30-rc1 will be uploaded within a few
days. I'm looking forward to your feedback on dm-ioband.

Thanks,
Ryo Tsuruta
