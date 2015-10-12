From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 14/18] Make use of /run depend on systemd
Date: Mon, 12 Oct 2015 09:34:06 +0200
Message-ID: <561B626E.9080406@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-15-git-send-email-bmarzins@redhat.com>
	<561B5CB0.7000105@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <561B5CB0.7000105@suse.de>
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

Dne 12.10.2015 v 09:09 Hannes Reinecke napsal(a):
> On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
>> While there are other ways to decide whether to use /run or /var/run,
>> I believe this should be good enough, and it uses a Makefile define
>> that already exists.  If it doesn't work for everyone, I'll switch it
>> to actually test the directories and add a new define to CFLAGS.
>>
>> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>> ---
>>   libmultipath/defaults.h | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
>> index e2d2779..a313d75 100644
>> --- a/libmultipath/defaults.h
>> +++ b/libmultipath/defaults.h
>> @@ -27,7 +27,11 @@
>>   #define MAX_CHECKINT(a)		(a << 2)
>>
>>   #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
>> +#ifdef USE_SYSTEMD
>>   #define DEFAULT_PIDFILE		"/run/multipathd.pid"
>> +#else
>> +#define DEFAULT_PIDFILE         "/var/run/multipathd.pid"
>> +#endif
>>   #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
>>   #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
>>   #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
>>
> Hmpf. Again.
>
> But yeah, I guess it's okay.
>
> If only systemd would stop moving things around ...
>

I assume things like this should be detected at configure time and
used  via  'AC_DEFINE()' m4 macro.
(Check i.e. lvm2 configure.in file)
(As user may wish to even use completely different directory, to
make a parallel usable binary)

Zdenek
