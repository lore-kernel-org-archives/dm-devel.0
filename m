From: Hannes Reinecke <hare@suse.de>
Subject: Re: Powerpath vs dm-multipath - two points of FUD?
Date: Sun, 14 Sep 2014 10:39:34 +0200
Message-ID: <54155446.2030700@suse.de>
References: <CA+ZWeLBUXK_kWjNkUcsg_5rP8ruew6ipupzdL_kw_K4v70p_5g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+ZWeLBUXK_kWjNkUcsg_5rP8ruew6ipupzdL_kw_K4v70p_5g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 09/09/2014 06:50 PM, Rob wrote:
> Hi List,
>
> Firstly, apologies if this is a common topic and my intentions are not
> to start a flame war. I've googled extensively but haven't found
> specific information to address my queries, so I thought I would turn her=
e.
>
> We have a rather large multi-tenant infrastructure using PowerPath.
> Since this inherently comes with increased maintenance costs
> (recompiling the module, requiring extra steps / care when upgrading
> etc) we are looking at using dm-multipath as the defacto standard
> SAN-connection abstraction layer for installations of RHEL 7+.
>
> After discussions with our SAN Architect team, we were given the below
> points to chew over and we were met with stiff resistance to moving away
> from Powerpath. Since there was little right-of-reply, I'd like to run
> these points past the minds of this list to understand if these are
> valid enough to justify a valid business case of keeping Powerpath over
> Multipath.
>
Hehe. PowerPath again.
Mind you, device-mapper multipathing is fully supported by EMC ...

>
> /Here=92s a couple of reasons to stick with powerpath:
>
> * Load Balancing:
>
>   Whilst dm-multipath can make use of more than one of the paths to an
> array, .i.e with round-robin, this isn=92t true load-balancing.  Powerpath
> is able to examine the paths down to the array and balance workload
> based on how busy the storage controller / ports are.  AFAIK Rhel6 has
> added functionality to make path choices based on queue depth and
> service time, which does add some improvement over vanilla round-robin.
>
We do this with the switch to request-based multipathing.
Using one of the other load balancers (eg least-pending) and set =

rr_min_io to '1' will give you exactly that behaviour.

>   For VMAX and CX/VNX, powerpath uses the following parameters to
> balance the paths out: Pending I/Os on the path, Size of I/Os, Types of
> I/Os, and Paths most recently used.
>
pending I/O is covered with the 'least-pending' I/O scheduler; I fail to =

see the value in any of the others (where would be the point in =

switching I/O based on the _size_ of the I/O request ?)

>   * Flakey Path Detection:
>
>   The latest versions of powerpath can proactively take paths out of
> service should it observe intermittent IO failures (remember any IO
> failure can hold a thread for 30-60 seconds whilst the SCSI command
> further up the stack times out, and a retry is sent).  dm-multipath
> doesn=92t have functionality to remove a flakey path, paths can only be
> marked out of service on hard failure./
>
Wrong. I've added flakey path detection a while back. I'll be looking
at the sources and will be checking the current status; might be I've =

not gotten around to send it upstream.
So you _might_ need to switch to SLES :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
