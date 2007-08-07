From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Tue, 7 Aug 2007 22:50:20 +0100
Message-ID: <20070807215020.GF2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B254E4.60700@cfl.rr.com> <20070803081133.GB939@percy.comedia.it>
	<46B36F7A.2090601@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B36F7A.2090601@cfl.rr.com>
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

On Fri, Aug 03, 2007 at 02:10:02PM -0400, Phillip Susi wrote:
> Where does lvm store state 
> information right now?  In conf files in /etc isn't it?  

It uses an untrusted cache in /etc/lvm as hints to speed up its
processing if the hints prove to be still correct.  It can't ever trust
because things can change on the system without lvm2's knowledge.  And
device scanning causes us no end of problems - particularly in a
clustered environment.  The new model should provide us with a
completely-reliable cache.

And why does lvm2 today have to include code to check for partition
tables, md devices, filesystems etc.?

If all these components co-operated through common interfaces there'd be
no need!

Alasdair
-- 
agk@redhat.com
