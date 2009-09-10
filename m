From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Thu, 10 Sep 2009 09:25:03 -0400
Message-ID: <20090910132503.GA29559@redhat.com>
References: <20090908134244.GA15974@redhat.com>
	<20090909.190146.59669568.ryov@valinux.co.jp>
	<20090909143159.GC8256@redhat.com>
	<20090910.124547.71116284.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090910.124547.71116284.ryov@valinux.co.jp>
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
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Thu, Sep 10, 2009 at 12:45:47PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > > In addition,
> > > there are devices which doesn't use standard IO schedulers, and
> > > dm-ioband can work on even such devices.
> > 
> > This is a interesting use case. Few thoughts.
> > 
> > - Can't io scheduling mechanism of these devices make use of elevator and
> >   elevator fair queuing interfaces to take advantage of io controlling
> >   mechanism. It should not be too difficult. Look at noop. It has
> >   just 131 lines of code and it now supports hierarchical io scheduling.
> >  
> >   This will come with request queue and its merging and plug/unplug
> >   mechanism. Is that an issue?
> >
> > - If not, then yes, for these corner cases, io scheduler based controller
> >   does not work as it is.
> 
> I have a extreme fast SSD and its device driver provides its own
> make_request_fn(). So the device driver intercepts IO requests and the
> subsequent processes are done within it.

IMHO, in those cases these SSD driver needs to hook into block layer's request
queue mechanism if they need io controlling mechanism instead of we coming
up a device mapper module.

Think of it that if somebody needs CFQ like tasks classes and prio
suported on these devices, should we also come up with another device
mapper module "dm-cfq"?

Jens, I am wondering if similiar concerns have popped in the past also for
CFQ also? Somebody asking to support task prio and classes on devices which
don't use standard IO scheduler?

Thanks
Vivek
