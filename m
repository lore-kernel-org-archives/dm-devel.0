From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for July 21 (drivers/md/dm-raid)
Date: Thu, 21 Jul 2011 14:56:48 -0700
Message-ID: <20110721145648.2477f8bb.rdunlap@xenotime.net>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
Sender: linux-raid-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 21 Jul 2011 16:55:42 +1000 Stephen Rothwell wrote:

> Hi all,

When CONFIG_DM_RAID=m and CONFIG_MD_RAID1 is not enabled:

ERROR: "md_raid1_congested" [drivers/md/dm-raid.ko] undefined!

due to:

	if (rs->raid_type->level == 1)
		return md_raid1_congested(&rs->md, bits);

Should that just be surrounded with this?

#if defined(CONFIG_MD_RAID1) || defined(CONFIG_MD_RAID1_MODULE)
...
#endif

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
