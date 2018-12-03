From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 20/24] libmultipath: avoid syslog loglevel >
	LOG_DEBUG
Date: Mon,  3 Dec 2018 20:36:20 +0100
Message-ID: <20181203193624.21870-3-mwilck@suse.com>
References: <20181203193624.21870-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181203193624.21870-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

We use condlog(5, ...) in some places, which doesn't work well
with syslog.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/log_pthread.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index bb35dfc7..be57bb1a 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -25,6 +25,9 @@ static int log_messages_pending;
 
 void log_safe (int prio, const char * fmt, va_list ap)
 {
+	if (prio > LOG_DEBUG)
+		prio = LOG_DEBUG;
+
 	if (log_thr == (pthread_t)0) {
 		vsyslog(prio, fmt, ap);
 		return;
-- 
2.19.1
