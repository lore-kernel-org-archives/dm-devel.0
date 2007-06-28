From: "Trantow, Wayne D" <wayne.d.trantow@intel.com>
Subject: RE: RAID1 Recovery
Date: Wed, 27 Jun 2007 17:31:35 -0700
Message-ID: <4AFE4AEEFA305C4BB82F73F4D819506001DD83A5@orsmsx420.amr.corp.intel.com>
References: <20070627234539.GA25276@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-reply-to: <20070627234539.GA25276@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

>-----Original Message-----
>From: malahal@us.ibm.com [mailto:malahal@us.ibm.com]
>Sent: Wednesday, June 27, 2007 4:46 PM
>To: Trantow, Wayne D
>Cc: dm-devel@redhat.com
>Subject: Re: [dm-devel] RAID1 Recovery
>
>Trantow, Wayne D [wayne.d.trantow@intel.com] wrote:
>> Hello,
>> I am studying the dmraid-1.0.0.rc14, device-mapper_CVS Latest, and
>> Fedora 6 (2.6.18-1.2798) kernel dmraid code to understand the
recovery
>> logic for a RAID1 set.  The usage scenario is where one disk in a
mirror
>> dies, the user swaps in a clean disk and then invokes dmraid app to
>> copy/sync data to the new disk.
>>
>> Within this context I have a couple questions:
>>
>> - In kernel space, it looks like a recovery operation (RH_RECOVERING)
>> will take place if the mirror_target.resume (mirror_resume) handler
is
>> called.  In user space, in dmraid/reconfig.c add_dev_to_set() func
sets
>> up handler add_dev_to_raid1() which should start the recovery.
However,
>> as far as I can see, add_dev_to_set is not wired in to the rest of
the
>> dmraid code (i.e., nothing calls it).  What was the intent here?
>>
>> - If you follow the call chain from add_dev_to_raid1 into
device-mapper
>> it sets up a 'resume' call via an DM_DEV_RESUME ioctl dm_task,
however,
>> in the device-mapper _cmd_data_v4 struct (in libdm-iface.c) the
'resume'
>> handler func is associated with the DM_DEV_SUSPEND ioctl not
>> DM_DEV_RESUME. Hence, even if you invoked add_dev_to_raid1, a direct
>> ioctl call to the kernel mirror_target.resume func is not possible.
>> this a bug or intentional? Or am I not seeing it correctly?
>
>Quick glance indicates that resume and suspend, they both, seem to use
>suspend ioctl command.  DM_SUSPEND_FLAG is used to take the suspend
>operation, otherwise resume operation is done. See dev_suspend() in
>drivers/md/dm-ioctl.c

Yes.  At this point only __dev_status() in dm-ioctl sets the
DM_SUSPEND_FLAG. So it seems that most calls to dev_suspend in the
kernel are really doing a do_resume(). But the confusing part is that,
in user space, the add_dev_to_raid1() calls reload_subset() which calls
dm_suspend, followed by dm_resume. So, we are probably actually getting
the dm_suspend call eventuating in a 'do_resume' call (in the kernel)
followed by the dm_resume call which gets dropped on the floor in
device-mapper (because DM_DEV_RESUME is not mapped into the _cmd_data_v4
table). =20

Are there any docs that explain how to setup a debug environment where I
can trace the execution path from user space, i.e., from
add_dev_to_raid1(), down into kernel space via device-mapper to see how
it actually works?=20

SkipT.
