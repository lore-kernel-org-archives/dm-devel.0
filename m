From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [RFC][multipath-tools] device nodes
Date: Mon, 26 Sep 2005 00:01:07 +0200
Message-ID: <1127685667.26246.13.camel@zezette>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

Hello,

I strongly question the need to keep the multipath.dev udev trigger
around : it was initially intented to create a meaningful name in /dev
for a new multipath map. But a meaningful name is what appears
in /dev/mapper/ anyway.

Can we all agree to use those /dev/mapper/ nodes for multipath ?

If so, I'll also kill the devmap_name/ source subtree, redundant with
dmsetup(8) and whose slimness just lost interest.

Regards,
cvaroqui
