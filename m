From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: directio / readsector0
Date: Tue, 19 Jun 2007 22:08:22 +0200
Message-ID: <1182283702.20149.252.camel@localhost.localdomain>
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

Does someone object to my removing the readsector0 checker and promoting
the directio to the default throne ?

Now that directio is asynchronous, I don't see why we need another
non-scsi checker.

Regards,
cvaroqui
