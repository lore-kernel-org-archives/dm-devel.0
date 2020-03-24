From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 1/2] dm-zoned: cache device for zones
Date: Tue, 24 Mar 2020 12:22:22 +0800
Message-ID: <23a6c519-a1bc-6fcd-f3bc-3779ce03877c@oracle.com>
References: <20200323150352.107826-1-hare@suse.de>
	<20200323150352.107826-2-hare@suse.de>
	<CO2PR04MB2343170DAC13D92E9A649BBFE7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CO2PR04MB2343170DAC13D92E9A649BBFE7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
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
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Johannes Thumshirn <jth@kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 3/24/20 11:52 AM, Damien Le Moal wrote:
> +Bob who had proposed a similar change a last month.
> 

Thanks!

> On 2020/03/24 0:04, Hannes Reinecke wrote:
>> Implement 'cache' zones which reside on a different device.
>> The device is logically split into zones, which then will be
>> used as 'cache' zones, similar to the existing randow write
>> zones.
> 
> It does look like the new "cahce" zones are really used exactly as conventional
> zones of the SMR drive. So I wonder: why even define this new zone type ? We
> could have the "cache" device split into random (conventional) zones added to a
> single pool of random zones. We can simply add device awareness to the zone
> allocator to avoid as much as possible using a random zone from the same drive
> as the sequential zone it buffers. That would avoid repeating most of the code
> for cache & random.
> 
> Furthermore, this work is really great to support SMR drives with no
> conventional zones (a lot of ask for these). And considering that the new FORMAT
> WITH PRESET command is coming soon, a user will be able to reformat an SMR drive
> with sequential zones only to maximize capacity. For these, the cache device
> would need to hold the random zones, at which point the difference between cache
> and rando goes away.
> 
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/md/dm-zoned-metadata.c | 174 ++++++++++++++++++++++++++++-----
>>  drivers/md/dm-zoned-reclaim.c  |  76 +++++++++++---
>>  drivers/md/dm-zoned-target.c   | 109 ++++++++++++++++++---
>>  drivers/md/dm-zoned.h          |  31 +++++-
>>  4 files changed, 339 insertions(+), 51 deletions(-)
>>
>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>> index 369de15c4e80..41cc3a29db0b 100644
>> --- a/drivers/md/dm-zoned-metadata.c
>> +++ b/drivers/md/dm-zoned-metadata.c
>> @@ -132,6 +132,8 @@ struct dmz_sb {
>>  struct dmz_metadata {
>>  	struct dmz_dev		*dev;
>>  
>> +	struct dmz_cdev		*cdev;
> 
> Given the point above, we could have this generalized as an array of devices,
> with the first one meeting the constraints:
> * It contains the metadata
> * It has random/conventional zones, or is a regular device (with all its
> capacity used through emulated random zones)
> 

Yes, I was working my v2 patches as this.
Will send out this week.

Regards,
Bob

> I do not think that complicates the changes you did a lot. The reclaim part will
> need some more love I guess to be efficient, but it may be as simple as defining
> one work struct for each drive beside the first one.
> 
> Thoughts ?
> 
