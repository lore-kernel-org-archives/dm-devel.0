From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 05/57] Add HP MSA 2040 to the hardware table
Date: Thu, 9 Jun 2016 16:20:05 +0200
Message-ID: <01a29af9-deb9-64be-b01d-a1e248382cbc@gmail.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-6-git-send-email-hare@suse.de>
	<20160429000605.00006561@localhost> <5722F736.1050404@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5722F736.1050404@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 04/29/2016 07:55 AM, Hannes Reinecke wrote:

> On 04/29/2016 12:06 AM, Sebastian Herbszt wrote:
>>
>>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>>> index a4ae053..28ee595 100644
>>> --- a/libmultipath/hwtable.c
>>> +++ b/libmultipath/hwtable.c
>>> @@ -175,6 +175,21 @@ static struct hwentry default_hw[] = {
>>>  		.prio_name     = PRIO_ALUA,
>>>  		.prio_args     = NULL,
>>>  	},
>>> +	{
>>> +		/* HP MSA 1040/2040 product family */
>>> +		.vendor        = "HP",
>>> +		.product       = "MSA (1|2)040 SA(N|S)",
>>> +		.features      = DEFAULT_FEATURES,
>>> +		.hwhandler     = DEFAULT_HWHANDLER,
>>> +		.pgpolicy      = GROUP_BY_PRIO,
>>> +		.pgfailback    = -FAILBACK_IMMEDIATE,
>>> +		.rr_weight     = RR_WEIGHT_NONE,
>>> +		.no_path_retry = 18,
>>> +		.minio         = 100,
>>> +		.checker_name  = TUR,
>>> +		.prio_name     = PRIO_ALUA,
>>> +		.prio_args     = NULL,
>>> +	},
>>>  
>>>  	{
>>>  		/* HP SVSP */
>>
>> Any reason for a separate entry and not merging it with
>> "HP MSA2000 product family with new firmware" ?
>>
> Yes. MSA2000 are completely different beasts, so I'd like to keep
> them separate.

Sebastian is right.

And these three can be folded into one, because they share *exactly* the
same configuration.

/* HP MSA2000 product family with new firmware */
.vendor        = "HP",
.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",

/* HP P2000 family arrays */
.vendor        = "HP",
.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",

/* HP MSA 1040/2040 product family */
.vendor        = "HP",
.product       = "MSA (1|2)040 SA(N|S)",


In VxVM(libvxmsa2kfc_sa) they are grouped that way:
https://web.archive.org/web/20160608233140/https://sort.veritas.com/asl/details/756

Otherwise if hwtable.c is filled with a lot of duplicate entries,
it could be unmanageable.

Also all three DELL, some IBM, .... could be regrouped.
