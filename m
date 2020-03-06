From: mwilck@suse.com
Subject: [PATCH 0/4] libmpathpersist allocation size fixes
Date: Sat,  7 Mar 2020 00:06:01 +0100
Message-ID: <20200306230605.3473-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, David Bond <dbond@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe,

We recently found a problem with mpathpersist using an allocation length
of > 8192 bytes for PERSISTENT RESERVE IN/OUT commands. This patch set
tries to fix it. The last patch would change the ABI for external programs,
it's optional.

(Christophe, to avoid misunderstanding:	This set is not meant to be included
in the upcoming merge).

Reviews and comments welcome.

Regards,
Martin

Martin Wilck (4):
  libmpathpersist: limit PRIN allocation length to 8192 bytes
  libmpathpersist: format_transportids(): avoid PROUT overflow
  libmpathpersist: mpath_format_readfullstatus(): use real buffer size
  libmpathpersist: ABI change: limit data-in/out size to 8192 bytes

 libmpathpersist/mpath_persist.h  | 15 ++++++++----
 libmpathpersist/mpath_pr_ioctl.c | 40 +++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 10 deletions(-)

-- 
2.25.1
