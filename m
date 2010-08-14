From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] linux-2.6.35+ causes LVM to fail with "
	device-mapper: version ioctl failed: Inappropriate ioctl for device"
Date: Sat, 14 Aug 2010 17:16:17 +0100
Message-ID: <20100814161617.GK26032@agk-dp.fab.redhat.com>
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com> <20100814155401.GJ26032@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100814155401.GJ26032@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Aug 14, 2010 at 04:54:01PM +0100, Alasdair G Kergon wrote:
> The only one there possibly relevant is 7e507eb6432afdd798d4c6dccf949b8c43ef151c.

I'm guessing you could have a configuration not covered by the latest userspace
libdevmapper - not handling some combination of kernel+userspace+initrd packages
correctly.  We already dealt with one udev+initrd combination that failed last
week.
 
Alasdair
