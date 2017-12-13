From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: Makefile: Respect standard
 toolchain related envvars
Date: Wed, 13 Dec 2017 14:28:01 +0100
Message-ID: <74db7151-26f1-2751-60b3-cdebd0ac06d5@gmail.com>
References: <20171129232311.95483-1-whissi@gentoo.org>
	<1513092491.3704.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1513092491.3704.2.camel@wdc.com>
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
To: Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Thomas Deutschmann <whissi@gentoo.org>
List-Id: dm-devel.ids

On 12/12/2017 04:28 PM, Bart Van Assche wrote:
> On Thu, 2017-11-30 at 00:23 +0100, Thomas Deutschmann wrote:
>> The Makefile overrides standard envvars that control the toolchain flags.
>> This patch should set things right without reducing default behavior.
>>
>> Signed-off-by: Thomas Deutschmann <whissi@gentoo.org>
>> ---
>>  Makefile.inc | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile.inc b/Makefile.inc
>> index 29c290a2..951d58fc 100644
>> --- a/Makefile.inc
>> +++ b/Makefile.inc
>> @@ -90,11 +90,12 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
>>  		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
>>  		  --param=ssp-buffer-size=4
>>  
>> -CFLAGS		= $(OPTFLAGS) -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
>> +CFLAGS		?= $(OPTFLAGS)
>> +CFLAGS		+= -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
>>  BIN_CFLAGS	= -fPIE -DPIE
>>  LIB_CFLAGS	= -fPIC
>>  SHARED_FLAGS	= -shared
>> -LDFLAGS		= -Wl,-z,relro -Wl,-z,now
>> +LDFLAGS		+= -Wl,-z,relro -Wl,-z,now
>>  BIN_LDFLAGS	= -pie
>>  
>>  # Check whether a function with name $1 has been declared in header file $2.
> 
> Hello Thomas,
> 
> I agree that we need a way to specify additional compilation flags. However, is
> OPTFLAGS really a standard? Aren't most developers used to set CFLAGS to specify
> additional compilation flags?
OPTFLAGS is used by RPM distributions(Fedora, openSUSE and derivatives).
