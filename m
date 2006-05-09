From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH-RFC] Bug in dm-raid1 as used by pvmove
Date: Tue, 9 May 2006 16:19:58 +0100
Message-ID: <20060509151958.GK16180@agk.surrey.redhat.com>
References: <17504.8384.533148.557081@cse.unsw.edu.au>
	<51da725d31fe6ead1d9f3c13b8a0a746@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <51da725d31fe6ead1d9f3c13b8a0a746@redhat.com>
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

On Tue, May 09, 2006 at 10:00:18AM -0500, Jon Brassow wrote:
> It looks reasonable at first glance, but I have to think about it more. 
>  Do you have a test case that I can reproduce with?

How about you create a device with an enormous zero mapping followed by
a mirror mapping?

> On May 8, 2006, at 11:55 PM, Neil Brown wrote:
> > We will try to get this patch tested on the machine that showed the
> > fault, but I would appreciate any feedback about the patch and I am
> > still not very familiar with this code.

It's not the first time we've found a bug like that:-(
We need to review the rest of the file - on the face of it, more places
look to be missing that adjustment.

> >+	return (bio->bi_sector - rh->ms->ti->begin) >> rh->region_shift;

Alasdair
-- 
agk@redhat.com
