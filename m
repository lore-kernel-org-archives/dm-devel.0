From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: SCSI Sense patch
Date: Tue, 05 Sep 2006 12:39:26 -0500
Message-ID: <44FDB64E.7020301@cs.wisc.edu>
References: <BAY114-F483ED5326C22601EF09069D300@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BAY114-F483ED5326C22601EF09069D300@phx.gbl>
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

bart brooks wrote:
> Hi Alasdair,
>=20
> I take it you are referring to the addition of =93bi_error=94 to the bi=
o
> data structure.
> Any idea when an alternate solution will be available, is it still in
> the discussion phase ?
>=20

I did two possible alternatives when trying to think of a way around
KABI. You can find them here

http://www.cs.wisc.edu/~michaelc/block/dm/rhel4/

I am not pushing either approach right now since one is a crazy ugly
hack (u3-bio-sense/) that I do not want to maintain or try to completely
test for something like RHEL. The other possibility (u3-blkerr) is nicer
but needs to be fixed up for some cases and needs lots of testing. The
latter approach is also a little hacky since I had to work around the
KABI restrictions but I do not think it is as evil as the u3-bio-sense
approach.
