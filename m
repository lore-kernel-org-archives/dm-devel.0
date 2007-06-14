From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [multipath-tools] asynchronous path checking
Date: Fri, 15 Jun 2007 01:28:43 +0200
Message-ID: <1181863723.20149.194.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I would like to highlight the need to review and comment the direction
of commit 8a9de22b049f332a574eead7fa738678397f47fc in the korg git tree.

http://git.kernel.org/?p=linux/storage/multipath-tools/.git;a=commit;h=8a9de22b049f332a574eead7fa738678397f47fc

This work addresses a long-standing short-coming of the path checking
subsystem, inducing unreliable behaviour in face of over-burdened
storage hardware and long hangs in CLI and multipath.8 interactions.

I posted on linux-scsi ml to try and gather information on SG/AIO
programming, but still no luck. If someone there happen to know the
subject, please feed data.

Regards,
cvaroqui
