From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/2] mirror throttling
Date: Fri, 15 Feb 2013 00:53:21 +0000
Message-ID: <20130215005321.GK24130@agk-dp.fab.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com> <Pine.LNX.4.64.1301090043270.29917@file.rdu.redhat.com> <Pine.LNX.4.64.1301090044170.29917@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1301090044170.29917@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Guangliang Zhao <gzhao@suse.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, lucienchao@gmail.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 09, 2013 at 12:44:38AM -0500, Mikulas Patocka wrote:
> We maintain a history of kcopyd usage in variables io_period and
> total_period. The actual kcopyd activity is "(100 * io_period /
> total_period)" percent of time. If we exceed user-defined percentage
> threshold, we sleep.
 
Well, I'm going to take this pair of patches for now.

Some people do need this throttling today and this seems to me to be a
decent and simple way to give them a lever to deal with the problem.

I'm not proposing we expose this through LVM or other userspace tools at
this stage: people who need it should tune it directly through sysfs.

If need be, we can revisit this in future either by refining the
algorithm or making it adjustable per-device rather than per-module.
(Or by re-vamping kcopyd itself...)

The current version is:
  http://people.redhat.com/agk/patches/linux/editing/dm-kcopyd-introduce-configurable-throttling.patch

Alasdair
