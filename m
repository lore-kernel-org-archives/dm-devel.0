From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Wed, 5 Nov 2014 11:29:12 -0500
Message-ID: <20141105162912.GA17625@redhat.com>
References: <20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 05 2014 at  9:37am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> The patch series introduces two suspend mechanisms and it is unclear how 
> should they interact with each other.

And this point is not correct.  As you know dm_internal_suspend and
dm_internal_resume interface predates any of my changes.

That existing interface was extended them to be (mostly) fully formed
equivalents of dm_suspend() and dm_resume().

I say "mostly" because dm_internal_resume() doesn't call into the targets'
resume hooks because no existing callers (dm-stats or dm-thinp) need
to.  But obviously dm_resume() does need to so it passes @resume_targets
as true to __dm_resume().

I'm not trying to suggest there is a bug or bugs in this new code (you
already pointed out the locking issue across ioctls that I fixed).

But a bug doesn't implicitly mean this is an imperfect way forward --
if/when a bug is found we'll deal with it.. so feel free to pour over
this code to see if there is a bug or bugs.  I really do welcome your
review -- I would just like technical issues to be the focus of any
technical review.
