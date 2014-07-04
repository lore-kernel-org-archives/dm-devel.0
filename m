From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: v3.15 dm-mpath regression: cable pull test causes
 I/O hang
Date: Fri, 4 Jul 2014 03:10:05 +0000
Message-ID: <11AF7C027C4C02408624617A4986078401311EA8@BPXM12GP.gisp.nec.co.jp>
References: <53AD6B62.2020407@acm.org> <20140627133345.GA6150@redhat.com>
	<20140702220223.GA23894@redhat.com> <53B56120.8040802@acm.org>
	<20140703140516.GB28104@redhat.com> <53B569E1.1010405@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53B569E1.1010405@acm.org>
Content-Language: ja-JP
Content-ID: <28D0878FCF2C6F4B923BDF1FA505A389@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 07/03/14 23:34, Bart Van Assche wrote:
> On 07/03/14 16:05, Mike Snitzer wrote:
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
> 
> If you want I can send you the scripts I use to run this test and also
> the instructions that are necessary to build and install the SCST SRP
> target driver.

Hi Bart,

could you collect output of 'dmsetup table' on the test machine?
My particular interest is whether pg_init is involved or not
since Hannes's patch made major surgery on pg_init processing.

Also, output of the followings while the problem is happening might help:
  dmsetup status
  dmsetup info -c
  cat /proc/diskstat
  multipathd -k"show paths"
  multipathd -k"show maps status"
  multipathd -k"show maps stats"

-- 
Jun'ichi Nomura, NEC Corporation
