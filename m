Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E0912C499
	for <dm-devel@lists.linux.dev>; Fri,  8 Nov 2024 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731058822; cv=none; b=EYM7Gpn8wkGBDqkjD+3cqdG5ZMxJn+Hk5waX30JpAVf7OH9wQabhhtVz/om1Ov9HG/u3z3/uXuH4vnL4YZTIZkIbEOqBJmccashqeh93amI1w7GG/x7KcHGtgtK+oJ6TiMjnfquYleTgM8Tp2Yc/Gd7Bl3dAKsUmGJeCPGFqIcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731058822; c=relaxed/simple;
	bh=VE7ZtmTA2RgauIlgQabrVAZcfhXilfwl5mvfgMV1yU8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XcrrPrMXxpmTXjJE1Zte9axbtrMP0nRzTz7sTbTBZFXL5Sd49Ams64yGfbq9AzUrjsM8itzYeWaGEBiJzMAG88ugcvKEreCyFtsliCe5qcQzzGWVnVOHq+9Hh2yN3/ob9/rA0RxkfZUs2q/r5pE1SEGSQTpZnyscGUUW5UeKH2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VYKfIF0u; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYKfIF0u"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d5231f71cso211498f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 08 Nov 2024 01:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731058817; x=1731663617; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cFU4yL5w4o6vZ05/kFwCUnadp/E1GWsPzTDQKu8MwG4=;
        b=VYKfIF0ueqxrZqmuPXF8UHCOMoqPbAoZ4MdW4OUa9bzSYtzaNcgvipb8ZAilexuIke
         Wp/aS9b4yhpo+JtLNIuVNLs5Kv6rI+tD115JyUZFWXKvtIZKljVa6VBr2tgL6IQlot08
         nllJO0Jar2oNFk0R1La+ElikG6SP5SKDXJWlLWoc/aAGr+StreN/cLCwy9cynN5DpZph
         WxDgCuv6WfD3pdnGMq9sneZAOEUw3QQgq8PxgqGqhK+1xLXE1d2sbE6Rj0P1obACVE/i
         SQuhLif9ndOLA+1gs1PfRqNmsalko6PchwHF+0dhfi/KqRG+p2o3aoTdjxtmXIdaMd4p
         ATVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731058817; x=1731663617;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cFU4yL5w4o6vZ05/kFwCUnadp/E1GWsPzTDQKu8MwG4=;
        b=lW/E/Jhj5U9nMGjT2QwpAdn2pVSmOZ9eTyGNOmqJfQB/ovrPkX1do/JytaCprWgNLw
         Aw4YDxOmjqIOL/bxrrUOaFvLgQsKEfuryCBxL5xEdR0ug9XP8zuzF9DsN9rNKFqvnzma
         aPkdTAkS1nphV1oXCjyYu/feHkG833uqdPClgqxPZgybe34jWyB74hYBGRmn47qgFUfY
         5nq3+6txfdYb3l7sgs3V0BRfX6lF5ddMBj2nPtY9llIsl1J7PtJm2WM8M+vdWl0QBb5t
         gHASOWKuegmQMFb40Dip7VM/QaV5Uk5fZcXDR3yUELX/iSVBL4rsQ5EJJ1kNlbsJ/01C
         2sig==
X-Forwarded-Encrypted: i=1; AJvYcCU/uj4ZccY+O8SNyw1RkqjT5iJV5Akcu4poKD6UuXHKtNCCkwCZqOuaeXuJ6qVTjyVUKXDUh03Iyw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxDbh7zUkXf5VeJuqi9asbPpFDWJA57Rx6TwZtE5+HeNVzRzAwI
	Krfbh5uU7Zj6g1Oz3v4oKmWyb4AjJBbs/eWkST304mVcN6y313E=
X-Google-Smtp-Source: AGHT+IEBPfb7bmOqzyoc2dlzyrZC33Xe0/yK/8XLEzkNZd64LKFDV/6PqCP8hNViFOUhH0VvmIgAVA==
X-Received: by 2002:a05:6000:178b:b0:37c:c815:a204 with SMTP id ffacd0b85a97d-381f171441emr747117f8f.3.1731058817031;
        Fri, 08 Nov 2024 01:40:17 -0800 (PST)
Received: from localhost (145.red-81-44-150.dynamicip.rima-tde.net. [81.44.150.145])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed97cd97sm4051152f8f.27.2024.11.08.01.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 01:40:16 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: refresh fsf licences
Date: Fri,  8 Nov 2024 10:40:15 +0100
Message-ID: <20241108094015.383481-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Old licences have been modified, because FSF postal address was changed:
https://lists.gnu.org/archive/html/info-gnu/2024-09/msg00000.html
https://www.fsf.org/blogs/community/fsf-office-closing-party

