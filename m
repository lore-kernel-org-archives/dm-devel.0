From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath-tool: gcc warnings
Date: Sat, 12 Jan 2013 20:22:02 +0100
Message-ID: <1358018522.4263.23.camel@lapoo.opensvc.com>
References: <50F196C2.4050104@gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50F196C2.4050104@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: wein@de.ibm.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On sam., 2013-01-12 at 18:00 +0100, Xose Vazquez Perez wrote:
> hi,
> 
> I built multipath-tool with -Wextra and gcc shows a lot
> of warnings. But I believe two of them are relevant:
...
> dasd.c:233:4: warning: comparison is always false due to limited range of data type [-Wtype-limits]
> - wrong type

Stephan,

would you approve this patch to the kpartx dasd parser you contributed
back in 2009 ?

diff --git a/kpartx/dasd.h b/kpartx/dasd.h
index 0ed7c80..42f94db 100644
--- a/kpartx/dasd.h
+++ b/kpartx/dasd.h
@@ -68,7 +68,7 @@ typedef struct volume_label
        char res2[4];           /* reserved                                  */
        char lvtoc[14];         /* owner code for LVTOC                      */
        char res3[28];          /* reserved                                  */
-       char ldl_version;       /* version number, valid for ldl format      */
+       uint8_t ldl_version;    /* version number, valid for ldl format      */
        uint64_t formatted_blocks; /* valid when ldl_version >= f2           */
 } __attribute__ ((packed)) volume_label_t;
 

Best regards,
Christophe Varoqui
