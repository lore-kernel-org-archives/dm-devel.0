From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: multipath -f/-F exit status
Date: Mon, 15 Dec 2008 17:35:41 +0000
Message-ID: <4946956D.7030800@redhat.com>
References: <20081213125937.2ddc34d6@plop>
Reply-To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081213125937.2ddc34d6@plop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Christophe Varoqui wrote:
>> Hi Folks,
>>
>> Older versions of multipath-tools would always exit with status 0
>> (success) when flushing multipath device maps (-f/-F). This was never
>> guaranteed but happened because the "r" local in multipath/main.c was
>> used uninitialised in these code paths (by chance, it always lands on
>> a freshly zeroed stack page, so although undefined the behaviour was
>> pretty reliable).
>>
>> This was changed by commit 8497928514aa3df6d46f24d8d9b70b086e9fcfbd:
>>
> Then by a9a6c71592d4e2271a38c3d334bee7cbce963cff.
> 
> Does the upstream version works as you expect in this regard ?

Sorry - not sure how I missed that last week.

>> The alternative for -F seems to be to return 0 if all unused maps were
>> flushed and 1 if there were unused maps that could not be flushed.
>> This doesn't seem like a very likely occurrence, but maybe it should
>> be handled separately?
>>
> I guess the current implementation return r as the number failures.

It does, which seems a slightly strange thing to return - I don't see 
how it's useful as it's actually the number of device-mapper maps that 
we couldn't flush (sum of returns from dm_flush_map), i.e. the total 
number of maps that either weren't multipath, weren't unused etc :)

This will cause problems on systems that have 256 such maps since the 
exit status is truncated to 8-bits and we would falsely reported the 
status as zero.

It seems more useful to return an overall success/failure indication for 
these commands and would be more in-keeping with other similar tools and 
POSIX.

Regards,
Bryn.
