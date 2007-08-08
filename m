From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Wed, 08 Aug 2007 17:06:03 -0400
Message-ID: <46BA303B.8050301@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>	<20070802065012.GA28687@percy.comedia.it>	<46B254E4.60700@cfl.rr.com>
	<20070803081133.GB939@percy.comedia.it>	<46B36F7A.2090601@cfl.rr.com>	<20070803195749.GA27271@percy.comedia.it>	<46B39E58.2040305@cfl.rr.com>	<20070804065047.GA29541@percy.comedia.it>	<46B733EE.4090507@cfl.rr.com>	<20070807091747.GA20787@percy.comedia.it>
	<20070807220149.GH2064@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070807220149.GH2064@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, ataraid-list@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Tue, Aug 07, 2007 at 11:17:47AM +0200, Luca Berra wrote:
>> 1) disable the automatic vgscan performed by every lvm command
> 
> With access to a 100% accurate external device database instead of the
> existing .cache this is easy.
> The --trustcache argument would be enabled by default on such a system.

It doesn't even need to look somewhere special for a cache, just needs 
to be passed the list of devices on the command line it should open 
rather than generating a list from a readdir() of /dev.
