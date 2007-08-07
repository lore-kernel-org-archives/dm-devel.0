From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Tue, 7 Aug 2007 22:53:07 +0100
Message-ID: <20070807215307.GG2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B254E4.60700@cfl.rr.com> <20070803081133.GB939@percy.comedia.it>
	<46B36F7A.2090601@cfl.rr.com>
	<20070803195749.GA27271@percy.comedia.it>
	<46B39E58.2040305@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B39E58.2040305@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, ataraid-list@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 03, 2007 at 05:30:00PM -0400, Phillip Susi wrote:
> Editing a conf file to 
> specify a filter list of devices by name is all well and good for a 
> static system, but it does not play well in the modern udev managed plug 
> and play world.
 
BTW The filters could of course be generated dynamically (from a database) and
supplied on the command line (with --config) - or lvm2 could be extended to
read them from a database.

Alasdair
-- 
agk@redhat.com
