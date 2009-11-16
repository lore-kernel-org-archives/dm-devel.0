From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/3] Add deleting state check for target
	messages
Date: Mon, 16 Nov 2009 11:14:47 +0900
Message-ID: <4B00B597.6050905@ct.jp.nec.com>
References: <20091113080422.17412.49305.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091113080422.17412.49305.stgit@localhost.localdomain>
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

Hi Mike,

On 11/13/2009 05:04 PM +0900, Mike Anderson wrote:
> This patch adds a accessor function that allows determining if a
> mapped_device is in the deleting state and then adds this check to the
> target_message function. The result of this change would be that all
> targets would not be allowed to process messages post a mapped device
> entering the deleting state.
> 
> As previously described in the email at the archive url provided below the
> target_message ioctl can result in new work / activities being started
> post the mapped device entering states that new target work could cause
> issues.
> 
> http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/10486

Thank you for the patch-set.
Although I'm not sure this patch-set is really needed after the fix
of message ioctl during suspend will have been done, I understand
why you want this patch-set (since issuing message ioctl to a deleting
device is a bit pointless).

But there is a small window in this patch-set as Malahal described.
Also, I have some comments below:
  o Please use drivers/md/dm.h instead of include/linux/device-mapper.h
    and don't export symbols, because all accessors you are adding are
    used in only dm-core, no target uses them.

  o target_message() can use dm_deleting(), because target_message()
    has a reference to the md.
    We don't need the table function, dm_table_md_deleting(), at all.

Thanks,
Kiyoshi Ueda
