From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
	I/O hang
Date: Thu, 3 Jul 2014 11:00:55 -0400
Message-ID: <20140703150055.GA28518@redhat.com>
References: <53AD6B62.2020407@acm.org> <20140627133345.GA6150@redhat.com>
	<20140702220223.GA23894@redhat.com> <53B56120.8040802@acm.org>
	<20140703140516.GB28104@redhat.com> <53B569E1.1010405@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53B569E1.1010405@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 03 2014 at 10:34am -0400,
Bart Van Assche <bvanassche@acm.org> wrote:

> On 07/03/14 16:05, Mike Snitzer wrote:
> > How easy would it be to replicate your testbed?  Is it uniquely FIO hw
> > dependent?  How are you simulating the cable pull tests?
> > 
> > I'd love to setup a testbed that would enable me to chase this more
> > interactively rather than punting to you for testing.
> 
> Hello Mike,
> 
> The only nonstandard hardware that is required to run my test is a pair
> of InfiniBand HCA's and an IB cable to connect these back-to-back. The
> test I ran is as follows:
> * Let an SRP initiator log in to an SRP target system.
> * Start multipathd and srpd.
> * Start a fio data integrity test on the initiator system on top of
>   /dev/dm-0.
> * From the target system simulate a cable pull by disabling IB traffic
>   via the ibportstate command.
> * After a random delay, unload and reload SCST and the IB stack. This
>   makes the IB ports operational again.
> * After a random delay, repeat the previous two steps.

I'll work on getting some IB cards.  But I _should_ be able to achieve
the same using iSCSI right?

> If you want I can send you the scripts I use to run this test and also
> the instructions that are necessary to build and install the SCST SRP
> target driver.

Please do, thanks!

Also, Red Hat has a rather extensive battery of dm-mpath FC cable pull
tests for RHEL but these dm-mpath changes haven't been included in any
RHEL yet.. I _could_ port these upstream changes to a test RHEL7 kernel
just to leverage the RHEL-based testing.
