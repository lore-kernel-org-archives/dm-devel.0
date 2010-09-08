From: Tejun Heo <teheo@suse.de>
Subject: Re: [PATCHSET #upstream] block,
 fs: replace HARDBARRIER with FLUSH/FUA, take#2
Date: Wed, 08 Sep 2010 18:12:18 +0200
Message-ID: <4C87B5E2.6070207__7358.97897179729$1283962447$gmane$org@suse.de>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Hello, Jens.

I added Mike's cleanup patch and Kiyoshi's Tested-by and updated
flush-fua branch accordingly.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git flush-fua

I guess it's about ready.  Please consider pulling it into the block
tree so that it can get linux-next exposure.  If you want the whole
patch series resent, please let me know.

Thanks.

-- 
tejun
