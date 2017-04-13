From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/1] Missing RDAC patch
Date: Thu, 13 Apr 2017 17:39:47 +0200
Message-ID: <20170413153948.26557-1-mwilck@suse.com>
References: <CABr-GncgE=O+XAFENX8fkg9ofa2crk27UuKVTTHKhfwku4k_ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GncgE=O+XAFENX8fkg9ofa2crk27UuKVTTHKhfwku4k_ow@mail.gmail.com>
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
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Hi Cristophe,

I'm sending this on Hannes' behalf now. Sorry we didn't make it for 0.7.0.

Regards,
Martin

Hannes Reinecke (1):
  libmultipath/propsel: Do not select sysfs prioritizer for RDAC arrays

 libmultipath/discovery.c |  2 +-
 libmultipath/discovery.h |  1 +
 libmultipath/propsel.c   | 24 ++++++++++++++++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.12.2
