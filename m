From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: DM / LVM hangs if snapshot present on kernel v3.0.3
Date: Mon, 20 Feb 2012 18:17:06 +0100
Message-ID: <4F428012.6090302@redhat.com>
References: <4F405E1B.5030609@shiftmail.org>
	<20120220135103.GB27388@redhat.com>
	<4F426234.1020704@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F426234.1020704@shiftmail.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-lvm@redhat.com
List-Id: dm-devel.ids

Dne 20.2.2012 16:09, Spelic napsal(a):
> On 02/20/12 14:51, Mike Snitzer wrote:
>> I've never seen this. Which distro are you using?
> 
> Ubuntu 11.04  64-bit but with vanilla 3.0.3 kernel
> 
> Ubuntu's lvm:
> # lvm version
>   LVM version:     2.02.66(2) (2010-05-20)
>   Library version: 1.02.48 (2010-05-20)
> 

So I'd guess you might be a 'victim' of Debian home-brew udev rules for lvm2,
which were unfortunately not consulted with upstream (nor udev, nor lvm).

If you really need 'quick' solution - try to build CVS version
(shouldn't be really hard) - second thing to try my be more recent Debian
lvm2  build which has merged most of udev rules from upstream (though there
are still some deviation that might be source of troubles).

If you want to get some support for your version of OS and lvm2, you may try
to open Ubuntu bugzilla.

> PV1 (a MD raid) --> VG1 --> 5 x LVs used for virtual machines disks; of these,
> only one LV had one snapshot. No other snapshots. None of these volumes were
> mounted on the host. This is where the problem happened.
> PV2 (a MD raid) --> VG2 --> 1 x LV , I don't remember if this was mounted on
> the host at that time or was a disk for a virtual machine, but anyway was not
> the root filesystem of the host. No snapshots here.
> 
> Root filesystem of the host was definitely *not* on LVM.
> 
> Unfortunately the machine where it happened is a production machine and it's
> too dangerous to try to reproduce it there; this weekend I tried to reproduce
> it elsewhere but clearly it didn't happen. I had a stack trace of the DM hang
> but I lost it, stupid me...

It's always best to have reproducer on different machine so you may check your
solution you want to deploy on production machine.

Note - upstream code contains test suite (subdir test) which you may try to
run in your environment to see whether all tests passes.

Zdenek
