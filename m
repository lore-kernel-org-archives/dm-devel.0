From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 6/6] dm to use bd_claim_by_disk
Date: Mon, 6 Mar 2006 15:56:50 +0000
Message-ID: <20060306155649.GB25317@agk.surrey.redhat.com>
References: <4408E33E.1080703@ce.jp.nec.com> <4408E638.9060704@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4408E638.9060704@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: akpm@osdl.org, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 03, 2006 at 07:58:32PM -0500, Jun'ichi Nomura wrote:
> This patch is part of dm/md sysfs dependency tree.
 
> +static int open_dev(struct dm_dev *d, dev_t dev, struct gendisk *holder)
> +static int upgrade_mode(struct dm_dev *dd, int new_mode, struct gendisk *holder)
> +static void close_dev(struct dm_dev *d, struct gendisk *holder)

Please pass the dm structure, struct mapped_device, around between dm functions
internally where you can, instead of struct gendisk.  (Every time the new 
parameter is passed it's wrapped with dm_disk(), so move the dm_disk() inside.)

Alasdair
-- 
agk@redhat.com
