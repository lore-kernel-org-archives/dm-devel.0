From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Wed, 15 Apr 2009 00:37:59 -0400
Message-ID: <20090415043759.GA8349@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090413.130552.226792299.ryov@valinux.co.jp>
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
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>, linux-kernel@vger.kernel.org, Moyer Jeff Moyer <jmoyer@redhat.com>, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Nauman Rafique <nauman@google.com>, agk@redhat.com, Balbir Singh <balbir@linux.vnet.ibm.com>
List-Id: dm-devel.ids

On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> Hi Alasdair and all,
> 
> I did more tests on dm-ioband and I've posted the test items and
> results on my website. The results are very good.
> http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> 
> I hope someone will test dm-ioband and report back to the dm-devel
> mailing list.
> 

Hi Ryo,

I have been able to take your patch for 2.6.30-rc1 kernel and started
doing some testing for reads. Hopefully you will provide bio-cgroup
patches soon so that I can do some write testing also.

In the beginning of the mail, i am listing some basic test results and
in later part of mail I am raising some of my concerns with this patchset.

My test setup:
--------------
I have got one SATA driver with two partitions /dev/sdd1 and /dev/sdd2 on
that. I have created ext3 file systems on these partitions. Created one
ioband device "ioband1" with weight 40 on /dev/sdd1 and another ioband
device "ioband2" with weight 10 on /dev/sdd2.
  
1) I think an RT task with-in a group does not get its fair share (all
  the BW available as long as RT task is backlogged). 

  I launched one RT read task of 2G file in ioband1 group and in parallel
  launched more readers in ioband1 group. ioband2 group did not have any
  io going. Following are results with and without ioband.

  A) 1 RT prio 0 + 1 BE prio 4 reader

	dm-ioband
	2147483648 bytes (2.1 GB) copied, 39.4701 s, 54.4 MB/s
	2147483648 bytes (2.1 GB) copied, 71.8034 s, 29.9 MB/s

	without-dm-ioband
	2147483648 bytes (2.1 GB) copied, 35.3677 s, 60.7 MB/s
	2147483648 bytes (2.1 GB) copied, 70.8214 s, 30.3 MB/s

  B) 1 RT prio 0 + 2 BE prio 4 reader

	dm-ioband
	2147483648 bytes (2.1 GB) copied, 43.8305 s, 49.0 MB/s
	2147483648 bytes (2.1 GB) copied, 135.395 s, 15.9 MB/s
	2147483648 bytes (2.1 GB) copied, 136.545 s, 15.7 MB/s

	without-dm-ioband
	2147483648 bytes (2.1 GB) copied, 35.3177 s, 60.8 MB/s
	2147483648 bytes (2.1 GB) copied, 124.793 s, 17.2 MB/s
	2147483648 bytes (2.1 GB) copied, 126.267 s, 17.0 MB/s

  C) 1 RT prio 0 + 3 BE prio 4 reader

	dm-ioband
	2147483648 bytes (2.1 GB) copied, 48.8159 s, 44.0 MB/s
	2147483648 bytes (2.1 GB) copied, 185.848 s, 11.6 MB/s
	2147483648 bytes (2.1 GB) copied, 188.171 s, 11.4 MB/s
	2147483648 bytes (2.1 GB) copied, 189.537 s, 11.3 MB/s

	without-dm-ioband
	2147483648 bytes (2.1 GB) copied, 35.2928 s, 60.8 MB/s
	2147483648 bytes (2.1 GB) copied, 169.929 s, 12.6 MB/s
	2147483648 bytes (2.1 GB) copied, 172.486 s, 12.5 MB/s
	2147483648 bytes (2.1 GB) copied, 172.817 s, 12.4 MB/s

  C) 1 RT prio 0 + 3 BE prio 4 reader
	dm-ioband
	2147483648 bytes (2.1 GB) copied, 51.4279 s, 41.8 MB/s
	2147483648 bytes (2.1 GB) copied, 260.29 s, 8.3 MB/s
	2147483648 bytes (2.1 GB) copied, 261.824 s, 8.2 MB/s
	2147483648 bytes (2.1 GB) copied, 261.981 s, 8.2 MB/s
	2147483648 bytes (2.1 GB) copied, 262.372 s, 8.2 MB/s

	without-dm-ioband
	2147483648 bytes (2.1 GB) copied, 35.4213 s, 60.6 MB/s
	2147483648 bytes (2.1 GB) copied, 215.784 s, 10.0 MB/s
	2147483648 bytes (2.1 GB) copied, 218.706 s, 9.8 MB/s
	2147483648 bytes (2.1 GB) copied, 220.12 s, 9.8 MB/s
	2147483648 bytes (2.1 GB) copied, 220.57 s, 9.7 MB/s

