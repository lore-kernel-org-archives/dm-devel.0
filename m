From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Thu, 21 Jan 2016 19:33:48 +0200
Message-ID: <CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <569F6F08.1040503@redhat.com>
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

On Wed, Jan 20, 2016 at 1:27 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 20.1.2016 v 11:05 Dennis Yang napsal(a):
>>
>> Hi,
>>
>> I had noticed that I/O requests to one thin device will be blocked
>> when the other thin device is being deleting. The root cause of this
>> is that to delete a thin device will eventually call dm_btree_del()
>> which is a slow function and can block. This means that the device
>> deleting process will need to hold the pool lock for a very long time
>> to wait for this function to delete the whole data mapping subtree.
>> Since I/O to the devices on the same pool needs to held the same pool
>> lock to lookup/insert/delete data mapping, all I/O will be blocked
>> until the delete process finish.
>>
>> For now, I have to discard all the mappings of a thin device before
>> deleting it to prevent I/O from being blocked. Since these discard
>> requests not only take lots of time to finish but hurt the pool I/O
>> throughput, I am still looking for other better solutions to fix this
>> issue.
>>
>> I think the main problem is still the big pool lock in dm-thin which
>> hurts both the scalability and performance of. I am wondering if there
>> is any plan on improving this or any better fix for the I/O block
>> problem.
>
>
> Hi
>
> What is your use case.
>
> You may possibly split the load between several thin-pools ?
>
> Current design is not targeted to simultaneously maintain very large number
> of active thin-volumes within a single thin-pool.

Sorry of the offtopic, but what would constitute a "Very large number"
- 100, 1000s?

>
>
> Zdenek
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
