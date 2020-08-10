From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 3/6] libmultipath: remove code duplication in
 path counting
Date: Mon, 10 Aug 2020 16:51:25 -0500
Message-ID: <20200810215125.GO19233@octiron.msp.redhat.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
	<1595877868-5595-4-git-send-email-bmarzins@redhat.com>
	<a8190af67d89edb0819b231417b349e56c3deff1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a8190af67d89edb0819b231417b349e56c3deff1.camel@suse.com>
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
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 06, 2020 at 10:48:12AM +0000, Martin Wilck wrote:
> On Mon, 2020-07-27 at 14:24 -0500, Benjamin Marzinski wrote:
> > pathcountgr() is never used except by pathcount(), and neither is the
> > special case for PATH_WILD. Simplify this and make one function that
> > is
> > used by both pathcount() and count_active_paths(). This will be used
> > again in a future patch.
> > 
> > Also use count_active_paths() in mpath_persist.
> 
> The patch looks correct. I had thought about something like it as well
> when I first introduced count_active_paths(). But count_active_paths()
> is used a *lot*, and often in critical situations. I wonder whether it
> deserves an optimized version. The compiler can surely optimize better
> with two constant expressions than with the additional for-loop over an
> array with variable size. That's why back then I decided against
> implementing it as a special case of a generic function. I actually
> considered inlining count_active_paths().
> 
> It's hard to quantify the effect, and I haven't done any benchmarks. 
> But still, can we perhaps keep the optimized version of
> count_active_paths() itself?

Sure.

-Ben

> 
> Martin
> 
