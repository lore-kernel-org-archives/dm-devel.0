From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: external hwhandlers build
Date: Tue, 31 Jan 2006 12:23:32 +0100
Message-ID: <20060131112332.GB26120@pundit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello,

I tried to build an out-of-tree hardware handler on a RHEL4u2 with the kernel-smp-devel package installed, but found that some headers are not included : drivers/md/dm-hw-handler.h and drivers/md/dm.h.

I guess they should be included.

Regards,
cvaroqui
