From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] block: clean up bdev claim/release
	handling
Date: Thu, 11 Nov 2010 18:14:48 +0100
Message-ID: <4CDC2488.1030801__16541.9121426114$1289495836$gmane$org@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundatio
List-Id: dm-devel.ids

Hello,

I just appended two patches to the series.  These two are the
blkdev_get_by_*() cleanup patches suggested in the fourth patch which
Christoph liked.

I updated the git tree accordingly and added acked-by's.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cleanup-bd_claim

Jens, if you want the whole series resent, please let me know.

Thanks.

-- 
tejun
