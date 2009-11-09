From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH] a deadlock bug in the kernel-side device
	mapper code
Date: Mon, 9 Nov 2009 00:51:42 -0800
Message-ID: <20091109085142.GA4432@linux.vnet.ibm.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi
> 
> This is the patch that uses two locks to avoid the deadlock.

Thanks for doing the patch. 

I had previously started trying to address this issue using rcu and moving
dm_copy_name_and_uuid back to being called during dm_build_path_uevent, but
that patch still had a couple of cases to be addressed.

In testing your patch without moving where dm_copy_name_and_uuid is called
I run into a issue during test runs where I receive a BUG_ON for the
dm_put in dm_copy_name_and_uuid as DMF_FREEING was able to progress (Note:
this failure case occurs without your path). If the proper dm_get / dm_put
is added to the dm_uevent functions then there are cases where
dm_uevent_free becomes the last dm_put resulting in recursion.

It would be good since we are adding this synchronization if we selected a
synchronization type that could be called from dm_build_path_uevent (i.e.,
SOFTIRQ-safe) allowing the movement of the call to dm_copy_name_and_uuid
back to dm_build_path_uevent.

The test case below normally fails in about 5-10 minutes.

I am running the test case using a spinlock instead of the mutex and
moving dm_copy_name_and_uuid to being called from dm_build_path_uevent. It
has been running for a few hours now. I will continue to let it run.

Should we look to use a spinlock for this read access?

My test case just uses scsi debug to create a two path dm mpath device.

1.) modprobe scsi_debug vpd_use_hostno=0 add_host=2
2.) Then in one shell do a loop of "dmsetup remove" and multipath
3.) In another window do a loop of "dmsetup message ... fail_path"
followed by "dmsetup message ... reinstate_path" on the two paths of the
same dm device that is being removed / added.

Note: If someone tries to repeat this testing, occasionally I would hit an
issue in scsi_debug so for longer test runs I needed to add a patch for
handling ensuring that reacquiring queued_arr_lock did not occur.

Thanks,

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
