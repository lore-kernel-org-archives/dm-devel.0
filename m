From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 20:51:05 +0100
Message-ID: <20050630195105.GB12721@agk.surrey.redhat.com>
References: <d459df3fa77e2c972d837f613a137de5@redhat.com>
	<200506301138.29354.kevcorry@us.ibm.com>
	<20050630175645.GG27078@agk.surrey.redhat.com>
	<81d8053f082764c89f295d2defd3e16c@redhat.com>
	<cf0b6e0fc6f6810b37989e46950fccc8@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <cf0b6e0fc6f6810b37989e46950fccc8@redhat.com>
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

On Thu, Jun 30, 2005 at 02:05:29PM -0500, Jon Brassow wrote:
> I think the pvmove stuff is already busted.  How does it handle mirrors 
> with more than 2 sides?  

It only has to handle 2 devices.

> (ok, so pvmove isn't broken, 

Correct.  No compatibility problems there.

> code that 
> uses the same function to determine a mirrors status would be - lvs?)  

But that can easily be enhanced when needed.

Alasdair
-- 
agk@redhat.com
