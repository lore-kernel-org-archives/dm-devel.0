From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] linux-2.6.35+ causes LVM to fail with
	"	device-mapper: version ioctl failed: Inappropriate ioctl
	for device"
Date: Sun, 15 Aug 2010 14:03:36 +0100
Message-ID: <20100815130336.GA24055@agk-dp.fab.redhat.com>
References: <AANLkTime9NS3Bk-8ZpovRNy9iEGJxwYw=-aZ38JoRa_3@mail.gmail.com>
	<20100814155401.GJ26032@agk-dp.fab.redhat.com>
	<AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTi=aJ7f5X9sMeA85KJxi+rzWhiZCZ2ZwriNEVFCT@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, lkml <linux-kernel@vger.kernel.org>, lvm-devel@redhat.com
List-Id: dm-devel.ids

> Just a vanilla linux. No udev.

So likely a userspace problem where udev is now assumed to be present.
 
> > Provide long listing of /dev/mapper and any dm/lvm devices in /dev.

You can do that by running:
  ls -l /dev/mapper /dev/vg01

Also:
  cat /proc/devices
  cat /proc/misc

Alasdair

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
