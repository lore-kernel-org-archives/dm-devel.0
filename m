From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 9/9] dm path selector: Avoid that device
 removal triggers an infinite loop
Date: Thu, 1 Sep 2016 14:14:57 +0000
Message-ID: <BLUPR02MB1683AC1B30C6E1EAE953C67081E20@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<242bfdfc-1af1-014a-48c6-301598b8ad65@sandisk.com>
	<20160901024931.GA4741@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/31/16 20:29, Mike Snitzer wrote:
> On Wed, Aug 31 2016 at  6:18pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>
>> If pg_init_retries is set and a request is queued against a
>> multipath device with all underlying block devices in the "dying"
>> state then an infinite loop is triggered because activate_path()
>> never succeeds and hence never calls pg_init_done(). Fix this by
>> making ql_select_path() skip dying paths.
>
> Assuming DM multipath needs to be sprinkling these dying queue checks so
> deep (which I'm not yet sold on):
>
> Same would be needed in service-time and round-robin right?

Hello Mike,

Before addressing service-time and round-robin path selectors I wanted 
to make sure that we reach agreement about how to fix the queue length 
path selector.

Do you have a proposal for an alternative approach to fix the infinite 
loop that can be triggered during device removal?

Thanks,

Bart.
