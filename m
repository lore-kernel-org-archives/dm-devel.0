From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Thu, 27 Nov 2008 02:50:39 -0500
Message-ID: <492E514F.2080007@redhat.com>
References: <492C91DF.7040507@redhat.com> <492D9BDB.5010001@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <492D9BDB.5010001@cfl.rr.com>
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
>> Hi All,
>>
>> This is my first post to this mailing list, but let me introduce
>> a patch set to implement multi-log devices for dm-mirror.
>> I appreciate your kind comments and suggestions on this patch set.
> 
> Does it keep track of which log device corresponds to each mirror device
> and make sure that the log on disk X is updated before the data on disk
> X?  In other words, if you are about to write data to disk 1 that would
> cause that section to be flagged as dirty, you have to update the log on
> disk 1 first, not the log on disk 2.
> 
> The syntax and the fact that the number of logs does not have to equal
> the number of mirrors makes me think this is not the case.

bitmap data on a log disk indicates if each region are "clean" or "dirty"
among mirror disks. If a bit related to a region is "1", it means that
the region is "clean" and data in the region is synchronized in all mirror
disks and they store the same data in the region. On the other hand,
if a bit related to a region is "0", the region is "dirty" and the region
is out of synchronization. It means that each mirror disk might contain
different data in the region.

Therefore, a log disk contains a state of each region, but does not
correspond to a specific mirror device.

This patch set introduces redundant log disk on dm-mirror.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America) Inc.
