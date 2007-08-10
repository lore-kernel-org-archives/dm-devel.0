From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Fri, 10 Aug 2007 14:49:54 +0100
Message-ID: <20070810134954.GC2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B1B5E1.1050406@redhat.com> <46B251BB.1010004@cfl.rr.com>
	<20070807210359.GA2064@agk.fab.redhat.com>
	<46BA2FCC.1040001@cfl.rr.com>
	<20070808214538.GR2064@agk.fab.redhat.com>
	<46BB4E86.7090000@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46BB4E86.7090000@cfl.rr.com>
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
Cc: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 09, 2007 at 01:27:34PM -0400, Phillip Susi wrote:
> Why would it open the other devices?  LVM does not scan /dev/mapper/*, 
> only /dev/sd*.

Upstream lvm2 has done for a long time (since 2.02.00 with quite a few
fixes and tweaks after that, and one known problem still outstanding).
I can't speak for any customisation done in ubuntu or on the machine
with the problem - hence my request for full version and configuration
information.

Alasdair
-- 
agk@redhat.com
