From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 1/1] dm: add clone target
Date: Tue, 27 Aug 2019 11:34:47 -0400
Message-ID: <20190827153447.GA3920@redhat.com>
References: <20190709141522.29606-1-ntsironis@arrikto.com>
	<20190709141522.29606-2-ntsironis@arrikto.com>
	<a6d47841-fcbc-50b2-724c-082be9e764d1@redhat.com>
	<e2b23d5c-0ef2-400b-9697-3fb7899ce3e2@arrikto.com>
	<92afa0f6-90ac-7a3f-8d8a-78fa446fec73@redhat.com>
	<d06576ba-2bcf-5e6f-7f4b-5dec61c807b5@arrikto.com>
	<859d881b-2c33-f49d-2fac-fcd8a22810f5@redhat.com>
	<5c127a57-127b-ff2e-c3f6-5cef626b1367@arrikto.com>
	<0a780ffc-c34c-2da4-80d1-8598d116c93f@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0a780ffc-c34c-2da4-80d1-8598d116c93f@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: vkoukis@arrikto.com, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On Tue, Aug 27 2019 at 10:09am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Hello,
> 
> This is a kind reminder for this patch set. I'm bumping this thread to
> solicit your feedback.
> 
> Following the discussion with Heinz, I have provided extensive
> benchmarks that show dm-clone's significant performance increase
> compared to a dm-snapshot/dm-raid1 stack.
> 
> How can we move forward with the review of dm-clone, so it can
> eventually be merged upstream?
> 
> Looking forward to your feedback,

I actually pulled it into my local dm-5.4 branch yesterday and have
started reviewing.  Firrst pass it looks like you've got solid code; a
lot of familiar code patterns too (barrowed from thinp, etc).

But the first thing that is tripping me up is the name "dm-clone"
considering how cloning is so fundamental to all DM.  The second term
that is just awkward is "hydration".  But that is just my initial
thought.  I'll need the rest of the week to really dig in and have more
constructive feedback for you.

Thanks for the ping; wasn't needed in this instance but it never hurts.

Mike
