From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] libdevmapper: (0/6) Filtering feature in
	dm_report
Date: Wed, 18 Apr 2007 12:41:59 -0400
Message-ID: <46264A57.1020800@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,

This series of patches enables dmsetup to control which  types
of devices are listed.
For example, "dmsetup info -c -o name --filter 'parents_count == 0'"
will display top-level dm devices and
"dmsetup info -c --filter 'uuid !~ /^LVM/'" will display
dm devices which are not LVM2 volumes.

As the feature is implemented in libdevmapper, LVM2 is easily
made to use it, too. The patch will be posted to lvm-devel.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
