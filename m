From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/3] configuration overhaul and overrides section
Date: Wed,  1 Oct 2014 19:55:56 -0500
Message-ID: <1412211359-24766-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Nir Soffer <nsoffer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch set is an alternative solution to my all_devs patch, which
uses a whole new multipath.conf section. "overrides"

Adding an overrides section to the existing multipath configuration system
would have involved a lot (over 1500 lines) of mostly copy/paste code. Intead
of doing that, I overhauled dict.c and propsel.c to use macros to cut down
on code duplication. This made adding the new section much easier.

Benjamin Marzinski (3):
  libmultipath: rewrite dict.c with function generation macros
  libmultipath: cleanup propsel.c with macros for common actions
  libmultipath: add overrides section to multipath.conf

 libmultipath/config.c      |    6 +-
 libmultipath/config.h      |    1 +
 libmultipath/defaults.h    |    2 -
 libmultipath/dict.c        | 3207 +++++++++++---------------------------------
 libmultipath/dict.h        |    7 +
 libmultipath/pgpolicies.c  |    2 +-
 libmultipath/print.c       |   30 +
 libmultipath/print.h       |    1 +
 libmultipath/propsel.c     |  761 +++++------
 libmultipath/structs.c     |    9 +-
 libmultipath/structs.h     |   44 +-
 multipath.conf.annotated   |   18 +-
 multipath.conf.defaults    |    2 +
 multipath.conf.synthetic   |    3 +
 multipath/main.c           |    6 +
 multipath/multipath.conf.5 |   57 +
 multipathd/cli_handlers.c  |   10 +
 17 files changed, 1270 insertions(+), 2896 deletions(-)

-- 
1.8.3.1
