From: "goggin, edward" <egoggin@emc.com>
Subject: RE: racing libdevmapper calls
Date: Wed, 19 Oct 2005 13:46:16 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AD3D@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 19 Oct 2005 00:30:45 +0200
Christophe Varoqui <christophe.varoqui@free.fr> wrote:

> The following command :
> # dmsetup remove foo;echo "0 10 linear 8:16 63"|dmsetup create foo &
> echo "0 20 linear 8:16 63"|dmsetup create foo
> 
> will quite easily produce error message like :
> "device-mapper ioctl cmd 3 failed: Device or resource busy"
> 
> Is it designed behaviour ?

Yes, I think so.  Whichever create runs first wins the race.
The second create gets EBUSY since the name "foo" is already
taken.

> Can't we expect libdevmapper to serialize its ioctls ?

No, this is unreasonable.  Any time ordering of these events
should be external to the libdevmapper library.

> 
> multipath(8), being run in storms by udev, has trouble with this.
> Ideas ?

I've been working on patches to multipath-tools which will allow
multipathd(8) to properly react add/remove path/map block type
uevents and not require any multipath-tools interaction with hotplug.

I think these patches have also eliminated the need for multipath(8) to
be used to configure paths -- although it is still needed to display
the results in pretty format -- at least until "multipath -k" is
enhanced to do similarly.

> 
> Regards,
> cvaroqui
