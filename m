From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Multipath target does not shift block offset?
Date: Thu, 10 Feb 2005 17:18:32 +0000
Message-ID: <20050210171832.GC14093@agk.surrey.redhat.com>
References: <420AEAE4.8090506@anu.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <420AEAE4.8090506@anu.edu.au>
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

On Thu, Feb 10, 2005 at 04:02:28PM +1100, Tim Burgess wrote:
> However, dm appears to be trying 
> to map the range 286749488-573498975 of the dm device to the same 
> offsets in the sde/sdm device.
 
> Is this what was intended?
 
No.

In dm-mpath.c try adding to multipath_map() at the top of the function:

  bio->bi_sector = (bio->bi_sector - ti->begin);

Alasdair
-- 
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
