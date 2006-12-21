From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Re: [RFC PATCH 1/8] rqbased-dm: allow
	blk_get_request() to be called from interrupt context
Date: Thu, 21 Dec 2006 19:24:32 +0100
Message-ID: <20061221182432.GB17199@kernel.dk>
References: <20061220134848.GF10535@kernel.dk>
	<20061220.125002.71083198.k-ueda@ct.jp.nec.com>
	<20061220184917.GJ10535@kernel.dk>
	<20061220.165549.39151582.k-ueda@ct.jp.nec.com>
	<20061221075305.GD17199@kernel.dk>
	<458ACB69.8000603@cs.wisc.edu> <458ACEB1.3030406@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <458ACEB1.3030406@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, mchristi@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 21 2006, Mike Christie wrote:
> Or the block layer code could set up the clone too. elv_next_request
> could prep a clone based on the orignal request for the driver then dm
> would not have to worry about that part.

It really can't, since it doesn't know how to allocate the clone
request. I'd rather export this functionality as helpers.

-- 
Jens Axboe
