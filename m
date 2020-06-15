From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 21/29] docs: device-mapper: add dm-ebs.rst to an index file
Date: Mon, 15 Jun 2020 08:47:00 +0200
Message-ID: <e6195a56b6e7924ccbb7fd07837453530f02e9dc.1592203542.git.mchehab+huawei@kernel.org>
References: <cover.1592203542.git.mchehab+huawei@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1592203542.git.mchehab+huawei@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Solves this Sphinx warning:
	Documentation/admin-guide/device-mapper/dm-ebs.rst: WARNING: document isn't included in any toctree

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/admin-guide/device-mapper/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index ec62fcc8eece..6cf8adc86fa8 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -11,6 +11,7 @@ Device Mapper
     dm-clone
     dm-crypt
     dm-dust
+    dm-ebs
     dm-flakey
     dm-init
     dm-integrity
-- 
2.26.2
