From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: dm-devel Digest, Vol 18, Issue 2
Date: Tue, 02 Aug 2005 22:27:09 +0200
Message-ID: <1123014429.20148.3.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AB99@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB99@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On mar, 2005-08-02 at 15:07 -0400, goggin, edward wrote:
> On Tue, 02 Aug 2005 09:37:14 -0500
> "Christopher C. Weis" <ccweis@gmail.com> wrote
> 
> > I have a multipath SAN environment with storage controllers that are
> > active/active.  However, the controllers are not active/active at the
> > LUN-level without a performance penalty, meaning if two 
> > servers want to
> > see the same LUN (as in a clustered filesystem environment), they both
> > need to be using the same controller.  I'm trying to figure 
> > out a way to
> > statically "order" the paths so that I can copy a config to all of the
> > nodes using the CFS.
> > 
> > >From what I've read, in a single-server environment with controllers
> > such as the ones I'm dealing with, the path_grouping_policy should be
> > set to "group_by_serial", which should work fine, but in a clustered
> > environment, I need to be sure that the path ordering is the same.
> > 
> > Are there any path_selectors, other than round-robin, that might
> > accomplish this?  Any other ideas?
> > 
> 
> One was is to configure each multipath to have two groups with one group
> having a higher priority than the other based on whether the path accesses
> the fast path controller.  The assignment of the highest priority path group
> is non deterministic when using the "group_by_serial" path grouping policy.
> 
> Seems like you want to use the "group_by_priority" path grouping policy and
> create and get_priority executable which when invoked will return a 1 for
> fast path and 0 for slow path.  See the code for mpath_prio_emc, the
> get_priority executable for the EMC CLARiiON array in
> multipath-tools/path_priority/pp_emc/pp_emc.c.
> 
Yes, also note "group_by_priority" path grouping policy may be overkill
for the context. PG produced by "group_by_serial" can be sorted with an
adequate prioritizer too.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
