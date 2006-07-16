From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Fix a bug in error path in alloc_dev
Date: Sun, 16 Jul 2006 20:39:09 +0100
Message-ID: <20060716193909.GU26314@agk.surrey.redhat.com>
References: <20060716193030.GA2486@mellanox.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060716193030.GA2486@mellanox.co.il>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ishai Rabinovitz <ishai@mellanox.co.il>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Jul 16, 2006 at 10:30:30PM +0300, Ishai Rabinovitz wrote:
> While reading the code I found a bug in the error path in alloc_dev in dm.c
> When blk_alloc_queue fails there is no call to free_minor.
 
Well spotted!
[I don't like numbered labels BTW - the patch shows why.]
 
Alasdair
-- 
agk@redhat.com
