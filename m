From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Tue, 7 Aug 2007 22:03:59 +0100
Message-ID: <20070807210359.GA2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B1B5E1.1050406@redhat.com> <46B251BB.1010004@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B251BB.1010004@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 02, 2007 at 05:50:51PM -0400, Phillip Susi wrote:
> The problem is that lvm is looking at the physical disks at all.  It 
> needs to scan the dmraid device, not the underlying disks.
 
Indeed.  Please send the evidence showing where it is going wrong so
we can fix it.

Alasdair
-- 
agk@redhat.com
