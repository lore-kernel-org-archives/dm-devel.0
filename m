From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 16:25:38 +0000
Message-ID: <20071211162538.GR22311@agk.fab.redhat.com>
References: <1197389316.25082.27.camel@quest>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1197389316.25082.27.camel@quest>
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
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Tue, Dec 11, 2007 at 04:08:36PM +0000, Scott James Remnant wrote:
> This is a patch we've written and applied in Ubuntu to improve the
> atomicity of devmapper device creation somewhat, and avoid races with
> udev.
 
BTW I won't be applying this upstream - these nodes are designed to be
managed by libdevmapper not udev so it's not relevant.  I'm awaiting
patches that have been promised to an agreed design that will provide
for correct libdevmapper/udev integration without races/deadlocks etc.

Alasdair
-- 
agk@redhat.com
