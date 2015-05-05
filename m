From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [4.1-rc1][Hibernation failed]  bisect result  included
Date: Tue, 05 May 2015 22:48:01 +0200
Message-ID: <1578315.Syt0DGTIqh@vostro.rjw.lan>
References: <36DF59CE26D8EE47B0655C516E9CE6402CA0E2@SHSMSX101.ccr.corp.intel.com> <20150504142654.GA985@redhat.com> <55482B44.6060407@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <55482B44.6060407@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Yu Chen <yu.c.chen@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Dan Ehrenberg <dehrenberg@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>, Martin Steigerwald <martin@lichtvoll.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tuesday, May 05, 2015 10:30:28 AM Yu Chen wrote:
> On 05/04/2015 10:26 PM, Mike Snitzer wrote:
> > On Mon, May 04 2015 at 10:08am -0400,
> > Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> >> On Sunday, May 03, 2015 03:54:39 PM Chen, Yu C wrote:
> >>> Hi,all,
> >>> When we are doing QA test, a hibernation failor was found on latest kernel 4.1-rc1,
> >>> resume from hibernation failed with the following error:
> >>>
> >>> PM: Hibernation image not present or could not be loaded.
> >>>
> >>> Bisect shows following commit might trigger this problem:
> >>> commit 283e7ad0241155710f99a9f39d13313a53336926
> >>>
> >>> The  reason for failor is that, some distribution use klibc in initrd
> >>> to restore the image, and klibc will provide kernel with the device
> >>> format of major:minor:offset,
> >>> for example, 8:3:0 represents a swap partition, and klibc will
> >>> echo 8:3:0 > /sys/power/resume to resume the system manually.
> >>> However in current implementation, format of 8:3:0 will be regarded
> >>> as an invalid device, so restoring from hibernation failed.
> >>>
> >>> Do we need to add support for device format like 8:3:0?
> >>> I'm happy to debug more specifically if you can let me know what
> >>> would be of use, and I've also attached a temporary patch
> >>> for this problem, not sure if it is suitable,  thanks.
> >>
> >> It'd be better to send the patch inline so it is not lost in replies.
> >> Reproduced below.
> >>
> >> Dan, Mike, any chance to look at this?  It is a functional regression for
> >> some people.
> >
> > Sorry about this.  Wasn't aware that such a strange format was being
> > used.  The proposed patch looks good to me (formatting is a bit weird
> > though, the last "&dummy) == 3)) {" line shouldnt be needed if previous
> > line isn't indented so far.
> >
> 
> Thank you very much, Mike and Rafeal,
> I'll send another version titled with V2 for review.

Have you sent it already?  Where is it if so?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
