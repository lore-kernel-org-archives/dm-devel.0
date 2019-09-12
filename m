From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/5] use global replacement for dm-bufio buffers
Date: Thu, 12 Sep 2019 10:44:43 +0200
Message-ID: <20190912084443.142319800@debian-a64.vm>
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
To: Martijn Coenen <maco@android.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: maco@google.com, dm-devel@redhat.com, jiyong@google.com, kernel-team@android.com, dariofreni@google.com
List-Id: dm-devel.ids

dm-bufio divides the size of cache by the number of clients and uses it as
a per-client limit. However, this is suboptimal when there is large amount
of clients.

This patch set introduces global buffer replacement. All the buffers from
all the clients are put to a global queue and dm-bufio cleans up old
buffers in the queue.

This improves cache utilization - if one dm-bufio client uses the cache
heavily and another dm-bufio client is not using the cache, dm-bufio will
prefer caching buffers from the first client (instead of partitioning the
cache equally between the first and second client).
