From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] dmraid: use alt_size
Date: Sun, 01 Feb 2009 11:59:30 +0900
Message-ID: <49851012.8070904__45006.3513279476$1233457301$gmane$org@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Mauelshagen@redhat.c
List-Id: dm-devel.ids

Hello again,

This patchset is for dmraid-1.0.0.rc15 and NOT for kernel.  It
contains the following three patches to make dmraid use alt_size if
available.

  0001-dmraid-set-read_info-to-offset-by-default-in-read_.patch
  0002-dmraid-add-alt_size-to-dev_info.patch
  0003-dmraid-make-nv-use-alt_size-if-available.patch

Thanks.

-- 
tejun
