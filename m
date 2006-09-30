From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/4] dm-userspace fixes
Date: Sat, 30 Sep 2006 19:44:28 +0900
Message-ID: <200609301044.k8UAiYL3013330@r-dd.iij4u.or.jp>
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
To: dm-devel@redhat.com
Cc: danms@us.ibm.com
List-Id: dm-devel.ids

Some patches against Dan's latest dm-userspace work (posted at
2006/09/28):

http://www.redhat.com/archives/dm-devel/2006-September/msg00115.html


The first three patches are cleanups and fixes. The last patch is an
updated version of the mmapped buffer patch for performance
comparisons (I also fixes some bugs in the previous version).
