From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm: remove pointless comparison
Date: Tue, 07 Jan 2014 18:28:15 +0100
Message-ID: <52CC392F.1070804@gmail.com>
References: <alpine.LRH.2.02.1401062249200.17811@file01.intranet.prod.int.rdu2.redhat.com>
	<20140107103930.GA11734@debian> <20140107155252.GB7983@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140107155252.GB7983@redhat.com>
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
Cc: ejt@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 01/07/2014 04:52 PM, Mike Snitzer wrote:
> On Tue, Jan 07 2014 at  5:39am -0500,
> Joe Thornber <thornber@redhat.com> wrote:
> 
>> On Mon, Jan 06, 2014 at 10:53:28PM -0500, Mikulas Patocka wrote:
>>> Remove pointless comparison in dm_get_from_kobject. The comparison is
>>> always true and the compiler optimizes it out anyway.
>>>gmane.linux.kernel.device-mapper.devel
>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>
>>> ---
>>>  drivers/md/dm.c |    2 --
>>>  1 file changed, 2 deletions(-)
>>>
>>> Index: linux-3.13-rc7/drivers/md/dm.c
>>> ===================================================================
>>> --- linux-3.13-rc7.orig/drivers/md/dm.c	2014-01-07 01:28:27.000000000 +0100
>>> +++ linux-3.13-rc7/drivers/md/dm.c	2014-01-07 01:28:39.000000000 +0100
>>> @@ -2922,8 +2922,6 @@ struct mapped_device *dm_get_from_kobjec
>>>  	struct mapped_device *md;
>>>  
>>>  	md = container_of(kobj, struct mapped_device, kobj);
>>> -	if (&md->kobj != kobj)
>>> -		return NULL;
>>
>> What were they trying to check?  The compiler?
>>
> 
> Milan's commit 784aae735d, and the current dm.c code, offers this
> comment above dm_get_from_kobject:
> 
> /*
>  * struct mapped_device should not be exported outside of dm.c
>  * so use this check to verify that kobj is part of md structure
>  */
> 
> I'm lacking the vision to _know_ why the kobject would suddenly be
> outside of the mapped_device without us knowing via code change..
> 
> The check does seem overly cautious/useless (if we remove it the above
> comment should be removed too).

Yes, please remove both :) The check doesn't make sense.

I think it is just relict of some experiments before I committed this simple
embedded sysfs kobj handling (there were always problems like the missing .release
function you are just solving in other thread).

Milan

 
