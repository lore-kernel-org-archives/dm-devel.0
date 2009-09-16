From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: dm-ioband fairness in terms of sectors seems to be
	killing disk
Date: Wed, 16 Sep 2009 20:10:26 +0900 (JST)
Message-ID: <20090916.201026.71092560.ryov@valinux.co.jp>
References: <20090903131146.GA12041@redhat.com>
	<20090904.101222.226781140.ryov@valinux.co.jp>
	<20090915214032.GB3711@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090915214032.GB3711@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vgoyal@redhat.com
Cc: dhaval@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Ryo,
> 
> I am running a sequential reader in one group and few random reader and
> writers in second group. Both groups are of same weight. I ran fio scripts
> for 60 seconds and then looked at the output. In this case looks like we just
> kill the throughput of sequential reader and disk (because random
> readers/writers take over).

Thank you for testing dm-ioband. 

I ran your script on my environment, and here are the results.

                        Throughput  [KiB/s]
              vanilla     dm-ioband            dm-ioband   
                       (io-throttle = 4)  (io-throttle = 50)
  randread      312           392                 368
  randwrite      11            12                  10
  seqread      4341           651                1599

I ran the script on dm-ioband under two conditions, one is that the
io-throttle options is set to 4, and the other is set to 50. When
there are some in-flight IO requests in the group and those numbers
exceed io-throttle, then dm-ioband gives priority to the group and the
group can issue subsequent IO requests in preference to the other
groups. 50 io-throttle means that it cancels this mechanism, so the
seq-read got more bandwidth than 4 io-throttle.

I tried to test with 2.6.31-rc7 and io-controller v9, but unfortunately,
a kernel panic happened. I'll try to test with your io-controller
again later.
 
> with io scheduler based io controller, we see increased throughput for
> seqential reader as compared to CFQ, because now random readers are
> running in a separate group and hence reader gets isolation from random
> readers.

I summarized your results in a tabular format.

                   Throughput [KiB/s]
             vanilla io-controller  dm-ioband
randread        257        161          314
randwrite        11         45           15
seqread        5598       9556          631

On the result of io-controller, the throughput of seqread was
increased but randread was decreased against vanilla. Did it perform as
you expected? Was disktime consumed equally on each group according to
the weight settings? Could you tell me your opinion what an
io-controller should do when this kind of workload is applied?

Thanks,
Ryo Tsuruta
