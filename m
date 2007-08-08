From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Wed, 08 Aug 2007 17:00:06 -0400
Message-ID: <46BA2ED6.9090209@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B1B5E1.1050406@redhat.com>
	<46B251BB.1010004@cfl.rr.com>	<46B2798D.8000902@gmail.com>
	<20070807213714.GD2064@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070807213714.GD2064@agk.fab.redhat.com>
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
> On Fri, Aug 03, 2007 at 10:40:45AM +1000, David Robinson wrote:
>> If you need LVM to only scan certain devices you should modify the 
>> filter line in lvm.conf.
>  
> Yes, this is the current approach: a well-configured system would be
> actively modifying the filters (with the help of udev) both on boot and
> if device configurations change subsequently.

No.  The config files are for administrators to modify.  Udev should not 
be automagically messing with things in /etc.
