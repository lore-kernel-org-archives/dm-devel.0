From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/3] Remove path-selector's dependency to dm-mpath
Date: Thu, 10 Apr 2008 15:48:19 -0400 (EDT)
Message-ID: <20080410.154819.71084314.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: agk@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair and List,

This patch-set removes path-selector's dependency to dm-mpath.
No functional change.

So we can share the same path selector for multipath target
with other targets.

It might be better to find a different word than 'path' because
it's no longer about 'path'.
I left the names unchanged to avoid bloating the patches.
If you have a good idea, please let me know.

Any comments are very appreciated.

If no problem, please apply.
The patch-set was created on top of 2.6.25-rc8.

Thanks,
Kiyoshi Ueda
