From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: New git URLs in old repo are wrong
Date: Tue, 21 Aug 2012 11:20:53 +0100
Message-ID: <50336105.7000004@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The URLs for the new git repo in the frozen repo at
http://sources.redhat.com/git/lvm2.git are wrong:

  http://git.fedorahosted.org/git/LVM2.git
  git clone git://git.fedorahosted.org/git/LVM2.git

Both should be lowercase. Not sure it's worth another commit at this
stage but it's a trivial change.

commit 53eeeb279e5196d5998bc86fdb744a49bf9c7829
Author: Bryn M. Reeves <bmr@redhat.com>
Date:   Tue Aug 21 11:19:04 2012 +0100

    Fix URLs for new git repository

diff --git a/README b/README
index ff5fa2a..edc306d 100644
--- a/README
+++ b/README
@@ -4,8 +4,8 @@ NEWS
 On 7th June 2012, we froze this copy of the source code and moved it to
 fedorahosted.org:

-  http://git.fedorahosted.org/git/LVM2.git
-  git clone git://git.fedorahosted.org/git/LVM2.git
+  http://git.fedorahosted.org/git/lvm2.git
+  git clone git://git.fedorahosted.org/git/lvm2.git

 -------------------------------------------------------------------------------
