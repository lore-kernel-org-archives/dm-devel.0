From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2] dm log writes: make sure the log super
 sectors are written in order
Date: Thu, 13 Jun 2019 10:42:25 -0400
Message-ID: <20190613144224.zxvi6tpmzcwsd33c@MacBook-Pro-91.local>
References: <1559741228-96463-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1559741228-96463-1-git-send-email-yi.zhang@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, josef@toxicpanda.com, agk@redhat.com, houtao1@huawei.com
List-Id: dm-devel.ids

On Wed, Jun 05, 2019 at 09:27:08PM +0800, zhangyi (F) wrote:
> Currently, although we submit super bios in log-write thread orderly
> (the super.nr_entries is incremented by each logged entry), the
> submit_bio() cannot make sure that each super sector is written to log
> device in order. So the submitting bio of each super sector may be
> out-of-order, and then the final nr_entries maybe small than the real
> entries submitted.
> 
> This problem can be reproduced by the xfstests generic/455 with ext4,
> which may complained below after running the test:
> 
>   QA output created by 455
>  -Silence is golden
>  +mark 'end' does not exist
> 
> This patch serialize submitting super secotrs to make sure each super
> sectors are written to log disk in order, so that we can prevent the
> latest nr_entries be rewritten by some old super bios.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> Suggested-by: Josef Bacik <josef@toxicpanda.com>
> ---
> Changes since v1:
>  - Switch to use completion instead of wait_queue to synchronize
>    submitting super bios.
> 

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
