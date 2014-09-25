From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] multipath-tools: Change path checker for
 IBM IPR devices
Date: Thu, 25 Sep 2014 11:47:42 -0500
Message-ID: <5424472E.4060300@linux.vnet.ibm.com>
References: <20140924195721.148637349@linux.vnet.ibm.com>
	<20140924195752.289011902@linux.vnet.ibm.com>
	<5423B664.2020007@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5423B664.2020007@suse.de>
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

On 09/25/2014 01:29 AM, Hannes Reinecke wrote:
> On 09/24/2014 09:57 PM, wenxiong@linux.vnet.ibm.com wrote:
>> We would like to change path checker to directio for IBM IPR devices.
>>
>> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>> ---
>>  libmultipath/hwtable.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: b/libmultipath/hwtable.c
>> ===================================================================
>> --- a/libmultipath/hwtable.c	2014-09-23 17:39:27.000000000 -0500
>> +++ b/libmultipath/hwtable.c	2014-09-23 17:40:31.419667000 -0500
>> @@ -630,7 +630,7 @@ static struct hwentry default_hw[] = {
>>  		.pgfailback    = -FAILBACK_IMMEDIATE,
>>  		.rr_weight     = RR_WEIGHT_NONE,
>>  		.no_path_retry = NO_PATH_RETRY_UNDEF,
>> -		.checker_name  = TUR,
>> +		.checker_name  = DIRECTIO,
>>  		.prio_name     = PRIO_ALUA,
>>  		.prio_args     = NULL,
>>  	},
>>
>> -- -- dm-devel mailing list dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
> Any particular reason for doing so?
> 
> Using 'directio' has the drawback that it might stall under higher
> load, as it's being added to the _tail_ of the request queue.
> TUR is using the 'SG_IO' ioctl, which is added to the head of the
> request_queue and hence won't be stalled ...

The issue we've run into started when this patch started making its
way into distros:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/scsi/scsi_error.c?id=14216561e164671ce147458653b1fea06a4ada1e

That changed the behaviour for user initiated TUR commands. After an ipr
adapter gets reset, all disk array devices require a start unit command
to be issued to them before they will accept commands. So, with the SCSI
EH change, we now end up in a scenario with dual ipr adapters where the
TUR getting issued from the health checker returns with a Not Ready response
and since SCSI EH no longer triggers the Start Unit in this scenario,
the path never recovers.

The alternative solution would be to change the TUR path checker in multipath-tools
to issue a Start Unit if it sees a 02/04/02.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
