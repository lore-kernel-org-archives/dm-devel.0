From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt: Document new no_workqueue flags.
Date: Mon, 24 Aug 2020 08:46:23 +0200
Message-ID: <5e803f19-241a-d2ff-6cdb-a45846cd06a0@gmail.com>
References: <20200820174538.20837-1-gmazyland@gmail.com>
	<CY4PR04MB37518F3475AE21AB020B628DE7560@CY4PR04MB3751.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CY4PR04MB37518F3475AE21AB020B628DE7560@CY4PR04MB3751.namprd04.prod.outlook.com>
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
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 24/08/2020 03:15, Damien Le Moal wrote:
> On 2020/08/21 2:46, Milan Broz wrote:
>> Patch 39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877 introduced new
>> dm-crypt no_read_workqueue and no_write_workqueue flags.
>>
>> This patch adds documentation to admin guide for them.
>>
>> Signed-off-by: Milan Broz <gmazyland@gmail.com>
>> ---
>>  Documentation/admin-guide/device-mapper/dm-crypt.rst | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
>> index 8f4a3f889d43..94466921415d 100644
>> --- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
>> +++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
>> @@ -121,6 +121,12 @@ submit_from_crypt_cpus
>>      thread because it benefits CFQ to have writes submitted using the
>>      same context.
>>  
>> +no_read_workqueue
>> +    Bypass dm-crypt internal workqueue and process read requests synchronously.
>> +
>> +no_write_workqueue
>> +    Bypass dm-crypt internal workqueue and process write requests synchronously.
> 
> Could you add one more line here saying something like:
> 
> This option is automatically enabled for host-managed zoned block devices (e.g.
> host-managed SMR hard-disks).

Yes, Mike can squeeze it there (Mike, if you prefer, I can resend the patch with the note above).

I just see one problem here - when we activate device without these flags,
then dm-crypt decides to set the feature bits because of zone device.

So you activate device with some feature set but table will show something different.
It is not a technical problem, but I think DM table was not expected to behave this way.

It is probably not the first change (I think some flags are activated in dm-integrity
according to on-disk superblock state only).

Milan

p.s. Both noqueue flags are now supported in cryptsetup master, for LUKS2 we can store them persistently
(IOW to be used in all later LUKS2 activations if kernel supports it).
It should appear in next stable cryptsetup release.
