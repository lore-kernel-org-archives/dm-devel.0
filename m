From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2/7] dm table: add dm_table_run_md_queue_async
Date: Tue, 4 Feb 2014 03:27:30 +0000
Message-ID: <11AF7C027C4C02408624617A498607840105D644@BPXM12GP.gisp.nec.co.jp>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-3-git-send-email-snitzer@redhat.com>
Content-Language: ja-JP
Content-ID: <C5C4EFA2B9D9384FB1EFCFE96D96F8C2@gisp.nec.co.jp>
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
> Introduce dm_table_run_md_queue_async() to run the request_queue of the
> mapped_device associated with a request-based DM table.
> 
> Also add dm_md_get_queue() wrapper to extract the request_queue from a
> mapped_device.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

-- 
Jun'ichi Nomura, NEC Corporation
