From: Eric Engestrom <eric@engestrom.ch>
Subject: [PATCH 06/41] Documentation: device-mapper: fix spelling mistakes
Date: Mon, 25 Apr 2016 01:24:03 +0100
Message-ID: <1461543878-3639-7-git-send-email-eric@engestrom.ch>
References: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Eric Engestrom <eric@engestrom.ch>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
List-Id: dm-devel.ids

Signed-off-by: Eric Engestrom <eric@engestrom.ch>
---
 Documentation/device-mapper/cache-policies.txt | 4 ++--
 Documentation/device-mapper/statistics.txt     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/device-mapper/cache-policies.txt b/Documentation/device-mapper/cache-policies.txt
index e5062ad..e3a2063 100644
--- a/Documentation/device-mapper/cache-policies.txt
+++ b/Documentation/device-mapper/cache-policies.txt
@@ -11,7 +11,7 @@ Every bio that is mapped by the target is referred to the policy.
 The policy can return a simple HIT or MISS or issue a migration.
 
 Currently there's no way for the policy to issue background work,
-e.g. to start writing back dirty blocks that are going to be evicte
+e.g. to start writing back dirty blocks that are going to be evicted
 soon.
 
 Because we map bios, rather than requests it's easy for the policy
@@ -67,7 +67,7 @@ the entries (each hotspot block covers a larger area than a single
 cache block).
 
 All these mean smq uses ~25bytes per cache block.  Still a lot of
-memory, but a substantial improvement nontheless.
+memory, but a substantial improvement nonetheless.
 
 Level balancing:
 MQ places entries in different levels of the multiqueue structures
diff --git a/Documentation/device-mapper/statistics.txt b/Documentation/device-mapper/statistics.txt
index 6f5ef94..170ac02 100644
--- a/Documentation/device-mapper/statistics.txt
+++ b/Documentation/device-mapper/statistics.txt
@@ -205,7 +205,7 @@ statistics on them:
 
   dmsetup message vol 0 @stats_create - /100
 
-Set the auxillary data string to "foo bar baz" (the escape for each
+Set the auxiliary data string to "foo bar baz" (the escape for each
 space must also be escaped, otherwise the shell will consume them):
 
   dmsetup message vol 0 @stats_set_aux 0 foo\\ bar\\ baz
-- 
2.8.0
