From: mwilck@suse.com
Subject: [PATCH 0/2] multipath-tools: disable foreign libraries
	by default
Date: Fri,  8 May 2020 21:33:00 +0200
Message-ID: <20200508193302.11401-1-mwilck@suse.com>
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
Cc: "George, Martin" <Martin.George@netapp.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe,

This is a follow-up to the previous discussion with topic 'RFC:
multipath-tools: NVMe native multipath and default setting for
"enable_foreign"'. Upon Netapp's initiative, I'd asked for foreign
libraries to be disabled by default. Ben had replied he'd agree,
and suggested implementing a "-e" option for multipath to enable
all foreign libraries:

https://www.redhat.com/archives/dm-devel/2020-February/msg00271.html

This patch set implements this idea.

Regards,
Martin


Martin Wilck (2):
  libmultipath: set "enable_foreign" to NONE by default
  multipath: add "-e" option to enable foreign libraries

 libmultipath/defaults.h    |  4 ++--
 multipath/main.c           | 11 ++++++++++-
 multipath/multipath.8      |  6 ++++++
 multipath/multipath.conf.5 |  5 +++--
 4 files changed, 21 insertions(+), 5 deletions(-)

-- 
2.26.2
