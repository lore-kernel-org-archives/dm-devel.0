From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools: scsi_id based path priorities and
 multiple prioritizers
Date: Tue, 21 May 2013 16:19:34 +0200
Message-ID: <519B8276.9070203@suse.de>
References: <001301ce53be$64265b10$2c731130$@larionov@salva.ee>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <001301ce53be$64265b10$2c731130$@larionov@salva.ee>
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

On 05/18/2013 01:54 PM, Viktor Larionov wrote:
> Hi everybody!
> =

>  =

> =

> First of all, thanks for all the hard work you guys have been doing
> developing dm. It=92s an amazing piece of work you have done!
> =

> While working with dm-multipath we have bumped into some limitations
> which we felt bit uncomfortable with, and seems like managed to
> change. I=92d thought I share the experience on that with others, in
> hope that this would help somebody.
> =

>  =

> =

> Long story short =96 our servers are connected to our SAN with both fc
> and iscsi links. (same targets, same wwid=92s are exported both
> through fc and iscsi)
> =

> Pretty much a standard installation =96 two independent controllers on
> the storage side (fc and iscsi each), dual port fc controllers on
> the server side + iscsi.
> =

> All this leaves us with approximate of 6 paths per device. (2 fc,
> and 4 iscsi =96 1 fc, and 2 iscsi per storage controller)
> =

>  =

> =

> Now if we use ALUA, which is standard for our infra (IBM Storewize
> V3700), the picture looks pretty much like this:
> =

>  =

> =

> alessandra viktor.larionov # multipath -ll www-2-mysql
> =

> www-2-mysql (360050763008080581000000000000029) dm-37 IBM,2145
> =

> size=3D10G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
> =

> |-+- policy=3D'round-robin 0' prio=3D50 status=3Dactive
> =

> | |- 2:0:0:9  sdak 66:64   active ready running
> =

> | |- 3:0:0:9  sdcf 69:48   active ready running
> =

> | `- 4:0:0:9  sdcy 70:96   active ready running
> =

> `-+- policy=3D'round-robin 0' prio=3D10 status=3Denabled
> =

>   |- 1:0:0:9  sdl  8:176   active ready running
> =

>   |- 5:0:0:9  sdcb 68:240  active ready running
> =

>   `- 6:0:0:9  sdct 70:16   active ready running
> =

>  =

> =

> Where sdak and sdl are fiber links and the rest of those are iscsi.
> Priorities come from alua which correspond to san controller
> preference at this particular moment.
> =

> What we don=92t like about this setup is that fc and iscsi links end
> up with the same prioriy in the same group. The idea behind having
> iscsi links on machines having fc at all, is redundancy to fc failures.
> =

> But we surely don=92t want to operate iscsi links the times when
> either primary or backup fc are fully operational.
> =

>  =

> =

> So this led us to the idea, of somehow telling the prioritizer to be
> more granular and separate fc and iscsi controller priorities. After
> doing some several hour googling, I found out that we are not the
> only ones with such a story, and there has been no solution to the
> point. (take this one for example
> http://www.redhat.com/archives/dm-devel/2008-August/msg00083.html)
> In fact prio_callout which could possibly solve this kind of thing,
> is deprecated.
> =

>  =

> =

> It=92s true that there=92s no easy or trivial way to determine if a path
> behing an sg is fiber or iscsi (or something else). But thinking on
> this issue, we thought that we actully can satisfy if we could just
> assign a custom priority based on a scsi_id of the device. The idea
> behind it is simple =96 say in our case we have an IBM ServeRAID
> controller, which is SCSI host 0, Emulex Light Pulse which is SCSI
> host 1 and 2 (for each port respectively and all of the rest is
> iSCSI. So if we could give static priorities based on this
> information this could do the trick.
> =

>  =

> =

> So, we poked up with code a bit, and wrote up a custom prioritizer,
> called sg_id. (patch for the latest multipath-tools available here:
> http://viktor.ee/multipath-tools-patches/sg_id_prio.patch)
> =

> Usage is very simple: in /etc/multipath.conf: prio =84sg_id=93, and
> priorities are passed through prio_args as regexes: e.g. a prio_args of
> =

> prio_sg_id(default)=3D0 prio_sg_id(^[0-2]:0)=3D40 prio_sg_id(^5:[2-3]:)=
=3D30
> =

> will give prio 40 for everything on SCSI hosts 0, 1 and 2, channel
> 0. 30 on scsi_host 5 channels 2 and 3, and everything else will get 0.
> =

>  =

> =

> Using sg_id in the upper example we will have sdl and sdak in the
> first group, and all othe other stuff in the second. Which is ok,
> but not quite.
> =

> The problem with this approach for us is that ALUA gives us valuable
> information on our storage priorities (which controller is primary
> and which is secondary for that particular lun at this particular
> moment), and we=92re not quite ready to sacrifice this information
> even for sg_id prios. If there only would be a way to use multiple
> prioritizers.
> =

> And so we=92ve played another couple of our hours with multipath-tools
> code allowing it to accept multiple prioritizers in prio
> configuration. (patch here
> http://viktor.ee/multipath-tools-patches/multiprio.patch)
> =

> In this case, prioritizers should be separated by coma, semicolon or
> space, and the end priority would be a sum of priorities given by
> all of the specified prioritizers. (a single prioritizer value is
> also accepted of course.)
> =

> As an example:
> =

>         prio                  "sg_id, alua"
> =

>         prio_args             "prio_sg_id(default)=3D0
> prio_sg_id(^[0-2]:0)=3D100"
> =

>  =

> =

> So combining the two of above with the same example we get:
> =

>  =

> =

> alessandra multipath-tools-0.4.9 # multipath -r www-2-mysql
> =

> reload: www-2-mysql (360050763008080581000000000000029) undef IBM,2145
> =

> size=3D10G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Dundef
> =

> |-+- policy=3D'round-robin 0' prio=3D150 status=3Dundef
> =

> | `- 2:0:0:9  sdak 66:64   active ready running
> =

> |-+- policy=3D'round-robin 0' prio=3D110 status=3Dundef
> =

> | `- 1:0:0:9  sdl  8:176   active ready running
> =

> |-+- policy=3D'round-robin 0' prio=3D50 status=3Dundef
> =

> | |- 3:0:0:9  sdcf 69:48   active ready running
> =

> | `- 4:0:0:9  sdcy 70:96   active ready running
> =

> `-+- policy=3D'round-robin 0' prio=3D10 status=3Dundef
> =

>   |- 5:0:0:9  sdcb 68:240  active ready running
> =

>   `- 6:0:0:9  sdct 70:16   active ready running
> =

>  =

> =

> Exactly what we needed: primary FC link with 150, secondary 110, and
> then follow primary and secondary ISCSI links with 50 and 10
> respectively.
> =

> All in all this one seems to have solved our problem, and well maybe
> can help anybody elses too.
> =

Actually, I like the idea with the stackable prioritizers.
Not sure about the 'sg_id' thing; that's still too much to configure.
We should be identifying the transport, and base some priorities
based on the transport.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
