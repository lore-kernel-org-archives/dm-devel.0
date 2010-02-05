From: "--[ UxBoD ]--" <uxbod@splatnix.net>
Subject: GIT fails to compile
Date: Fri, 5 Feb 2010 09:30:32 +0000 (GMT)
Message-ID: <17162868.1221.1265362232061.JavaMail.root@office.splatnix.net>
Reply-To: "--\[ UxBoD \]--" <uxbod@splatnix.net>,
        device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Try to compile from GIT under:

Linux xxxxxxxxx 2.6.29.1 #1 SMP Sat Apr 11 20:03:55 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux

and CentOS 5.4 and receive the following error:

cc -pipe -g -Wall -Wunused -Wstrict-prototypes -fPIC -DLIB_STRING=\"lib64\" -I../libmultipath -c -o main.o main.c
main.c: In function ?child?:
main.c:1443: error: ?pthread_mutex_t? has no member named ?depth?
main.c:1443: error: ?pthread_mutex_t? has no member named ?mutex?
make[1]: *** [main.o] Error 1

I did not see anything to say that a include or library was missing ?

-- 
Thanks, Phil
