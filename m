From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: reorder vendors in hwtable
Date: Sun, 17 Mar 2019 00:04:46 +0100
Message-ID: <b450ce2f-72fe-6a06-f46d-f93ecf600d2d@gmail.com>
References: <20181219212357.21076-1-xose.vazquez@gmail.com>
	<74dbe64aabf33700924e57bcbe249a02c027ff29.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <74dbe64aabf33700924e57bcbe249a02c027ff29.camel@suse.de>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 12/21/18 12:51 AM, Martin Wilck wrote:
> On Wed, 2018-12-19 at 22:23 +0100, Xose Vazquez Perez wrote:
>> Xio was acquired by Violin, and add FlashSystem 9100 to Storwize in
>> comments.
>>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM-DEVEL ML <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  libmultipath/hwtable.c | 50 ++++++++++++++++++++------------------
>> ----
>>  1 file changed, 24 insertions(+), 26 deletions(-)
>>

> How important is it to reflect this kind of company-A-owns-company-B
> information in multipath-tools source code? IMO it makes it harder to
> track code changes, for no obvious technical reason.

Keep the file consistent with the real world.
There is no more Xiotech company, now their products are sold by Violin.
The same happened in the past with:
XIV : RamSan -> IBM
LSI_RDAC : SolidFir -> NetApp
DEC -> Compaq : 3PAR : LEFTHAND : Nimble : SGI -> HPE
DGC : XtremIO -> EMC : Compellent -> DELL
...
......

>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index d3a8d9b..3eeadde 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -604,7 +604,7 @@ static struct hwentry default_hw[] = {
>>  		.pgpolicy      = MULTIBUS,
>>  	},
>>  	{
>> -		/* Storwize family / SAN Volume Controller / Flex
>> System V7000 / FlashSystem V840/V9000 */
>> +		/* Storwize family / SAN Volume Controller / Flex
>> System V7000 / FlashSystem V840/V9000/9100 */
>>  		.vendor        = "IBM",
>>  		.product       = "^2145",
>>  		.no_path_retry = NO_PATH_RETRY_QUEUE,
>> @@ -1099,31 +1099,7 @@ static struct hwentry default_hw[] = {
>>  		.no_path_retry = 30,
>>  	},
>>  	/*
>> -	 * Xiotech
>> -	 */
>> -	{
>> -		/* Intelligent Storage Elements family */
>> -		.vendor        = "(XIOTECH|XIOtech)",
>> -		.product       = "ISE",
>> -		.pgpolicy      = MULTIBUS,
>> -		.no_path_retry = 12,
>> -	},
>> -	{
>> -		/* iglu blaze family */
>> -		.vendor        = "(XIOTECH|XIOtech)",
>> -		.product       = "IGLU DISK",
>> -		.pgpolicy      = MULTIBUS,
>> -		.no_path_retry = 30,
>> -	},
>> -	{
>> -		/* Magnitude family */
>> -		.vendor        = "(XIOTECH|XIOtech)",
>> -		.product       = "Magnitude",
>> -		.pgpolicy      = MULTIBUS,
>> -		.no_path_retry = 30,
>> -	},
>> -	/*
>> -	 * Violin Memory
>> +	 * Violin Systems
>>  	 */
>>  	{
>>  		/* 3000 / 6000 Series */
>> @@ -1148,6 +1124,28 @@ static struct hwentry default_hw[] = {
>>  		.product       = "CONCERTO ARRAY",
>>  		.pgpolicy      = MULTIBUS,
>>  		.no_path_retry = 30,
>> +	},
>> +		/* Xiotech */
>> +	{
>> +		/* Intelligent Storage Elements family */
>> +		.vendor        = "(XIOTECH|XIOtech)",
>> +		.product       = "ISE",
>> +		.pgpolicy      = MULTIBUS,
>> +		.no_path_retry = 12,
>> +	},
>> +	{
>> +		/* iglu blaze family */
>> +		.vendor        = "(XIOTECH|XIOtech)",
>> +		.product       = "IGLU DISK",
>> +		.pgpolicy      = MULTIBUS,
>> +		.no_path_retry = 30,
>> +	},
>> +	{
>> +		/* Magnitude family */
>> +		.vendor        = "(XIOTECH|XIOtech)",
>> +		.product       = "Magnitude",
>> +		.pgpolicy      = MULTIBUS,
>> +		.no_path_retry = 30,
>>  	},
>>  	/*
>>  	 * Promise Technology
> 
> 
> 
