From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: dm: propagate QUEUE_FLAG_NO_SG_MERGE
Date: Mon, 11 Aug 2014 10:40:20 -0400
Message-ID: <x49mwbbozsb.fsf@segfault.boston.devel.redhat.com>
References: <x49iom3hvle.fsf@segfault.boston.devel.redhat.com>
	<20140811011108.GA13946@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140811011108.GA13946@redhat.com> (Mike Snitzer's message of
	"Sun, 10 Aug 2014 21:11:08 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> Hi Jeff,
>
> Thanks for the patch.  But I think you need the following tweak.
> Otherwise if the DM table is reloaded (and the devices in the table
> happen to change) the flag won't get cleared as needed.

Ah, thanks for the education.  Looks good to me.

Thanks!
Jeff
