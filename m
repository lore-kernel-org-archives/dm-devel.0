From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 8 Sep 2009 13:54:00 -0400
Message-ID: <20090908175400.GE15974@redhat.com>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908134244.GA15974@redhat.com>
	<e98e18940909080930o40008d5dnc823db96687654af@mail.gmail.com>
	<4AA68AA5.10505@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AA68AA5.10505@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Rik van Riel <riel@redhat.com>
Cc: guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, Nauman Rafique <nauman@google.com>, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Tue, Sep 08, 2009 at 12:47:33PM -0400, Rik van Riel wrote:
> Nauman Rafique wrote:
>
>> I think this is probably the key deal breaker. dm-ioband has no
>> mechanism to anticipate or idle for a reader task. Without such a
>> mechanism, a proportional division scheme cannot work for tasks doing
>> reads. 
>
> That is a really big issue, since most reads tend to be synchronous
> (the application is waiting for the read), while many writes are not
> (the application is doing something else while the data is written).
>
> Having writes take precedence over reads will really screw over the
> readers, while not benefitting the writers all that much.
>

I ran a test to show how readers can be starved in certain cases. I launched
one reader and three writers. I ran this test twice. First without dm-ioband
and then with dm-ioband.

Following are few lines from the script to launch readers and writers.

**************************************************************
sync
echo 3 > /proc/sys/vm/drop_caches

# Launch writers on sdd2
dd if=/dev/zero of=/mnt/sdd2/writezerofile1 bs=4K count=262144 &

# Launch  writers on sdd1
dd if=/dev/zero of=/mnt/sdd1/writezerofile1 bs=4K count=262144 &
dd if=/dev/zero of=/mnt/sdd1/writezerofile2 bs=4K count=262144 &

echo "sleeping for 5 seconds"
sleep 5

# launch reader on sdd1
time dd if=/mnt/sdd1/testzerofile1 of=/dev/zero &
echo "launched reader $!"
*********************************************************************

Without dm-ioband, reader finished in roughly 5 seconds.

289533952 bytes (290 MB) copied, 5.16765 s, 56.0 MB/s
real	0m5.300s
user	0m0.098s
sys	0m0.492s

With dm-ioband, reader took, more than 2 minutes to finish.

289533952 bytes (290 MB) copied, 122.386 s, 2.4 MB/s

real	2m2.569s
user	0m0.107s
sys	0m0.548s

I had created ioband1 on /dev/sdd1 and ioband2 on /dev/sdd2 with weights
200 and 100 respectively.

Thanks
Vivek
