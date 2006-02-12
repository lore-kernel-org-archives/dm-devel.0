From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Make sure QUEUE_FLAG_CLUSTER is set properly
	for dm.
Date: Mon, 13 Feb 2006 09:38:11 +1100
Message-ID: <17391.47315.428100.32466@cse.unsw.edu.au>
References: <17302.21846.792776.256696@cse.unsw.edu.au>
	<20051207222755.GM3647@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Alasdair G Kergon on Wednesday December 7
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

On Wednesday December 7, agk@redhat.com wrote:
> On Wed, Dec 07, 2005 at 02:21:58PM +1100, Neil Brown wrote:
> >  the block layer has a flag - QUEUE_FLAG_CLUSTER - which can be set
> 
> Yes, but does it make much difference at the moment, given that we 
> need to use small bios to avoid having to split them if they cross 
> mapping boundaries?  (That's the real problem that needs tackling.)
> 

I'm sorry, I didn't see this back in December... I'm still not used to
these lists that set the 'reply-to' header, so I don't get a reply
explicitly addressed to me.... I've have to make my filters smarter!

Does DM *always* use small bios?  Even for multipath targets, where
presumably there would be no need even to limit the size?

If so, I guess this patch isn't going to make a big difference no, but
it would be worth having it in place for whenever handling larger bios
gets implemented.

Thanks,
NeilBrown
