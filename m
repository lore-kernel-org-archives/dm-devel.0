From: yangerkun <yangerkun@huawei.com>
Subject: [RFC 0/2] introduce interface to list all badblocks
Date: Fri, 5 Jun 2020 15:31:59 +0800
Message-ID: <20200605073201.1742675-1-yangerkun@huawei.com>
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
To: bgurney@redhat.com, agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, yangerkun@huawei.com
List-Id: dm-devel.ids

We can add/remove/query the badblocks, but no interface to list all
badblocks when we want to know the badblocks we ever set still
available. Add message listbadblocks to do this.

To list all bad block list, run the following message command:

    $ sudo dmsetup message dust1 0 listbadblocks

We will get following message(image that we have insert block 1/2, and
we will list the block index in order)::

device-mapper: dust: dust_list_badblocks: badblocks list as below:
    device-mapper: dust: bad block: 1
    device-mapper: dust: bad block: 2
    device-mapper: dust: dust_list_badblocks: badblocks list end.



yangerkun (2):
  dm dust: add interface to list all badblocks
  dm dust: introduce listbadblocks in the rst

 .../admin-guide/device-mapper/dm-dust.rst     | 16 ++++++++++++++
 drivers/md/dm-dust.c                          | 21 +++++++++++++++++++
 2 files changed, 37 insertions(+)

-- 
2.25.4
