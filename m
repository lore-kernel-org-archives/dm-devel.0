From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 3/4] multipath-tools: replace TUR with
 DEFAULT_CHECKER in hwtable
Date: Thu, 23 Jun 2016 16:13:02 +0200
Message-ID: <4ca95b13-eaeb-c703-f192-a232997d121b@gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
	<1466689340-5590-4-git-send-email-xose.vazquez@gmail.com>
	<576BE8CE.9040201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <576BE8CE.9040201@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

On 06/23/2016 03:49 PM, Hannes Reinecke wrote:

> On 06/23/2016 03:42 PM, Xose Vazquez Perez wrote:
>> DEFAULT_CHECKER already is TUR
>> ---
>>  libmultipath/hwtable.c | 78 +++++++++++++++++++++++++-------------------------
>>  1 file changed, 39 insertions(+), 39 deletions(-)
>>
>> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>> index fb334ab..6e73e67 100644
>> --- a/libmultipath/hwtable.c
>> +++ b/libmultipath/hwtable.c
>> @@ -34,7 +34,7 @@ static struct hwentry default_hw[] = {
>> -		.checker_name  = TUR,
>> +		.checker_name  = DEFAULT_CHECKER,
>>  		.prio_name     = PRIO_ALUA,
>>  		.pgfailback    = 30,
>>  		.minio         = 128,
>>
> Why do you need to set it to 'DEFAULT_CHECKER'?
> It's the default, right?
> So it should be sufficient to just delete those lines...

I was being wordy. As "checker_name  = DEFAULT_CHECKER,"
was being used already by 3 devices. And I followed what
has been previously done.

Christophe?
