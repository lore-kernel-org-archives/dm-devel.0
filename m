From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: Re: [RFC][PATCH 0/10] I/O context inheritance
Date: Wed, 23 Apr 2008 12:27:20 +0900 (JST)
Message-ID: <20080423.122720.110761879.taka@valinux.co.jp>
References: <20080422.230318.112756414.taka@valinux.co.jp>
	<20080422145418.GL12774@kernel.dk>
	<e9c3a7c20804221110y1968dfb3q27b86c9a7480ad1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e9c3a7c20804221110y1968dfb3q27b86c9a7480ad1@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dan.j.williams@intel.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@sourceware.org
List-Id: dm-devel.ids

Hi,

> > On Tue, Apr 22 2008, Hirokazu Takahashi wrote:
> >  > Hi,
> >  >
> >  > Sorry, these patches are for linux-2.6.25.
> >  >
> >  > > This series of patches make the block I/O layer and the I/O schedulers
> >  > > be able to determine the right io_context of every I/O.
> >  > >
> >  > > The current implementation of the block I/O layer and the I/O schedulers
> >  > > assume that the current process is the one which issued the given I/O,
> >  > > then use the io_context of this process to control the I/O.
> >  > > But this assumption isn't quite right because several kernel threads
> >  > > will handle I/O requests on behalf of the processes which originated them.
> >  > > This often happens when you want to use device mapper modules.
> >  > >
> >  > > The patches make every bio has a pointer to an io_context, which will
> >  > > be set when it is allocated or cloned. So it makes it possible to find
> >  > > the right io_context from any bio at any place.
> >  > >
> >  > > I'm waiting for your comments.
> >
> >  Can you give a brief summary of what you need this stuff for?
> >
> 
> I am not sure if this the intended application, but I have been
> looking at supporting ionice over software-raid and this series seems
> like a necessary first step.

Yes, the intention is to make ionice be able to work correctly over
device mapper modules such as software-raid and the multipath driver.
This mechanism is needed since quite a few device mapper modules have
kernel threads, including workqueues, handle I/O requests.

And I also have a plan to use this new feature for block I/O bandwidth
control based on cgroup with some enhancement. With this feature, we
can also trace the iocontext of the process or cgroup which made
a certain page dirtied.


Thank you,
Hirokazu Takahashi.
