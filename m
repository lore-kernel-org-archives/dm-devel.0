From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH 2/8] rqbased-dm: add block layer hook
Date: Wed, 20 Dec 2006 14:49:24 +0100
Message-ID: <20061220134924.GG10535@kernel.dk>
References: <20061219.171150.75425661.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20061219.171150.75425661.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, mchristi@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 19 2006, Kiyoshi Ueda wrote:
> This patch adds new "end_io_first" hook in __end_that_request_first()
> for request-based device-mapper.

What's this for, lack of stacking?

-- 
Jens Axboe
