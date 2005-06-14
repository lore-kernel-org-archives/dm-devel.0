From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: tools target for SLES9 SP2 and RHEL4 U2
Date: Tue, 14 Jun 2005 14:22:42 +0100
Message-ID: <20050614132242.GP4195@agk.surrey.redhat.com>
References: <1118341002.14457.23.camel@zezette>
	<20050609191541.GO15809@agk.surrey.redhat.com>
	<20050610061033.GA9474@us.ibm.com>
	<20050610104711.GC20162@marowsky-bree.de>
	<20050614103450.GH25295@marowsky-bree.de>
	<20050614114434.GA12019@averon.dyndns.org>
	<20050614120027.GK25295@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050614120027.GK25295@marowsky-bree.de>
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
List-Id: dm-devel.ids

On Tue, Jun 14, 2005 at 02:00:27PM +0200, Lars Marowsky-Bree wrote:
> > Have you pondered backporting the uevent kernel patch : it seems
> > rather safe (from my seat, that is :)
> That might indeed be the cleanest solution. What exactly is needed for
> it to work for multipath-tools?
 
Or produce something in userspace that emulates what uevent is being
used for.
 
Alasdair
-- 
agk@redhat.com
