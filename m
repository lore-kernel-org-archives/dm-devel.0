From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/2] two multipathd fixes
Date: Tue, 13 Nov 2018 22:30:50 +0100
Message-ID: <20181113213052.2009-1-mwilck@suse.com>
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

Hi Christophe,

Two small fixes, based on my prior submissions which have been
acked by Ben.

Martin

Martin Wilck (2):
  multipathd: fix irritating "minor number mismatch" message
  multipathd: reset delay_wait_checks counter on failure

 multipathd/main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.19.1
