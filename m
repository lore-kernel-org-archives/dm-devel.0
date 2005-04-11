From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 04:53:07 -0700
Message-ID: <425A6523.8060204@us.ibm.com>
References: <20050410192934.GP12752@marowsky-bree.de>	<1113164717.8372.2.camel@zezette>
	<4259B895.4070600@us.ibm.com>	<20050411011444.GA3748@osdl.org>	<20050411084611.GA12752@marowsky-bree.de>	<425A42EF.50808@us.ibm.com>
	<20050411114309.GJ12752@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050411114309.GJ12752@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Lars Marowsky-Bree wrote:
> On 2005-04-11T02:27:11, Mike Christie <mikenc@us.ibm.com> wrote:
>=20
>=20
>>what is wrong with what you have now where you utilize the queue/path's=
=20
>>mempool by doing a blk_get_request with GFP_WAIT?=20
>=20
>=20
> ... what if it's trying to free memory by going to swap on multipath,
> and can't, because we're blocked on getting the request with
> GFP_WAIT...?

GFP_WAIT does not casue IOs though. That is the difference between=20
waiing on GFP_KERNEL and GFP_WAIT I thought. GFP_KERNEL can cause a page=20
write out which you wait on and then there is a problem since it could=20
be to the same disk you are trying to recover. But if you are just=20
waiting for something to be returned to the mempool like with GFP_WAIT +=20
blk_get_request you should be ok as long as the code below you=20
eventually give up their resources and frees the requests you are=20
waiting on?

>=20
> Your patch helps, because it means we need less memory.
>=20
> But, ultimately, we ought to preallocate the requests already when the
> hw-handler is initialized for a map (because presumably at that time
> we'll have enough memory, or can just fail the table setup). From that
> point on, our memory useage should not grow.
>=20
>=20
> Sincerely,
>     Lars Marowsky-Br=E9e <lmb@suse.de>
>=20
