From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Thin provisioning bug in interface
Date: Mon, 19 Sep 2011 15:42:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109191534370.26904@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1109191245060.17525@hs20-bc2-1.build.redhat.com>
	<20110919171138.GD1842@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110919171138.GD1842@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Edward Thornber <thornber@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, 19 Sep 2011, Alasdair G Kergon wrote:

> On Mon, Sep 19, 2011 at 12:59:42PM -0400, Mikulas Patocka wrote:
> > if you destroy the pool target (reload it with empty table or something 
> > like that) --- the pool structure can't be freed from memory (because a 
> > thin device is open) and it is still active. 
> 
> You shouldn't be able to destroy the pool target while it is in use.
> (When I last looked at it a few weeks ago, I thought the target line
> parameters were OK, but just that we'd not fixed every possible usage
> sequence/handover yet.)

I am just concerned that this is bloating dm core with more code. 
dm-get-md and singleton is already a bloat (it exposes something that 
wasn't expected to be exposed to the targets) and now you need to add more 
bloat to prevent a cresh when the user reloads 'pool' table without pool 
target.

If you designed it just like the old snapshots, there would be no need for 
any dm core change.

Mikulas

> Alasdair
> 
