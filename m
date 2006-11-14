From: Alasdair G Kergon <agk@redhat.com>
Subject: device-mapper patches
Date: Tue, 14 Nov 2006 22:05:33 +0000
Message-ID: <20061114220533.GL6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Userspace patches
=================

I recently configured device-mapper CVS to send patches to this mailing list
whenever code is checked in.  (Commits are relatively infrequent so, unlike
lvm2, it hardly seemed worth setting up a new mailing list for discussion of
them.)


Kernel patches
==============

I wrote some guidelines for device-mapper patches on the new wiki here:
  http://sources.redhat.com/lvm2/wiki/KernelPatchGuidelines

The main point is to aim for short well-documented patches that have a good
chance of being understandable to people who aren't intimately familiar with
the relevant code.

I'm now copying in dm-devel when sending patches upstream.


Alasdair
-- 
agk@redhat.com
