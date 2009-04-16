From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
Date: Thu, 16 Apr 2009 11:47:50 +0900 (JST)
Message-ID: <20090416.114750.226794985.ryov@valinux.co.jp>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	<20090415043759.GA8349@redhat.com>
	<20090415.223832.71125857.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753946AbZDPCsE@vger.kernel.org>
In-Reply-To: <20090415.223832.71125857.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek, 

> General thoughts about dm-ioband
> ================================
> - Implementing control at second level has the advantage tha one does not
>   have to muck with IO scheduler code. But then it also has the
>   disadvantage that there is no communication with IO scheduler.
> 
> - dm-ioband is buffering bio at higher layer and then doing FIFO release
>   of these bios. This FIFO release can lead to priority inversion problems
>   in certain cases where RT requests are way behind BE requests or 
>   reader starvation where reader bios are getting hidden behind writer
>   bios etc. These are hard to notice issues in user space. I guess above
>   RT results do highlight the RT task problems. I am still working on
>   other test cases and see if i can show the probelm.
>
> - dm-ioband does this extra grouping logic using dm messages. Why
>   cgroup infrastructure is not sufficient to meet your needs like
>   grouping tasks based on uid etc? I think we should get rid of all
>   the extra grouping logic and just use cgroup for grouping information.

I want to use dm-ioband even without cgroup and to make dm-ioband has
flexibility to support various type of objects.
 
> - Why do we need to specify bio cgroup ids to the dm-ioband externally with
>   the help of dm messages? A user should be able to just create the
>   cgroups, put the tasks in right cgroup and then everything should
>   just work fine.

This is because to handle cgroup on dm-ioband easily and it keeps the
code simple.

> - Why do we have to put another dm-ioband device on top of every partition
>   or existing device mapper device to control it? Is it possible to do
>   this control on make_request function of the reuqest queue so that
>   we don't end up creating additional dm devices? I had posted the crude
>   RFC patch as proof of concept but did not continue the development 
>   because of fundamental issue of FIFO release of buffered bios.
> 
> 	http://lkml.org/lkml/2008/11/6/227 
> 
>   Can you please have a look and provide feedback about why we can not
>   go in the direction of the above patches and why do we need to create
>   additional dm device.
> 
>   I think in current form, dm-ioband is hard to configure and we should
>   look for ways simplify configuration.

This can be solved by using a tool or a small script.

> - I personally think that even group IO scheduling should be done at
>   IO scheduler level and we should not break down IO scheduling in two
>   parts where group scheduling is done by higher level IO scheduler 
>   sitting in dm layer and io scheduling among tasks with-in groups is
>   done by actual IO scheduler.
> 
>   But this also means more work as one has to muck around with core IO
>   scheduler's to make them cgroup aware and also make sure existing
>   functionality is not broken. I posted the patches here.
> 
> 	http://lkml.org/lkml/2009/3/11/486
> 
>   Can you please let us know that why does IO scheduler based approach
>   does not work for you? 

I think your approach is not bad, but I've made it my purpose to
control disk bandwidth of virtual machines by device-mapper and
dm-ioband. 
I think device-mapper is a well designed system for the following
reasons:
 - It can easily add new functions to a block device.
 - No need to muck around with the existing kernel code.
 - dm-devices are detachable. It doesn't make any effects on the
   system if a user doesn't use it.
So I think dm-ioband and your IO controller can coexist. What do you
think about it?
 
>   Jens, it would be nice to hear your opinion about two level vs one
>   level conrol. Do you think that common layer approach is the way
>   to go where one can control things more tightly or FIFO release of bios
>   from second level controller is fine and we can live with this additional       serialization in the layer above just above IO scheduler?
>
> - There is no notion of RT cgroups. So even if one wants to run an RT
>   task in root cgroup to make sure to get full access of disk, it can't
>   do that. It has to share the BW with other competing groups. 
>
> - dm-ioband controls amount of IO done per second. Will a seeky process
>   not run away more disk time? 

Could you elaborate on this? dm-ioband doesn't control it per second.

>   Additionally, at group level we will provide fairness in terms of amount
>   of IO (number of blocks transferred etc) and with-in group cfq will try
>   to provide fairness in terms of disk access time slices. I don't even
>   know whether it is a matter of concern or not. I was thinking that
>   probably one uniform policy on the hierarchical scheduling tree would
>   have probably been better. Just thinking loud.....
> 
> Thanks
> Vivek

Thanks,
Ryo Tsuruta
