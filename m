From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 01/18] io-controller: Documentation
Date: Wed, 6 May 2009 09:31:50 -0400
Message-ID: <20090506133150.GB8180@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-2-git-send-email-vgoyal@redhat.com> <4A0100F4.4040400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759306AbZEFNeU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A0100F4.4040400@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Wed, May 06, 2009 at 11:16:04AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +	mount -t cgroup -o io,blkio none /cgroup
> > +
> > +- Create two cgroups
> > +	mkdir -p /cgroup/test1/ /cgroup/test2
> > +
> > +- Set weights of group test1 and test2
> > +	echo 1000 > /cgroup/test1/io.ioprio
> > +	echo 500 > /cgroup/test2/io.ioprio
> 
>   Here seems should be /cgroup/test2/io.weight
> 

Forgot to update these lines while switching from the notion of ioprio
to weight for the groups. Will do that next time.

Thanks
Vivek

> > +
> > +- Create two same size files (say 512MB each) on same disk (file1, file2) and
> > +  launch two dd threads in different cgroup to read those files. Make sure
> > +  right io scheduler is being used for the block device where files are
> > +  present (the one you compiled in hierarchical mode).
> > +
> > +	echo 1 > /proc/sys/vm/drop_caches
> > +
> > +	dd if=/mnt/lv0/zerofile1 of=/dev/null &
> > +	echo $! > /cgroup/test1/tasks
> > +	cat /cgroup/test1/tasks
> > +
> > +	dd if=/mnt/lv0/zerofile2 of=/dev/null &
> > +	echo $! > /cgroup/test2/tasks
> > +	cat /cgroup/test2/tasks
> > +
> > +- At macro level, first dd should finish first. To get more precise data, keep
> > +  on looking at (with the help of script), at io.disk_time and io.disk_sectors
> > +  files of both test1 and test2 groups. This will tell how much disk time
> > +  (in milli seconds), each group got and how many secotors each group
> > +  dispatched to the disk. We provide fairness in terms of disk time, so
> > +  ideally io.disk_time of cgroups should be in proportion to the weight.
> > +  (It is hard to achieve though :-)).
> 
> -- 
> Regards
> Gui Jianfeng
