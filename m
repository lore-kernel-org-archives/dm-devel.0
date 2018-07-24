From: Jens Axboe <axboe@kernel.dk>
Subject: Re: kill bio_clone_kmalloc and bio_clone_bioset
Date: Tue, 24 Jul 2018 13:43:37 -0700
Message-ID: <8539f366-178d-ee2d-7c24-2bf339f4caff@kernel.dk>
References: <20180724075234.26861-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180724075234.26861-1-hch@lst.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 7/24/18 12:52 AM, Christoph Hellwig wrote:
> Hi all,
> 
> this series removes all but one users of the traditional deep bio clone,
> and then moves bio_clone_bioset to its only caller so that we get rid
> of the deep bio cloning in the block layer API.

Applied for 4.19.

-- 
Jens Axboe
