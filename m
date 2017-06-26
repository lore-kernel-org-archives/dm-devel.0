From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Mon, 26 Jun 2017 13:49:25 +0200
Message-ID: <c01457b7-2178-30c0-ab59-8b059560d598@redhat.com>
References: <20170626090848.21585-1-zren@suse.com>
	<7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
	<3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
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
To: Eric Ren <zren@suse.com>, dm-devel@redhat.com
Cc: jtang@suse.com, snitzer@redhat.com, neilb@suse.com, agk@redhat.com
List-Id: dm-devel.ids

Dne 26.6.2017 v 12:55 Eric Ren napsal(a):
> Hi Zdenek,
> 
> 
> On 06/26/2017 05:46 PM, Zdenek Kabelac wrote:
>> Dne 26.6.2017 v 11:08 Eric Ren napsal(a):
>>>
>> [... snip...]
>>
>> Hi
>>
>> Which kernel version is this ?
>>
>> I'd thought we've already fixed this BZ for old mirrors:
>> https://bugzilla.redhat.com/show_bug.cgi?id=1382382
>>
>> There similar BZ for md-raid based mirrors (--type raid1)
>> https://bugzilla.redhat.com/show_bug.cgi?id=1416099
> My base kernel version is 4.4.68, but with this 2 latest fixes applied:
> 
> """
> Revert "dm mirror: use all available legs on multiple failures"

Ohh  - I've -rc6 - while this  'revert' patch went to 4.12-rc7.

I'm now starting to wonder why?

It's been a real fix for a real issue - and 'revert' message states
there is no such problem ??

I'm confused....

Mike  - have you tried the sequence from BZ  ?

Zdenek
