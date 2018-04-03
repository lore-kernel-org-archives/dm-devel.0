From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [BUG] dm-thin metadata operation failed due to
 -ENOSPC returned by dm_pool_alloc_data_block() after processing DISCARD
 bios
Date: Tue, 3 Apr 2018 11:31:18 +0200
Message-ID: <e0f8863c-ee85-7962-1ae5-51eba3b43eb0@redhat.com>
References: <CAAR726JcYQpSSXAhL6=yPmzT0MOZRG_WwjC63q0QSMzT5qNPSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAR726JcYQpSSXAhL6=yPmzT0MOZRG_WwjC63q0QSMzT5qNPSg@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>, ejt@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 3.4.2018 v 06:07 Dennis Yang napsal(a):
> Hi,
> 
> Recently we have came across an issue that dm-thin pool will be
> switched to READ_ONLY mode because dm_pool_alloc_data_block() returns
> -ENOSPC. AFAIK, this should not happen since alloc_data_block() will
> check if there is any free space (and commit metadata if it first
> reports no free space) before it allocates pool block. In addition,
> total virtual space of all thin volumes is smaller than the pool
> physical space in my testing environment which makes pool impossible
> to run out of space.
> 


Hi


Which kernel has been used during testing - was this upstream ?
(4.16??)

> This issue could be easily reproduced by the following steps.
> 
> 1) Create a thin pool and a slightly smaller thin volume
>> sudo dmsetup create meta --table "0 40000000 linear /dev/sdf 0"

maximum metadadata size is only ~16G (... 33161216 blocks or so)


>> sudo dmsetup create data --table "0 10240000 linear /dev/md125 0"
>> sudo dd if=/dev/zero of=/dev/mapper/meta bs=1M count=1
>> sudo dmsetup create pool --table "0 10240000 thin-pool /dev/mapper/meta /dev/mapper/data 1024 0 2 skip_block_zeroing error_if_no_space"
>> sudo dmsetup message pool 0 "create_thin 0"
>> sudo dmsetup create thin --table "0 10238976 thin /dev/mapper/pool 0"

I've tried to reproduce with smaller LVs - but haven't managed yet:

vg-LV1: 0 102384 thin 253:4 1
vg-pool: 0 102400 linear 253:4 0
vg-pool-tpool: 0 102400 thin-pool 253:2 253:3 128 0 2 skip_block_zeroing 
error_if_no_space
vg-pool_tdata: 0 102400 linear 253:0 10240
vg-pool_tmeta: 0 8192 linear 253:1 2048


Regards

Zdenek
