From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
Date: Tue, 04 Oct 2011 09:32:45 -0400
Message-ID: <x49pqicnapu.fsf@segfault.boston.devel.redhat.com>
References: <1317397918.27140.15.camel@localhost>
	<x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
	<1317729761.25998.4.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317729761.25998.4.camel@localhost> (Christophe Saout's message
	of "Tue, 04 Oct 2011 14:02:41 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe Saout <christophe@saout.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

Christophe Saout <christophe@saout.de> writes:

> Hi Jeff,
>
>> Anyway, it would help a great deal if you could retrigger the failure
>> and provide the full failure output.  You can get that by issuing the
>> 'dmesg' command and redirecting it to a file.
>
> Oh, sorry, yes, there's a line missing.
>
> Line 323 is this one: BUG_ON(!rq->bio || rq->bio != rq->biotail);
>
> The bug is not specific to GFS2, I also get it when using an ext3 mount
> on that multipath storage pool when writing to a file.

Great, thanks!  I tried ext3 and ext4 as well, and was unable to trigger
this problem.  I setup a linear volume on top of a multipath device.  Is
that the configuration you are using?  Anyway, this may be enough to get
me on the right path...

Cheers,
Jeff
