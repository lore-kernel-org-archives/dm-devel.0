From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] Re: 2.6.24-rc4-mm1
Date: Fri, 07 Dec 2007 19:44:29 +0100
Message-ID: <1197053069.5483.8.camel@lov.site>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <3941.1196941764@turing-police.cc.vt.edu>
	 <20071206040420.6c89c675.akpm@linux-foundation.org>
	 <4374.1196968688@turing-police.cc.vt.edu>
	 <20071206193843.GA25125@kroah.com>
	 <3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
	 <2955.1196982750@turing-police.cc.vt.edu>
	 <1196983444.2829.38.camel@lov.site>
	 <6593.1197051630@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756041AbXLGSor@vger.kernel.org>
In-Reply-To: <6593.1197051630@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Cc: device-mapper development <dm-devel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, 2007-12-07 at 13:20 -0500, Valdis.Kletnieks@vt.edu wrote: 
> On Fri, 07 Dec 2007 00:24:04 +0100, Kay Sievers said:
> > On Thu, 2007-12-06 at 18:12 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > On Thu, 06 Dec 2007 23:04:12 +0100, Kay Sievers said:
> > > 
> > > > What's the value of SYSFS_DEPRECATED? Care to set it to yes, if it isn't,
> > > > and try again?
> > > 
> > > I *knew* there was a D'Oh! error in here. ;)
> > > 
> > > Bisection is fast closing in on gregkh-driver-block-device.patch, which broke
> > > my LVM almost the exact same way the *last* time it showed up in -mm ;)
> > 
> > Oh, it must not, if SYSFS_DEPRECATED=y is set. I hope we fixed all
> > issues. Please let us know if it does not work, then we will need to
> > look into it.
> 
> I changed SYSFS_DEPRECATED to y, and it was able to boot with the same old
> initrd I've been using for a while.

Great!

> Note that I had it set to 'n' for at least the last 4-5 -mm kernels, so it
> *was* working fine without it..

Yeah, but the raw block kobjects got converted to devices, which are
symlinks with SYSFS_DEPRECATED=n.

> > > > A fix for LVM to handle symlinks instead of directories is in the LVM
> > > > CVS tree, but there wasn't a release since August.
> > > 
> > > I seem to recall it was 'nash' rather than LVM that had the indigestion the
> > > last time around.
> > 
> > I think that a recent nash should work, even with SYSFS_DEPRECATED=n.
> > Anyway, nothing should change when SYSFS_DEPRECATED set, nash works fine
> > here, with that.
> 
> It was working fine with =n here until -rc4-mm1 as well, that's why it's a bit
> of a surprise.  What got added to the 'deprecated' list in this iteration?

Block devices got integrated in the driver model.

> Now for the truly odd part - I just tried with a rebuilt initrd that included
> the lvm.static from last night's Rawhide (lvm2-2.02.29-1.fc9).  And that didn't
> work any better.
> 
> So to summarize: (old lvm == 2.02.24)
> 
> release	SYSFS_DEPRECATED	lvm2		works
> -rc3-mm2		N	old	yes
> -rc4-mm1		N	old	no
> -rc4-mm1		Y	old	yes
> -rc4-mm1		N	new	no
> 
> (I'm sure looking at that, everybody is now going 'WTF??!?' ;)
> 
> gregkh-driver-driver-core-fix-class-glue-dir-cleanup-logic.patch and
> gregkh-driver-block-device.patch are the only patches left in the (very small)
> bisect window that reference SYSFS_DEPRECATED at all (according to grep)
> 
> Anybody got any brilliant ideas? :)

I guess it's nash again, which version is it?

You probably need to wait for Red Hat to catch up, and don't disable
SYSFS_DEPRECATED for now, they don't support that.

Kay

