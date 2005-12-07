From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Make sure QUEUE_FLAG_CLUSTER is set properly
	for dm.
Date: Wed, 7 Dec 2005 22:27:55 +0000
Message-ID: <20051207222755.GM3647@agk.surrey.redhat.com>
References: <17302.21846.792776.256696@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <17302.21846.792776.256696@cse.unsw.edu.au>
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

On Wed, Dec 07, 2005 at 02:21:58PM +1100, Neil Brown wrote:
>  the block layer has a flag - QUEUE_FLAG_CLUSTER - which can be set

Yes, but does it make much difference at the moment, given that we 
need to use small bios to avoid having to split them if they cross 
mapping boundaries?  (That's the real problem that needs tackling.)

Alasdair
-- 
agk@redhat.com
