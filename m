From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 0/3] Device mapper log writes patches
Date: Thu, 19 Mar 2015 16:31:07 -0400
Message-ID: <1426797070-27463-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, zab@redhat.com, fstests@vger.kernel.org
List-Id: dm-devel.ids

Here are my patches for adding the dm-log-writes target to the kernel and the
supporting xfstests to go along with it.  The dm patch has a pretty detailed
documentation file to describe the methodology behind the target and how to use
it.  The xfstest that is generic has been tested on btrfs, xfs and ext4 and
currently fails on all of them in different ways with my kernel (which is just
3.19 so don't be too alarmed).  The btrfs specific one passes currently, more
evil tests will come later.

Basically the idea behind this target and these tests are to give our file
systems a more thorough power fail scenario testing.  The target logs writes in
order that things would have made it safely to disk and then the tests replay
that log in various ways and check the result.

You can find the supporting userspace program here

https://github.com/josefbacik/log-writes

I apologize for it being ugly, I was trying to get it working as quickly as
possible.  There is an example script in there that you can use to do an
exhaustive step by step through a log to make sure your file system is always
consistent.  Thanks,

Josef

