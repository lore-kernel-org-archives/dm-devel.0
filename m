From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Fri, 10 Aug 2007 16:15:57 -0400
Message-ID: <46BCC77D.8070205@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B1B5E1.1050406@redhat.com>
	<46B251BB.1010004@cfl.rr.com>	<20070807210359.GA2064@agk.fab.redhat.com>	<46BA2FCC.1040001@cfl.rr.com>	<20070808214538.GR2064@agk.fab.redhat.com>	<46BB4E86.7090000@cfl.rr.com>
	<20070810134954.GC2064@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070810134954.GC2064@agk.fab.redhat.com>
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

Alasdair G Kergon wrote:
> Upstream lvm2 has done for a long time (since 2.02.00 with quite a few
> fixes and tweaks after that, and one known problem still outstanding).
> I can't speak for any customisation done in ubuntu or on the machine
> with the problem - hence my request for full version and configuration
> information.

It scans everything in /dev and all subdirectories?  Wow that would be 
colossally slow and prone to hang.  Imagine trying to access a nd device 
whose server is down.

In any case, if it did scan the dmraid device, it would just complain 
about finding duplicates; it has no way of knowing which one it should 
use.

Also it looks like feisty used 2.2.06 and the config files shipped in 
the package can be found here:

http://packages.ubuntu.com/feisty/admin/lvm2
