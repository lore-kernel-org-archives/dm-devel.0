From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] multipath_ctr() and friends - parameter cleanup
Date: Wed, 9 Aug 2006 22:31:25 +0100
Message-ID: <20060809213125.GR18633@agk.surrey.redhat.com>
References: <20060808113227.GA26434@rere.qmqm.pl>
	<20060808114650.GA9486@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060808114650.GA9486@rere.qmqm.pl>
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
List-Id: dm-devel.ids

On Tue, Aug 08, 2006 at 01:46:50PM +0200, Micha=C5=82 Miros=C5=82aw wrote=
:
> After initialising m->ti, there's no need to pass it in subsequent call=
s
> to static functions used for parsing parameters.
=20
Thanks, will include in the next patchset.
=20
Alasdair
--=20
agk@redhat.com
