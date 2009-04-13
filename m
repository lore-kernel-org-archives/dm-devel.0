From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: SMP-aware kcryptd?
Date: Mon, 13 Apr 2009 19:47:16 +0200
Message-ID: <49E37AA4.8060007@wpkg.org>
References: <49E3410D.9040500@wpkg.org> <49E37824.8010100@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49E37824.8010100@redhat.com>
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
Cc: dm-crypt@saout.de
List-Id: dm-devel.ids

Milan Broz schrieb:
> Tomasz Chmielewski wrote:
>> Currently, the trend with CPUs is to add more cores rather than increase 
>> the speed of a single core.
>>
>> This does not scale very well with certain things in the Linux kernel. 
>> One of them is kcryptd.
>>
>>
>> A system able to deliver data with a speed of ~200 MB/s from a RAID 
>> array, will be only able to deliver a fraction of it (i.e. ~40 MB/s in 
>> my case) when reads are being done from a dm-crypt device.

(...)

> Anyway, it is not highest priority currently... but still in slow progress.
> (but I guess high speed SSDs will increase priority for this too,
> currently it is real problem only for RAID arrays:-)

And, laptops/netbooks with (slow) multi-core CPUs.

Encryption is getting popular there as well.


-- 
Tomasz Chmielewski
http://wpkg.org
