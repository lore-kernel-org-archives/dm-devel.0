From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Set of patches fixing memory leaks.
Date: Tue, 16 Dec 2008 10:54:52 -0500
Message-ID: <1229442897-3765-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

Here are some patches for some of the memory leaks I've observed                
when using multipathd with large amounts of LUNs and when heavily
re-adding/deleting multipath device mapper maps.           
                                                                                
Most of the fixes are faily simple, but the overall effect is that              
multipathd shrinks from 1.3GB (with 2000 LUNs) down to 60MB.

 libmultipath/configure.c |    5 +++++
 libmultipath/devmapper.c |   18 ++++++++++--------
 libmultipath/memory.c    |    5 ++---
 multipathd/main.c        |    3 +++
 4 files changed, 20 insertions(+), 11 deletions(-)
