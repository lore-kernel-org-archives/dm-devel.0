From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [4.1-rc1][Hibernation failed]  bisect result  included
Date: Mon, 04 May 2015 23:26:01 +0200
Message-ID: <1679784.bJHkPcaI3h@vostro.rjw.lan>
References: <36DF59CE26D8EE47B0655C516E9CE6402CA0E2@SHSMSX101.ccr.corp.intel.com> <59629198.7WWMERNz9P@vostro.rjw.lan> <20150504142654.GA985@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150504142654.GA985@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Chen, Yu C" <yu.c.chen@intel.com>, Dan Ehrenberg <dehrenberg@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>, Martin Steigerwald <martin@lichtvoll.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Monday, May 04, 2015 10:26:54 AM Mike Snitzer wrote:
> On Mon, May 04 2015 at 10:08am -0400,
> Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> 
> > On Sunday, May 03, 2015 03:54:39 PM Chen, Yu C wrote:
> > > Hi,all,
> > > When we are doing QA test, a hibernation failor was found on latest kernel 4.1-rc1,
> > > resume from hibernation failed with the following error:
> > > 
> > > PM: Hibernation image not present or could not be loaded.
> > > 
> > > Bisect shows following commit might trigger this problem:
> > > commit 283e7ad0241155710f99a9f39d13313a53336926
> > > 
> > > The  reason for failor is that, some distribution use klibc in initrd
> > > to restore the image, and klibc will provide kernel with the device 
> > > format of major:minor:offset,
> > > for example, 8:3:0 represents a swap partition, and klibc will
> > > echo 8:3:0 > /sys/power/resume to resume the system manually.
> > > However in current implementation, format of 8:3:0 will be regarded 
> > > as an invalid device, so restoring from hibernation failed.
> > > 
> > > Do we need to add support for device format like 8:3:0?
> > > I'm happy to debug more specifically if you can let me know what 
> > > would be of use, and I've also attached a temporary patch 
> > > for this problem, not sure if it is suitable,  thanks.
> > 
> > It'd be better to send the patch inline so it is not lost in replies.
> > Reproduced below.
> > 
> > Dan, Mike, any chance to look at this?  It is a functional regression for
> > some people.
> 
> Sorry about this.  Wasn't aware that such a strange format was being
> used.  The proposed patch looks good to me (formatting is a bit weird
> though, the last "&dummy) == 3)) {" line shouldnt be needed if previous
> line isn't indented so far.
> 
> Unless other more official init maintainer(s) want to pick this fix up:
> since I committed the commit that caused this regression I can pick this
> patch up and get it to Linus for 4.1-rc3 inclussion via linux-dm.git.
> Please just let me know, thanks!

Please pick it up if you can.  I won't bet any amount of money on anyone
else doing that ...


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
