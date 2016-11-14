From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm-cache issue
Date: Mon, 14 Nov 2016 16:34:55 +0100
Message-ID: <884adfe3-ac18-5e37-f4b4-478e5031f35f@redhat.com>
References: <CAJV2nOTJoWWc=N80e6WCpZUh6ZRxvCW8Wt=aZWTyYSKso+kQ5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJV2nOTJoWWc=N80e6WCpZUh6ZRxvCW8Wt=aZWTyYSKso+kQ5Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alexander Pashaliyski <al.pashaliyski@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 14.11.2016 v 16:02 Alexander Pashaliyski napsal(a):
> Hi guys,
>
>
> I am in a process of evaluating dm-cache for our backup system.
>
> Currently I have an issue when restart the backup server. The server is
> booting for hours, because of IO load. It seems is triggered a flush from SSD
> disk (that is used for a cache device) to the raid controllers (they are with
> slow SATA disks).
> I have 10 cached logical volumes in *writethrough mode*, each with 2T of data
> over 2 raid controllers. I use a single SSD disk for the cache.
> The backup system is with lvm2-2.02.164-1 & kernel 4.4.30.
>
>
> Do you have any ideas why such flush is triggered? In writethrough cache mode
> we shouldn't have dirty blocks in the cache.
>

Hi

Have you ensured there was proper shutdown ?
Cache needs to be properly deactivated - if it's just turned off,
all metadata are marked dirty.


Regards

Zdenek
