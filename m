From: Mike Galbraith <efault@gmx.de>
Subject: Re: Do not overload dispatch queue (Was: Re: IO
 scheduler based IO controller V10)
Date: Sun, 04 Oct 2009 21:47:18 +0200
Message-ID: <1254685638.7637.6.camel@marge.simson.net>
References: <1254581496.8293.8.camel@marge.simson.net>
	<20091003151445.GF31616@kernel.dk>
	<1254585420.7539.2.camel@marge.simson.net>
	<20091003173532.GG31616@kernel.dk>
	<1254596864.7153.9.camel@marge.simson.net>
	<20091003192321.GA26573@kernel.dk>
	<1254599386.7153.46.camel@marge.simson.net>
	<1254653434.7237.18.camel@marge.simson.net>
	<20091004173901.GD26573@kernel.dk>
	<1254680622.27889.2.camel@marge.simson.net>
	<20091004183822.GF26573@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091004183822.GF26573@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Sun, 2009-10-04 at 20:38 +0200, Jens Axboe wrote:
> On Sun, Oct 04 2009, Mike Galbraith wrote:
> > On Sun, 2009-10-04 at 19:39 +0200, Jens Axboe wrote:
> > 
> > > So I'll commit a change that doesn't do the delay at all, basically it
> > > just offset the current code by one slice.
> > 
> > Ok, when it hits block-for-linus, I'll take it out for a spin.
> 
> It's committed:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=e00c54c36ac2024c3a8a37432e2e2698ff849594

Looks like a keeper to me :)

	-Mike

dd vs konsole -e exit
                                             Avg
 1.70     1.94     1.32     1.89     1.87    1.7     fairness=1 overload_delay=1
 1.55     1.79     1.38     1.53     1.57    1.5     desktop=1 +last_end_sync
 1.09     0.87     1.11     0.96     1.11    1.0     block-for-linus-8e29675
 1.29     2.18     1.16     1.21     1.24    1.4     block-for-linus-e00c54c

concurrent git test
                                                 Avg
108.12   106.33    106.34    97.00    106.52   104.8  1.000 virgin
 89.81    88.82     91.56    96.57     89.38    91.2   .870 desktop=1 +last_end_sync
 92.61    94.60     92.35    93.17     94.05    93.3   .890 blk-for-linus-8e29675
 88.73    89.02     88.10    90.84     88.30    88.9   .848 blk-for-linus-e00c54c

read vs write test

desktop=0                                Avg
elapsed        98.23    91.97   91.77    93.9  sec   1.000
30s-dd-read     48.5     49.6    49.1    49.0  mb/s  1.000
30s-dd-write    23.1     27.3    31.3    27.2        1.000
dd-read-total   49.4     50.1    49.6    49.7        1.000
dd-write-total  34.5     34.9    34.9    34.7        1.000

desktop=1 pop 8e296755                    Avg
elapsed        93.30    92.77    90.11   92.0         .979
30s-dd-read     50.5     50.4     51.8   50.9        1.038 
30s-dd-write    22.7     26.4     27.7   25.6         .941
dd-read-total   51.2     50.1     51.6   50.9        1.024 
dd-write-total  34.2     34.5     35.6   34.7        1.000

desktop=1 push 8e296755                   Avg
elapsed       104.51   104.52   101.20  103.4        1.101
30s-dd-read     43.0     43.6     44.5   43.7         .891
30s-dd-write    21.4     23.9     28.9   24.7         .908
dd-read-total   42.9     43.0     43.5   43.1         .867
dd-write-total  30.4     30.3     31.5   30.7         .884

latency=1 push e00c54c                   Avg
elapsed        90.03    93.03    91.68   91.5         .974
30s-dd-read     53.1     54.8     51.3   53.0        1.081
30s-dd-write    20.0     23.3     28.2   23.8         .875
dd-read-total   53.7     54.0     52.6   53.4        1.074
dd-write-total  35.5     34.2     34.9   34.8        1.002
