From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Tue, 13 Mar 2018 11:25:51 -0400
Message-ID: <20180313152551.GA2785@redhat.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com>
	<1520890358.3469.68.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520890358.3469.68.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 12 2018 at  5:32pm -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Mon, 2018-03-12 at 17:23 -0400, Mike Snitzer wrote:
> > Could you provide more details on your setup?
> > 
> > Obviously you're using "queue_mode mq", what are your underlying paths?
> > 
> > Given the trace it would seem you're hitting multipath_clone_and_map()'s
> > blk_queue_dying(q) error path that calls activate_or_offline_path().
> 
> Hello Mike,
> 
> The reported kernel crash was triggered by running the following command:
> 
> srp-test/run_tests -c -d -r 10 -t 02-mq
> 
> The srp-test software is available at https://github.com/bvanassche/srp-test.
> All patches necessary to run that script in a virtual machine (RoCE support
> for the SRP initiator and target drivers) will be sent to Linus during the
> kernel v4.17 merge window. These patches are already available in linux-next
> today. Although I have not tried this myself, I expect that if you run the
> above command against a kernel built from the linux-next code that that will
> allow you to reproduce what I reported.

A pointer to the commit ids in question would be helpful so I can
appreciate the details better.

Why is there need for a virtual machine?
Just using extra isolation so as not to conflict with anything on the
host?

Anyway, I followed srp-test's README.md

But sadly, today's linux-next (next-20180313) is a mess (lots of macro
expansion breakage, for me anyway).
