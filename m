From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: New -udm?
Date: Mon, 11 Apr 2005 10:46:11 +0200
Message-ID: <20050411084611.GA12752@marowsky-bree.de>
References: <20050410192934.GP12752@marowsky-bree.de>
	<1113164717.8372.2.camel@zezette> <4259B895.4070600@us.ibm.com>
	<20050411011444.GA3748@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050411011444.GA3748@osdl.org>
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

On 2005-04-10T18:14:44, Dave Olien <dmo@osdl.org> wrote:

> You're correct.  I'll rewrite it on Thursday this week.
> I'll use the same methods Lars used in the dm-emc.c

Note that dm-emc.c also would need to pre-allocate it's requests, but
doesn't right now :/

Pre-allocating the requests sucks: Either we pre-allocate for _every_
path we might potentially need to send the request down on, or fix up
the request for the path we sent it down on (which would require us to
use internal knowledge about the req structs we're not supposed to
have).

Good solutions solicited ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
