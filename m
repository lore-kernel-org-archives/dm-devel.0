From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [mdadm PATCH 4/4] Create: tell udev device is not ready when
 first created.
Date: Wed, 26 Apr 2017 12:19:15 +0200
Message-ID: <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mvbasqx6.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 04/20/2017 11:35 PM, NeilBrown wrote:
> On Thu, Apr 20 2017, Jes Sorensen wrote:
...
>> Second, isn't this going to be racey if you have multiple arrays 
>> running? I am wondering if we cannot find a solution that relies on a 
>> permanently installed udev rule that we enable/disable with systemctl 
>> and use the device name as an argument?
> 
> There would only be a problematic race of an array as being created at
> the same time that another array is being assembled.  Is that at all
> likely?  They tend to happen at different parts of the usage cycle...  I
> guess we shouldn't assume though.
> 
> I admit that blocking *all* arrays was a short cut.  We need to create
> the udev rule before the new device is first activated, and keep it in
> existence until after the array has been started and the fd on /dev/mdXX
> has been closed - and then a bit more because udev doesn't respond
> instantly.
> In some cases we don't know the name of the md device until
> create_mddev() chooses on with find_free_devnum().
> So if we want to block udev from handling a device, we need to put the
> block into effect (e.g. create the rules.d file) in mddev_create() just
> before the call to open_dev_excl().
> 
> If we wanted an more permanent udev rule, we would need to record the
> devices that should be ignored in the filesystem somewhere else.
> Maybe in /run/mdadm.
> e.g.
> 
>  KERNEL=="md*", TEST="/run/mdadm/creating-$kernel", ENV{SYSTEMD_READY}="0"
> 
> Then we could have something like the following (untested) in mdadm.
> Does that seem more suitable?
> 

Yes, please, if possible, go for a permanent udev rule surely - this
will make it much easier for other foreign tools to hook in properly if
needed and it would also be much easier to debug.

But, wouldn't it be better if we could just pass this information ("not
initialized yet") as RUN_ARRAY md ioctl parameter? In that case the md
driver in kernel could add the variable to the uevent it generates which
userspace udev rules could check for easily. This way, we don't need to
hassle with creating files in filesystem and the information would be
directly a part of the uevent the md kernel driver generates (so
directly accessible in udev rules too). Also, possibly adding more
variables for other future scenarios if needed.

We use something similar in device-mapper already where we pass flags
(besides other things) as a device-mapper ioctl parameter which then
gets into the uevent as DM_COOKIE uevent variable (which in turn the
udev rules can decode into individual flags). This method proved to be
working well for us to solve the problem of uninitialized data area so
we don't get into trouble with scans from udev (see also dm_ioctl
structure in usr/include/linux/dm-ioctl.h and the dm_kobject_uevent
function in drivers/md/dm.c for the kernel part; in udev rules the flags
are then various DM_UDEV_* variables we check for)

-- 
Peter
