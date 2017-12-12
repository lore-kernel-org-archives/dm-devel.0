From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/3] Three multipath-tools source code cleanup
	patches
Date: Mon, 11 Dec 2017 16:45:00 -0800
Message-ID: <20171212004503.12823-1-bart.vanassche@wdc.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christophe,

The three patches in this series make it easier to compile the multipath-tools
source code with sparse and address two issues discovered by sparse. Please
consider these patches for inclusion in the upstream multipath-tools repository.

Thanks,

Bart.

Bart Van Assche (3):
  Makefile.inc: Allow additional CFLAGS to be specified on the command
    line
  Allow the compiler to verify the consistency of the uxsock_timeout
    definition and declaration
  multipathd/cli.h: Add a header file guard

 Makefile.inc      | 3 ++-
 multipathd/cli.h  | 5 +++++
 multipathd/main.c | 3 +--
 3 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.15.1
