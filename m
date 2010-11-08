From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RFC: multipath IO multiplex
Date: Mon, 8 Nov 2010 12:56:38 +0000
Message-ID: <20101108125638.GB15253@agk-dp.fab.redhat.com>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
	<20101106115102.GF10171@agk-dp.fab.redhat.com>
	<20101106165743.GE30809@suse.de>
	<1289125849.2821.5.camel@Nokia-N900-42-11>
	<20101108115028.GH16210@suse.de>
	<20101108121208.GA15253@agk-dp.fab.redhat.com>
	<20101108121941.GK16210@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101108121941.GK16210@suse.de>
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

On Mon, Nov 08, 2010 at 01:19:41PM +0100, Lars Marowsky-Bree wrote:
> I wonder how other latency-sensitive IO handles multipath? Maybe they
> just haven't noticed yet they'd like a facility like this? ;-)
 
As usual, it's the lack of a cancellation interface for incomplete I/O
that seems to make the kernel-side option troublesome: we still have
to wait for timeouts.  Do we prevent more than one I/O being sent
in this mode, given that any other alternative would have races?

Alasdair
