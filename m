From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Device removal handling
Date: Mon, 11 Jul 2011 16:23:43 +0100
Message-ID: <20110711152343.GG7857@agk-dp.fab.redhat.com>
References: <4E1A079A.9060901@cfl.rr.com>
	<20110710220330.GA7857@agk-dp.fab.redhat.com>
	<4E1B11D5.8050603@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E1B11D5.8050603@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 11, 2011 at 11:08:05AM -0400, Phillip Susi wrote:
> Hardware removal also necessitates bottom up removal, since the initial  

That's back-to-front!  You stop using a device first, then you remove it.
You really don't want to be removing devices while they are in use if you
can avoid it.

If something goes wrong and a device disappears, then yes, that disappearance
should propagate up the stack to be handled as best it can by each layer.

Alasdair
