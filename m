From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 5/7] dm mpath: reduce memory pressure when
 requeuing
Date: Tue, 4 Feb 2014 03:27:38 +0000
Message-ID: <11AF7C027C4C02408624617A498607840105D654@BPXM12GP.gisp.nec.co.jp>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-6-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-6-git-send-email-snitzer@redhat.com>
Content-Language: ja-JP
Content-ID: <A33C891B6E9EE84C8CBC31C566DA4511@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 02/04/14 05:28, Mike Snitzer wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> When multipath needs to requeue I/O in the block layer the per-request
> context shouldn't be allocated, as it will be freed immediately
> afterwards anyway.  Avoiding this memory allocation will reduce memory
> pressure during requeuing.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

-- 
Jun'ichi Nomura, NEC Corporation
