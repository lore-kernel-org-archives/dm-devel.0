From: Vivek Goyal <vgoyal@redhat.com>
Subject: ioband: Writer starves reader even without competitors
	(Re: Regarding dm-ioband tests)
Date: Tue, 15 Sep 2009 19:37:07 -0400
Message-ID: <20090915233706.GA3770@redhat.com>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908134244.GA15974@redhat.com>
	<e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
	<4AA68AA5.10505@redhat.com> <20090908175400.GE15974@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090908175400.GE15974@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: Rik Van Riel <riel@redhat.com>, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, Nauman Rafique <nauman@google.com>, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Tue, Sep 08, 2009 at 01:54:00PM -0400, Vivek Goyal wrote:

[..]
> I ran a test to show how readers can be starved in certain cases. I launched
> one reader and three writers. I ran this test twice. First without dm-ioband
> and then with dm-ioband.
> 
> Following are few lines from the script to launch readers and writers.
> 
> **************************************************************
> sync
> echo 3 > /proc/sys/vm/drop_caches
> 
> # Launch writers on sdd2
> dd if=/dev/zero of=/mnt/sdd2/writezerofile1 bs=4K count=262144 &
> 
> # Launch  writers on sdd1
> dd if=/dev/zero of=/mnt/sdd1/writezerofile1 bs=4K count=262144 &
> dd if=/dev/zero of=/mnt/sdd1/writezerofile2 bs=4K count=262144 &
> 
> echo "sleeping for 5 seconds"
> sleep 5
> 
> # launch reader on sdd1
> time dd if=/mnt/sdd1/testzerofile1 of=/dev/zero &
> echo "launched reader $!"
> *********************************************************************
> 
> Without dm-ioband, reader finished in roughly 5 seconds.
> 
> 289533952 bytes (290 MB) copied, 5.16765 s, 56.0 MB/s
> real	0m5.300s
> user	0m0.098s
> sys	0m0.492s
> 
> With dm-ioband, reader took, more than 2 minutes to finish.
> 
> 289533952 bytes (290 MB) copied, 122.386 s, 2.4 MB/s
> 
> real	2m2.569s
> user	0m0.107s
> sys	0m0.548s
> 
> I had created ioband1 on /dev/sdd1 and ioband2 on /dev/sdd2 with weights
> 200 and 100 respectively.

Hi Ryo,

I notice that with-in a single ioband device, a single writer starves the
reader even without any competitor groups being present.

I ran following two tests with and without dm-ioband devices

Test1
====
Try to use fio for a sequential reader job. First fio will lay out the
file and do write operation. While those writes are going on, try to do
ls on that partition and observe latency of ls operation.

with dm-ioband (ls test)
------------------------
# cd /mnt/sdd2
# time ls

real    0m9.483s
user    0m0.000s
sys     0m0.002s

without dm-ioband (ls test)
---------------------------
# cd /mnt/sdd2
# time ls

256M-file1  256M-file5  2G-file1  2G-file5    writefile1  writezerofile
256M-file2  256M-file6  2G-file2  files       writefile2
256M-file3  256M-file7  2G-file3  fio         writefile3
256M-file4  256M-file8  2G-file4  lost+found  writefile4

real    0m0.067s
user    0m0.000s
sys     0m0.002s

Notice the time simle "ls" operation took in two cases.


Test2
=====
Same case where fio is laying out a file and then try to read some small
files on that partition at the interval of 1 second.

small file read with dm-ioband
------------------------------
[root@chilli fairness-tests]# ./small-file-read.sh
file #   0, plain reading it took: 0.24 seconds
file #   1, plain reading it took: 13.40 seconds
file #   2, plain reading it took: 6.27 seconds
file #   3, plain reading it took: 13.84 seconds
file #   4, plain reading it took: 5.63 seconds


small file read with-out dm-ioband
==================================
[root@chilli fairness-tests]# ./small-file-read.sh
file #   0, plain reading it took: 0.04 seconds
file #   1, plain reading it took: 0.03 seconds
file #   2, plain reading it took: 0.04 seconds
file #   3, plain reading it took: 0.03 seconds
file #   4, plain reading it took: 0.03 seconds

Notice how small file read latencies have shot up.

Looks like a single writer is completely starving a reader even without
any IO going in any of the other groups.

setup
=====
I created an two ioband device of weight 100 each on partition /dev/sdd1
and /dev/sdd2 respectively. I am doing IO only on partition /dev/sdd2
(ioband2).

Following is fio job script.

[seqread]
runtime=60
rw=read
size=2G
directory=/mnt/sdd2/fio/
numjobs=1
group_reporting


Following is small file read script.

echo 3 > /proc/sys/vm/drop_caches

for ((i=0;i<5;i++)); do
        printf "file #%4d, plain reading it took: " $i
        /usr/bin/time -f "%e seconds"  cat /mnt/sdd2/files/$i >/dev/null
        sleep 1
done


Thanks
Vivek
