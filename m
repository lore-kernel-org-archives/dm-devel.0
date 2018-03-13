From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Tue, 13 Mar 2018 12:58:51 -0400
Message-ID: <20180313165851.GC2785@redhat.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com>
	<1520890358.3469.68.camel@wdc.com>
	<20180313152551.GA2785@redhat.com>
	<20180313163135.GB2785@redhat.com>
	<1520959569.2638.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520959569.2638.19.camel@wdc.com>
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

On Tue, Mar 13 2018 at 12:46pm -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Tue, 2018-03-13 at 12:31 -0400, Mike Snitzer wrote:
> > But now I cannot get the test to run:
> > 
> > # srp-test/run_tests -c -d -r 10 -t 02-mq
> > Unloaded the ib_srpt kernel module
> > Unloaded the rdma_rxe kernel module
> > SoftRoCE network interfaces: rxe0 rxe1 rxe2 rxe3
> > Zero-initializing /dev/ram0 ... done
> > Zero-initializing /dev/ram1 ... done
> > Configured SRP target driver
> > Running test srp-test/tests/02-mq ...
> > Test file I/O on top of multipath concurrently with logout and login (0 min; mq)
> > Unloaded the ib_srp kernel module
> > /dev/disk/by-id/dm-uuid-mpath-3600140572616d6469736b31000000000: not found
> > Test srp-test/tests/02-mq failed
> > 
> > [  379.634518] ib_srp: QP creation failed for dev rxe1: -22
> > [  379.639849] srpt/10.16.43.122: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
> > [  379.665891] sd 7:0:0:1: [sdk] Attached SCSI disk
> > [  379.673312] ib_srp: QP creation failed for dev rxe2: -22
> > [  379.688331] ib_srp: QP creation failed for dev rxe3: -22
> > [  379.708324] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
> > [  379.724538] ib_srp: target creation request is missing one or more parameters
> > [  379.740253] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
> > [  379.756531] ib_srp: target creation request is missing one or more parameters
> > [  379.773242] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
> > [  379.789532] ib_srp: target creation request is missing one or more parameters
> > [  379.805255] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
> > [  379.822532] ib_srp: target creation request is missing one or more parameters
> 
> That's weird. I will see whether I can reproduce this with linux-next, since I have
> not yet tried to run srp-test against linux-next myself.

OK, I appreciate it (you'll need to revert thos commits I shared in the
other linux-next thread).
