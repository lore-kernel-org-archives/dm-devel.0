From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 17:03:52 +0000
Message-ID: <20071211170352.GS22311@agk.fab.redhat.com>
References: <1197389316.25082.27.camel@quest>
	<20071211162538.GR22311@agk.fab.redhat.com>
	<1197391333.25082.31.camel@quest>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1197391333.25082.31.camel@quest>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Tue, Dec 11, 2007 at 04:42:13PM +0000, Scott James Remnant wrote:
> What is that agreed design?
 
In simple terms:

- udev takes over full responsibility for creating nodes
[this will probably be a ./configure option]

- udev provides interface we use to wait until it has finished
processing all the outstanding requests we sent it.

Key point is that our udev requests appear in batches, then we wait for
the batch to complete, as when the system is under memory pressure, udev
userspace may find itself blocked processing the first of the batch
until just before we issue the wait at the end of the batch.
[Note how libdevmapper today pushes all the requests onto an internal
stack and processes them all together at the end.]

Alasdair
-- 
agk@redhat.com
