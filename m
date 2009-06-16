From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Tue, 16 Jun 2009 10:55:17 -0700
Message-ID: <e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245163906.28257.113.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Tue, Jun 16, 2009 at 7:51 AM, Heinz Mauelshagen<heinzm@redhat.com> wro=
te:
> On Tue, 2009-06-16 at 10:09 -0400, Christoph Hellwig wrote:
>> On Mon, Jun 15, 2009 at 07:21:05PM +0200, heinzm@redhat.com wrote:
>> > Hi,
>> >
>> > this patch series introduces the raid45 target.
>> > Please include upstream.
>>
>> NACK, no need for another raid target, especially if it happens to be
>> as broken as the raid1 one.
>
> You didn't review it it seems ?

Will you be allowing time for review?  This seems a bit late for
2.6.31, as your "Please include upstream" implies.

>> =A0 Please help on making the md raid4/5 code
>> more useful for your purposes (whatever that may be).
>
> Supporting various ATARAID raid5 mappings via dmraid long before md got
> external metadata suport added.

This is an opportunity to investigate what technical hurdles remain to
allow dmraid to use md infrastructure [1] (or as Neil proposed [2] a
new unified virtual block device infrastructure) for activating
external metadata raid5 arrays.  The libata/ide situation shows that
there is precedence for duplicate functionality in the kernel, but my
personal opinion is that we exhaust the code reuse discussion before
heading down that path.

Regards,
Dan

[1] http://marc.info/?l=3Dlinux-raid&m=3D123300614013042&w=3D2
[2] http://marc.info/?l=3Dlinux-fsdevel&m=3D124450400028660&w=3D2
