From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] linux-2.6.35+ causes LVM to fail with "
	device-mapper: version ioctl failed: Inappropriate ioctl for device"
Date: Sat, 14 Aug 2010 16:54:01 +0100
Message-ID: <20100814155401.GJ26032@agk-dp.fab.redhat.com>
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Aug 14, 2010 at 02:01:47AM +0800, Jeff Chua wrote:
> It seems one of these commits in
> 8357422d4bf33bc2c35884d4016c3fc9efbbc1d2 is causing LVM2
> (LVM2.2.02.72) to fail.

Did you (partially) bisect that or are you just guessing?
The only one there possibly relevant is 7e507eb6432afdd798d4c6dccf949b8c43ef151c.

> Previously good logical volumes cannot be mounted anymore, and new one
> cannot be created. All failed with the error ...
> "device-mapper: version ioctl failed: Inappropriate ioctl for device"

What distribution?  What version of udev package?
'lvm version' output?
Provide long listing of /dev/mapper and any dm/lvm devices in /dev.
Add -vvvv to your lvm command for better clues.

> Is there a new LVM2 for this new dm ioctl or the dm is not right?
There's no new dm ioctl.
 
Alasdair
