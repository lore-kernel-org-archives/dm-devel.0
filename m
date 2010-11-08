From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RFC: multipath IO multiplex
Date: Mon, 8 Nov 2010 12:12:08 +0000
Message-ID: <20101108121208.GA15253@agk-dp.fab.redhat.com>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
	<20101106115102.GF10171@agk-dp.fab.redhat.com>
	<20101106165743.GE30809@suse.de>
	<1289125849.2821.5.camel@Nokia-N900-42-11>
	<20101108115028.GH16210@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101108115028.GH16210@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Marowsky-Bree <lmb@novell.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Mon, Nov 08, 2010 at 12:50:28PM +0100, Lars Marowsky-Bree wrote:
> I think handling this at the dm-multipath level is cleaner; similarly
> how we handle network bonding (which incidentally has a broadcast mode
> too), instead of requiring every application to go out and open N
> independent channels.
 
Or could it hook into the userspace multipath monitoring code which
already knows the state of the paths?

Well, I'm struggling to see anything clean, simple or generic about
a kernel-side solution here so far.  Seems like a lot of extra kernel
code for just one highly-specialised case: so far I'm unconvinced.

Alasdair
