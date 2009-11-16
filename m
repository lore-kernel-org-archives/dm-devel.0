From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/3] Add deleting state check for target
	messages
Date: Sun, 15 Nov 2009 23:38:48 -0800
Message-ID: <20091116073848.GA20475@linux.vnet.ibm.com>
References: <20091113080422.17412.49305.stgit@localhost.localdomain>
	<4B00B597.6050905@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B00B597.6050905@ct.jp.nec.com>
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
List-Id: dm-devel.ids

Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi Mike,
> 
> On 11/13/2009 05:04 PM +0900, Mike Anderson wrote:
> > This patch adds a accessor function that allows determining if a
> > mapped_device is in the deleting state and then adds this check to the
> > target_message function. The result of this change would be that all
> > targets would not be allowed to process messages post a mapped device
> > entering the deleting state.
> > 
> > As previously described in the email at the archive url provided below the
> > target_message ioctl can result in new work / activities being started
> > post the mapped device entering states that new target work could cause
> > issues.
> > 
> > http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/10486
> 
> Thank you for the patch-set.
> Although I'm not sure this patch-set is really needed after the fix
> of message ioctl during suspend will have been done, I understand
> why you want this patch-set (since issuing message ioctl to a deleting
> device is a bit pointless).
> 

Yes this patch set should not be needed post the fix to the message ioctl.
The reduction was aimed at future callers using dm_get_md prior to
DMF_FREEING being set as the dm_table_destroy holders wait would not
proceed until current message operations had completed, but the reduction
of this case is not that important with the other message ioctl changes in
place.

This patch set can be dropped.

> But there is a small window in this patch-set as Malahal described.
> Also, I have some comments below:
>   o Please use drivers/md/dm.h instead of include/linux/device-mapper.h
>     and don't export symbols, because all accessors you are adding are
>     used in only dm-core, no target uses them.
> 
>   o target_message() can use dm_deleting(), because target_message()
>     has a reference to the md.
>     We don't need the table function, dm_table_md_deleting(), at all.
>

Thanks for the review tip.


-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
