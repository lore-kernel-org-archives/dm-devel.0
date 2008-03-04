From: Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Date: Tue, 4 Mar 2008 12:24:36 -0800
Message-ID: <20080304202436.GA29456@suse.de>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu> <20080304104312.457ba3a8.akpm@linux-foundation.org> <20080304193348.GC5534@suse.de> <alpine.LFD.1.00.0803041200390.12253@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933843AbYCDUYy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803041200390.12253@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, "Zhang, Rui" <rui.zhang@intel.com>, linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 04, 2008 at 12:04:50PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 4 Mar 2008, Greg KH wrote:
> > 
> > I have a patch queued up to change the wording of this config entry to
> > not say 2006, as that's not true anymore, and it should hopefully fix
> > some of the confusion here.
> 
> Well, I think some of the confusion is simply from people who already 
> turned it off *before* (without problems), and now just do "make 
> oldconfig" or otherwise just keep it off, and it causes problems for them.
> 
> Updating the help text won't do squat, because those people won't be 
> reading it - maybe they read it back when it was a new option (and it 
> worked for them), but not any more.

Yeah, that makes sense :(

> So I would almost suggest we simply force the option back on for now. 
> Then, in 2.6.26, we can make it a question again, and by that time, people 
> will have it as 'y' in their config files and will now have the option to 
> turn it off again.
> 
> In other words, how about just this diff?

Well, this will force the distros that are going to ship based on 2.6.25
(Fedora 9, openSUSE 11.0, etc.) to either enable EMBEDDED, or patch this
chunk out, as they do want to run with that option enabled because they
do have up-to-date userspace code.

It's as if we should just change the config option name every kernel
release to make sure that users keep things up to date.  So Ingo's
original proposal makes sense to me, more so than this patch.

thanks,

greg k-h
