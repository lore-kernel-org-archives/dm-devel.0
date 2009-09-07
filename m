From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Mon, 07 Sep 2009 15:40:53 +0800
Message-ID: <4AA4B905.8010801@cn.fujitsu.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi Vivek,

I happened to encount a bug when i test IO Controller V9.
When there are three tasks to run concurrently in three group,
that is, one is parent group, and other two tasks are running 
in two different child groups respectively to read or write 
files in some disk, say disk "hdb", The task may hang up, and 
other tasks which access into "hdb" will also hang up.

The bug only happens when using AS io scheduler.
The following scirpt can reproduce this bug in my box.

===========
#!/bin/sh

mkdir /cgroup
mount -t cgroup -o io,blkio io  /cgroup

echo anticipatory > /sys/block/hdb/queue/scheduler

mkdir /cgroup/test1
echo 100 > /cgroup/test1/io.weight

mkdir /cgroup/test2
echo 400 > /cgroup/test2/io.weight

mkdir /cgroup/test2/test3
echo 400 > /cgroup/test2/test3/io.weight

mkdir /cgroup/test2/test4
echo 400 > /cgroup/test2/test4/io.weight

#./rwio -r -f /hdb2/2000M.3 &
dd if=/hdb2/2000M.3 of=/dev/null &
pid4=$!
echo $pid4 > /cgroup/test2/test3/tasks
echo "pid4: $pid4"

#./rwio -r -f /hdb2/2000M.1 &
dd if=/hdb2/2000M.1 of=/dev/null &
pid1=$!
echo $pid1 > /cgroup/test1/tasks
echo "pid1 $pid1"

#./rwio -r -f /hdb2/2000M.2 &
dd if=/hdb2/2000M.2 of=/dev/null &
pid2=$!
echo $pid2 > /cgroup/test2/test4/tasks
echo "pid2 $pid2"

sleep 20

for ((;1;))
{
        ps -p $pid1 > /dev/null 2>&1
        if [ $? -ne 0 ]; then
                break
        fi

        kill -9 $pid1 > /dev/null 2>&1
}
for ((;1;))
{
        ps -p $pid2 > /dev/null 2>&1
        if [ $? -ne 0 ]; then
                break
        fi

        kill -9 $pid2 > /dev/null 2>&1
}


kill -9 $pid4 > /dev/null 2>&1

rmdir /cgroup/test2/test3
rmdir /cgroup/test2/test4
rmdir /cgroup/test2
rmdir /cgroup/test1

umount /cgroup
rmdir /cgroup
