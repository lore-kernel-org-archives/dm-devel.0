From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tool: gcc warnings
Date: Sat, 12 Jan 2013 18:00:50 +0100
Message-ID: <50F196C2.4050104@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

hi,

I built multipath-tool with -Wextra and gcc shows a lot
of warnings. But I believe two of them are relevant:

log_pthread.c:37:3: warning: implicit declaration of function =91syslog=92 =
[-Wimplicit-function-declaration]
- missing header <syslog.h>

dasd.c:233:4: warning: comparison is always false due to limited range of d=
ata type [-Wtype-limits]
- wrong type
