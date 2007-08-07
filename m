From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Re: LVM on dmraid breakage
Date: Tue, 7 Aug 2007 22:37:14 +0100
Message-ID: <20070807213714.GD2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B1B5E1.1050406@redhat.com> <46B251BB.1010004@cfl.rr.com>
	<46B2798D.8000902@gmail.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-lvm-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B2798D.8000902@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 03, 2007 at 10:40:45AM +1000, David Robinson wrote:
> If you need LVM to only scan certain devices you should modify the 
> filter line in lvm.conf.
 
Yes, this is the current approach: a well-configured system would be
actively modifying the filters (with the help of udev) both on boot and
if device configurations change subsequently.

Alasdair
-- 
agk@redhat.com

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
