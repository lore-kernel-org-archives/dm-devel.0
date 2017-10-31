From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: dm: dm-zoned: Ignore last smaller runt zone
Date: Tue, 31 Oct 2017 09:48:04 +0900
Message-ID: <2f633f7a-0f5d-265e-0790-05f3a24ab2bc@wdc.com>
References: <20171028073934.23293-1-damien.lemoal@wdc.com>
	<20171030200539.GA14059@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171030200539.GA14059@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Mike,

On 10/31/17 05:05, Mike Snitzer wrote:
> On Sat, Oct 28 2017 at  3:39am -0400,
> Damien Le Moal <damien.lemoal@wdc.com> wrote:
> 
>> The scsi layer allows ZBC drives to have a smaller last runt zone. For
>> such device, specifying the entire capacity for a dm-zoned target table
>> entry fails as the specified capacity is not aligned on the device zone
>> size indicated in the request queue structure of the device.
>>
>> Fix this problem by ignoring the last runt zone in the entry length
>> when seting up the dm-zoned target (ctr method) and when iterating table
>> entries of the target (iterate_devices method). This allows dm-zoned
>> users to still easily setup a target using the entire device capacity
>> (as mandated by dm-zoned) or the aligned capacity excluding thelast runt
>> zone.
>>
>> While at it, replace direct references to the device queue chunk_sectors
>> limit with calls to the accessor blk_queue_zone_sectors().
>>
>> Reported-by: Peter Desnoyers <pjd@ccs.neu.edu>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> 
> Applied for 3.15 (also cc'd stable@)

Thank you. Since this is a bug fix, I was hoping to get this in 4.14 as
this is scheduled as an LTS. Is it too late for that ?

-- 
Damien Le Moal,
Western Digital
