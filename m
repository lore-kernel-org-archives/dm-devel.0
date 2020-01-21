From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 10/15] libmultipath: change how the checker
 async is set
Date: Tue, 21 Jan 2020 06:49:49 -0600
Message-ID: <20200121124949.GU30153@octiron.msp.redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-11-git-send-email-bmarzins@redhat.com>
	<24099.17365.933723.879139@quad.stoffel.home>
	<20200120150745.GO30153@octiron.msp.redhat.com>
	<24102.2942.443422.59933@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <24102.2942.443422.59933@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: John Stoffel <john@stoffel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

On Mon, Jan 20, 2020 at 03:20:14PM -0500, John Stoffel wrote:
> >>>>> "Benjamin" == Benjamin Marzinski <bmarzins@redhat.com> writes:
> 
> Benjamin> On Sat, Jan 18, 2020 at 12:43:49PM -0500, John Stoffel wrote:
> >> >>>>> "Benjamin" == Benjamin Marzinski <bmarzins@redhat.com> writes:
> >> 
> Benjamin> The way that the checkers async mode worked in multipathd didn't make
> Benjamin> much sense. When multipathd starts up, all checker classes are in the
> Benjamin> sync mode, and any pathinfo() calls on devices would run the checker in
> Benjamin> sync mode. However, the First time a checker class was used in
> Benjamin> checkerloop, it would set that checker class to async (assuming
> Benjamin> force_sync wasn't set).  After that, no matter when a checker from that
> Benjamin> class was called, it would always run in async mode.  Multipathd doesn't
> Benjamin> need to run checkers in sync mode at all, so don't.
> >> 
> >> Sorry, I had a hard time parsing this description, especially the last
> >> sentence.  Do you mean that checkers should default to async then,
> >> instead of sync mode?  And from looking at the code, don't you mean
> >> that you force sync mode?  I guess the question is whether checker
> >> classes should default sync, or async.  And if they move to async,
> >> should they stay there?
> >> 
> 
> Benjamin> Sorry. I mean that right now multipathd runs the checkers from pathinfo(),
> Benjamin> wait_for_pending_paths() and check_path(). When multipathd starts, all
> Benjamin> checkers are in sync mode. The first time a checker is run from
> Benjamin> check_path(), it is switched to async mode, and stays there for the rest
> Benjamin> of the time multipathd is runing.
> 
> Benjamin> There is no need for multipathd to run checkers in sync mode at all, so
> Benjamin> we shouldn't be doing so for these first checks.
> 
> Thanks, that makes the entire issue much more clear.  This raises the
> question of why there is a sync mode at all then?  In any case, the
> above makes the issue more understandable.

The multipath command, which uses the same checkers, runs in sync mode.

-Ben

> 
> John
