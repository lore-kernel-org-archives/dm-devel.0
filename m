From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Missing DM event ?
Date: Thu, 28 Jul 2005 16:25:33 +0200
Message-ID: <20050728142533.GA3321@averon.dyndns.org>
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

I played with the "rename" multipath feature in /sbin/multipath and noticed it doesn't trigger a DM event to the old devmap listeners. Which is quite annoying if we want the daemon to rely on this event to catch a rename initiated by /sbin/multipath.

Don't know if it is expected behaviour ...
Anyway, I finaly went the easy way and did the thing with a remove/add sequence.

Regards,
cvaroqui
