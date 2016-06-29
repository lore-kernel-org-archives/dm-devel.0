From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [BUG] multipath-tools: multipathd/main.c: cannot jump
 from this goto statement to its label
Date: Wed, 29 Jun 2016 15:36:29 +0200
Message-ID: <fcfe982c-4d96-71f7-4a93-93eaeb18322b@gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

spotted by clang-3.8.0:

make[1]: Entering directory '/home/xose/tmp/arrays/multipath-tools.x1/multipathd'
clang -O2 -g -pipe -Wformat-security -Wall -fexceptions -fstack-protector --param=ssp-buffer-size=4 -Wunused -Wstrict-prototypes -fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath
-I../libmpathpersist -I../libmpathcmd -DUSE_SYSTEMD=229 -c -o main.o main.c
main.c:586:3: error: cannot jump from this goto statement to its label
  goto out_unlock;
  ^
main.c:631:38: note: jump bypasses initialization of variable with __attribute__((cleanup))
 do { struct __pthread_cleanup_frame __clframe __attribute__ ((__cleanup__ (__pthread_cleanup_routine))) = { .__cancel_routine = (cleanup_lock), .__cancel_arg = (&vecs->lock), .__do_it = 1 };;
                                     ^
1 error generated.
