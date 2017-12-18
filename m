From: Scott Bauer <scott.bauer@intel.com>
Subject: [PATCH v4 0/2] dm-unstripe
Date: Mon, 18 Dec 2017 10:28:07 -0700
Message-ID: <20171218172809.5826-1-scott.bauer@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids


Change log:

v3->v4:
 Addressed comments from Randy. Modified documentation to be clearer,
 and fixed small off by one in bounds checking in constructor.

v2->v3:

1) Renamed variables in-code to reflect correct terminology with respect
   to the dm-stripe target.

2) Fixed a  __must_check missing check in the constructor.

3) Used correct types for working with sector remaping.

3) Fixed documentation to reflect the correct termonology, like the code.
   Added the test script Keith sent out in an email that makes a striped
   device and uses the un-stripe target to access the underlying loop
   devices.
