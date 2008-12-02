From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Mon, 01 Dec 2008 23:52:22 -0500
Message-ID: <4934BF06.7010500@redhat.com>
References: <492C91DF.7040507@redhat.com>	<492D9BDB.5010001@cfl.rr.com>	<492E514F.2080007@redhat.com>	<49304F41.2060205@cfl.rr.com>	<49338BA6.3010809@redhat.com>
	<49340C59.4070504@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49340C59.4070504@cfl.rr.com>
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

Phillip Susi wrote:
> Takahiro Yasui wrote:
>> log disks are updated in parallel and we do not know which disk has the
>> latest and correct data if the system crashes during write operations
>> on log devices. But there is no problem about it.
> 
> Once the IO request has been completed, the data needs to be stable on
> the disk.  This means that either you have to wait until the data has
> been written to all underlying mirror devices before completing the
> request ( slow ) or you have to have some way of knowing which disk(s)
> got written to, and which ones need updated after a crash.  Are you
> saying you take the former path?

Yes, write I/O to all underlying mirror devices need to be completed.
I understand your concern and think that there is a room to study about
performance enhancement.

>> There are two cases we need to think about.
>>
>> 1) Some log devices contain "clean", but mirror devices are not synchronized
>>
>> This case is problematic, but never happens, because data is written on
>> mirror devices after marking log devices "dirty", and make it "clean"
>> after write I/Os on mirror devices completed and mirrors get synchronized.
> 
> Does the entire log-data-log update cycle complete before dm completes
> the higher level IO request?  That would maintain data integrity, but at
> significant cost to performance.

I/O request returns to the higher level after data I/O completed, and
an update of the log device is done later.

> For performance sake, don't you want to allow write requests to be
> completed before the log is necessarily marked as clean again?  That way
> multiple writes to the same data zone do not require multiple log
> dirty/clean updates.  Also for performance reasons, don't you want to
> allow the data to be written to only one mirror before completing the
> request?  Then go back and do lazy synchronization?

I am also thinking exactly what you mentioned, and it will improve performance
of dm-mirror. I am now trying to improve performance in terms of:

> FUTURE WORKS
>   * Independent header and bitmap I/O
>   * Partial bitmap update

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America) Inc.
