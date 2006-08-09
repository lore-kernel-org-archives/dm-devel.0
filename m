From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-mpath: kmalloc+memset -> kzalloc
Date: Wed, 9 Aug 2006 22:29:31 +0100
Message-ID: <20060809212931.GQ18633@agk.surrey.redhat.com>
References: <20060809151746.GA31694@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060809151746.GA31694@rere.qmqm.pl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 09, 2006 at 05:17:46PM +0200, Micha=C5=82 Miros=C5=82aw wrote=
:
> Use kzalloc() instead of kmalloc() + memset().
=20
Thanks,
Alasdair
--=20
agk@redhat.com
