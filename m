From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm thin pool discarding
Date: Thu, 10 Jan 2019 16:08:15 +0100
Message-ID: <b62b708f-f7ac-d04a-c536-1881d3a8fad7@redhat.com>
References: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
	<ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
	<46a8e85e0258cd8ccc328052a428fff0cbdd5ad3.camel@suse.de>
	<db63baea-269e-e331-a34b-acdffd62839e@redhat.com>
	<7f57a14868a8d365668d7dde9b3aac92e1ffdf64.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7f57a14868a8d365668d7dde9b3aac92e1ffdf64.camel@suse.de>
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
To: Martin Wilck <mwilck@suse.de>, james harvey <jamespharvey20@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 10. 01. 19 v 14:41 Martin Wilck napsal(a):
> On Thu, 2019-01-10 at 12:52 +0100, Zdenek Kabelac wrote:
>> Dne 10. 01. 19 v 12:40 Martin Wilck napsal(a):
>>>
>>    > So far my understanding was that even without zeroing, an LVM
>> thin
>>> volume could be considered as a drive with "discard zeroes data"
>>> property. If there's a flaw in the argument below, please point it
>>> out
>>> to me.
>>>
>>
>> As said - if you discard 'less then aligned' chunk - nothing happens,
>> so it cannot be takes as like it would be always zeroing...
> 
> Yuck, that's the Catch-22 then. Sorry for having missed that on the
> first pass. Wouldn't it be wise to fail discard (or only zeroout?)
> requests which aren't chunk-aligned, rather than just doing nothing?
> 
> I for one would find it very attractive if dm-thin had a mode
> supporting fast zeroout.


I believe '/sys/block/*/queue/discard_zeroes_data  is now always returning 
false for any device as it's been considered as unreliable logic.

So using 'discard' for zeroing is not really an option here.

Zdenek
