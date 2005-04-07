From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM Performance
Date: Thu, 7 Apr 2005 13:43:28 +0100
Message-ID: <20050407124328.GP9049@agk.surrey.redhat.com>
References: <425527A0.4040800@tevp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <425527A0.4040800@tevp.net>
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

On Thu, Apr 07, 2005 at 02:29:20PM +0200, Tom Parker wrote:
> 1) Is there any limit on the size of a mapping table? Can hand over a table 
> with 30,000+ entries and expect DM to still work?

Yes, but you might hit hard-coded libdevmapper limit.

> 2) Is there any significant performance degredation with large tables?

Should not be.

> 3) As I understand it, DM stores the mapping tables itself somehow, in a 
> way that is persistant across reboots. 

No, that's one thing lvm2, multipath-tools etc. are for.

Alasdair
-- 
agk@redhat.com
