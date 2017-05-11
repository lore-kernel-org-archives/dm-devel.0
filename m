From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the select
 or poll function
Date: Thu, 11 May 2017 11:10:04 -0700
Message-ID: <01517603-ba44-bc02-8b70-96feef8050ed@redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com> <1494495801.6093.12.camel@suse.com>
	<20170511132134.GA10709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170511132134.GA10709@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On 05/11/2017 06:21 AM, Mike Snitzer wrote:
> On Thu, May 11 2017 at  5:43am -0400,
> Martin Wilck <mwilck@suse.com> wrote:
> 
>> On Thu, 2017-05-11 at 11:39 +0200, Martin Wilck wrote:
>>> On Tue, 2017-05-09 at 12:10 -0700, Andy Grover wrote:
>>>> From: Mikulas Patocka <mpatocka@redhat.com>
>>>>   
>>>> This is the very simple patch for polling on the
>>>> /dev/mapper/control
>>>> device. The select or poll function waits until any event happens
>>>> on
>>>> any
>>>> dm device since opening the /dev/mapper/control device. When select
>>>> or
>>>> poll returns the device as readable, we must close and reopen the
>>>> device
>>>> to wait for new dm events.
>>>
>>> Why have you done it that way? Couldn't you just save the
>>> dm_global_event_nr at the time poll() is called?
>>
>> I should have read your patch 2/3 before posting ... but I'm still
>> missing why the counter can't simply be set at poll() time.
> 
> If you did that then you would have a race where:
> 
> 1) userspace has recorded events prior to poll()
> 2) an event triggers an increment of dm_global_event_nr before userspace
> calls poll()
> 3) then userspace calls poll() -- only to find that after poll() returns
> multiple events have occurred.
> 
> Which implies missed handling of events.
> 
> But if I'm wrong I'm sure Andy or Mikulas will correct me.

I think getting one readiness notification for multiple events should be ok.

But, the semantics of poll(2) are level-triggered, meaning if a fd is 
ready then it will stay ready through multiple invocations of poll() 
until something is done to satisfy it (e.g. for a TCP socket, read()ing 
all the available data). Therefore we can't make it "edge-triggered" by 
auto-clearing - it has to be a separate action.

my 2c -- Regards -- Andy
