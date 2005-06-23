From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: blacklist issues and more
Date: Thu, 23 Jun 2005 19:18:44 +0200
Message-ID: <20050623171844.GV2059@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321AAF7@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AAF7@SRMANNING.eng.emc.com>
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

On 2005-06-22T12:21:46, "goggin, edward" <egoggin@emc.com> wrote:

(Cleaned up some seriously broken quoting ... ;-)

> > > This happened because it appears that symbolic links in
> > > /dev/disk/by-name to device mapper device files in /dev are NOT
> > > cleaned up as a result of running "multipath -F", "dmsetup remove
> > > <map-name>, or "dmsetup remove_all".  A subsequent invocation of
> > > multipath will not necessarily assign multipath mapped devices to
> > > the same device mapper minor instances (for example, if one or
> > > more of them are blacklisted after the remove step) causing the
> > > stale symbolic links in /dev/disk/by-name to refer to the wrong
> > > dm-<minor> device file in /dev.
> > >=20
> > > An invocation of "multipath -F" did cleanup device files in /dev
> > > on my Red Hat AS 4 host but an invocation of "dmsetup remove
> > > <map-name>" did not.  I was loath to experiment with "dmsetup
> > > remove_all" on my Red Hat host since my root device on that host
> > > is on a device mapper LVM2 logical volume.  Otherwise, I suspect
> > > that this command would fail to clean up device files in the same
> > > way "dmsetup remove_all" failed.
> > >=20
> > I'll wait for you to pin down this problem.
>=20
> I was hoping Alasdair or Lars would comment first :))

Alasdair and Lars were verrry much travelling this week and busy with
other stuff ;-) (Actually, I'm travelling as of now, but a train ride
can also be a good time to play catchup with e-mail.)

Yeah, problem acknowledged. I _think_ it should work though - as the
symbolic names are created via hotplug/udev, they ought to be removed
when the device disappears. I think that's what I'm seeing when I type
"/etc/init.d/multipathd stop"?

A reboot works though, as /dev/disk/... is cleaned up during startup and
all links are created anew ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
