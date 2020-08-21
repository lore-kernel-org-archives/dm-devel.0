From: mwilck@suse.com
Subject: [PATCH 0/3]  Fixes for bitfield unit tests
Date: Sat, 22 Aug 2020 00:42:21 +0200
Message-ID: <20200821224224.13536-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

embarassingly, it turns out that my unit test code for the bitfield
code was broken in various ways, which at the same time shows that
I didn't test this as broadly as I should have before submitting.
The good news is that only the test code was broken, not the
implementation itself.

With these fixes, I successfully compiled it on both little and
big endian architectures, with and without glibc 2.27.
(https://build.opensuse.org/package/show/Base:System/multipath-tools)

Regards,
Martin

Martin Wilck (3):
  multipath-tools tests: fix bitfield tests for small fields
  multipath-tools tests: fix bitfield tests for big endian
  multipath-tools tests: fix small bitfield tests for big endian

 tests/util.c | 146 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 120 insertions(+), 26 deletions(-)

-- 
2.28.0
