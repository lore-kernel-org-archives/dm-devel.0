From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH-RFC] Bug in dm-raid1 as used by pvmove
Date: Fri, 19 May 2006 10:00:22 +0100
Message-ID: <20060519090022.GY16180@agk.surrey.redhat.com>
References: <17504.8384.533148.557081@cse.unsw.edu.au>
	<17517.7366.969023.850708@cse.unsw.edu.au>
	<e6862225c1d72fa1707005745fa9282f@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e6862225c1d72fa1707005745fa9282f@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, May 18, 2006 at 11:45:09PM -0500, Jon Brassow wrote:
> I've also check to make sure that it doesn't screw anything up when 
> fault tolerance is included (see http://www.brassow.com/mirroring).  We 
> had to check to ensure that if bio_map was called (which alters the bio 
> and takes off the ti->begin) that a later function would not then call 
> the updated bio_to_region - effectively subtracting off ti->begin 
> twice.

This is a small thing I want to consider for the 'next generation' of 
device-mapper.  The dm core should be responsible for subtracting the
offset.  (Many target implementations originally forget to do this.)
 
Alasdair
-- 
agk@redhat.com
