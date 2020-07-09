From: mwilck@suse.com
Subject: [PATCH 00/39] multipath-tools series part II:
	dev_loss_tmo fixes
Date: Thu,  9 Jul 2020 12:19:48 +0200
Message-ID: <20200709101952.7285-1-mwilck@suse.com>
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

This is part II of a larger patch series for multpath-tools I've been preparing.
It contains some minor fixes for dev_loss_tmo handling, mostly logging.
It's based on the previously submitted part I.

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-2007

There are tags in that repo for each part of the series.
This part is tagged "submit-200709-2".

Regards,
Martin


Martin Wilck (4):
  libmultipath: add macro DEV_LOSS_TMO_UNSET
  libmultipath: improve logging for dev_loss_tmo override
  libmultipath: print message if setting dev_loss_tmo is unsupported
  libmultipath: increase log level of limiting dev_loss_tmo

 libmultipath/defaults.h  |  1 +
 libmultipath/dict.c      |  4 +--
 libmultipath/discovery.c | 56 ++++++++++++++++++++++++++++++----------
 libmultipath/propsel.c   |  2 +-
 4 files changed, 46 insertions(+), 17 deletions(-)

-- 
2.26.2
