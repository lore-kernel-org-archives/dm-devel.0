From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bug 5297] New: Memory problem with kcopyd under
 LVM2 lvremove execution and copying data at the same time.
Date: Fri, 23 Sep 2005 11:56:22 -0700
Message-ID: <20050923115622.384937eb.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


This is purportedly a post-2.6.14-rc1 regression?


Begin forwarded message:

Date: Fri, 23 Sep 2005 04:04:20 -0700
From: bugme-daemon@kernel-bugs.osdl.org
To: akpm@osdl.org
Subject: [Bug 5297] New: Memory problem with kcopyd under LVM2 lvremove execution and copying data at the same time.


http://bugzilla.kernel.org/show_bug.cgi?id=5297

            Summary: Memory problem with kcopyd under LVM2 lvremove execution
                     and copying data at the same time.
