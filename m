From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [RFC PATCH 2/8] rqbased-dm: add block layer hook
Date: Wed, 20 Dec 2006 16:52:46 -0500 (EST)
Message-ID: <20061220.165246.85417944.k-ueda@ct.jp.nec.com>
References: <20061219.171150.75425661.k-ueda@ct.jp.nec.com>
	<20061220134924.GG10535@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061220134924.GG10535@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, mchristi@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Jens,

Sorry for the less explanation.

On Wed, 20 Dec 2006 14:49:24 +0100, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Dec 19 2006, Kiyoshi Ueda wrote:
> > This patch adds new "end_io_first" hook in __end_that_request_first()
> > for request-based device-mapper.
> 
> What's this for, lack of stacking?

I don't understand the meaning of "lack of stacking" well but
I guess that it means "Is the existing hook in end_that_request_last()
not enough?"  If so, the answer is no.
(If the geuss is wrong, please let me know.)

The new hook is needed for error handling in dm.
For example, when an error occurred on a request, dm-multipath
wants to try another path before returning EIO to application.
Without the new hook, at the point of end_that_request_last(),
the bios are already finished with error and can't be retried.

Thanks,
Kiyoshi Ueda
