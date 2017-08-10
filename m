From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/7] dm-mpath: Complain about
	unsupported	__multipath_map_bio() return values
Date: Thu, 10 Aug 2017 11:29:55 +0200
Message-ID: <20170810092955.GI24539@lst.de>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
	<20170809183216.526-6-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170809183216.526-6-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 09, 2017 at 11:32:14AM -0700, Bart Van Assche wrote:
> The only behavior change introduced by this patch is that WARN_ON_ONCE()
> is called if __multipath_map_bio() would return an unsupported return
> value.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
