From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: fix dmsetup link failure with --enable-static_link on
	Debian unstable
Date: Fri, 10 Aug 2007 21:06:24 +0100
Message-ID: <20070810200624.GF2064@agk.fab.redhat.com>
References: <873ayrmapd.fsf@meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <873ayrmapd.fsf@meyering.net>
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

On Fri, Aug 10, 2007 at 09:49:34PM +0200, Jim Meyering wrote:
> Configuring with --enable-static_link on Debian unstable
> makes dmsetup fail to link:
 
Only if dmeventd is enabled?  If so, the check must take that into account.
If not, I'm curious what's pulling that in.

Alasdair
-- 
agk@redhat.com
