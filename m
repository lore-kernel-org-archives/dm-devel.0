From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2/2] dm-bdev-keep-bdev-always-referenced.patch
Date: Tue, 19 May 2009 10:36:08 +0900
Message-ID: <4A120D08.2040307@ce.jp.nec.com>
References: <Pine.LNX.4.64.0904281211590.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904281214120.22533@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904290223490.9079@hs20-bc2-1.build.redhat.com>
	<4A093417.6050007@ce.jp.nec.com>
	<Pine.LNX.4.64.0905181127040.22422@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0905181127040.22422@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas Patocka wrote:
> On Tue, 12 May 2009, Jun'ichi Nomura wrote:
> 
>> Mikulas Patocka wrote:
>>> @@ -1280,8 +1284,7 @@ static int __bind(struct mapped_device *
>>>  	if (size != get_capacity(md->disk))
>>>  		memset(&md->geometry, 0, sizeof(md->geometry));
>>>  
>>> -	if (md->bdev)
>>> -		__set_size(md, size);
>>> +	__set_size(md, size);
>>>  
>>>  	if (!size) {
>>>  		dm_table_destroy(t);
>>> @@ -1523,11 +1526,6 @@ int dm_swap_table(struct mapped_device *
>>>  	if (!dm_suspended(md))
>>>  		goto out;
>>>  
>>> -	/* without bdev, the device size cannot be changed */
>>> -	if (!md->bdev)
>>> -		if (get_capacity(md->disk) != dm_table_get_size(table))
>>> -			goto out;
>>> -
>>>  	__unbind(md);
>>>  	r = __bind(md, table);
>> When the device is suspended with noflush,
>> can __set_size() wait forever on i_mutex
>> if somebody is waiting for I/O flushing with i_mutex held (e.g. fsync)?
>>
>> md->bdev was also used as a marker to tell whether the device was
>> suspended with noflush.
>> Sorry, the original comment in the code was perhaps not adequate.
> 
> Hi
> 
> Thanks for reviewing it. Your concern is correct. But maybe that 
> mutex_lock in __set_size is not needed at all --- because no one can 
> change size simultaneously. What do you think?

I think a lock is still needed.

bd_set_size() can be called concurrently and overwrite
the i_size with old capacity:

  __set_size() (in dm.c)       __blkdev_get()
  -----------------------------------------------------------
                               get_capacity
  set_capacity
  i_size_write
                               bd_set_size


I don't think check_disk_size_change() is called for dm device
but if somebody decides to use it on dm device, the following race is
also possible:

  __set_size() (in dm.c)       check_disk_size_change()
  -----------------------------------------------------------
  set_capacity
                               get_capacity
                               i_size_read
  i_size_write                 i_size_write

and the concurrent i_size_write could break i_size_seqcount on 32bit SMP.


Given that functions like check_disk_size_change() and bd_set_size()
are protected by bd_mutex, using bd_mutex in __set_size() might be a fix.
However, I suspect a holder of bd_mutex can still block on
the I/O on the device.


So perhaps the right solution is deferring the i_size_write
until the process can safely wait for bd_mutex
or introducing a new spinlock to protect the i_size_write on bd_inode.


> BTW. I have found another problem --- a few places in dm don't use 
> i_size_read and read i_size directly, which is wrong, see the next patch.

I think those changes are ok.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
