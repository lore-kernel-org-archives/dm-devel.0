From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: Can we drop 'hardware_handler "1 alua"'?
Date: Tue, 27 Mar 2018 10:09:52 -0500
Message-ID: <20180327150952.GW3103@octiron.msp.redhat.com>
References: <1522140989.13140.12.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1522140989.13140.12.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel mailing list <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Tue, Mar 27, 2018 at 10:56:29AM +0200, Martin Wilck wrote:
> hwtable.c has multiple entries that set 'hardware_handler "1 alua"'
> explicitly. But the kernel has been auto-attaching the ALUA hwhandler
> to devices that support it since 4.3, the only prerequisite being that
> scsi_dh_alua is present at device probing time (kernel commits
> d95dbff2, d6a32b98). "retain_attached_hwhandler" is also hard-wired
> since 4.3. Thus if the above prerequisite is met, there's no point in
> setting 'hardware_handler "1 alua"'.
> =

> We've recently seen problems with the explicit setting of the alua
> hwhandler in the hwtable; if we do this and the device fails ALUA for
> whatever reason, setting up the multipath map fails entirely.
> =

> Therefore we have reasons to try and remove 'hardware_handler "1 alua"'
> from the hwtable. But it could cause regressions in some cases, e.g.
> for distributions that don't force-load scsi_dh_alua before device
> probing, or for kernels older than 4.3.
> =


If the only mode of operation a device supports is alua, and something
fails there, the device may well not be usable. If we can't send the
alua commands that the device needs, we definitely shouldn't just be
silently failing back to something broken. I do agree that any device
that has multiple modes that it can be configured in (or at least
devices that could be configured as ALUA or something else, where we
can't tell from the vendor/product/revision) should have their default
config set to the other mode, since multipath should autodetect if they
are in alua mode. If autodetection isn't working for some devices, we
should fix that.

-Ben

> Opinions, please.
> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
