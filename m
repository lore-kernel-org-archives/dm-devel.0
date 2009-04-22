From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Wed, 22 Apr 2009 11:18:06 -0400
Message-ID: <20090422151805.GC32602@redhat.com>
References: <20090421.211051.183023683.ryov@valinux.co.jp>
	<20090421135723.GA13953@redhat.com>
	<20090421141607.GA22619@redhat.com>
	<20090422.121443.104042516.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090422.121443.104042516.ryov@valinux.co.jp>
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
Cc: fernando@oss.ntt.co.jp, dm-devel@redhat.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, agk@redhat.com, jens.axboe@oracle.com, nauman@google.com, vgoyal@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Tue, Apr 21 2009 at 11:14pm -0400,
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> Hi,
> 
> From: Vivek Goyal <vgoyal@redhat.com>
> Subject: [dm-devel] Re: dm-ioband: Test results.
> Date: Tue, 21 Apr 2009 10:16:07 -0400
> 
> > On Tue, Apr 21, 2009 at 09:57:23AM -0400, Mike Snitzer wrote:
> > > On Tue, Apr 21 2009 at  8:10am -0400,
> > > Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> > > 
> > > > Hi Nauman,
> > > > 
> > > > > > The real question is, once you create a version of dm-ioband that
> > > > > > co-operates with CFQ scheduler, how that solution would compare with
> > > > > > the patch set Vivek has posted? In my opinion, we need to converge to
> > > > > > one solution as soon as possible, so that we can work on it together
> > > > > > to refine and test it.
> > > > > 
> > > > > I think I can do some help for your work. but I want to continue the
> > > > > development of dm-ioband, because dm-ioband actually works well and
> > > > > I think it has some advantages against other IO controllers.
> > > > >   - It can use without cgroup.
> > > > >   - It can control bandwidth on a per partition basis.
> > > > >   - The driver module can be replaced without stopping the system.
> > > > 
> > > > In addition, dm-ioband can run on the RHEL5.
> > > 
> > > RHEL5 compatibility does not matter relative to merging an I/O bandwidth
> > > controller upstream.  So both the "can [be] use without cgroup" and "can
> > > run on RHEL5" features do not help your cause of getting dm-ioband
> > > merged upstream.  In fact these features serve as distractions.
> >
> > Exactly. I don't think that "it can be used without cgroup" is a feature
> > or advantage. To me it is a disadvantage and should be fixed. cgroup is
> > standard mechanism to group tasks arbitrarily and we should use that to make
> > things working instead of coming up with own ways of grouping things and
> > terming it as advantage.
> > 
> > What do you mean by "The driver module can be replaced without stopping
> > the system"? I guess you mean that one does not have to reboot the system
> > to remove ioband device? So if one decides to not use the cgroup, then
> > one shall have to remove the ioband devices, remount the filesystems and
> > restart the application?
> 
> Device-mapper has a feature that can replace an intermediate module
> without unmount the device like the following.
> 
>       ---------------------        ---------------------
>      |         /mnt        |      |        /mnt         |
>      |---------------------|      |---------------------|
>      | /dev/mapper/ioband1 |      | /dev/mapper/ioband1 |
>      |---------------------|      |---------------------|
>      |      dm-ioband      | <==> |      dm-linear      |
>      |---------------------|      |---------------------|
>      |      /dev/sda1      |      |      /dev/sda1      |
>       ---------------------        ---------------------
> 
> So we can safely unload the dm-ioband module and update it.
> 
> > With cgroup approach, if one does not want things to be classified, a user
> > can simply move all the tasks to root group and things will be fine. No
> > remounting, no application stopping etc. So this also does not look like
> > an advantage instead sounds like an disadvantage.
> > 
> > Thanks
> > Vivek

Ryo,

Why is it that you repeatedly ignore concern/discussion about your
determination to continue using a custom grouping mechanism?  It is this
type of excess layering that serves no purpose other than to facilitate
out-of-tree use-cases.  dm-ioband would take a big step closer to being
merged upstream if you took others' feedback and showed more willingness
to work through the outstanding issues.

Mike
