From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/6][RESEND] configuration overhaul and
	find_multipaths
Date: Wed, 19 Nov 2014 00:17:33 -0600
Message-ID: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Since the first time I sent them, they got no response at all, I'm resending
the alternative solution to my all_devs patch, which uses a whole new
multipath.conf section. "overrides"

Adding an overrides section to the existing multipath configuration system
would have involved a lot (over 1500 lines) of mostly copy/paste code. Intead
of doing that, I overhauled dict.c and propsel.c to use macros to cut down on
code duplication. This made adding the new section much easier.

Also, I'm resending my find_multipaths patch, based on the conversation I had
here.

http://www.redhat.com/archives/dm-devel/2014-July/msg00029.html

Just to clarify. find_multipaths is a configurable option that when set to
'yes' will make multipath only run on devices have more than one path.  This
means that users can mostly leave the blacklist alone, and they will only get
the multipath devices that they want. The only time the blacklist is necessary
is when users actually have multiple paths to a device, but still don't want
multipath set up on it.  It's been around since RHEL6, and it is turned on
in the default multipath.conf file in RHEL7. The internal default is "off".

Benjamin Marzinski (6):
  libmultipath: rewrite dict.c with function generation macros
  libmultipath: cleanup propsel.c with macros for common actions
  libmultipath: add overrides section to multipath.conf
  add find_multipaths option
  correctly set partition delimiter on rename
  libmultipath: only add uninitialized paths in check_path

 libmultipath/config.c      |   10 +-
 libmultipath/config.h      |    3 +
 libmultipath/configure.c   |   11 +
 libmultipath/defaults.h    |    3 +-
 libmultipath/devmapper.c   |   14 +-
 libmultipath/dict.c        | 3221 +++++++++++---------------------------------
 libmultipath/dict.h        |    7 +
 libmultipath/discovery.c   |    2 +
 libmultipath/pgpolicies.c  |    2 +-
 libmultipath/print.c       |   30 +
 libmultipath/print.h       |    1 +
 libmultipath/propsel.c     |  761 +++++------
 libmultipath/structs.c     |    9 +-
 libmultipath/structs.h     |   45 +-
 libmultipath/wwids.c       |   26 +
 libmultipath/wwids.h       |    1 +
 multipath.conf.annotated   |   18 +-
 multipath.conf.defaults    |    2 +
 multipath.conf.synthetic   |    3 +
 multipath/main.c           |   33 +-
 multipath/multipath.conf.5 |   57 +
 multipathd/cli_handlers.c  |   10 +
 multipathd/main.c          |    9 +
 23 files changed, 1375 insertions(+), 2903 deletions(-)

-- 
1.8.3.1
