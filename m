From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] md/dm-ioctl.c: optimize memory allocation
	in copy_params
Date: Tue, 22 Jul 2014 03:04:58 +0100
Message-ID: <20140722020458.GE6822@agk-dp.fab.redhat.com>
References: <53B68068.2060102@intel.com> <alpine.LRH.2.02.1407081831510.27831@file01.intranet.prod.int.rdu2.redhat.com> <53BCA278.5050205@linux.intel.com> <alpine.LRH.2.02.1407091032400.4545@file01.intranet.prod.int.rdu2.redhat.com> <53CDB81B.90509@linux.intel.com> <20140722012352.GD6822@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140722012352.GD6822@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, Mikulas Patocka <mpatocka@redhat.com>, "xinhui.pan" <xinhuix.pan@intel.com>, linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, "Liu, ShuoX" <shuox.liu@intel.com>
List-Id: dm-devel.ids

On Tue, Jul 22, 2014 at 02:23:52AM +0100, Alasdair G Kergon wrote:
> Unanswered.  Let's ask the same question in a different way:
 
A quick search for 'vold' returns:
  https://android.googlesource.com/platform/system/vold/
and the code there requests a fixed 64K allocation to hold the names of
active volumes.

So unlike libdevmapper-based applications where a smaller allocation is
used at first and only extended if needed, Android just assumes that
64KB is enough for everyone.

So is your claim that:

1. This 64KB allocation for the brief duration of the ioctl to store the
names of active device-mapper volumes leads to memory problems?
[Mustn't the system *already* be in a bad state if this pushes it over
the limit?]

and

2. The systems on which this memory shortage occurs have so many volumes
(with long names?) that a smaller allocation would not suffice?

Alasdair
