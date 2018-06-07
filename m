From: Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>
Subject: Re: [PATCH] block: Add block level changes for inline encryption
Date: Thu, 7 Jun 2018 06:55:42 +0000
Message-ID: <BD7FB879CC136E419544C8E2AE7B9C3020C7FA@IN01WEMBXA.internal.synopsys.com>
References: <d3624fab-e6fc-f14d-c780-db703c809068@synopsys.com>
 <20180601081330.GA13067@infradead.org>
 <BD7FB879CC136E419544C8E2AE7B9C3020C566@IN01WEMBXA.internal.synopsys.com>
 <918609fa-8721-0ee1-801e-4c29b64ac9ae@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manjunath M Bettegowda <Manjunath.MB@synopsys.com>, Prabu Thangamuthu <Prabu.T@synopsys.com>, Tejas Joglekar <Tejas.Joglekar@synopsys.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Johannes Thumshirn <jthumshirn@suse.de>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Eric Biggers <ebiggers3@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
List-Id: dm-devel.ids

On Thursday 07 June 2018 02:53 AM, Jens Axboe wrote:=0A=
> On 6/6/18 1:35 AM, Ladvine D Almeida wrote:=0A=
>> On Friday 01 June 2018 09:13 AM, Christoph Hellwig wrote:=0A=
>>> On Mon, May 28, 2018 at 02:43:09PM +0100, Ladvine D Almeida wrote:=0A=
>>>> This patch introduces new variable under bio structure to=0A=
>>>> facilitate inline encryption. This variable is used to=0A=
>>>> associate I/O requests to crypto information.=0A=
>>> This seems to be missing a whole lot of context.  Where is the whole=0A=
>>> series showing what you are trying to do?=0A=
>>>=0A=
>> Christoph,=0A=
>>=0A=
>> The patches are generated in the below > manner, with a thought of=0A=
>> sending separately to the MAINTAINERS responsible for each.=0A=
> What both Christoph and I have said is that it's _impossible_ to review=
=0A=
> changes when you don't know what is being built on top of it. The block=
=0A=
> change, by itself, is utterly useless. The use case needs to be seen.=0A=
> But apart from that, my comments on why it's doing it completely=0A=
> backwards still apply, and I've outlined how you need to fix it. The=0A=
> patch, in its current form, isn't going anywhere.=0A=
>=0A=
Jens,=0A=
=0A=
Since there are implementation level concerns on both device mapper layer a=
nd block layer, I will investigate=0A=
=0A=
more and work on those lines. I can send the full patch series to the relev=
ant maintainers after addressing the=0A=
=0A=
issues.=0A=
=0A=
Regards,=0A=
=0A=
Ladvine=0A=
=0A=
