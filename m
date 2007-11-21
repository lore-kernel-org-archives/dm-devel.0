From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: Re: Bug in dm-stripe.c driver
Date: Wed, 21 Nov 2007 12:23:32 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC019BA45A@orsmsx418.amr.corp.intel.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC019BA3E9@orsmsx418.amr.corp.intel.com>
	<20071121193932.GM22843@agk.fab.redhat.com>
	<20071121194214.GN22843@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20071121194214.GN22843@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Healey,  Douglas D" <douglas.d.healey@intel.com>, "Ciechanowski,  Ed" <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids


>-----Original Message-----
>From: Alasdair G Kergon [mailto:agk@redhat.com]
>Sent: Wednesday, November 21, 2007 11:42 AM
>To: Wood, Brian J
>Cc: device-mapper development; Ciechanowski, Ed; Healey, Douglas D
>Subject: Re: [dm-devel] Re: Bug in dm-stripe.c driver
>
>On Wed, Nov 21, 2007 at 07:39:32PM +0000, Alasdair G Kergon wrote:
>> On Wed, Nov 21, 2007 at 11:15:52AM -0800, Wood, Brian J wrote:
>> > /***** Here's the problem spot *****/
>> >        struct stripe stripe[0];
>>
>> That one must remain the last element in the struct.
>> Add any new fields above it.
>
>Here's how the real size is calculated before it's allocated:
>
>static inline struct stripe_c *alloc_context(unsigned int stripes)
>{
>        size_t len;
>
>        if (array_too_big(sizeof(struct stripe_c), sizeof(struct
stripe),
>                          stripes))
>                return NULL;
>
>        len =3D sizeof(struct stripe_c) + (sizeof(struct stripe) *
stripes);
>
>        return kmalloc(len, GFP_KERNEL);
>}

Ok, I did see that call to alloc_context() and it looked like the
kmalloc call was declaring enough memory to house all the drives in the
stripe (so I wasn't worried that it would overwrite anything outside the
driver's memory space). When I did my testing I noticed that if I put my
declarations above this line it worked correctly, I just thought it
might have been a logic error.=20

Would it be ok to add a comment above (or below) the line "struct stripe
stripe[0];" just to prevent developers down the road from seeing this
strange behavior if they add a field?

Thanks=20


>
>
>Alasdair
>--
>agk@redhat.com

Brian Wood
Software Engineer
Intel Corp., Manageability & Platform Software Division
brian.j.wood@intel.com
