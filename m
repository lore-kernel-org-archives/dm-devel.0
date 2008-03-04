From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Date: Tue, 4 Mar 2008 12:04:50 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0803041200390.12253@woody.linux-foundation.org>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com>
	<20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu>
	<20080304104312.457ba3a8.akpm@linux-foundation.org>
	<20080304193348.GC5534@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080304193348.GC5534@suse.de>
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
Cc: kay.sievers@vrfy.org, linux-kernel <linux-kernel@vger.kernel.org>, "Zhang,
	Rui" <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alexey Dobriyan <adobriyan@sw.ru>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
List-Id: dm-devel.ids



On Tue, 4 Mar 2008, Greg KH wrote:
> 
> I have a patch queued up to change the wording of this config entry to
> not say 2006, as that's not true anymore, and it should hopefully fix
> some of the confusion here.

Well, I think some of the confusion is simply from people who already 
turned it off *before* (without problems), and now just do "make 
oldconfig" or otherwise just keep it off, and it causes problems for them.

Updating the help text won't do squat, because those people won't be 
reading it - maybe they read it back when it was a new option (and it 
worked for them), but not any more.

So I would almost suggest we simply force the option back on for now. 
Then, in 2.6.26, we can make it a question again, and by that time, people 
will have it as 'y' in their config files and will now have the option to 
turn it off again.

In other words, how about just this diff?

		Linus

---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f698a5a..a36e2e2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -367,7 +367,7 @@ config RESOURCE_COUNTERS
 	depends on CGROUPS
 
 config SYSFS_DEPRECATED
-	bool "Create deprecated sysfs files"
+	bool "Create deprecated sysfs files" if EMBEDDED
 	depends on SYSFS
 	default y
 	help
