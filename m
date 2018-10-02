From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/2] multipath-tools: unit test fixes
Date: Tue,  2 Oct 2018 20:46:59 +0200
Message-ID: <20181002184701.18956-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Martin Wilck (2):
  multipath/tests: fix hwtable tests after "hidden" support
  multipath-tools: tests/hwtable: test hidden devices

 tests/hwtable.c  | 20 ++++++++++++++++++++
 tests/test-lib.c |  6 ++++++
 tests/test-lib.h |  3 ++-
 3 files changed, 28 insertions(+), 1 deletion(-)

-- 
2.19.0
