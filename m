From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: allocate buffer for messages with
	small	number of arguments with GFP_NOIO (resend)
Date: Mon, 30 Sep 2013 21:27:39 +0100
Message-ID: <20130930202739.GG26694@agk-dp.fab.redhat.com>
References: <alpine.LRH.2.02.1309301621170.19187@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1309301621170.19187@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Mon, Sep 30, 2013 at 04:22:32PM -0400, Mikulas Patocka wrote:
> I tried the approach with double scan of the message and no reallocation, 
> but it performs 5% worse on dm-switch table loading. So I stayed with the 
> current approach that does single scan and argv reallocation.

Acked-by: Alasdair G Kergon <agk@redhat.com>

(Testing k.org patchwork)
