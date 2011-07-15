From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-crypt: add mapping table option
	to	allowing discard requests
Date: Fri, 15 Jul 2011 02:26:12 +0100
Message-ID: <20110715012611.GD15253@agk-dp.fab.redhat.com>
References: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
	<4E1F9023.5020801@deserettechnology.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E1F9023.5020801@deserettechnology.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Cook <jeff@deserettechnology.com>, device-mapper development <dm-devel@redhat.com>, list@eworm.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

To check the status of a dm patch, look at patchwork in the first instance.

The vast majority of dm patches are submitted to dm-devel.
They are caught by patchwork here:
  https://patchwork.kernel.org/project/dm-devel/list/?state=*

Initially status is 'New'.
Patches that are assigned to 'agk' are deemed ready for me to look at.
I set the status to 'Under Review' when I take a patch into my 'editing' quilt
tree, which is synced onto two independent servers here:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/

At this point the patch will be below the 'next' line (as in 'linux-next') in
the quilt series file, also uploaded there.  The number at the end of the
line is the patchwork patch number.  (Multiple numbers mean I folded
patches together.)

When I've reviewed a patch, I add my sign off, move it into the linux-next
section and set the patchwork state to 'Awaiting Upstream'.

When a group of patches enters the upstream kernel, I set the state to
'Accepted' and 'archived'.

(With some minor patches that I fold into other patches, I sometimes
set the state to 'Accepted' and 'archived' immediately as it's no
longer worth tracking them separately.  The actual patch included
upstream is often not identical to the one in patchwork as I can make
small changes to it for many reasons during review.)

Periodically I take a backup of the patch directory (tagged with the kernel
version) and remove some patches no longer needed (including patches
now upstream).  (Go up the directory hierarchy to see these backups.)

Alasdair
