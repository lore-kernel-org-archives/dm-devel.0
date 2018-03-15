From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 04/23] libmultipath: parser: use
 call-by-value for "snprint" methods
Date: Thu, 15 Mar 2018 14:25:28 +0000
Message-ID: <1521123927.3336.1.camel@wdc.com>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-5-mwilck@suse.com>
Content-Language: en-US
Content-ID: <F864DDDE77338742BEEAD4E95F65A79C@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mwilck@suse.com" <mwilck@suse.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-03-06 at 00:14 +0100, Martin Wilck wrote:
> Convert the snprint methods for all keywords to call-by-value,
> and use "const" qualifier for the "data" argument. This makes sure
> that "snprint" type functions don't modify the data they're print,
> helps compile-time correctness checking, and allows more proper
> "const" cleanups in the future.

Hello Martin,

With this patch applied on top of Christophe's master branch:

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ea273dd91962..ac9216c4c5f3 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -23,6 +23,7 @@
 #include <errno.h>
 #include <inttypes.h>
 #include "mpath_cmd.h"
+#include "dict.h"
 
 static int
 set_int(vector strvec, void *ptr)


I see a whole bunch of warnings appear (see below). Can you have a look at
this?

Thanks,

Bart.


dict.c:627:1: error: conflicting types for 'print_fast_io_fail'
 print_fast_io_fail(char * buff, int len, long v)
 ^~~~~~~~~~~~~~~~~~
In file included from dict.c:26:0:
dict.h:16:5: note: previous declaration of 'print_fast_io_fail' was here
 int print_fast_io_fail(char * buff, int len, void *ptr);
     ^~~~~~~~~~~~~~~~~~
dict.c:666:1: error: conflicting types for 'print_dev_loss'
 print_dev_loss(char * buff, int len, unsigned long v)
 ^~~~~~~~~~~~~~
In file included from dict.c:26:0:
dict.h:17:5: note: previous declaration of 'print_dev_loss' was here
 int print_dev_loss(char * buff, int len, void *ptr);
     ^~~~~~~~~~~~~~
dict.c:697:1: error: conflicting types for 'print_pgpolicy'
 print_pgpolicy(char * buff, int len, long pgpolicy)
 ^~~~~~~~~~~~~~
In file included from dict.c:26:0:
dict.h:14:5: note: previous declaration of 'print_pgpolicy' was here
 int print_pgpolicy(char * buff, int len, void *ptr);
     ^~~~~~~~~~~~~~
dict.c:814:1: error: conflicting types for 'print_rr_weight'
 print_rr_weight (char * buff, int len, long v)
 ^~~~~~~~~~~~~~~
In file included from dict.c:26:0:
dict.h:12:5: note: previous declaration of 'print_rr_weight' was here
 int print_rr_weight (char * buff, int len, void *ptr);
     ^~~~~~~~~~~~~~~
dict.c:860:1: error: conflicting types for 'print_pgfailback'
 print_pgfailback (char * buff, int len, long v)
 ^~~~~~~~~~~~~~~~
In file included from dict.c:26:0:
dict.h:13:5: note: previous declaration of 'print_pgfailback' was here
 int print_pgfailback (char * buff, int len, void *ptr);
     ^~~~~~~~~~~~~~~~
dict.c:907:1: error: conflicting types for 'print_no_path_retry'
 print_no_path_retry(char * buff, int len, long v)
 ^~~~~~~~~~~~~~~~~~~
In file included from dict.c:26:0:
dict.h:15:5: note: previous declaration of 'print_no_path_retry' was here
 int print_no_path_retry(char * buff, int len, void *ptr);
     ^~~~~~~~~~~~~~~~~~~
dict.c:1049:1: error: conflicting types for 'print_off_int_undef'
 print_off_int_undef(char * buff, int len, long v)
 ^~~~~~~~~~~~~~~~~~~
In file included from dict.c:26:0:
dict.h:19:5: note: previous declaration of 'print_off_int_undef' was here
 int print_off_int_undef(char * buff, int len, void *ptr);
     ^~~~~~~~~~~~~~~~~~~
make[1]: *** [../Makefile.inc:131: dict.o] Error 1
make: *** [Makefile:25: recurse] Error 2
install: cannot remove '/lib64/libmpathcmd.so.0': Permission denied
make[1]: *** [Makefile:19: install] Error 1
make: *** [Makefile:34: recurse_install] Error 2

Compilation exited abnormally with code 2 at Thu Mar 15 07:23:12
