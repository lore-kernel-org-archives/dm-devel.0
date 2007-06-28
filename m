From: malahal@us.ibm.com
Subject: Re: RAID1 Recovery
Date: Wed, 27 Jun 2007 19:09:31 -0700
Message-ID: <20070628020931.GA26378@us.ibm.com>
References: <20070627234539.GA25276@us.ibm.com>
	<4AFE4AEEFA305C4BB82F73F4D819506001DD83A5@orsmsx420.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AFE4AEEFA305C4BB82F73F4D819506001DD83A5@orsmsx420.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Trantow, Wayne D" <wayne.d.trantow@intel.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Trantow, Wayne D [wayne.d.trantow@intel.com] wrote:
> >Quick glance indicates that resume and suspend, they both, seem to use
> >suspend ioctl command.  DM_SUSPEND_FLAG is used to take the suspend
> >operation, otherwise resume operation is done. See dev_suspend() in
> >drivers/md/dm-ioctl.c
> 
> Yes.  At this point only __dev_status() in dm-ioctl sets the
> DM_SUSPEND_FLAG. So it seems that most calls to dev_suspend in the
> kernel are really doing a do_resume(). But the confusing part is that,
> in user space, the add_dev_to_raid1() calls reload_subset() which calls
> dm_suspend, followed by dm_resume. So, we are probably actually getting
> the dm_suspend call eventuating in a 'do_resume' call (in the kernel)
> followed by the dm_resume call which gets dropped on the floor in
> device-mapper (because DM_DEV_RESUME is not mapped into the _cmd_data_v4
> table).  
> 
> Are there any docs that explain how to setup a debug environment where I
> can trace the execution path from user space, i.e., from
> add_dev_to_raid1(), down into kernel space via device-mapper to see how
> it actually works? 
> 
> SkipT.

I don't know anything about add_dev_to_raid1() (don't have dmraid1 code
with me) but DM_SUSPEND_FLAG is set by the user level code in
lib/ioctl/libdm-iface.c
