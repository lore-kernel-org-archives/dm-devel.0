From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: RE: racing libdevmapper calls
Date: Wed, 19 Oct 2005 20:47:14 +0200
Message-ID: <1129747635.7313.34.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AD3D@SRMANNING.eng.emc.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AD3D@SRMANNING.eng.emc.com>
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


> 
> I've been working on patches to multipath-tools which will allow
> multipathd(8) to properly react add/remove path/map block type
> uevents and not require any multipath-tools interaction with hotplug.
> 
> I think these patches have also eliminated the need for multipath(8) to
> be used to configure paths -- although it is still needed to display
> the results in pretty format -- at least until "multipath -k" is
> enhanced to do similarly.
> 
Yes,

I pondered moving that way at that time, and decided for a basic
serialization in multipath(8) and wait after I release 0.4.6 to begin
that merging work into the daemon.

We'll need to synchronize with Mike, who will need structural changed
too.

Let me know when you have something ready for me to read.
I'd prefer we do it one keyword at a time, for my brain's sake.

Well I guess I'll release 0.4.6 real soon now :/

Regards,
cvaroqui
