From: "Olivier B." <dm.list@daevel.fr>
Subject: Re: dm-cache module
Date: Sun, 21 Mar 2010 11:35:02 +0100
Message-ID: <4BA5F656.4030108@daevel.fr>
References: <4BA5623F.8040502@daevel.fr> <20100321033704.GA6448@redhat.com>
Reply-To: dm-devel@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100321033704.GA6448@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 21/03/2010 04:37, Mike Snitzer wrote:
> Such a DM target would be quite useful to have upstream given how
> prevalent SSDs have become.
>    

I'm totally agree with that.


> Just curious: where have you gotten this insight about dm-cache being
> stable and used in production?  That should help dm-cache's cause if it
> is submitted for review.
>    
Well I wrote to Ming before post here, and found comments about the 
module in the project OpenFiler which seem to integrate it : 
https://forums.openfiler.com/viewtopic.php?id=3595


> Writeback support is arguably the most useful aspect of a caching DM
> target so emphasis must be placed on its review/implementation.  Using
> SSD as a persistent writeback cache should afford us much more fault
> tolerance in the face of system crashes during writeback to the slower
> media.
>    

Yes it's also for the writeback feature I'm interested.

I don't think be enough skilled to help for update the code, but maybe I 
can do some tests.

Thanks,
Olivier
