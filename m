From: Eric Ren <zren@suse.com>
Subject: Re: dm mirror: fix crash caused by NULL-pointer
 dereference
Date: Tue, 27 Jun 2017 13:47:39 +0800
Message-ID: <c046deef-139f-8ca0-390b-9a6251b72dc1@suse.com>
References: <20170626090848.21585-1-zren@suse.com>
	<7ba503ae-ab87-493a-264c-3b42f8418c34@redhat.com>
	<3291473d-1eec-89a7-c3a1-d49c82df500c@suse.com>
	<c01457b7-2178-30c0-ab59-8b059560d598@redhat.com>
	<20170626134335.GA31446@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170626134335.GA31446@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, neilb@suse.com, agk@redhat.com, jtang@suse.com
List-Id: dm-devel.ids

Hi Mike,


On 06/26/2017 09:43 PM, Mike Snitzer wrote:
> On Mon, Jun 26 2017 at  7:49am -0400,
> Zdenek Kabelac <zkabelac@redhat.com> wrote:
>
> [...snip...]
> Jon (cc'd) tested it and found that the original issue wasn't
> reproducible.  But that the commit in question was the source of crashes
> (likely due to needing the fix from this thread).
>
> We can revisit for 4.13 -- but I'll defer to Heinz.
>
> Eric, please share your results from testing the latest 4.12-rc7.
Testing on 4.12-rc7 doesn't crash the kernel.

Sorry for the noise, please ignore this patch. It's still a
confusion to me why backporting this fixes has problem.
Will update this thread, if I find something.

Regards,
Eric

>
> Mike
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
