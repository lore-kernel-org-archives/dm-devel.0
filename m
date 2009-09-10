From: Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Thu, 10 Sep 2009 17:18:25 +0200
Message-ID: <4AA918C1.6070907@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751882AbZIJPTY@vger.kernel.org>
In-Reply-To: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
> Hi All,
> 
> Here is the V9 of the IO controller patches generated on top of 2.6.31-rc7.
 
Hi Vivek,

I've run some postgresql benchmarks for io-controller. Tests have been
made with 2.6.31-rc6 kernel, without io-controller patches (when
relevant) and with io-controller v8 and v9 patches.
I set up two instances of the TPC-H database, each running in their
own io-cgroup. I ran two clients to these databases and tested on each
that simple request:
$ select count(*) from LINEITEM;
where LINEITEM is the biggest table of TPC-H (6001215 entries,
720MB). That request generates a steady stream of IOs.

Time is measure by psql (\timing switched on). Each test is run twice
or more if there is any significant difference between the first two
runs. Before each run, the cache is flush:
$ echo 3 > /proc/sys/vm/drop_caches


Results with 2 groups of same io policy (BE) and same io weight (1000):

	w/o io-scheduler	io-scheduler v8		io-scheduler v9
	first	second		first	second		first	second
	DB	DB		DB	DB		DB	DB

CFQ	48.4s	48.4s		48.2s	48.2s		48.1s	48.5s
Noop	138.0s	138.0s		48.3s	48.4s		48.5s	48.8s
AS	46.3s	47.0s		48.5s	48.7s		48.3s	48.5s
Deadl.	137.1s	137.1s		48.2s	48.3s		48.3s	48.5s

As you can see, there is no significant difference for CFQ
scheduler. There is big improvement for noop and deadline schedulers
(why is that happening?). The performance with anticipatory scheduler
is a bit lower (~4%).


Results with 2 groups of same io policy (BE), different io weights and
CFQ scheduler:
			io-scheduler v8		io-scheduler v9
weights = 1000, 500	35.6s	46.7s		35.6s	46.7s
weigths = 1000, 250	29.2s	45.8s		29.2s	45.6s

The result in term of fairness is close to what we can expect from the
ideal theoric case: with io weights of 1000 and 500 (1000 and 250),
the first request get 2/3 (4/5) of io time as long as it runs and thus
finish in about 3/4 (5/8) of total time. 


Results  with 2 groups of different io policies, same io weight and
CFQ scheduler:
			io-scheduler v8		io-scheduler v9
policy = RT, BE		22.5s	45.3s		22.4s	45.0s
policy = BE, IDLE	22.6s	44.8s		22.4s	45.0s

Here again, the result in term of fairness is very close from what we
expect.

Thanks,
Jerome
