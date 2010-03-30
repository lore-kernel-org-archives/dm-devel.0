From: Martin Schwenke <martin@meltin.net>
Subject: Re: RHEL 5.4 multipath doesn't handle virtio block
 devices
Date: Tue, 30 Mar 2010 17:23:58 +1100
Message-ID: <20100330172358.69e794b9@martins.ozlabs.org>
References: <20100330121606.54b4a50c@martins.ozlabs.org>
	<4BB186F6.1050402@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BB186F6.1050402@ct.jp.nec.com>
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
Cc: k-ueda@ct.jp.nec.com
List-Id: dm-devel.ids

On Tue, 30 Mar 2010 14:07:02 +0900, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
wrote:

> Why do you want to use dm-multipath on virtio block devices?

For consistency rather than failover...  :-)

I'm using virtual machines to test a clustered NAS environment.  The
production setup expects to see dm devices from dm-multipath.  So I'm
using dm-multipath on virtio block devices to simulate use of
dm-multipath in a SAN environment.  

The RHEL 5.4 version of KVM doesn't contain a SCSI emulation, so the
only 2 choices for large numbers of block devices are virtio and
iSCSI.  I'm trying to keep my options open for both of these.

The fix for virtio block devices seems quite straightforward, so I
thought I would propose it.  :-)

peace & happiness,
martin
