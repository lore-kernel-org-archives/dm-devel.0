From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath-tools: use internal drd.h file
Date: Sun, 16 Oct 2016 18:59:40 +0200
Message-ID: <ea6f0aac-4ca5-e3dd-da71-5a4a1361de64@suse.de>
References: <20161008202212.11963-1-xose.vazquez@gmail.com>
	<9e801117-cb59-b3a7-de85-b724326d2b34@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9e801117-cb59-b3a7-de85-b724326d2b34@gmail.com>
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

On 10/16/2016 12:26 PM, Xose Vazquez Perez wrote:
> On 10/08/2016 10:22 PM, Xose Vazquez Perez wrote:
>
>> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  libmultipath/debug.c | 2 +-
>>  multipathd/main.c    | 2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> This patch is missing.
> Thank you.
>
>
>> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
>> index 295136c..fbe171a 100644
>> --- a/libmultipath/debug.c
>> +++ b/libmultipath/debug.c
>> @@ -8,7 +8,7 @@
>>  #include "log_pthread.h"
>>  #include <sys/types.h>
>>  #include <time.h>
>> -#include <../third-party/valgrind/drd.h>
>> +#include "../third-party/valgrind/drd.h"
>>  #include "vector.h"
>>  #include "config.h"
>>
>> diff --git a/multipathd/main.c b/multipathd/main.c
>> index cdfafe8..0998085 100644
>> --- a/multipathd/main.c
>> +++ b/multipathd/main.c
>> @@ -23,7 +23,6 @@
>>  #endif
>>  #include <semaphore.h>
>>  #include <time.h>
>> -#include <valgrind/drd.h>
>>
>>  /*
>>   * libmultipath
>> @@ -85,6 +84,7 @@ int uxsock_timeout;
>>  #include "lock.h"
>>  #include "waiter.h"
>>  #include "wwids.h"
>> +#include "../third-party/valgrind/drd.h"
>>
>>  #define FILE_NAME_SIZE 256
>>  #define CMDSIZE 160
>>
>
Please don't.
We're trying to keep dependencies to each package as small as possible.
And requiring valgrind by default is not going to help here.
Please make this a compile-time option.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
