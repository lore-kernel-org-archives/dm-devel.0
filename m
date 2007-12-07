From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Re: 2.6.24-rc4-mm1
Date: Fri, 07 Dec 2007 21:49:41 +0100
Message-ID: <1197060581.5483.35.camel@lov.site>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
	<20071206040420.6c89c675.akpm@linux-foundation.org>
	<4374.1196968688@turing-police.cc.vt.edu>
	<20071206193843.GA25125@kroah.com>
	<3ae72650712061404w170fc434nb1172e048216e139@mail.gmail.com>
	<2955.1196982750@turing-police.cc.vt.edu>
	<1196983444.2829.38.camel@lov.site>
	<6593.1197051630@turing-police.cc.vt.edu>
	<1197053069.5483.8.camel@lov.site>
	<4192.1197059303@turing-police.cc.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4192.1197059303@turing-police.cc.vt.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <greg@kroah.com>, device-mapper development <dm-devel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, 2007-12-07 at 15:28 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 07 Dec 2007 19:44:29 +0100, Kay Sievers said:
> 
> > > Anybody got any brilliant ideas? :)
> > 
> > I guess it's nash again, which version is it?
> 
> Confirmed - nash again.  6.0.9 does not work, upgrading to 6.0.19 works.

Oh, cool!

I expected 6.0.9 to contain the fix though:
  http://lkml.org/lkml/2007/6/7/209

> init/Kconfig says this for SYSFS_DEPRECATED (which is where I got lead astray,
> as most of my laptop is Fedora Rawhide and therefor "released this week"):
> 
>           If you are using a distro that was released in 2006 or later,
>           it should be safe to say N here.
> 
> nash 6.0.9 came out in April 2007, and I suspect, but can't prove, that the
> relevant change was this one:
> 
> * Mon Aug 27 2007 Peter Jones <pjones@redhat.com> - 6.0.12-2
> - Fix segfault in scsi vpd probe code
> - Fix block device creation
> 
> That was just over 3 months ago.

Yeah right, even if it is fixed earlier, it's at least 6 months.

>  We probably need to fix that help text,
> but I admit not being sure what guidance we should give now....

Right, the help text needs to be changed. There are distros like Red Hat
which don't support !DEPRECATED at all today, so we should probably just
remove the date and add that to the help text.

On the other hand, we are currently considering making the DEPRECATED
behavior a boot-time option, so it can be changed on the kernel command
line instead of a compile option. There would only be a compile-time
default to set.
We will get to that after the current kobject work (~100 patches) in
Greg's tree is finished.

Thanks for your help and patience,
Kay
