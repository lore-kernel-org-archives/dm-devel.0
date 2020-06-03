From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv4 00/15] dm-zoned: multiple drive support
Date: Wed, 3 Jun 2020 01:11:01 +0000
Message-ID: <CY4PR04MB37519AA086D8ADDFC7003CFFE7880@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200602110956.121170-1-hare@suse.de>
	<20200602222719.GA14318@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/06/03 7:27, Mike Snitzer wrote:
> On Tue, Jun 02 2020 at  7:09am -0400,
> Hannes Reinecke <hare@suse.de> wrote:
> 
>> Hi all,
>>
>> here's the second version of my patchset to support multiple zoned
>> drives with dm-zoned.
>> This patchset:
>> - Converts the zone array to using xarray for better scalability
>> - Separates out shared structures into per-device structure
>> - Enforce drive-locality for allocating and reclaiming zones
>> - Lifts the restriction of 2 devices to handle an arbitrary number
>>   of drives.
>>
>> This gives me a near-perfect scalability by increasing the write
>> speed from 150MB/s (for a cache and one zoned drive) to 300MB/s
>> (for a cache and two zoned drives).
>>
>> Changes to v1:
>> - Include reviews from Damien
>> - Reshuffle patches
>> Changes to v2:
>> - Add reviews from Damien
>> - Merge patches 'dynamic device allocation' and
>>   'support arbitrary number of devices'
>> - Fix memory leak when reading tertiary superblocks
>> Changes to v3:
>> - Add reviews from Damien
>> - Add patch to ensure correct device ordering
> 
> I've picked this series up for 5.8 (yes, I know it is last minute).  But
> I saw no benefit to merging the initial 2 device step in 5.8 only to
> then churn the code and interface to support an arbitrary number of
> devices in 5.9.  Easier to support one major update to the code now.
> 
> As such the target's version number was _not_ bumped from 2.0.0 to
> 3.0.0.
> 
> I tweaked various patch headers (_please_ "dm zoned" instead of
> "dm-zoned" in commit subjects, also don't ever say "we" or "this patch"
> in a commit header... if you do, I am forced to rewrite the header).
> 
> BTW, just so I feel like I said it: all these changes to use additional
> device(s) really seems like a tradeoff between performance and reduced
> MTBF -- there is increased potential for failure with each additional
> device that is added to the dm-zoned device... there I've said it ;)

Yes, agreed. While the cache SSD + 1xSMR disk can I think have reasonable
applications, more than 1 SMR disk without any data protection is indeed
dangerous. However, I think that we now have a good base to improve this:
duplication of zones across devices using reclaim should not be difficult to
implement. That is a RAID1 level, to which we can even add more than one copy
again with reclaim (dm-kcopyd comes in very handy for that). And I am still
thinking of ways to erasure code zones across the multiple devices to raise the
possible RAID levels :)

Another approach would be to do intelligent stacking of dm-raid on top of
dm-zoned devices. "intelligent" here means that in case of any drive failure,
only a partial rebuild of the dm-zoned device with the failed drive is needed:
one only needs to rebuild the sector chunks that the failed SMR drive was holding.

> 
> Thanks,
> Mike
> 
> 


-- 
Damien Le Moal
Western Digital Research
