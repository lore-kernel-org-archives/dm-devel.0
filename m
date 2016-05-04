From: Todd Gill <tgill@redhat.com>
Subject: [PATCH 0/1] add option to output JSON for multipathd
	command
Date: Wed,  4 May 2016 16:23:47 -0400
Message-ID: <1462393428-13929-1-git-send-email-tgill@redhat.com>
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
To: dm-devel@redhat.com
Cc: Todd Gill <tgill@redhat.com>
List-Id: dm-devel.ids

Hi,

I had earlier sent an email to dm-devel proposing we add a feature
in multipathd to output multipath map topology in JSON format. This
patch contains to the code for that feature.

Having an option for the  CLI to output in JSON would allow higher
level applications to more easily monitor/manage multipath.

I thought it was best to take advantage of some of the existing
snprintf_xxx functions rather than adding a library dependency
to multipathd.

Will add code for groups next if this is accepted.

Thanks,
Todd

Todd Gill (1):
  add display of map information in JSON format

 libmultipath/print.c      | 122 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.h      |  50 +++++++++++++++++++
 multipathd/cli.c          |   3 ++
 multipathd/cli.h          |   2 +
 multipathd/cli_handlers.c |  93 +++++++++++++++++++++++++++++++++++
 multipathd/cli_handlers.h |   2 +
 multipathd/main.c         |   2 +
 7 files changed, 274 insertions(+)

-- 
2.5.5
