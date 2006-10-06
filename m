From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC] Reverting "bd_mount_mutex" to "bd_mount_sem"
Date: Fri, 06 Oct 2006 15:50:12 -0500
Message-ID: <4526C184.7070507@sandeen.net>
References: <451A78DF.1060901@in.ibm.com> <20060927135705.GA30311@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422949AbWJFUu2@vger.kernel.org>
In-Reply-To: <20060927135705.GA30311@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Srinivasa Ds <srinivasa@in.ibm.com>, dm-devel@redhat.com, linux-lvm@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

Ingo Molnar wrote:
> * Srinivasa Ds <srinivasa@in.ibm.com> wrote:
> 
>>   On debugging I found out that,"dmsetup suspend <device name>" calls 
>> "freeze_bdev()",which locks "bd_mount_mutex" to make sure that no new 
>> mounts happen on bdev until thaw_bdev() is called.
>>   This "thaw_bdev()" is getting called when we resume the device 
>> through "dmsetup resume <device-name>".
>>   Hence we have 2 processes,one of which locks 
>> "bd_mount_mutex"(dmsetup suspend) and Another(dmsetup resume) unlocks 
>> it.
> 
> hm, to me this seems quite a fragile construct - even if the 
> mutex-debugging warning is worked around by reverting to a semaphore.
> 
> 	Ingo

Ingo, what do you feel is fragile about this?  It seems like this is a
reasonable way to go, except that maybe a down_trylock would be good if
a 2nd process tries to freeze while it's already frozen...

Thanks,

-Eric
