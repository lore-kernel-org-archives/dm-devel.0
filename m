From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] dm snapshot: Improve performance using a
 more fine-grained locking scheme
Date: Mon, 18 Feb 2019 10:15:30 -0500
Message-ID: <20190218151530.GA7852@redhat.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
	<763dd7f2-b0c2-ea15-004e-d6b95fce79ca@arrikto.com>
	<alpine.LRH.2.02.1902180936350.17098@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1902180936350.17098@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Nikos Tsironis <ntsironis@arrikto.com>, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On Mon, Feb 18 2019 at  9:37am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 18 Feb 2019, Nikos Tsironis wrote:
> 
> > Hello,
> > 
> > This is a kind reminder for this patch set. I'm bumping this thread to
> > solicit your feedback. Please let me know what else I may need to do for
> > these patches to land in the upcoming merge window for 5.1.
> > 
> > Looking forward to your feedback,
> > 
> > Nikos
> 
> I don't know what to do with those patches.
> 
> The patches make it more complicated, so I can't really say if they are 
> correct or not.

As I mentioned to you before: please do the best you can reasoning
through (and even quantifying on your own) the performance reward these
patches provide.

Then we'll need to make a call on risk vs reward.

Nikos mentioned in another mail on Friday that this dm-snapshot patchset
is a prereq for more dm-snapshot changes he has.  Nikos, if you could
forecast what those additional changes to dm-snapshot are that could
help inform the review process for this initial patchset.

Thanks,
Mike
