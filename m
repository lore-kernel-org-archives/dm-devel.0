From: crquan@gmail.com
Subject: [PATCH 0/3] dm-target: target_type improvements
Date: Fri, 19 Dec 2008 12:19:42 +0800
Message-ID: <1229660385-17153-1-git-send-email-crquan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753660AbYLSETW@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Cheng Renquan <crquan@gmail.com>

The series of patches:
1. use module's refcount instead of self-maintained use field;
2. use pointer reference instead of making a copy of target_type;
3. totally remove tt_internal;

The 3rd patch may be controversial,

On Wed, Dec 17, 2008 at 7:48 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> Target registrations should be rare one-off events.  The existing trade-off
> is
> in favour of a cleaner interface (that does not expose private fields).  The
> struct target_type passed to dm_register_target is always static read-only
> data
> and perhaps that could be enforced and a pointer stored in tt_internal
> instead
> of making a copy.

But I still think it's worth it:
1. current users of struct target_type hasn't been marked with const, just
   static;
2. other similar structures (file_system_type in filesystems, packet_type in
   net core, ) all have internally used list_head for manage purpose;
   this design can avoid memory frag from kmalloc/kfree.

--
Cheng Renquan, Shenzhen, China
