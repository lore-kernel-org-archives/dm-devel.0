From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 69/74] libmultipath: disassemble_map(): get
 rid of "is_daemon" argument
Date: Wed, 05 Aug 2020 22:05:19 +0200
Message-ID: <a51ef1b268de27db37386ba05af009f513ecce84.camel@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-17-mwilck@suse.com>
	<20200719052617.GY11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200719052617.GY11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 2020-07-19 at 00:26 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:51:40PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > The reason for the is_daemon parameter in disassemble_map() lies
> > deep in multipath-tools' past, in b96dead ("[multipathd] remove the
> > retry login in uev_remove_path()"): By not adding paths from
> > disassembled maps to the pathvec, we avoided to re-add removed
> > paths on
> > future map reloads (logic in update_mpp_paths()). As we can handle
> > this with
> > INIT_REMOVED now, we don't need to distinguish daemon and non-
> > daemon
> > mode any more. This fixes a memory leak, because only paths which
> > are in
> > pathvec will be freed on program exit.
> 
> I don't have any problems with the code in this patch. I just want to
> reiterate that I don't think that multipathd should automatically be
> adding paths, just because they were in a multipath device.  In my
> opinion, multipathd should have the final decision as to what a
> multipath device should look like.  If it sees an unexpected path,
> and
> runs pathinfo on it, and finds that that path does belong, it's fine
> to
> add it. But if pathinfo says that the path doesn't belong, multipathd
> shouldn't add it to the pathvec. It should instead trigger a reload
> of
> the device to remove path.

Got it. I commented in my reply to 65/74. I'll repost this part with
the minor issues you raised fixed (hopefully). Then let's review /
discuss this again. If we agree on your PoV, we can probably ditch the
whole INIT_REMOVED part of my series.

I hope you agree that "if (!is_daemon)" so deep in libmultipath
is ugly and should be replaced by something cleaner.

We should take the opportunity to agree on a definition on the exact
semantics of pathvec, i.e. which devices should be members of pathvec,
and which ones shouldn't. I don't see a clear, consequent definition
currently.

Martin
