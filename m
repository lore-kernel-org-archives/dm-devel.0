From: Christoph Nelles <evilazrael@evilazrael.de>
Subject: Re: DM-Cache Writeback & Direct IO?
Date: Thu, 09 Jul 2015 18:51:55 +0200
Message-ID: <559EA6AB.2080603@evilazrael.de>
References: <559CE76E.6020504@evilazrael.de> <20150708144829.GA5058@rh-vpn>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150708144829.GA5058@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello Joe,

I updated to the latest kernel from Ubuntu mainline (4.2.0-040200rc1) 
and will rerun the same fio command over the night. Currently it shows 
the same behaviour. The fio command i use is
fio --name=test --filename=/dev/mapper/dmcache  --rw=randwrite 
--filesize=16G  --bs=64k --ioengine=libaio --direct=1 --iodepth=1000

After 4 runs, the status for the device mapper looks like this:
dmcache: 0 6442450943 cache 8 6029/4161600 512 2283/2913051 1517 119 
25120 1294780 0 2283 1484 1 writeback 2 migration_threshold 2048 smq 0 rw

Regards

Christoph



Am 08.07.2015 um 16:48 schrieb Joe Thornber:
> On Wed, Jul 08, 2015 at 11:03:42AM +0200, Christoph Nelles wrote:
>> Hi,
>>
>> Can the dm-cache writeback cache buffer direct IO or goes direct IO
>> always immediately to the origin device?
> Yes, the device mapper layer knows nothing about direct IO vs page
> cache IO.
>
>> I am currently performing tests and see that random direct write IO
>> never hits the cache, even after overwriting the same region over
>> and over.
> Could you try with the latest kernels and the new smq policy please?
>
> - Joe
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
