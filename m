From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer lengths
	for skcipher devices
Date: Wed, 16 Sep 2020 18:40:04 +0000
Message-ID: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: shirley.ma@oracle.com, ssudhakarp@gmail.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

Hi,

This changeset allows processing of unaligned bio requests in dm crypt
for the I/Os generated from a windows guest OS in a QEMU environment. If
this changeset is accepted, then I will be submitting another changeset that
addresses the similar issue in AEAD disks and dm-integrity module.

Thanks
Sudhakar

Sudhakar Panneerselvam (2):
  dm crypt: Allow unaligned bio buffer lengths for skcipher devices
  dm crypt: Handle unaligned bio buffer lengths for lmk and tcw

 drivers/md/dm-crypt.c | 154 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 108 insertions(+), 46 deletions(-)

-- 
1.8.3.1
