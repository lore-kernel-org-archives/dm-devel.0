From: Mike Snitzer <snitzer@redhat.com>
Subject: cmwq and dm-crypt devices? (was: Re: md: dm-crypt: Add
 option to re-use a new global work-queue.)
Date: Tue, 2 Nov 2010 18:02:07 -0400
Message-ID: <20101102220207.GD23680@redhat.com>
References: <1271958538-11193-1-git-send-email-san@google.com>
	<4BD08F78.4000701@redhat.com>
	<q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
	<4BD099DB.2020108@redhat.com>
	<s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
	<x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: San Mehat <san@google.com>
Cc: Christophe Saout <christophe@saout.de>, Brian Swetland <swetland@google.com>, device-mapper development <dm-devel@redhat.com>, andi@firstfloor.org, tj@kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi,

On Tue, Apr 27 2010 at  4:58pm -0400,
San Mehat <san@google.com> wrote:

> *ping* Any word on my previous counter-proposal? Shall I prepare
> another patch for consideration?

The new concurrency managed workqueues (cmwq) that went in to 2.6.36
_should_ hopefully obviate the need for the patch you proposed:
https://patchwork.kernel.org/patch/94179/

Some background on cmwq:
Documentation/workqueue.txt
http://lwn.net/Articles/403891/

We on the DM team haven't explored the impact cmwq has on dm-crypt
devices yet so more research and testing is needed here.  But it'd be
nice to have a hypothesis on how much cmwq will help us solve the
our dm-crypt goals "for free".

[Cc'ing Tejun]

Tejun,

Your insight on how dm-crypt should be using cmwq to achieve the
following conflicting goals would be appreciated:

1) scale down the number of workqueue threads associated with N devices
   (w/ 2 workqueue threads per device) so that the number of threads is
   reasonable ("reasonable" is TBD but I'd imagine it doesn't buy us a
   lot to have 2 single thread workqueues dedicated to each dm-crypt
   device).

   [seems dm-crypt will already get this "for free" using
    create_singlethread_workqueue's WQ_UNBOUND?]

2) scale up the number of workqueue threads used for a single dm-crypt
   device so that a device can realize per-cpu concurrency (to address
   Andi's scalability concerns: https://patchwork.kernel.org/patch/244031/)

   [the desired locality is currently missing due to dm-crypt's current
    use of WQ_UNBOUND; so it is clear the way the workqueues are created
    will be important]

Regards,
Mike
