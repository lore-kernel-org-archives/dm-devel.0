From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Wed, 17 Aug 2016 08:37:12 -0700
Message-ID: <66272579-fa56-b3d1-8dce-0cc1ceb1fc9d@sandisk.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
	<7b1ac503-6f17-68b5-7510-547bd5f11731@sandisk.com>
	<21bda432-784b-3cde-5de1-d81eab98aeb1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <21bda432-784b-3cde-5de1-d81eab98aeb1@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/17/2016 07:44 AM, Hannes Reinecke wrote:
> On 08/16/2016 10:11 PM, Bart Van Assche wrote:
>> On 08/15/2016 11:31 PM, Hannes Reinecke wrote:
>>> Makes one wonder: what happens to the waitevent threads?
>>> We won't be waiting for them after applying this patch, right?
>>> So why did we ever had this busy loop here?
>>> Ben?
>>>
>>> (And while we're at the subject: can't we drop the waitevent threads
>>> altogether? We're listening to uevents nowadays, so we should be
>>> notified if something happened to the device-mapper tables. Which should
>>> make the waitevent threads unnecessary, right?)
>>
>> Hello Hannes,
>>
>> Maybe this is not what you had in mind, but would you agree with the
>> attached two patches?
>>
> Well, yes, sort of.
> However, it still would mean that the main multipath daemon thread might
> terminate before the event threads have completed, though.
>
> Not sure if it matters, just wanted to bring is up.

Hello Hannes,

I think that for the tur checker the libcheck_free() function should 
wait until the tur thread has finished. multipathd calls 
remove_maps_and_stop_waiters() during shutdown and that function calls 
libcheck_free() for all checkers that were loaded.

Regarding the waiter threads: stop_waiter_thread() is called by 
_remove_map() so the waiter threads are also stopped during multipathd 
shutdown.

Bart.
