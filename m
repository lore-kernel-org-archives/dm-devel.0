From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/7] dm: Fix the second dec_pending()
	argument in	__split_and_process_bio()
Date: Thu, 10 Aug 2017 11:28:48 +0200
Message-ID: <20170810092848.GF24539@lst.de>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
	<20170809183216.526-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170809183216.526-2-bart.vanassche@wdc.com>
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

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
