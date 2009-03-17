From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 29] Exception Store API Changes - group 2
Date: Tue, 17 Mar 2009 09:10:02 -0500
Message-ID: <1237299002.16968.19.camel@hydrogen.msp.redhat.com>
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
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%
20group1/

This group of patches can be found at:
http://patchwork.kernel.org/bundle/jbrassow/Exception%20Store%20API%
20group2/

These patches form an exception store API that gives device-mapper
snapshots the ability to use different COW device implementations.  The
current set includes 'persistent/P' and 'transient/N'.  Future
implementations include 'shared' and 'cluster-aware'.

The 'shared' exception store implementation is included (patch 29).  It
compiles, loads, but only partially runs at this point.  There is some
debugging left to do.

There is also one more change I would like to make to the API.  I'd like
to add a 'group' parameter to the lookup_exception as a hint to
exception stores that are "shared" to check that exceptions exist for
all snapshots... not just a specific one.  So, there will be at least
one more revision of this group of patches.

After applying all patches, everything seems to pass my quick tests -
except for the snapshots using the shared exception store.

Please review, test, and offer your thoughts, but bear in mind the
following still needs to be accomplished:
- better patch header and in-line comments
- lookup_exception parameter addition
- shared exception store bug fixing
- sign-off all patches
- other?

 brassow
