From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: StorageWorks multipath support
Date: Wed, 15 Jun 2005 15:53:37 +0200
Message-ID: <20050615135337.GG11423@marowsky-bree.de>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
	<20050615134536.GC16446@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050615134536.GC16446@averon.dyndns.org>
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

On 2005-06-15T15:45:36, Christophe Varoqui <christophe.varoqui@free.fr> wrote:

> I'm not attached to the ghost term, but what it describes is here to
> stay.

OK.

> This state has a special treatment in the daemon : paths in this state
> are kept in active state in the DM, instead of proactively being
> failed. This is for the hwhandler to be given a chance to activate a
> PG with only ghost paths in it.

Well, before, those paths were simply kept as "active" / "healthy" (and
from the point of view of the kernel code they are, just that the PG
they are in might not be enabled).

But it makes the status output look nicer of course if those paths are
listed as "ghost" in the user-space.

> If you come with a better term, I'll sure consider it. Maybe "spare" ?

Well, "ghost" or "passive" or "spare", I don't care ;-) I was just
asking.

BTW, backporting uevent is a bit more annoying then I thought. How about
a way to manually prod the daemon? That might be useful in general, for
example if a hotplug event was lost due to whatever reason...


-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
