From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: remove per-cpu structure
Date: Sat, 22 Feb 2014 19:58:04 +0100
Message-ID: <5308F33C.5080405@gmail.com>
References: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>
	<20140220235935.GA32743@redhat.com>
	<alpine.LRH.2.02.1402201907120.29698@file01.intranet.prod.int.rdu2.redhat.com>
	<20140221023240.GA338@redhat.com>
	<alpine.LRH.2.02.1402210238470.5846@file01.intranet.prod.int.rdu2.redhat.com>
	<53087BD3.1000900@gmail.com> <20140222142526.GA12207@redhat.com>
	<5308DF91.6030003@gmail.com> <20140222182907.GA13445@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140222182907.GA13445@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Lisa Du <chunlingdu1@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 02/22/2014 07:29 PM, Mike Snitzer wrote:

> Thanks for the configuration scenarios.  I think I've asked this of you
> before but: Do you have any automated testing?  Something that we hand a
> blockdevice to and it produces a result that you find meaningful to use
> as a point of comparison.

Ask Ondra, he should have all code what I used (I think he modified it later).
(It was some fio scripts, stacked dmcrypt test, some basic dt and fsx tests and
some simple seek test.)

I run it against several versions (no patch, without sort part, etc)
and tried to compare times and throughput.

It is of course possible I did some stupid mistake.

On top of it, I do not have anything better.
And I do not have any suitable hw for testing now, so I can just say my opinion.

I just hope you have more facts than you mentioned here to support your decision
to merge these changes.

Milan
