From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: fix dmsetup link failure with --enable-static_link on
	Debian unstable
Date: Fri, 10 Aug 2007 21:08:29 +0100
Message-ID: <20070810200829.GS29894@agk.fab.redhat.com>
References: <873ayrmapd.fsf@meyering.net>
	<20070810200624.GF2064@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070810200624.GF2064@agk.fab.redhat.com>
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

On Fri, Aug 10, 2007 at 09:06:24PM +0100, Alasdair G Kergon wrote:
> Only if dmeventd is enabled?  If so, the check must take that into account.
> If not, I'm curious what's pulling that in.
 
If it's selinux, then restrict pulling it in to the cases when selinux
is enabled.

Alasdair
-- 
agk@redhat.com
