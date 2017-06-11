From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: replace 64bit archs macros
 by __LP64__
Date: Sun, 11 Jun 2017 21:14:03 +0200
Message-ID: <13c7d90c-47d6-fe96-d7e2-ce1aa0b266ca@gmail.com>
References: <20170519013818.15130-1-xose.vazquez@gmail.com>
	<1495164703.3174.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1495164703.3174.1.camel@sandisk.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/19/2017 05:31 AM, Bart Van Assche wrote:

> On Fri, 2017-05-19 at 03:38 +0200, Xose Vazquez Perez wrote:
>> Rationale: https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html
>>
>> __LP64__
>> _LP64
>>  These macros are defined, with value 1, if (and only if) the compilation is
>>  for a target where long int and pointer both use 64-bits and int uses 32-bit.
>>
>>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  kpartx/lopart.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/kpartx/lopart.c b/kpartx/lopart.c
>> index 4e6dab4..3c16eb0 100644
>> --- a/kpartx/lopart.c
>> +++ b/kpartx/lopart.c
>> @@ -38,11 +38,10 @@
>>  #define LOOP_CTL_GET_FREE       0x4C82
>>  #endif
>>  
>> -#if !defined (__alpha__) && !defined (__ia64__) && !defined (__x86_64__) \
>> -	&& !defined (__s390x__)
>> -#define int2ptr(x)	((void *) ((int) x))
>> -#else
>> +#if defined (__LP64__)
>>  #define int2ptr(x)	((void *) ((long) x))
>> +#else
>> +#define int2ptr(x)	((void *) ((int) x))
>>  #endif
>>  
>>  static char *
> 
> Hello Xose,
> 
> Since there is only one user of int2ptr(), please remove the macro definitions
> and use the following construct: (void *)(uintptr_t)(...).
No time for a proper patch, use it as an interim fix.
