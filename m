From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: small dm mpath cleanups
Date: Wed, 26 Apr 2017 18:41:27 +0000
Message-ID: <1493232084.2632.5.camel@sandisk.com>
References: <20170426074039.14602-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426074039.14602-1-hch@lst.de>
Content-Language: en-US
Content-ID: <1583EDE685375749B513E384DEAC6835@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, 2017-04-26 at 09:40 +0200, Christoph Hellwig wrote:
> this series has some prep patches for my work to have proper, type
> checked block errors codes.  One fallout of that is that we need to
> get rid of how dm overloads a few return values with either internal
> positive error codes or negative errno values.  This patches does
> that, which happens to clean things up a bit, and also allows us
> dm to propagate the actual error code in one case where it currently
> is dropped on the floor.

Hello Christoph,

Some patches in this series conflict with patches I would like to end up in
the stable kernel series. If I would rebase my patch series on top of your
series then that would make it harder to apply my patches on the stable
kernel trees. Mike and Christoph, please advise how to proceed.

Bart.=
