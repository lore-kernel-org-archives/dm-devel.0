From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: Unable to build MPT 0.4.9
Date: Mon, 24 May 2010 17:10:19 +0200
Message-ID: <4BFA96DB.8090101@redhat.com>
References: <13799941.598.1274705554197.JavaMail.root@office.splatnix.net>
	<4BFA8F59.4040805@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BFA8F59.4040805@redhat.com>
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
Cc: "--[ UxBoD ]--" <uxbod@splatnix.net>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On 05/24/2010 04:38 PM, Zdenek Kabelac wrote:
> Dne 24.5.2010 14:52, --[ UxBoD ]-- napsal(a):
>> When attempting to build the RPM for the latest release I receive the error:
>>
>> ake[2]: Leaving directory `/home/compuser/multipath-tools-0.4.9/libmultipath/checkers'
>> make[2]: Entering directory `/home/compuser/multipath-tools-0.4.9/multipath'
>> cc -pipe -g -Wall -Wunused -Wstrict-prototypes -fPIC -DLIB_STRING=\"lib64\" -I../libmultipath -c -o main.o main.c
>> main.c: In function ?main?:
>> main.c:457: warning: implicit declaration of function ?dm_udev_wait?
>> cc -pipe -g -Wall -Wunused -Wstrict-prototypes -fPIC -DLIB_STRING=\"lib64\" -I../libmultipath main.o -o multipath -lpthread -ldevmapper -ldl -lmultipath -L../libmultipath
>> main.o: In function `main':
>> /home/compuser/multipath-tools-0.4.9/multipath/main.c:457: undefined reference to `dm_udev_wait'
>> ../libmultipath/libmultipath.so: undefined reference to `dm_task_set_cookie'
>> collect2: ld returned 1 exit status
>> make[2]: *** [multipath] Error 1
>> make[2]: Leaving directory `/home/compuser/multipath-tools-0.4.9/multipath'
>> make[1]: *** [recurse] Error 2
>> make[1]: Leaving directory `/home/compuser/multipath-tools-0.4.9'
>> error: Bad exit status from /var/tmp/rpm-tmp.44249 (%build)
>>
>> This is on a CentOS 5.4 system running kernel 2.6.28.7.  Am I missing a dependency ?
> 
> Looks like your libdevmapper is compiled without udev support, but multipath
> is configured with udev support - thought this is just a wild guess from your
> output.

Well, yes, multipath needs to check for the version of libdevmapper if it's
recent enough and if it has udev_sync support interface (libdevmapper >= 1.2.39).

Peter
