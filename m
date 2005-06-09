From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: tools target for SLES9 SP2 and RHEL4 U2
Date: Thu, 09 Jun 2005 21:34:53 +0200
Message-ID: <1118345693.14457.30.camel@zezette>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050609191541.GO15809@agk.surrey.redhat.com>
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

On jeu, 2005-06-09 at 20:15 +0100, Alasdair G Kergon wrote:
> On Thu, Jun 09, 2005 at 08:16:42PM +0200, christophe varoqui wrote:
> > Should we stabilize a 0.4.5 out of the git head
> 
> Yes - both distributions are basing their next package on your 
> current git head.
> 
ok,

be aware I broke the StorageWorks failover model to satisfy the
expressed need to proactively fail paths in the DM when the checkers see
them going down.

StorageWorks hardware relied on the daemon to keep the paths in failover
path groups to be in active state. That is no longer the case, now that
we keep the DM path state in sync with checker states.

I guess to correct way to get back to a working model is to implement
the DM path activation in a hardware handler. Dave Olien and Mike
Christie have worked on such a handler. It needs debuging and testing.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
