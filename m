From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 25 Sep 2009 16:26:36 -0400
Message-ID: <20090925202636.GC15007@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	<4ABC28DE.7050809@datenparkplatz.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4ABC28DE.7050809@datenparkplatz.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Sep 25, 2009 at 04:20:14AM +0200, Ulrich Lukas wrote:
> Vivek Goyal wrote:
> > Notes:
> > - With vanilla CFQ, random writers can overwhelm a random reader.
> >   Bring down its throughput and bump up latencies significantly.
> 
> 
> IIRC, with vanilla CFQ, sequential writing can overwhelm random readers,
> too.
> 
> I'm basing this assumption on the observations I made on both OpenSuse
> 11.1 and Ubuntu 9.10 alpha6 which I described in my posting on LKML
> titled: "Poor desktop responsiveness with background I/O-operations" of
> 2009-09-20.
> (Message ID: 4AB59CBB.8090907@datenparkplatz.de)
> 
> 
> Thus, I'm posting this to show that your work is greatly appreciated,
> given the rather disappointig status quo of Linux's fairness when it
> comes to disk IO time.
> 
> I hope that your efforts lead to a change in performance of current
> userland applications, the sooner, the better.
> 
[Please don't remove people from original CC list. I am putting them back.]

Hi Ulrich,

I quicky went through that mail thread and I tried following on my
desktop.

##########################################
dd if=/home/vgoyal/4G-file of=/dev/null &
sleep 5
time firefox
# close firefox once gui pops up.
##########################################

It was taking close to 1 minute 30 seconds to launch firefox and dd got 
following.

4294967296 bytes (4.3 GB) copied, 100.602 s, 42.7 MB/s

(Results do vary across runs, especially if system is booted fresh. Don't
 know why...).


Then I tried putting both the applications in separate groups and assign
them weights 200 each.

##########################################
dd if=/home/vgoyal/4G-file of=/dev/null &
echo $! > /cgroup/io/test1/tasks
sleep 5
echo $$ > /cgroup/io/test2/tasks
time firefox
# close firefox once gui pops up.
##########################################

Now I firefox pops up in 27 seconds. So it cut down the time by 2/3.

4294967296 bytes (4.3 GB) copied, 84.6138 s, 50.8 MB/s

Notice that throughput of dd also improved.

I ran the block trace and noticed in many a cases firefox threads
immediately preempted the "dd". Probably because it was a file system
request. So in this case latency will arise from seek time.

In some other cases, threads had to wait for up to 100ms because dd was
not preempted. In this case latency will arise both from waiting on queue
as well as seek time.

With cgroup thing, We will run 100ms slice for the group in which firefox
is being launched and then give 100ms uninterrupted time slice to dd. So
it should cut down on number of seeks happening and that's why we probably
see this improvement.

So grouping can help in such cases. May be you can move your X session in
one group and launch the big IO in other group. Most likely you should
have better desktop experience without compromising on dd thread output.

Thanks
Vivek
