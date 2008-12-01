From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Mon, 1 Dec 2008 12:09:37 +0100
Message-ID: <20081201110937.GA6287@rere.qmqm.pl>
References: <49338BA6.3010809@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49338BA6.3010809@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

2008/12/1 Takahiro Yasui <tyasui@redhat.com>:
> Phillip Susi wrote:
[...]
>> Right... and when recording a log on every disk in the mirror, each copy
>> of the log may not contain exactly the same information at any given
>> time.  If you write to one disk in the mirror first, then you need to
>> mark the region as dirty on that disk first, so that if the system
>> crashes before you can copy the data to the other mirror, you can see
>> that the first disk is more up to date than the second disk.
>>
>> In other words, knowing that a region is or is not synchronized across
>> each disk is not enough; if they are out of sync you need to figure out
>> which disk has the most current information so it can be replicated to
>> the others, don't you?
>>
>> Or do you just always write to the first disk first, and assume it has
>> the most recent data if the region was marked as dirty in ANY of the logs?
>
> log disks are updated in parallel and we do not know which disk has the
> latest and correct data if the system crashes during write operations
> on log devices. But there is no problem about it.
>
> There are two cases we need to think about.
>
> 1) Some log devices contain "clean", but mirror devices are not synchronized
>
> This case is problematic, but never happens, because data is written on
> mirror devices after marking log devices "dirty", and make it "clean"
> after write I/Os on mirror devices completed and mirrors get synchronized.
>
> 2) Some log devices contain "dirty", but mirror devices are synchronized
>
> This case may happen but is not problematic. Just data replication of
> the region among mirror devices will be done when the mirror is resumed.
> This case would also happen on the system with the current single log if
> the system crashes after marking a log device "dirty" and before marking
> it back to "clean".

What happens if some log devices contain "dirty" and not all mirrors were written
yet before a crash? How do you know which mirror has the most recent data?
Are the writes to mirrors ordered somehow?

Best Regards,
Michal Miroslaw
