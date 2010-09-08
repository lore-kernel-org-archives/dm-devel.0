From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 24/41] dm: implement REQ_FLUSH/FUA support for request-based
 dm
Date: Wed, 08 Sep 2010 10:46:15 +0900
Message-ID: <4C86EAE7.607@ct.jp.nec.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-25-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1283509796-1510-25-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, snitzer@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

Hi Tejun,

On 09/03/2010 07:29 PM +0900, Tejun Heo wrote:
> This patch converts request-based dm to support the new REQ_FLUSH/FUA.

I reviewed this patch and found no obvious problem.
Also, I tested this patch series using request-based dm-multipath +
ext3/ext4 and found no problem.

Tested-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Thanks,
Kiyoshi Ueda
