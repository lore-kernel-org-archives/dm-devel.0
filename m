From: mpatocka@redhat.com
Subject: [patch 0/8] dm-bufio patches
Date: Mon, 26 Mar 2018 20:29:39 +0200
Message-ID: <20180326182939.169591126@debian.vm>
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
To: mpatocka@redhat.com, msnitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending the second version of dm-bufio patches for arbitrary
sector size.

I dropped the patch that removes alloc_pages because it turns out that
alloc_pages is faster than the slab allocator.

I also added a patch that removes struct bio from struct dm_buffer
(reducing the size of dm_buffer to 1/3) and allocates the bio only when
doing read or write.

Mikulas
