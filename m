From: Ming Lei <ming.lei@redhat.com>
Subject: Re: dm_set_target_max_io_len
Date: Thu, 21 Mar 2019 19:14:58 +0800
Message-ID: <20190321111457.GA23305@ming.t460p>
References: <alpine.LRH.2.02.1903210621110.17154@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1903210621110.17154@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On Thu, Mar 21, 2019 at 06:33:32AM -0400, Mikulas Patocka wrote:
> Hi
> 
> I'm looking at the patch 8f50e358153dd68182c714626be4a90b64179cf4. The 
> patch claims that dm-crypt can't deal with large bios - but I fixed this 
> problem with dm-crypt a year before (see the patch 
> 4e870e948fbabf62b78e8410f04c67703e7c816b). Was my fix for dm-crypt 
> inefficient? Can you provide some test where dm-crypt fails with big bios?

Sorry for missing the commit 4e870e948fbabf62b78e8410f04c67703e7c816b.

> 
> Should 8f50e358153dd68182c714626be4a90b64179cf4 be dropped? The variable 

Yeah, I think so.

Thanks,
Ming
