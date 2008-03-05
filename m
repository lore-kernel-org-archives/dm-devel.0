From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Date: Wed, 5 Mar 2008 14:25:37 +0100
Message-ID: <20080305132537.GC11701@elte.hu>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com>
	<20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu>
	<20080304104312.457ba3a8.akpm@linux-foundation.org>
	<20080304193348.GC5534@suse.de>
	<alpine.LFD.1.00.0803041200390.12253@woody.linux-foundation.org>
	<20080304202436.GA29456@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080304202436.GA29456@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Greg KH <gregkh@suse.de>
Cc: kay.sievers@vrfy.org, linux-kernel <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "Zhang,
	Rui" <rui.zhang@intel.com>
List-Id: dm-devel.ids


* Greg KH <gregkh@suse.de> wrote:

> It's as if we should just change the config option name every kernel 
> release to make sure that users keep things up to date.  So Ingo's 
> original proposal makes sense to me, more so than this patch.

this change is now upstream and included in -rc4:

  ------------------->
  commit d47846c5866b7d98a1173c86a39d810a06647329
  Author: Ingo Molnar <mingo@elte.hu>
  Date:   Tue Mar 4 14:54:47 2008 +0100

      sysfs: CONFIG_SYSFS_DEPRECATED fix
  <------------------

thanks Greg!

	Ingo
