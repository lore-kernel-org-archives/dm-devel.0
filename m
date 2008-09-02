From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
Date: Tue, 02 Sep 2008 06:55:33 -0400
Message-ID: <48BD1BA5.1020604@hp.com>
References: <48BD173B.3090600@hp.com> <48BD19B1.9040207@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753004AbYIBKzt@vger.kernel.org>
In-Reply-To: <48BD19B1.9040207@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Tejun Heo wrote:
> Hello,
> 
> Alan D. Brunelle wrote:
>> I have found two problems in LVM2/DM w/ a potential new "experimental
>> feature" in 2.6.28: CONFIG_DEBUG_BLOCK_EXT_DEVT (this is from Jens
>> Axboe's origin/for-2.6.28 git branch)
> 
> It's a debug option and I don't expect it to be enabled in any
> production kernel.

Then perhaps it should /not/ default to Y...

> 
>> "Conventionally, block device numbers are allocated from predetermined
>> contiguous area.  However, extended block area may introduce
>> non-contiguous block device numbers.  This option forces most block
>> device numbers to be allocated from the extended space and spreads them
>> to discover kernel or userland code paths which assume predetermined
>> contiguous device number allocation."
>>
>> W/ LVM2 & DM there are (at least) two issues:
>>
>> (1) Device major numbers for some reason are /not/ being entered
>> correctly into /proc/devices -- w/ CONFIG_DEBUG_BLOCK_EXT_DEVT=y I am
>> seeing some devices w/ major "259" (a SATA controller) but no entry in
>> /proc/devices. LVM2/DM will not find the entry in /proc/devices, and not
>> allow any device w/ that major to be used with LVM commands.
> 
> Hmmm.. Adding a call to register_blkdev(), which will create the
> corresponding entry in /proc/devices, isn't difficult at all but which
> name would it use?  It'll be mix of block devices (hd and sds
> currently).  If we introduce a new name there, say, ext-block, would
> that work?  BTW, is there any specific reason why LVM2/DM can't use
> /sys/block/* ?
> 
>> (2) Device minor numbers can be quite large, and the 10-character limits
>> in dm/lib/libdm-deptree.c are too small.
> 
> Would it be difficult to increase that?


No, but knowing the upper bound would be helpful.


> 
> Thanks.
> 
