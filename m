From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 9/9] dm-integrity: recalculate checksums
Date: Tue, 3 Jul 2018 16:53:33 +0200
Message-ID: <e494f8d6-1b82-c346-c375-dc2b8dbd15d2@gmail.com>
References: <20180606153440.580394316@debian.vm>
	<30799a62-b825-4ce4-7b10-044ce8e030da@redhat.com>
	<7af22076-53fe-67d0-fa6e-09acbb145f36@gmail.com>
	<alpine.LRH.2.02.1806271046370.17497@file01.intranet.prod.int.rdu2.redhat.com>
	<20180703132115.GA28076@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180703132115.GA28076@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/03/2018 03:21 PM, Mike Snitzer wrote:
>>
>> Should we even have the possibility to stop recalculating?
>>
>> If the device was recalculating and we activate it without the 
>> "recalculate" flag, what should it do? If the user reads data that haven't 
>> been recalculated yet, we could:
>> 1. return an error
>> 2. ignore the non-recalculated checksum and return data
>> 3. continue with recalculating even if the flag "recalculate" is not present
>>
>> In my opinion, the option 3 is the best. Option 1 makes the device 
>> unreliable and option 2 makes the device silently lose the integrity 
>> protection.
> 
> Yes, option 3.  But you could even error out on table load; though that
> may be too unforgiving.. reality is userspace needs to account for
> staying in recalculating mode until it is complete.

I do not think table load error is the way to go.

Can we activate dmintegrity read-only (for example with read-only backend device)
that is not yet fully recalculated?

This can needed in some recovery scenarios... (But her we can use recovery mode).

> But to do that they'd need to monitor (similar to how snapshot-merge
> polls progress?)

For veritysetup I will just add this to "status" command output.

Milan
