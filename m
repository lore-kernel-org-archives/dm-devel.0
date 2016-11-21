From: Shaun Tancheff <shaun@tancheff.com>
Subject: Re: [PATCH] Add blkzonecmd and blkreport ZAC/ZBC drives
Date: Mon, 21 Nov 2016 15:37:01 -0600
Message-ID: <CAJ48U8XwhqQtnnCx8H8d0afs2paQgQ4k2U9shpQW4hNNfQ01rA@mail.gmail.com>
References: <20161121192937.14989-1-shaun@tancheff.com>
	<d202b14f-c889-85d5-deb9-ff8abda6a17a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d202b14f-c889-85d5-deb9-ff8abda6a17a@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Michael T Lombardi <michael.t.lombardi@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, dm-devel <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-Id: dm-devel.ids

On Mon, Nov 21, 2016 at 1:51 PM, Bart Van Assche
<bart.vanassche@sandisk.com> wrote:
> On 11/21/2016 11:29 AM, Shaun Tancheff wrote:
>>
>> This patch adds:
>>  - blkreset to issue Reset (Write Pointer) zone commands
>>  - blkreport to retrieve drive zone information
>>
>> Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
>> Signed-off-by: Shaun Tancheff <shaun@tancheff.com>
>
>
> Is this patch perhaps intended for the util-linux project? According to the
> README file of that project util-linux patches should be sent to
> util-linux@vger.kernel.org.
>
> Additionally, shouldn't Damien Le Moal have been CC'ed for this patch?

Yes this was supposed to go to util-linux.
Will Cc Damien as well.

>> diff --git a/configure.ac b/configure.ac
>> index 1bd7d2e..b8df1d4 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -275,6 +275,12 @@ AC_CHECK_HEADERS([security/pam_misc.h],
>>  #endif
>>  ])
>>
>> +AC_CHECK_HEADERS([linux/blkzoned.h], [], [], [
>> +#ifdef HAVE_BLKZONED_H
>> +#include <linux/blkzoned.h>
>> +#endif
>> +])
>
>
> What code in configure.ac defines HAVE_BLKZONED_H? Would the following code
> have been sufficient: AC_CHECK_HEADER([linux/blkzoned.h]) ? See also
> https://www.gnu.org/software/autoconf/manual/autoconf-2.68/html_node/Generic-Headers.html.

Thanks for the heads up, my use of check headers here wasn't doing
what I thought.
I've fixed it and will post to util-linux.

Thanks!
--Shaun
