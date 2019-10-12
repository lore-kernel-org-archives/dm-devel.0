From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 17/72] libmultipath: uevent_listen(): fix poll()
	retval check
Date: Sat, 12 Oct 2019 21:27:58 +0000
Message-ID: <20191012212703.12989-18-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Only check revents if poll() returns a positive value.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 8f7b2ef5..f128ced2 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -853,7 +853,7 @@ int uevent_listen(struct udev *udev)
 		poll_timeout = timeout * 1000;
 		errno = 0;
 		fdcount = poll(&ev_poll, 1, poll_timeout);
-		if (fdcount && ev_poll.revents & POLLIN) {
+		if (fdcount > 0 && ev_poll.revents & POLLIN) {
 			timeout = uevent_burst(&start_time, events + 1) ? 1 : 0;
 			dev = udev_monitor_receive_device(monitor);
 			if (!dev) {
-- 
2.23.0
