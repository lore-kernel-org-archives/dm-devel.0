From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/2] multipath-tools: hwhandler autodetection
Date: Tue, 27 Mar 2018 23:50:51 +0200
Message-ID: <20180327215053.3631-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

This is patch set is a follow-up of the late discussion
"Can we drop 'hardware_handler "1 alua"'?". With patch 1/2 in place,
I think we can - multipath uses the TPGS flag to determine whether
or not the paths support ALUA, and sets the hwhandler accordingly.
Unlike the "detect_checker" and "detect_prio" options, I have coded this
so that explicit "hardware_hander" settings take priority over autodetection,
except for the case in which we determine that TPGS is unsupported.

Thus I don't think an additional "detect_hwhandler" config option is
necessary.

To be actually effective to solve the problems with certain types of IBM IPR
controllers, patch 1/2 must be combined with my previous 
patch "libmultipath: don't reject maps with undefined prio".

Patch 2/2 is just a cleanup that looked logical to do after 1/2.

Martin Wilck (2):
  libmultipath: hwhandler auto-detection for ALUA
  libmultipath/propsel: (re)use static const vars for origin

 libmultipath/propsel.c | 187 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 114 insertions(+), 73 deletions(-)

-- 
2.16.1
