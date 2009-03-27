From: christophe.varoqui@free.fr
Subject: Re: multipathd segfault
Date: Fri, 27 Mar 2009 23:53:04 +0100 (CET)
Message-ID: <878262772.1795731238194384113.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <49CC8546.9080500@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49CC8546.9080500@suse.de>
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

Applied.


diff --git a/multipathd/main.c b/multipathd/main.c
index 7c995b6..1d8ff5a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -652,7 +652,7 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 static int
 uev_discard(char * devpath)
 {
-	char a[10], b[10], *c;
+	char a[11], b[11], *c;
 
 	/*
 	 * keep only block devices, discard partitions