https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
https://www.gnu.org/licenses/old-licenses/lgpl-2.0.txt
https://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 LICENSES/GPL-2.0  |  9 ++++-----
 LICENSES/LGPL-2.0 | 11 +++++------
 LICENSES/LGPL-2.1 |  9 ++++-----
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/LICENSES/GPL-2.0 b/LICENSES/GPL-2.0
index d159169d..9efa6fbc 100644
--- a/LICENSES/GPL-2.0
+++ b/LICENSES/GPL-2.0
@@ -2,7 +2,7 @@
                        Version 2, June 1991
 
  Copyright (C) 1989, 1991 Free Software Foundation, Inc.,
- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ <https://fsf.org/>
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
@@ -304,8 +304,7 @@ the "copyright" line and a pointer to where the full notice is found.
     GNU General Public License for more details.
 
     You should have received a copy of the GNU General Public License along
-    with this program; if not, write to the Free Software Foundation, Inc.,
-    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+    with this program; if not, see <https://www.gnu.org/licenses/>.
 
 Also add information on how to contact you by electronic and paper mail.
 
@@ -329,8 +328,8 @@ necessary.  Here is a sample; alter the names:
   Yoyodyne, Inc., hereby disclaims all copyright interest in the program
   `Gnomovision' (which makes passes at compilers) written by James Hacker.
 
-  <signature of Ty Coon>, 1 April 1989
-  Ty Coon, President of Vice
+  <signature of Moe Ghoul>, 1 April 1989
+  Moe Ghoul, President of Vice
 
 This General Public License does not permit incorporating your program into
 proprietary programs.  If your program is a subroutine library, you may
diff --git a/LICENSES/LGPL-2.0 b/LICENSES/LGPL-2.0
index 5bc8fb2c..ede5d544 100644
--- a/LICENSES/LGPL-2.0
+++ b/LICENSES/LGPL-2.0
@@ -2,7 +2,7 @@
                        Version 2, June 1991
 
  Copyright (C) 1991 Free Software Foundation, Inc.
- 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+ <https://fsf.org/>
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
@@ -133,7 +133,7 @@ such a program is covered only if its contents constitute a work based
 on the Library (independent of the use of the Library in a tool for
 writing it).  Whether that is true depends on what the Library does
 and what the program that uses the Library does.
-  
+
   1. You may copy and distribute verbatim copies of the Library's
 complete source code as you receive it, in any medium, provided that
 you conspicuously and appropriately publish on each copy an
@@ -463,8 +463,7 @@ convey the exclusion of warranty; and each file should have at least the
     Library General Public License for more details.
 
     You should have received a copy of the GNU Library General Public
-    License along with this library; if not, write to the Free Software
-    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+    License along with this library; if not, see <https://www.gnu.org/licenses/>.
 
 Also add information on how to contact you by electronic and paper mail.
 
@@ -475,7 +474,7 @@ necessary.  Here is a sample; alter the names:
   Yoyodyne, Inc., hereby disclaims all copyright interest in the
   library `Frob' (a library for tweaking knobs) written by James Random Hacker.
 
-  <signature of Ty Coon>, 1 April 1990
-  Ty Coon, President of Vice
+  <signature of Moe Ghoul>, 1 April 1990
+  Moe Ghoul, President of Vice
 
 That's all there is to it!
diff --git a/LICENSES/LGPL-2.1 b/LICENSES/LGPL-2.1
index 4362b491..f6683e74 100644
--- a/LICENSES/LGPL-2.1
+++ b/LICENSES/LGPL-2.1
@@ -2,7 +2,7 @@
                        Version 2.1, February 1999
 
  Copyright (C) 1991, 1999 Free Software Foundation, Inc.
- 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+ <https://fsf.org/>
  Everyone is permitted to copy and distribute verbatim copies
  of this license document, but changing it is not allowed.
 
@@ -484,8 +484,7 @@ convey the exclusion of warranty; and each file should have at least the
     Lesser General Public License for more details.
 
     You should have received a copy of the GNU Lesser General Public
-    License along with this library; if not, write to the Free Software
-    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+    License along with this library; if not, see <https://www.gnu.org/licenses/>.
 
 Also add information on how to contact you by electronic and paper mail.
 
@@ -496,7 +495,7 @@ necessary.  Here is a sample; alter the names:
   Yoyodyne, Inc., hereby disclaims all copyright interest in the
   library `Frob' (a library for tweaking knobs) written by James Random Hacker.
 
-  <signature of Ty Coon>, 1 April 1990
-  Ty Coon, President of Vice
+  <signature of Moe Ghoul>, 1 April 1990
+  Moe Ghoul, President of Vice
 
 That's all there is to it!
-- 
2.47.0

