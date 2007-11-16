From: Dushyanth <dushyanth@gmail.com>
Subject: Re: LVM2, Multipath & iSCSI Volumes
Date: Fri, 16 Nov 2007 13:50:49 +0000 (UTC)
Message-ID: <loom.20071116T134827-642@post.gmane.org>
References: <loom.20071116T082815-74@post.gmane.org>
	<000201c82853$cf63cd00$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hey,

> > After start iscsi initiator i created a primary partition (type set to LVM)
using parted on sdb, sdc and sde.

> I strongly suggest to avoid partitioning and using directly LVM2 on top of
> whole disk.

This works like a charm.

Thanks a lot..
Dushyanth
