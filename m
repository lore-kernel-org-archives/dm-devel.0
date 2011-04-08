From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 2/2] multipath-tools: report different piority
 value for rdac if io-shipping is enabled
Date: Fri, 8 Apr 2011 13:06:15 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FFAC96AF@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>
List-Id: dm-devel.ids

This patch adds code to report different priority value if the storage is configured with io-shipping.
It sets  the bit 3 if io-shipping is enabled. This is to differentiate between different modes.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by : Yanling Qi <yanling.qi@lsi.com> 
Reviewed-by : Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>

---
--- multipath-tools/libmultipath/prioritizers/rdac.c.orig	2011-04-01 17:06:25.000000000 -0500
+++ multipath-tools/libmultipath/prioritizers/rdac.c	2011-04-01 17:30:27.000000000 -0500
@@ -81,6 +81,10 @@ int rdac_prio(const char *dev, int fd)
 		break;
 	}
 
+	/* For ioship mode set the bit 3 (00001000) */
+	if ((sense_buffer[8] >> 5) & 0x01)
+		ret |= 0x08;
+
 out:
 	return(ret);
 }
