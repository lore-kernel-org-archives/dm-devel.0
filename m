From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 25/42] Make log_pthread more robust
Date: Wed, 09 Jan 2013 20:15:02 +0100
Message-ID: <50EDC1B6.2010608@gmail.com>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
	<1357653259-62650-26-git-send-email-hare@suse.de>
	<1357690572.12137.17.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357690572.12137.17.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 01/09/2013 01:16 AM, Christophe Varoqui wrote:
> On mar., 2013-01-08 at 14:54 +0100, Hannes Reinecke wrote:
>> We don't need to allocate memory for mutexes, we can just
>> be using static variables. And valgrind complained about
>> logqueue flush from shutdown, so don't do this.
>> The normal shutdown process should be flushing the log
>> queue anyway.
>>
> It seems the log_thread_flush() function is missing from the patchset.
> Care to send the incremental patch ?

and also log_reset()

chuchi:~/tmp/multipath-tools $ make -i
make[1]: Entering directory `/home/xose/tmp/multipath-tools/libmultipath'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/libmultipath'
make[1]: Entering directory `/home/xose/tmp/multipath-tools/libmultipath/prioritizers'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/libmultipath/prioritizers'
make[1]: Entering directory `/home/xose/tmp/multipath-tools/libmultipath/checkers'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/libmultipath/checkers'
make[1]: Entering directory `/home/xose/tmp/multipath-tools/libmpathpersist'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/libmpathpersist'
make[1]: Entering directory `/home/xose/tmp/multipath-tools/multipath'
cc -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -Wunused -Wstrict-prototypes -fPIC -DLIB_STRING=\"lib64\" -I../libmultipath main.o -o multipath -lpthread -ldevmapper -ldl -L../libmultipath -lmultipath
../libmultipath/libmultipath.so: undefined reference to `log_thread_flush'
../libmultipath/libmultipath.so: undefined reference to `log_reset'
collect2: error: ld returned 1 exit status
make[1]: [multipath] Error 1 (ignored)
/bin/gzip -9 -c multipath.8 > multipath.8.gz
/bin/gzip -9 -c multipath.conf.5 > multipath.conf.5.gz
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/multipath'
make[1]: Entering directory `/home/xose/tmp/multipath-tools/multipathd'
cc -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -Wunused -Wstrict-prototypes -fPIC -DLIB_STRING=\"lib64\" -I../libmultipath -I../libmpathpersist main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o -lpthread -ldevmapper -lreadline -lncurses -ludev -ldl -L../libmultipath -lmultipath -L../libmpathpersist -lmpathpersist -o multipathd
../libmultipath/libmultipath.so: undefined reference to `log_thread_flush'
../libmultipath/libmultipath.so: undefined reference to `log_reset'
collect2: error: ld returned 1 exit status
make[1]: [multipathd] Error 1 (ignored)
/bin/gzip -9 -c multipathd.8 > multipathd.8.gz
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/multipathd'
make[1]: Entering directory `/home/xose/tmp/multipath-tools/mpathpersist'
cc -g main.o  -o mpathpersist -lpthread -ldevmapper -L../libmpathpersist -lmpathpersist -L../libmultipath -lmultipath  -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -Wunused -Wstrict-prototypes -fPIC -DLIB_STRING=\"lib64\" -I../libmultipath -I../libmpathpersist ../libmultipath/libmultipath.so: undefined reference to `log_thread_flush'
../libmultipath/libmultipath.so: undefined reference to `log_reset'
collect2: error: ld returned 1 exit status
make[1]: [mpathpersist] Error 1 (ignored)
/bin/gzip -9 -c mpathpersist.8 > mpathpersist.8.gz
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/mpathpersist'
make[1]: Entering directory `/home/xose/tmp/multipath-tools/kpartx'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/xose/tmp/multipath-tools/kpartx'
