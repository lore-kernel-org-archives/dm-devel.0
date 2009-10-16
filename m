From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/9] barrier support for request-based dm
Date: Fri, 16 Oct 2009 13:52:33 +0900
Message-ID: <4AD7FC11.7030009@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

This patch-set adds barrier support for request-based dm-multipath.
It is made on top of 2.6.32-rc4 + the patches below:
  o http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=a9327cac440be4d8333bba975cbbf76045096275
    (Seperate read and write statistics of in_flight requests)

  o The patches below in the Alasdair's editing tree:
      dm-add-missing-del_gendisk-to-alloc_dev-error-path.patch
      dm-dec_pending-needs-locking-to-save-error-value.patch
      dm-ioctl-prefer-strlcpy-over-strncpy.patch
      dm-trace-request-based-remapping.patch

Most patches are clean-ups and refactorings for preparation of
the last patch.

Please review and apply if no problem.

Summary of the patch-set:
  1/9: dm core: clean up in-flight checking
  2/9: rqdm core: map_request() takes clone instead of orig
  3/9: rqdm core: alloc_rq_tio() takes gfp_mask
  4/9: rqdm core: clean up request cloning
  5/9: rqdm core: simplify suspend code
  6/9: rqdm core: use md->pending for in_flight I/O counting
  7/9: rqdm core: refactor completion functions
  8/9: rqdm core: move dm_end_request()
  9/9: rqdm core: add barrier support

 drivers/md/dm.c |  582 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 323 insertions(+), 259 deletions(-)

Thanks,
Kiyoshi Ueda
