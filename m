From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: Re: StorageWorks failover model (was: tools target
	for SLES9 SP2 and RHEL4 U2)
Date: Sun, 12 Jun 2005 18:37:49 +0200
Message-ID: <1118594269.20754.66.camel@zezette>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<1118345693.14457.30.camel@zezette>
	<20050612122138.GA16608@neu.nirvana>
	<1118579487.20754.59.camel@zezette>
	<20050612143314.GA19762@neu.nirvana>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050612143314.GA19762@neu.nirvana>
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

On dim, 2005-06-12 at 16:33 +0200, Axel Thimm wrote:
> On Sun, Jun 12, 2005 at 02:31:26PM +0200, christophe varoqui wrote:
> > On dim, 2005-06-12 at 14:21 +0200, Axel Thimm wrote:
> > > Hi,
> > > 
> > > On Thu, Jun 09, 2005 at 09:34:53PM +0200, christophe varoqui wrote:
> > > > On jeu, 2005-06-09 at 20:15 +0100, Alasdair G Kergon wrote:
> > > > > On Thu, Jun 09, 2005 at 08:16:42PM +0200, christophe varoqui wrote:
> > > > > > Should we stabilize a 0.4.5 out of the git head
> > > > be aware I broke the StorageWorks failover model to satisfy the
> > > > expressed need to proactively fail paths in the DM when the checkers see
> > > > them going down.
> > > 
> > > What does that mean for StorageWorks users? I'm currently setting up a
> > > StorageWorks EVA3000 from scratch based on FC4 final. Will I stumble
> > > into any pitfalls, or would that only affect gits users?
> > > 
> > 0.4.4 should be ok. I don't know what FC packagers did though.
> 
> It's 0.4.4.2 with a couple of patches. Is that still OK?
> 
I guess yes.
You'll know soon enough in your testing ...

What you have to be careful about is the daemon reinstating paths in the
inactive PG. If it does so, you should be safe.

> > Also be aware you'll be best served using the failover policy for now :
> > there is a 20% performance impact with multi-path per PG.
> 
> The default multipath.conf ships with path_grouping_policy multibus
> (e.g. all 4 paths in one path group on a 2x active/2x failing
> controller setup). I understand that doing round robin over the active
> and failed paths will make performance drop.

> But what about path grouping with group_by_serial (like tur did,
> e.g. an active path group and a failing path group)? Is that eating
> performance, too? So I should prefer a path per PG (failover)?
> 
Yes, there is a performance cost with all topologies involving multiple
paths in 1 PG. True for multibus and group_by_serial in your setup.

multibus as a default is an error, which is corrected in the devel
branch. group_by_serial would be the adequate policy, left alone this
performance problem that will eventually gets sorted out.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
