From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/7] dm: add reserved_rq_based_ios module
	parameter
Date: Thu, 12 Sep 2013 19:15:31 -0400
Message-ID: <20130912231531.GD31577@redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-3-git-send-email-snitzer@redhat.com>
	<alpine.LRH.2.02.1309121840470.31794@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1309121840470.31794@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

On Thu, Sep 12 2013 at  6:45pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> I think this is too complicated.
> 
> dm-bufio uses similar approach like this patch - but in dm-bufio the code 
> path is performance critical, we don't want to recalculate memory size 
> with each i/o request.
> 
> Here it is not performance critical, so I'd drop the mutex, drop the 
> latch, drop the function __reserved_request_based_ios_refresh and add only 
> these lines:
> 
> pool_size = ACCESS_ONCE(reserved_rq_based_ios);
> if (!pool_size) pool_size = RESERVED_REQUEST_BASED_IOS;

Could be I'm missing something but isn't the locking about correctness
rather than performance?

Also, using the latch enables the dm_get_reserved_rq_based_ios()
interface that is used in patch 5.

Mike
