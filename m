From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: 2.6.25-rc regression: kernel panic on boot
Date: Wed, 5 Mar 2008 01:19:45 +0000
Message-ID: <20080305011945.GP1788@agk.fab.redhat.com>
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
Cc: Greg KH <gregkh@suse.de>, kay.sievers@vrfy.org, linux-kernel <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>, dm-devel@redhat.com, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, "Zhang,
	Rui" <rui.zhang@intel.com>
List-Id: dm-devel.ids

On Tue, Mar 04, 2008 at 10:43:12AM -0800, Andrew Morton wrote:
> Isn't the device-mapper kernel code capable of detecting the older userspace
> version and loudly warning about it?  That at least would prevent us from
> wasting lots of people's time like this.
 
It's not a device-mapper problem: It's between userspace LVM2 and kernel
sysfs.

LVM2 userspace expects a particular sysfs layout.  That layout got
changed without offering sufficient lead time (>6-9 months) for the
required userspace changes to propagate into the main versions of the
distros people use.

LVM2 userspace version 2.02.29 (released 5th December 2007) can handle
old and new layouts.  The patch was in the CVS head for a while before
that.  Earlier versions of LVM2 require CONFIG_SYSFS_DEPRECATED.  A
less-efficient workaround is to disable the use of sysfs in the LVM2
config: 'devices { sysfs_scan = 0 }'.

(I think the root cause of this mess was changing what
CONFIG_SYSFS_DEPRECATED did instead of adding a new setting that could
be enabled by default.)

Alasdair
-- 
agk@redhat.com
