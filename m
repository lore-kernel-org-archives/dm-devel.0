From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [patch] dm-mpath pg_init could race with destructor
Date: Thu, 16 Jun 2005 00:31:30 +0200
Message-ID: <20050615223130.GR11423@marowsky-bree.de>
References: <20050615071946.GA765@marowsky-bree.de>
	<42B071AE.4040305@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <42B071AE.4040305@cs.wisc.edu>
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

On 2005-06-15T13:21:34, Mike Christie <michaelc@cs.wisc.edu> wrote:

> >Why send a pg_init request at this point if there are no queued ios?
> >This was in fact my solution, to only send a pg_init io if there are
> >queued ios.
> >
> Are there management situations where some admin wants to manually=20
> switch. If he was going to take a controller temporarily offline for=20
> maitnenance for example? Will multipath tools and dm-mutlipath be used=20
> to do this type of management, or will it be some vendor specific tool=20
> that sends a SG_IO directly?

I don't think that's a real problem. We will switch the group, but just
on the first IO.

That had already happened anyway (because otherwise no
process_queued_ios() would have been queued). The only place where this
really makes a difference is the queue_work() in presuspend: here, a
process_queued_ios() would be qeueued even if no IO was pending, which
could lead to a pg_init being issued, and then the object being free'd -
bang.

> It would not be possible to just have dm-multipath increment some=20
> refcount like pending so you cannot destroy things while a pg_init IO i=
s=20
> in flight would it?

See my other mails.

The problem is indeed that the DM multipath's internal operations are
not accounted for in the top-level struct mapped_device pending field.
However, trying to get at that from within dm-mpath.c is non-trivial and
a major conceptual change, it appears.

It's sort-of related to "try to give a sane log message from within
dm-mpath, which actually mentions the map / dm dev we belong to".  The
trigger_event() "fix" is also very much related.

The layering is pretty well isolated, which is good, but can make such
changes difficult.

Long-term, that fix will be needed: DM personalities need to be more
involved in their reference counting.=20


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
