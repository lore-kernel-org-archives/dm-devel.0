From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [REGRESSION][BISECTED] virtio-blk serial attribute causes guest
 to hang [Was: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support
 for request-based dm]
Date: Thu, 9 Sep 2010 13:55:37 -0400
Message-ID: <20100909175537.GA9589@redhat.com>
References: <20100902032246.GA31484@redhat.com>
 <20100909152658.GA8118@redhat.com>
 <20100909154442.GI30086@us.ibm.com>
 <20100909155726.GA9081@redhat.com>
 <20100909160324.GJ30086@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909160324.GJ30086@us.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Ryan Harper <ryanh@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Sep 09 2010 at 12:03pm -0400,
Ryan Harper <ryanh@us.ibm.com> wrote:

> * Mike Snitzer <snitzer@redhat.com> [2010-09-09 10:58]:

> > I'm using virtio-blk w/ cache=none for the root device.  virtio-blk
> > isn't used for any other devices in the guest.
> 
> And you don't have any other disks in the guest (I see just the root and
> the cdrom), the lv stuff is happening against some sort of dummy target?

Correct.  I have used variants of the script I provided against both
scsi-debug devices and iscsi devices in the guest.  The script I shared
uses multipath on scsi-debug (ram-based) devices.

That script causes udev to run its various callouts via multipath and
LVM (both packages, upstream and RHEL6, now use udev).

I have verified that I no longer get the hang if I switch the root
device from virtio to ide.

Mike
