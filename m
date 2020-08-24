From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm-crypt: Document new no_workqueue flags.
Date: Mon, 24 Aug 2020 07:40:10 +0000
Message-ID: <CY4PR04MB3751E799136C15AEB32BBEF0E7560@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200820174538.20837-1-gmazyland@gmail.com>
	<CY4PR04MB37518F3475AE21AB020B628DE7560@CY4PR04MB3751.namprd04.prod.outlook.com>
	<5e803f19-241a-d2ff-6cdb-a45846cd06a0@gmail.com>
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
To: Milan Broz <gmazyland@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/08/24 15:46, Milan Broz wrote:
> On 24/08/2020 03:15, Damien Le Moal wrote:
>> On 2020/08/21 2:46, Milan Broz wrote:
>>> Patch 39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877 introduced new dm-crypt
>>> no_read_workqueue and no_write_workqueue flags.
>>> 
>>> This patch adds documentation to admin guide for them.
>>> 
>>> Signed-off-by: Milan Broz <gmazyland@gmail.com> --- 
>>> Documentation/admin-guide/device-mapper/dm-crypt.rst | 6 ++++++ 1 file
>>> changed, 6 insertions(+)
>>> 
>>> diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst
>>> b/Documentation/admin-guide/device-mapper/dm-crypt.rst index
>>> 8f4a3f889d43..94466921415d 100644 ---
>>> a/Documentation/admin-guide/device-mapper/dm-crypt.rst +++
>>> b/Documentation/admin-guide/device-mapper/dm-crypt.rst @@ -121,6 +121,12
>>> @@ submit_from_crypt_cpus thread because it benefits CFQ to have writes
>>> submitted using the same context.
>>> 
>>> +no_read_workqueue +    Bypass dm-crypt internal workqueue and process
>>> read requests synchronously. + +no_write_workqueue +    Bypass dm-crypt
>>> internal workqueue and process write requests synchronously.
>> 
>> Could you add one more line here saying something like:
>> 
>> This option is automatically enabled for host-managed zoned block devices
>> (e.g. host-managed SMR hard-disks).
> 
> Yes, Mike can squeeze it there (Mike, if you prefer, I can resend the patch
> with the note above).
> 
> I just see one problem here - when we activate device without these flags, 
> then dm-crypt decides to set the feature bits because of zone device.
> 
> So you activate device with some feature set but table will show something
> different. It is not a technical problem, but I think DM table was not
> expected to behave this way.

Hmmm. Never wondered about that... Mike ? Is this a big problem ?

> It is probably not the first change (I think some flags are activated in
> dm-integrity according to on-disk superblock state only).
> 
> Milan
> 
> p.s. Both noqueue flags are now supported in cryptsetup master, for LUKS2 we
> can store them persistently (IOW to be used in all later LUKS2 activations if
> kernel supports it). It should appear in next stable cryptsetup release.

Great. Thanks. Note that I have code for Luks format on host-managed SMR disks,
or rather any host-managed zoned block device, including ZNS NVMe SSDs.

The current cryptsetup code needs some massaging for these drives because:
1) offset+size needs to be zoned aligned, so at the very least defaulting to
--offset=<device zone size> is needed.
2) The on-disk formatting is annoyingly not writing sequentially :) So the
current code fails if the drive does not have a conventional zone at LBA 0.

My code is rather dirty for now and needs a good cleanup. I will do that
rebasing on the next stable that adds the no queue flags support. The current
cryptsetup does work as is with plain type, and with Luks type for SMR drives
that have a conventional zone at LBA 0 with the added --offset=<device zone
size> option specified.

Best regards.


-- 
Damien Le Moal
Western Digital Research
