From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: StorageWorks failover model (was: tools target for
	SLES9 SP2 and RHEL4 U2)
Date: Sun, 12 Jun 2005 14:31:26 +0200
Message-ID: <1118579487.20754.59.camel@zezette>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<1118345693.14457.30.camel@zezette>
	<20050612122138.GA16608@neu.nirvana>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050612122138.GA16608@neu.nirvana>
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

On dim, 2005-06-12 at 14:21 +0200, Axel Thimm wrote:
> Hi,
> 
> On Thu, Jun 09, 2005 at 09:34:53PM +0200, christophe varoqui wrote:
> > On jeu, 2005-06-09 at 20:15 +0100, Alasdair G Kergon wrote:
> > > On Thu, Jun 09, 2005 at 08:16:42PM +0200, christophe varoqui wrote:
> > > > Should we stabilize a 0.4.5 out of the git head
> > be aware I broke the StorageWorks failover model to satisfy the
> > expressed need to proactively fail paths in the DM when the checkers see
> > them going down.
> 
> What does that mean for StorageWorks users? I'm currently setting up a
> StorageWorks EVA3000 from scratch based on FC4 final. Will I stumble
> into any pitfalls, or would that only affect gits users?
> 
0.4.4 should be ok. I don't know what FC packagers did though.

Also be aware you'll be best served using the failover policy for now :
there is a 20% performance impact with multi-path per PG.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
