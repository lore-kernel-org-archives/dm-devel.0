From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Tue, 13 Mar 2018 13:02:11 -0400
Message-ID: <20180313170210.GD2785@redhat.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com>
	<1520890358.3469.68.camel@wdc.com>
	<20180313012346.GA31673@redhat.com>
	<1520959432.2638.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520959432.2638.17.camel@wdc.com>
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

On Tue, Mar 13 2018 at 12:43pm -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Mon, 2018-03-12 at 21:23 -0400, Mike Snitzer wrote:
> > Anyway, I'm hopeful I fixed the issue you reported.  Please feel free to
> > test the 2 topmost commits I've staged in linux-next, via dm-4.16:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.16
> 
> So far I haven't seen the crash I reported yesterday in my tests with dm-4.16
> of this morning. But I see hanging dm requests. I did not see any such issue
> yesterday with the revert I posted applied on top of dm-4.16. What I see today
> in the logs is the following:
> 
> INFO: task kworker/3:150:1681 blocked for more than 120 seconds
> 
> and in debugfs:
> # (cd /sys/kernel/debug/block/ && grep -r op= .)
> ./dm-2/requeue_list:00000000df366fff {.op=READ, .cmd_flags=, .rq_flags=SORTED|STARTED|SOFTBARRIER|ELVPRIV|IO_STAT, .state=idle, .tag=-1, .internal_tag=45}
> ./dm-0/requeue_list:000000008302ea45 {.op=READ, .cmd_flags=, .rq_flags=SORTED|STARTED|SOFTBARRIER|ELVPRIV|IO_STAT, .state=idle, .tag=-1, .internal_tag=211}
> ./dm-1/requeue_list:000000007ea8ad0e {.op=READ, .cmd_flags=, .rq_flags=SOFTBARRIER|IO_STAT, .state=idle, .tag=428, .internal_tag=-1}
> ./dm-1/requeue_list:00000000e93ecaa8 {.op=READ, .cmd_flags=, .rq_flags=SOFTBARRIER|IO_STAT, .state=idle, .tag=429, .internal_tag=-1}

Strange.. but I'll review closer.  Clearly requests aren't getting
pulled off the request_list
