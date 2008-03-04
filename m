From: Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Date: Tue, 4 Mar 2008 11:33:48 -0800
Message-ID: <20080304193348.GC5534@suse.de>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com>
	<20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu>
	<20080304104312.457ba3a8.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080304104312.457ba3a8.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kay.sievers@vrfy.org, linux-kernel <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, "Zhang,
	Rui" <rui.zhang@intel.com>
List-Id: dm-devel.ids

On Tue, Mar 04, 2008 at 10:43:12AM -0800, Andrew Morton wrote:
> On Tue, 4 Mar 2008 14:54:47 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > On Mon, Mar 03, 2008 at 07:25:49AM +0800, Zhang, Rui wrote:
> > > > Hi, all,
> > > > 
> > > > kernel panic on boot when I try to run 2.6.25-rc1 and later, but 2.6.24-rc8 boots okay.
> > > > The result of git-bisect shows that
> > > > edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit.
> > > > 
> > > > The git-bisect-result and the dmesg log when the kernel panic are 
> > > > attached. Any help on this please? :)
> > > 
> > > Are you using LVM?  If so, please either upgrade your userspace/initrd 
> > > stuff, or enable CONFIG_SYSFS_DEPCRECATED
> > 
> > we _really_ must handle this differently and this _is_ a regression that 
> > multiple people have spent hours on bisecting already ...
> > 
> > So "enable CONFIG_SYSFS_DEPCRECATED" is _NOT_ the right answer, and this 
> > has been pointed out to you in the past.
> 
> Isn't the device-mapper kernel code capable of detecting the older userspace
> version and loudly warning about it?  That at least would prevent us from
> wasting lots of people's time like this.

Yes, this is an LVM issue with older userspace provided by some
distros, I think the dm code can notify the user about the problem, Kay
would know more.

The two distros I use here work just fine with this set to N :)

I have a patch queued up to change the wording of this config entry to
not say 2006, as that's not true anymore, and it should hopefully fix
some of the confusion here.

thanks,

greg k-h
