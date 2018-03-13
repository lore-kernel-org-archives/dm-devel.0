From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Tue, 13 Mar 2018 12:31:36 -0400
Message-ID: <20180313163135.GB2785@redhat.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com>
	<1520890358.3469.68.camel@wdc.com>
	<20180313152551.GA2785@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180313152551.GA2785@redhat.com>
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

On Tue, Mar 13 2018 at 11:25am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Mar 12 2018 at  5:32pm -0400,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Mon, 2018-03-12 at 17:23 -0400, Mike Snitzer wrote:
> > > Could you provide more details on your setup?
> > > 
> > > Obviously you're using "queue_mode mq", what are your underlying paths?
> > > 
> > > Given the trace it would seem you're hitting multipath_clone_and_map()'s
> > > blk_queue_dying(q) error path that calls activate_or_offline_path().
> > 
> > Hello Mike,
> > 
> > The reported kernel crash was triggered by running the following command:
> > 
> > srp-test/run_tests -c -d -r 10 -t 02-mq
> > 
> > The srp-test software is available at https://github.com/bvanassche/srp-test.
> > All patches necessary to run that script in a virtual machine (RoCE support
> > for the SRP initiator and target drivers) will be sent to Linus during the
> > kernel v4.17 merge window. These patches are already available in linux-next
> > today. Although I have not tried this myself, I expect that if you run the
> > above command against a kernel built from the linux-next code that that will
> > allow you to reproduce what I reported.
> 
> A pointer to the commit ids in question would be helpful so I can
> appreciate the details better.
> 
> Why is there need for a virtual machine?
> Just using extra isolation so as not to conflict with anything on the
> host?
> 
> Anyway, I followed srp-test's README.md
> 
> But sadly, today's linux-next (next-20180313) is a mess (lots of macro
> expansion breakage, for me anyway).

I fixed the linux-next build errors (I cc'd you on that).

But now I cannot get the test to run:

# srp-test/run_tests -c -d -r 10 -t 02-mq
Unloaded the ib_srpt kernel module
Unloaded the rdma_rxe kernel module
SoftRoCE network interfaces: rxe0 rxe1 rxe2 rxe3
Zero-initializing /dev/ram0 ... done
Zero-initializing /dev/ram1 ... done
Configured SRP target driver
Running test srp-test/tests/02-mq ...
Test file I/O on top of multipath concurrently with logout and login (0 min; mq)
Unloaded the ib_srp kernel module
/dev/disk/by-id/dm-uuid-mpath-3600140572616d6469736b31000000000: not found
Test srp-test/tests/02-mq failed

[  379.634518] ib_srp: QP creation failed for dev rxe1: -22
[  379.639849] srpt/10.16.43.122: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  379.665891] sd 7:0:0:1: [sdk] Attached SCSI disk
[  379.673312] ib_srp: QP creation failed for dev rxe2: -22
[  379.688331] ib_srp: QP creation failed for dev rxe3: -22
[  379.708324] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
[  379.724538] ib_srp: target creation request is missing one or more parameters
[  379.740253] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
[  379.756531] ib_srp: target creation request is missing one or more parameters
[  379.773242] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
[  379.789532] ib_srp: target creation request is missing one or more parameters
[  379.805255] ib_srp: bad dest parameter '[2620:52:0:102f:219:99ff:feb7:2648'
[  379.822532] ib_srp: target creation request is missing one or more parameters

But I realized that was with an old srp-test build.. so I tried to make
again.. seems your buildrequires has expanded:

Why does it need shellcheck?  On RHEL, having to pull in EPEL packages sucks.

And even once installed via EPEL (so ShellCheck-0.3.5-1.el7.x86_64):

# make
...
shellcheck -x -f gcc run_tests bin/getuid_callout lib/functions \
tests/*[^~]
unrecognized option `-x'

Usage: shellcheck [OPTIONS...] FILES...
  -e CODE1,CODE2..  --exclude=CODE1,CODE2..  exclude types of warnings
  -f FORMAT         --format=FORMAT          output format
  -s SHELLNAME      --shell=SHELLNAME        Specify dialect (bash,sh,ksh,zsh)
  -V                --version                Print version information

make: *** [shellcheck] Error 3

In general this srp-test suite is way too exotic with its requirements.
Barrier to entry from a dumb user like me is _way_ too high.
