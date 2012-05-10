From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Bcache v13 09/16] Bcache: generic utility code
Date: Thu, 10 May 2012 14:42:41 -0700
Message-ID: <CAH+dOxKy-ioqcWnsyfnfPJACcBu=qgWa0mUHnD_ekZevBePQ_Q@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<c3f0ca2a499f532253d4c16a30837d43e237266a.1336619038.git.koverstreet@google.com>
	<CAA9_cmcT0Jiz8pfj2MS+Sv55DqLrMMd=GaPMopRDCObiO5+waQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcT0Jiz8pfj2MS+Sv55DqLrMMd=GaPMopRDCObiO5+waQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tejun@google.com, agk@redhat.com
List-Id: dm-devel.ids

Whoops, grepped around but missed that. Thanks.

On Thu, May 10, 2012 at 12:35 PM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> On Wed, May 9, 2012 at 8:10 PM, Kent Overstreet <koverstreet@google.c=
om> wrote:
>> Much of this code should be moved out of drivers/block/bcache, but i=
t
>> was originally written for bcache.
>>
>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
>> ---
>
> [..]
>> +#include <linux/dynamic_fault.h>
> [..]
>> +#define bio_alloc_pages(...) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0 =A0 (dynamic_fault() ? -ENOMEM =A0 =A0 =A0: bio_alloc_page=
s(__VA_ARGS__))
>> +
>
> ...these missed the removal of the dynamic_fault bits.
