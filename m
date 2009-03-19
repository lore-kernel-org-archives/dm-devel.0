From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 30] Exception Store API Changes - group 2
Date: Thu, 19 Mar 2009 17:01:37 -0500
Message-ID: <1237500097.27055.5.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
List-Id: dm-devel.ids

Prerequisite patches (Exception Store API Changes - group 1):
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%20group1/

This group of patches can be found at:
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%20group2/

These patches form an exception store API that gives device-mapper
snapshots the ability to use different COW device implementations.  The
current set includes 'persistent/P' and 'transient/N'.  Future
implementations include 'shared' and 'cluster-aware'.

The 'shared' exception store implementation is included (patch 30).  It
works as far as 'read-only' snapshots are concerned.  IOW, you can take
snapshots, read and write from the origin, and read from the snapshot...
but you can't write to the snapshots yet.  Instructions for using
snapshots with the shared exception store can be found in patch 30.

 brassow
