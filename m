From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools clang: two old warnings
Date: Sat, 6 Aug 2016 23:50:59 +0200
Message-ID: <cbfd295b-480f-125e-234e-d63da27f0306@gmail.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

If you have a spare moment, could you check these ten years old warnings?


Thank you.


=== Added in 31528847 "[multipathd] add "show config" CLI command"

make[1]: Entering directory '/mnt/datos/curre/arrays/multipath-tools/libmultipath'
clang -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\"
-Werror -I../libmpathcmd -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DUSE_SYSTEMD=229 -DLIBDM_API_DEFERRED -c -o parser.o parser.c
parser.c:174:12: error: expression which evaluates to zero treated as a null pointer constant of type 'char *' [-Werror,-Wnon-literal-null-conversion]
                                buff = '\0';
                                       ^~~~


=== Added in 70b72117 "[multipath] nice clean up possible now that we store wwids as map uuids"

make[1]: Entering directory '/mnt/datos/curre/arrays/multipath-tools/multipath'
clang -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\"
-Werror -I../libmultipath -I../libmpathcmd -c -o main.o main.c
main.c:215:12: error: address of array 'mpp->wwid' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
                if (mpp->wwid && refwwid &&
                    ~~~~~^~~~ ~~
