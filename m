From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID:  add RAID1 support
Date: Wed, 25 May 2011 10:07:31 -0500
Message-ID: <A0313B08-B60D-4228-B356-E9A21650B31E@redhat.com>
References: <201105241931.p4OJVZWJ006336@localhost6.localdomain6>
	<20110525080552.GB16582@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110525080552.GB16582@infradead.org>
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


On May 25, 2011, at 3:05 AM, Christoph Hellwig wrote:

>> +#ifdef md_raid1_congested
>> +	if (rs->raid_type->level == 1)
>> +		return md_raid1_congested(&rs->md, bits);
>> +#endif
>> +
>> 	return md_raid5_congested(&rs->md, bits);
> 
> How well is this tested?  md_raid1_congested is a not a cpp macro
> in your md patch, so with that patch it never would be called.
> 
> Also I think the congested call really should go through function
> pointer indirections instead of opencoding all possible variants like
> this.

ok.

Indeed, these #if[n]def's mean that RAID1 is not allowed until they are removed.  Thus, the patch doesn't mean much until 1) the necessary changes are made in 'raid1.c' and 2) these macros are removed.  I thought I could be clever and introduce the functionality and have it available when the changes to 'raid1.c' were finished - not quite right.

Anyway, please look over the rest of the patch.  We can delay it until the 'raid1.c' changes are made.

 brassow
