From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 2/4] dm-snapshot-refactor-associations
Date: Thu, 8 Oct 2009 16:14:03 -0500
Message-ID: <491440B6-876B-49BD-B347-4B928FD12F7E@redhat.com>
References: <1254769231-12053-1-git-send-email-snitzer@redhat.com>
	<1254769231-12053-3-git-send-email-snitzer@redhat.com>
	<F284D478-E4DA-4410-AF2B-5343FC4246BB@redhat.com>
	<20091007182433.GB29197@redhat.com>
	<20091008173217.GA11142@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091008173217.GA11142@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


On Oct 8, 2009, at 12:32 PM, Mike Snitzer wrote:

> Jon,
>
> I discussed this with Mikulas and he agreed that the above would work.
> But he raised the fact that reverting dm-snapshot-refactor- 
> associations
> leaves the dm_snapshot and  dm_exception_store structures muddled with
> regard to where per-target members are located.  I'm inclined to agree
> with him.
>
> The dm-snapshot-refactor-associations patch offers cleanup so that:
> 1) dm_exception_store only contains exception store-specific members
> 2) dm_snapshot is the structure that contains per-target members
>
> So while this dm-snapshot-refactor-associations patch could be  
> viewed as
> "avoidable churn" it actually takes the data structures in a more
> controlled direction.
>
> I would rather dm-snapshot-refactor-associations be applied.

Ok, Mike.  Thanks for looking into it.

Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

  brassow
