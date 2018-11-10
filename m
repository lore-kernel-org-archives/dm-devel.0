From: shenghui <shhuiw@foxmail.com>
Subject: unnecessary "memset(n, 0, block_size);
	" in dm_btree_empty ?
Date: Sat, 10 Nov 2018 19:49:50 +0800
Message-ID: <9118.98302515528$1542014990@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <dm-devel@redhat.com>
Cc: thornber@redhat.com, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

Hi,

Sorry to trouble you.

I'm reading the code of persistent data, and noticed:

dm_btree_empty() -> new_block() -> dm_tm_new_block() to get a new block allocated.
And the new block is zeroed with write lock held.

"memset(n, 0, block_size);" in dm_btree_empty() seems unnecessary. Right?

Thanks,
shenghui
