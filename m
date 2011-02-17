From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: What is the deal with the partition separator?
Date: Thu, 17 Feb 2011 16:53:32 +0000
Message-ID: <20110217165332.GE28729@agk-dp.fab.redhat.com>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C2793.1020601@cfl.rr.com> <4D5CCE75.5090202@suse.de>
	<4D5D375F.9070106@cfl.rr.com> <4D5D3B34.4000005@suse.de>
	<4D5D3B0F.3050708@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4D5D3B0F.3050708@cfl.rr.com>
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
Cc: Curtis Gedak <gedakc@gmail.com>, serge.hallyn@ubuntu.com, parted-devel@lists.alioth.debian.org, Debian LVM Team <pkg-lvm-maintainers@lists.alioth.debian.org>
List-Id: dm-devel.ids

Partitions should be created only once, in one place.

If a second instance of anything tries to create them too, it should,
by default, detect that they are already there and not proceed.

You should not be able to run kpartx twice on the same underlying
disk with different delimiters without some sort of 'force' option.

(Check by querying /sys/.../holders ?)

Alasdair
