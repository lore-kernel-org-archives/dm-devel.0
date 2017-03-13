From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] dm: add integrity target
Date: Mon, 13 Mar 2017 13:01:23 +0300
Message-ID: <20170313100123.GA14298@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Mikulas Patocka,

The patch dfab77c854fc: "dm: add integrity target" from Jan 4, 2017,
leads to the following static checker warning:

	drivers/md/dm-integrity.c:2653 dm_integrity_ctr()
	warn: always true condition '(ic->sb->log2_interleave_sectors != -1) => (0-255 != (-1))'

drivers/md/dm-integrity.c
  2647          if (le16_to_cpu(ic->sb->integrity_tag_size) != ic->tag_size) {
  2648                  r = -EINVAL;
  2649                  ti->error = "Invalid tag size";
  2650                  goto bad;
  2651          }
  2652          /* make sure that ti->max_io_len doesn't overflow */
  2653          if (ic->sb->log2_interleave_sectors != -1 && (ic->sb->log2_interleave_sectors < MIN_INTERLEAVE_SECTORS || ic->sb->log2_interleave_sectors > MAX_INTERLEAVE_SECTORS)) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Impossible!  Also this line is really really really long so it doesn't
even fit in my email client.  It's like a million characters long.

  2654                  r = -EINVAL;
  2655                  ti->error = "Invalid interleave_sectors in the superblock";
  2656                  goto bad;
  2657          }
 

regards,
dan carpenter
