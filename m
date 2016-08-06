From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: new clang warning
Date: Sat, 6 Aug 2016 23:37:56 +0200
Message-ID: <6d529a59-6178-4568-48ea-c5cc42c6811f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

If you have a spare moment, could you check this new warning?
This code was added recently in bc6dd798
"multipathd: Add 'sysfs' prioritizer"

Thank you.


clang -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\"
-Werror -I../libmpathcmd -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DUSE_SYSTEMD=229 -DLIBDM_API_DEFERRED -c -o discovery.o discovery.c
discovery.c:513:33: error: comparison of constant 18446744073709551615 with expression of type 'unsigned int' is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (value == eptr || preferred == ULONG_MAX) {
                             ~~~~~~~~~ ^  ~~~~~~~~~