Notice that with dm-ioband as number of readers are increasing, finish
time of RT tasks is also increasing. But without dm-ioband finish time
of RT tasks remains more or less constat even with increase in number
of readers.

For some reason overall throughput also seems to be less with dm-ioband.
Because ioband2 is not doing any IO, i expected that tasks in ioband1
will get full disk BW and throughput will not drop.

I have not debugged it but I guess it might be coming from the fact that
there are no separate queues for RT tasks. bios from all the tasks can be
buffered on a single queue in a cgroup and that might be causing RT
request to hide behind BE tasks' request?

General thoughts about dm-ioband
================================
- Implementing control at second level has the advantage tha one does not
  have to muck with IO scheduler code. But then it also has the
  disadvantage that there is no communication with IO scheduler.

- dm-ioband is buffering bio at higher layer and then doing FIFO release
  of these bios. This FIFO release can lead to priority inversion problems
  in certain cases where RT requests are way behind BE requests or 
  reader starvation where reader bios are getting hidden behind writer
  bios etc. These are hard to notice issues in user space. I guess above
  RT results do highlight the RT task problems. I am still working on
  other test cases and see if i can show the probelm.

- dm-ioband does this extra grouping logic using dm messages. Why
  cgroup infrastructure is not sufficient to meet your needs like
  grouping tasks based on uid etc? I think we should get rid of all
  the extra grouping logic and just use cgroup for grouping information.

- Why do we need to specify bio cgroup ids to the dm-ioband externally with
  the help of dm messages? A user should be able to just create the
  cgroups, put the tasks in right cgroup and then everything should
  just work fine.

- Why do we have to put another dm-ioband device on top of every partition
  or existing device mapper device to control it? Is it possible to do
  this control on make_request function of the reuqest queue so that
  we don't end up creating additional dm devices? I had posted the crude
  RFC patch as proof of concept but did not continue the development 
  because of fundamental issue of FIFO release of buffered bios.

	http://lkml.org/lkml/2008/11/6/227 

  Can you please have a look and provide feedback about why we can not
  go in the direction of the above patches and why do we need to create
  additional dm device.

  I think in current form, dm-ioband is hard to configure and we should
  look for ways simplify configuration.

- I personally think that even group IO scheduling should be done at
  IO scheduler level and we should not break down IO scheduling in two
  parts where group scheduling is done by higher level IO scheduler 
  sitting in dm layer and io scheduling among tasks with-in groups is
  done by actual IO scheduler.

  But this also means more work as one has to muck around with core IO
  scheduler's to make them cgroup aware and also make sure existing
  functionality is not broken. I posted the patches here.

	http://lkml.org/lkml/2009/3/11/486

  Can you please let us know that why does IO scheduler based approach
  does not work for you? 

  Jens, it would be nice to hear your opinion about two level vs one
  level conrol. Do you think that common layer approach is the way
  to go where one can control things more tightly or FIFO release of bios
  from second level controller is fine and we can live with this additional       serialization in the layer above just above IO scheduler?

- There is no notion of RT cgroups. So even if one wants to run an RT
  task in root cgroup to make sure to get full access of disk, it can't
  do that. It has to share the BW with other competing groups. 

- dm-ioband controls amount of IO done per second. Will a seeky process
  not run away more disk time? 

  Additionally, at group level we will provide fairness in terms of amount
  of IO (number of blocks transferred etc) and with-in group cfq will try
  to provide fairness in terms of disk access time slices. I don't even
  know whether it is a matter of concern or not. I was thinking that
  probably one uniform policy on the hierarchical scheduling tree would
  have probably been better. Just thinking loud.....

Thanks
Vivek
 
> Alasdair, could you please merge dm-ioband into upstream? Or could
> you please tell me why dm-ioband can't be merged?
> 
> Thanks,
> Ryo Tsuruta
> 
> To know the details of dm-ioband:
> http://people.valinux.co.jp/~ryov/dm-ioband/
> 
> RPM packages for RHEL5 and CentOS5 are available:
> http://people.valinux.co.jp/~ryov/dm-ioband/binary.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
