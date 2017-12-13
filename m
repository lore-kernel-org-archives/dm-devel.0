From: Scott Bauer <scott.bauer@intel.com>
Subject: [PATCH v3 0/2] dm-unstripe
Date: Wed, 13 Dec 2017 14:33:30 -0700
Message-ID: <20171213213332.2914-1-scott.bauer@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids



Changes from v2->v3:

1) Renamed variables in-code to reflect correct terminology with respect
   to the dm-stripe target.

2) Fixed a  __must_check missing check in the constructor.

3) Used correct types for working with sector remaping.

3) Fixed documentation to reflect the correct termonology, like the code.
   Added the test script Keith sent out in an email that makes a striped
   device and uses the un-stripe target to access the underlying loop
   devices.
