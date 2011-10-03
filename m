From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [dm-devel] Block regression since 3.1-rc3
Date: Mon, 03 Oct 2011 10:43:52 -0400
Message-ID: <x49pqieyw2f.fsf@segfault.boston.devel.redhat.com>
References: <1317397918.27140.15.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317397918.27140.15.camel@localhost> (Christophe Saout's message
	of "Fri, 30 Sep 2011 17:51:57 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe Saout <christophe@saout.de>, device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

Christophe Saout <christophe@saout.de> writes:

> I think you guys should know - maybe you have an idea or have something
> for me to test.  I would have tried to file a bug somewhere, but half of
> the infrastructure is down at the moment.

You didn't include the top few lines which tell us what went wrong.  I
tried to reproduce this myself, but I ran into other issues with GFS2.
Anyway, it would help a great deal if you could retrigger the failure
and provide the full failure output.  You can get that by issuing the
'dmesg' command and redirecting it to a file.  And please CC me on any
future correspondences on this issue.

Thanks!
Jeff
