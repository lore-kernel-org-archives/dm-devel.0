From: "Stepan, Troy" <troy.stepan@unisys.com>
Subject: rr_min_io does not take effect
Date: Thu, 9 Nov 2006 10:01:24 -0500
Message-ID: <94C8C9E8B25F564F95185BDA64AB05F60461DB2F@USTR-EXCH5.na.uis.unisys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi--

I've played around with changing rr_min_io values in multipath.conf on
SLES10 and even after a reboot, it appears the change does not take hold
and the default of 1000 remains unchanged.  Here is the output from
multipath -v3:

(beginning removed)
mpath1: pgfailback =3D -2 (controler setting)
mpath1: pgpolicy =3D group_by_prio (controler setting)
mpath1: selector =3D round-robin 0 (controler setting)
mpath1: features =3D 1 queue_if_no_path (controler setting)
mpath1: hwhandler =3D 1 emc (controler setting)
mpath1: rr_weight =3D 1 (controler setting)
mpath1: minio =3D 1000 (controler setting) =20
mpath1: no_path_retry =3D 60 (controler setting)
mpath1: set ACT_NOTHING (map unchanged)

I would tend to think that "minio" is the equivalent of rr_min_io, but
cannot be sure.  I am leaning towards this assumption because even after
adjusting rr_min_io to an absurdly high value, I am still seeing I/Os
spread across both paths in under a couple seconds.  Please note that
this was just a test to verify rr_min_io taking effect.

Any idea on how to override the "controler setting"?  FYI, I'm using a
dual-port Emulex LP10000 as my HBA.  I took a look at the Emulex docs
and I don't see any parameters worth throwing in modprobe.conf.

Thanks for looking.
