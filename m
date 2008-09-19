From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband + bio-cgroup benchmarks
Date: Fri, 19 Sep 2008 09:12:04 -0400
Message-ID: <20080919131204.GB3606@redhat.com>
References: <20080918.210418.226794540.ryov@valinux.co.jp> <20080918131554.GB20640@redhat.com> <20080919.151221.49666828.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753895AbYISNUi@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080919.151221.49666828.taka@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: ryov@valinux.co.jp, linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org, righi.andrea@gmail.com, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Fri, Sep 19, 2008 at 03:12:21PM +0900, Hirokazu Takahashi wrote:
> Hi,
> 
> > > Hi All,
> > > 
> > > I have got excellent results of dm-ioband, that controls the disk I/O
> > > bandwidth even when it accepts delayed write requests.
> > > 
> > > In this time, I ran some benchmarks with a high-end storage. The
> > > reason was to avoid a performance bottleneck due to mechanical factors
> > > such as seek time.
> > > 
> > > You can see the details of the benchmarks at:
> > > http://people.valinux.co.jp/~ryov/dm-ioband/hps/
> > > 
> > 
> > Hi Ryo,
> > 
> > I had a query about dm-ioband patches. IIUC, dm-ioband patches will break
> > the notion of process priority in CFQ because now dm-ioband device will
> > hold the bio and issue these to lower layers later based on which bio's
> > become ready. Hence actual bio submitting context might be different and
> > because cfq derives the io_context from current task, it will be broken.
> 
> This is completely another problem we have to solve.
> The CFQ scheduler has really bad assumption that the current process
> must be the owner. This problem occurs when you use some of device
> mapper devices or use linux aio.
> 
> > To mitigate that problem, we probably need to implement Fernando's
> > suggestion of putting io_context pointer in bio. 
> > 
> > Have you already done something to solve this issue?
> 
> Actually, I already have a patch to solve this problem, which make
> each bio have a pointer to the io_context of the owner process.
> Would you take a look at the thread whose subject is "I/O context
> inheritance" in:
> http://www.uwsg.iu.edu/hypermail/linux/kernel/0804.2/index.html#2850
> 
> Fernando also knows this.

Great. Sure I will have a look at this thread. This is something we shall
have to implement, irrespective of the fact whether we go for dm-ioband
approach or an rb-tree per request queue approach.

Thanks
Vivek
