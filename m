From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] path latency prio fixes
Date: Sat, 18 Nov 2017 01:11:30 +0100
Message-ID: <20171118001134.26622-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe and Guan,

I was hoping to get down to the review before Christophe committed
your your patch "calculate standard deviation on a logarithmic scale for
prioritizer path_latency". I failed to do this in timely manner, sorry.

But I still have some issues with the patch. Please check these fixes.
I also have remaining issues with the "intermittent IO accounting"
patch, will send these later.

Martin Wilck (4):
  libmultipath: path latency: fix default base num
  libmultipath: path latency: log threshold with p2
  libmultipath: path latency: simplify getprio()
  libmultipath: path latency: remove warnings

 libmultipath/prioritizers/path_latency.c | 112 ++++++++++---------------------
 1 file changed, 34 insertions(+), 78 deletions(-)

-- 
2.15.0
