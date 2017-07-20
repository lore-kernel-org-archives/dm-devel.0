From: Milan Broz <mbroz@redhat.com>
Subject: Re: an optimization for dm-bufio and dm-integrity
Date: Thu, 20 Jul 2017 08:12:55 +0200
Message-ID: <996def54-ae14-f171-4d46-d494a19de10b@redhat.com>
References: <alpine.LRH.2.02.1707191128350.2305@file01.intranet.prod.int.rdu2.redhat.com>
	<20170719153954.GA61594@redhat.com>
	<25f78733-a371-068f-9465-830e65027940@redhat.com>
	<20170719185606.GB20480@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170719185606.GB20480@redhat.com>
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 07/19/2017 08:56 PM, Mike Snitzer wrote:
> On Wed, Jul 19 2017 at 12:22pm -0400,
> Milan Broz <mbroz@redhat.com> wrote:
> 
>> On 07/19/2017 05:39 PM, Mike Snitzer wrote:
>>> On Wed, Jul 19 2017 at 11:30P -0400,
>>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>
>>>> Hi Mike
>>>>
>>>> Some times ago, I sent this patch as dm-bufio optimization (it doesn't 
>>>> have to write full buffers, it only writes a part of the buffer that 
>>>> changed). You delayed the patch until the next kernel.
>>>>
>>>> Will you submit the patch to the current kernel?
>>>
>>> Sorry about that.  It obviously fell off my radar.
>>>
>>> I'll review it and see if I can make the justification for it going into
>>> 4.13-rc2.  But unfortunately the 4.13 merge window closed this past
>>> Sunday when Linus released v4.13-rc1
>>>
>>> I'll let you know though, thanks.
>>
>> Just FYI: I am just running some tests with the stack space fix and
>> this patch and the performance improvement for 4k sectors is really big
>> (compared to 4.12).
> 
> If you could quantify the performance improvement that would be helpful.

The linear write performance (4k blocks) with data journal and 4k sectors
(well, everyone likes "dd" tests ;-) went from 40MB/s to 130 MB/s on a SSD
(both for AEAD and standalone mode with CRC32).

I think it is mainly thanks to the first patch (that is already marked for stable).
 
> Are you also using the plugging patch?

Not yet, Mikulas sent it later :) Once the whole run is finished, I'll add it to the mix.

Thanks,
Milan



 
